export interface SendMessageOptions {
  recipient: string;
  subject?: string;
  body: string;
  metadata?: Record<string, any>;
}

export interface INotificationProvider {
  readonly channel: 'email' | 'whatsapp';
  sendMessage(options: SendMessageOptions): Promise<{ success: boolean; messageId?: string; error?: string }>;
}

