import { Injectable } from "@nestjs/common";
import { DiscoveryBatchDto, QuestionItemDto, ShuffleBatchDto, DiscoveryEventDto } from "./dto/discovery.dto";

@Injectable()
export class DiscoveryService {
  private readonly catalog: QuestionItemDto[] = [
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
    {
      questionId: "l4-005",
      prompt: "How do I set firm boundaries with friends or colleagues without feeling guilty?",
      shortDescription: "Mindset shifts and boundary scripts for saying no cleanly",
      displayAsset: "assets/images/l4_boundaries.png",
    },
    {
      questionId: "l4-006",
      prompt: 'How should I answer "Tell me about a time you failed" in an interview?',
      shortDescription: "Turn a past mistake into a compelling story of resilience",
      displayAsset: "assets/images/l4_interview.png",
    },
    {
      questionId: "l4-007",
      prompt: "What is a 2-minute daily routine to reset when stress feels overwhelming?",
      shortDescription: "Somatic breathing and nervous system calming tools",
      displayAsset: "assets/images/l4_stress.png",
    },
    {
      questionId: "l4-008",
      prompt: "How can I retain what I study without having to re-read everything twice?",
      shortDescription: "Active recall and spaced repetition in simple steps",
      displayAsset: "assets/images/l4_study.png",
    },
    {
      questionId: "l4-009",
      prompt: "How do I handle an awkward silence in a 1-on-1 conversation?",
      shortDescription: "Natural follow-up prompts to keep conversations comfortable",
      displayAsset: "assets/images/l4_conversation.png",
    },
    {
      questionId: "l4-010",
      prompt: "What should I do right after making a visible mistake at work or college?",
      shortDescription: "Own it, correct it, and rebuild trust without defensiveness",
      displayAsset: "assets/images/l4_mistake.png",
    },
    {
      questionId: "l4-011",
      prompt: "How do I ask senior leaders for guidance without feeling like a burden?",
      shortDescription: "How to structure high-impact, respectful mentorship requests",
      displayAsset: "assets/images/l4_mentorship.png",
    },
    {
      questionId: "l4-012",
      prompt: "How can I stay calm and articulate under unexpected questioning?",
      shortDescription: 'The "Pause-Acknowledge-Answer" method for high-pressure moments',
      displayAsset: "assets/images/l4_articulate.png",
    },
  ];

  getGuestBatch(limit = 8, previousBatchId?: string): DiscoveryBatchDto {
    const size = Math.min(Math.max(limit, 1), this.catalog.length);
    const shuffled = [...this.catalog].sort(() => 0.5 - Math.random());
    return {
      batchId: `batch_guest_${Date.now()}`,
      audience: "guest",
      items: shuffled.slice(0, size),
      expiresAt: Date.now() + 3600000,
    };
  }

  shuffleGuestBatch(dto: ShuffleBatchDto): DiscoveryBatchDto {
    const excluded = new Set(dto.excludedIds ?? []);
    const eligible = this.catalog.filter((q) => !excluded.has(q.questionId));
    const pool = eligible.length >= 8 ? eligible : this.catalog;
    const shuffled = [...pool].sort(() => 0.5 - Math.random());
    return {
      batchId: `batch_guest_${Date.now()}`,
      audience: "guest",
      items: shuffled.slice(0, 8),
      expiresAt: Date.now() + 3600000,
    };
  }

  getRegisteredBatch(limit = 6, context?: string): DiscoveryBatchDto {
    const size = Math.min(Math.max(limit, 1), this.catalog.length);
    const shuffled = [...this.catalog].sort(() => 0.5 - Math.random());
    const items = shuffled.slice(0, size).map((item, index) => {
      if (index === 0) {
        return { ...item, safeReasonLabel: "Recommended from your confidence goals" };
      }
      return item;
    });

    return {
      batchId: `batch_reg_${Date.now()}`,
      audience: "registered",
      items,
      expiresAt: Date.now() + 86400000,
    };
  }

  shuffleRegisteredBatch(dto: ShuffleBatchDto): DiscoveryBatchDto {
    const excluded = new Set(dto.excludedIds ?? []);
    const eligible = this.catalog.filter((q) => !excluded.has(q.questionId));
    const pool = eligible.length >= 6 ? eligible : this.catalog;
    const shuffled = [...pool].sort(() => 0.5 - Math.random());
    return {
      batchId: `batch_reg_${Date.now()}`,
      audience: "registered",
      items: shuffled.slice(0, 6),
      expiresAt: Date.now() + 86400000,
    };
  }

  recordEvent(dto: DiscoveryEventDto): { status: string; receivedAt: string } {
    return {
      status: "recorded",
      receivedAt: new Date().toISOString(),
    };
  }
}

