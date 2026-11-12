import { Injectable } from "@nestjs/common";
import { GuestSessionDto, QuestionPromptSummaryDto } from "./dto/guest.dto";

@Injectable()
export class GuestService {
  private readonly guestSessions: Map<string, { quotaRemaining: number; createdAt: string }> = new Map();

  createOrGetSession(existingGuestRef?: string): GuestSessionDto {
    if (existingGuestRef && this.guestSessions.has(existingGuestRef)) {
      const session = this.guestSessions.get(existingGuestRef)!;
      return {
        guestRef: existingGuestRef,
        quotaRemaining: session.quotaRemaining,
        createdAt: session.createdAt,
      };
    }

    const guestRef = `guest_${Math.random().toString(36).substring(2, 10)}`;
    const session = {
      quotaRemaining: 3,
      createdAt: new Date().toISOString(),
    };
    this.guestSessions.set(guestRef, session);

    return {
      guestRef,
      quotaRemaining: session.quotaRemaining,
      createdAt: session.createdAt,
    };
  }

  getQuota(guestRef: string): number {
    return this.guestSessions.get(guestRef)?.quotaRemaining ?? 3;
  }

  decrementQuota(guestRef: string): number {
    const session = this.guestSessions.get(guestRef);
    if (!session) {
      this.guestSessions.set(guestRef, { quotaRemaining: 2, createdAt: new Date().toISOString() });
      return 2;
    }
    session.quotaRemaining = Math.max(0, session.quotaRemaining - 1);
    return session.quotaRemaining;
  }

  getGuestQuestions(): QuestionPromptSummaryDto[] {
    return [
      {
        questionId: "l4-001",
        prompt: "How do I stop overthinking in group meetings and actually speak up?",
        shortDescription: "Quick tactics to contribute before hesitation takes over",
        displayAsset: "assets/images/l4_meeting.png",
      },
      {
        questionId: "l4-002",
        prompt: "What can I do when imposter syndrome kicks in before a presentation?",
        shortDescription: "Mental grounding techniques to regain your calm",
        displayAsset: "assets/images/l4_presentation.png",
      },
      {
        questionId: "l4-003",
        prompt: "How do I make tough decisions without constantly second-guessing myself?",
        shortDescription: "A practical framework to commit and move forward with conviction",
        displayAsset: "assets/images/l4_decisions.png",
      },
      {
        questionId: "l4-004",
        prompt: "How can I stop comparing my career journey to my peers on social media?",
        shortDescription: "Refocusing on your personal timeline and real strengths",
        displayAsset: "assets/images/l4_comparison.png",
      },
    ];
  }
}

