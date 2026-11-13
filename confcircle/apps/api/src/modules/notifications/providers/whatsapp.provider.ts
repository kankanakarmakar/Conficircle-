import { Injectable, Logger } from '@nestjs/common';
import { INotificationProvider, SendMessageOptions } from './notification-provider.interface';

@Injectable()
export class WhatsAppProvider implements INotificationProvider {
  readonly channel = 'whatsapp' as const;
  private readonly logger = new Logger(WhatsAppProvider.name);

  async sendMessage(options: SendMessageOptions): Promise<{ success: boolean; messageId?: string; error?: string }> {
    this.logger.log(`[STUB WHATSAPP] To: ${options.recipient} | Body: ${options.body.substring(0, 50)}...`);
    return { success: true, messageId: `wa_${Date.now()}` };
  }
}

