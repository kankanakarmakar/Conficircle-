import { Injectable, NotFoundException } from "@nestjs/common";
import { QuickTipOpenResponseDto } from "./dto/quicktip.dto";
import { GuestService } from "../guest/guest.service";

@Injectable()
export class QuicktipsService {
  constructor(private readonly guestService: GuestService) {}

  private readonly tips: Map<string, { content: string; order: number }> = new Map([
    [
      "qt-1",
      {
        content: "Write down your main point on paper before speaking. Having 3 bullet points lowers cognitive anxiety by 40%.",
        order: 1,
      },
    ],
    [
      "qt-2",
      {
        content: "Use the 3-second pause rule: Inhale slowly before answering any unexpected question to re-engage your prefrontal cortex.",
        order: 2,
      },
    ],
    [
      "qt-3",
      {
        content: "The Spotlight Effect is real: Most colleagues are focused on their own responsibilities, not scrutinizing your minor slips.",
        order: 3,
      },
    ],
    [
      "qt-4",
      {
        content: "Reframe nervous energy: Tell yourself 'I am energized and ready' instead of 'I am terrified'. Physiology of excitement and anxiety is nearly identical.",
        order: 4,
      },
    ],
  ]);

  // Idempotency cache: key -> response
  private readonly idempotencyCache: Map<string, QuickTipOpenResponseDto> = new Map();

  openTip(tipId: string, guestRef?: string, idempotencyKey?: string): QuickTipOpenResponseDto {
    if (idempotencyKey && this.idempotencyCache.has(idempotencyKey)) {
      return this.idempotencyCache.get(idempotencyKey)!;
    }

    const tip = this.tips.get(tipId) ?? {
      content: "Focus on providing one valuable insight rather than trying to dominate the entire conversation.",
      order: 1,
    };

    let quotaRemaining = 3;
    if (guestRef) {
      quotaRemaining = this.guestService.decrementQuota(guestRef);
    }

    const result: QuickTipOpenResponseDto = {
      id: tipId,
      content: tip.content,
      quotaRemaining,
      isUnlocked: true,
      order: tip.order,
    };

    if (idempotencyKey) {
      this.idempotencyCache.set(idempotencyKey, result);
    }

    return result;
  }
}

