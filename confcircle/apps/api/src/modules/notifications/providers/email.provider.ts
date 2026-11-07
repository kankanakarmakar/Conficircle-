import { Injectable, Logger } from '@nestjs/common';
import { INotificationProvider, SendMessageOptions } from './notification-provider.interface';

@Injectable()
export class EmailProvider implements INotificationProvider {
  readonly channel = 'email' as const;
  private readonly logger = new Logger(EmailProvider.name);

  async sendMessage(options: SendMessageOptions): Promise<{ success: boolean; messageId?: string; error?: string }> {
    this.logger.log(`[STUB EMAIL] To: ${options.recipient} | Subject: ${options.subject} | Body: ${options.body.substring(0, 50)}...`);
    return { success: true, messageId: `email_${Date.now()}` };
  }
}

