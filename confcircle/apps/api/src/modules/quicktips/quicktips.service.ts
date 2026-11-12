import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { GuestService } from '../guest/guest.service';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class QuickTipsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly guestService: GuestService,
  ) {}

  async openQuickTip(id: string, user: AuthenticatedUser | undefined, idempotencyKey?: string) {
    if (!user || user.isGuest) {
      const guestRef = user?.guestRef || 'anonymous';
      return this.guestService.openQuickTip(guestRef, id, idempotencyKey || `qt_${id}_${Date.now()}`);
    }

    // Registered user: unlimited access, record progress & event
    const tip = await this.prisma.quickTip.findUnique({
      where: { id },
      include: { topic: true },
    });

    if (!tip) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Quick Tip not found',
      });
    }

    // Record activity event and topic progress
    const sourceEventId = `user_${user.id}_qt_${id}`;
    await this.prisma.$transaction(async (tx) => {
      await tx.activityEvent.upsert({
        where: { sourceEventId },
        update: {},
        create: {
          userId: user.id,
          type: 'quicktip.viewed',
          refId: id,
          payload: { topicId: tip.topicId },
          sourceEventId,
        },
      });

      await tx.topicProgress.upsert({
        where: { userId_topicId: { userId: user.id, topicId: tip.topicId } },
        update: {
          quickTipsViewed: { increment: 1 },
          percentComplete: { increment: 5 },
        },
        create: {
          userId: user.id,
          topicId: tip.topicId,
          quickTipsViewed: 1,
          percentComplete: 10,
        },
      });
    });

    return {
      tip: {
        id: tip.id,
        content: tip.content,
        topic: { id: tip.topic.id, title: tip.topic.title },
      },
      quotaRemaining: null, // Unlimited for registered users
    };
  }

  async getQuickTip(id: string) {
    const tip = await this.prisma.quickTip.findUnique({
      where: { id },
      include: { topic: true },
    });

    if (!tip) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Quick Tip not found',
      });
    }

    return tip;
  }
}

