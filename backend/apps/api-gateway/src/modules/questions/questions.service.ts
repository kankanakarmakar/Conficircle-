import { Injectable, NotFoundException } from "@nestjs/common";
import { QuestionDetailDto } from "./dto/question.dto";
import { GuestService } from "../guest/guest.service";

@Injectable()
export class QuestionsService {
  constructor(private readonly guestService: GuestService) {}

  private readonly questionsMap: Map<string, QuestionDetailDto> = new Map([
    [
      "l4-001",
      {
        questionId: "l4-001",
        prompt: "How do I stop overthinking in group meetings and actually speak up?",
        shortDescription: "Quick tactics to contribute before hesitation takes over",
        permittedActions: [
          { actionType: "quicktip", enabled: true, quotaRemaining: 3 },
          { actionType: "video", enabled: false, reason: "ACCOUNT_REQUIRED" },
          { actionType: "assessment", enabled: false, reason: "ACCOUNT_REQUIRED" },
        ],
        quickTips: [
          {
            id: "qt-1",
            content: "Write down your main point on paper before speaking. Having 3 bullet points lowers cognitive anxiety by 40%.",
            order: 1,
          },
          {
            id: "qt-2",
            content: "Use the 3-second pause rule: Inhale slowly before answering any unexpected question.",
            order: 2,
          },
        ],
        videoSolutions: [
          {
            id: "vid-1",
            title: "Mastering Meeting Participation in High-Stakes Settings",
            durationSec: 240,
            requiresRegistration: true,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          },
        ],
        assessments: [
          {
            id: "ass-1",
            title: "Communication & Decisiveness Assessment",
            questionCount: 5,
            requiresRegistration: true,
          },
        ],
      },
    ],
    [
      "l4-002",
      {
        questionId: "l4-002",
        prompt: "What can I do when imposter syndrome kicks in before a presentation?",
        shortDescription: "Mental grounding techniques to regain your calm",
        permittedActions: [
          { actionType: "quicktip", enabled: true, quotaRemaining: 3 },
          { actionType: "video", enabled: false, reason: "ACCOUNT_REQUIRED" },
          { actionType: "assessment", enabled: false, reason: "ACCOUNT_REQUIRED" },
        ],
        quickTips: [
          {
            id: "qt-3",
            content: "Separate feelings from facts: Feeling like a fraud does not mean you lack technical competence.",
            order: 1,
          },
        ],
        videoSolutions: [
          {
            id: "vid-2",
            title: "Overcoming Imposter Syndrome: Cognitive Reframing",
            durationSec: 320,
            requiresRegistration: true,
          },
        ],
        assessments: [
          {
            id: "ass-2",
            title: "Imposter Pattern & Self-Worth Evaluation",
            questionCount: 4,
            requiresRegistration: true,
          },
        ],
      },
    ],
  ]);

  getQuestionDetail(questionId: string, guestRef?: string): QuestionDetailDto {
    const quota = guestRef ? this.guestService.getQuota(guestRef) : 3;

    if (this.questionsMap.has(questionId)) {
      const q = this.questionsMap.get(questionId)!;
      return {
        ...q,
        permittedActions: q.permittedActions.map((a) =>
          a.actionType === "quicktip" ? { ...a, quotaRemaining: quota } : a,
        ),
      };
    }

    // Default dynamic fallback for any valid ID
    return {
      questionId,
      prompt: "How can I build authentic confidence in daily conversations?",
      shortDescription: "Actionable micro-habits to strengthen your presence",
      permittedActions: [
        { actionType: "quicktip", enabled: true, quotaRemaining: quota },
        { actionType: "video", enabled: false, reason: "ACCOUNT_REQUIRED" },
        { actionType: "assessment", enabled: false, reason: "ACCOUNT_REQUIRED" },
      ],
      quickTips: [
        {
          id: `qt-${questionId}-1`,
          content: "Focus on curiosity instead of performance. Ask thoughtful questions rather than trying to impress.",
          order: 1,
        },
      ],
      videoSolutions: [
        {
          id: `vid-${questionId}`,
          title: "Building Authentic Presence & Assertiveness",
          durationSec: 180,
          requiresRegistration: true,
        },
      ],
      assessments: [
        {
          id: `ass-${questionId}`,
          title: "Foundations of Interpersonal Confidence",
          questionCount: 5,
          requiresRegistration: true,
        },
      ],
    };
  }

  getAllQuestions(): QuestionDetailDto[] {
    return Array.from(this.questionsMap.values());
  }
}

