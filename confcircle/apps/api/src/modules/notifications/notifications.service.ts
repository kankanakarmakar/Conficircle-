import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { EmailProvider } from './providers/email.provider';
import { WhatsAppProvider } from './providers/whatsapp.provider';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly emailProvider: EmailProvider,
    private readonly whatsappProvider: WhatsAppProvider,
  ) {}

  async dispatchNotification(userId: string, templateId: string, channel: 'email' | 'whatsapp') {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: { profile: true },
    });

    if (!user || !user.profile) {
      return { success: false, reason: 'user_not_found' };
    }

    // Access gate: check consent and opt-out
    if (channel === 'email') {
      if (!user.profile.notificationConsentEmail || user.profile.optOutEmail) {
        this.logger.log(`Skipping email notification: no consent or user opted out (${userId})`);
        await this.prisma.notificationDelivery.create({
          data: {
            userId,
            templateId,
            channel: 'email',
            status: 'failed',
            error: 'consent_not_given_or_opted_out',
          },
        });
        return { success: false, reason: 'consent_denied' };
      }
    } else if (channel === 'whatsapp') {
      if (!user.profile.notificationConsentWhatsapp || user.profile.optOutWhatsapp) {
        this.logger.log(`Skipping WhatsApp notification: no consent or user opted out (${userId})`);
        await this.prisma.notificationDelivery.create({
          data: {
            userId,
            templateId,
            channel: 'whatsapp',
            status: 'failed',
            error: 'consent_not_given_or_opted_out',
          },
        });
        return { success: false, reason: 'consent_denied' };
      }
    }

    const template = await this.prisma.notificationTemplate.findUnique({
      where: { id: templateId },
    });

    if (!template) {
      return { success: false, reason: 'template_not_found' };
    }

    const recipient = channel === 'email' ? user.email : user.phone;
    if (!recipient) {
      return { success: false, reason: 'no_contact_endpoint' };
    }

    const delivery = await this.prisma.notificationDelivery.create({
      data: {
        userId,
        templateId,
        channel,
        status: 'queued',
        attempts: 1,
      },
    });

    const provider = channel === 'email' ? this.emailProvider : this.whatsappProvider;
    const result = await provider.sendMessage({
      recipient,
      subject: template.subject || 'ConfCircle Update',
      body: template.body,
    });

    await this.prisma.notificationDelivery.update({
      where: { id: delivery.id },
      data: {
        status: result.success ? 'sent' : 'failed',
        provider: provider.channel,
        sentAt: result.success ? new Date() : null,
        error: result.error || null,
      },
    });

    return { success: result.success, deliveryId: delivery.id };
  }
}

