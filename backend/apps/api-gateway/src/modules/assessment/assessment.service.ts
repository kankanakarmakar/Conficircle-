import { Injectable, NotFoundException } from "@nestjs/common";
import {
  AssessmentSummaryDto,
  PublicAssessmentDto,
  SubmitAssessmentDto,
  AssessmentResultDto,
} from "./dto/assessment.dto";

@Injectable()
export class AssessmentService {
  private readonly assessments: PublicAssessmentDto[] = [
    {
      id: "ass-1",
      title: "Communication & Decisiveness Assessment",
      description: "Evaluate your readiness to contribute in high-visibility group discussions.",
      questionCount: 3,
      estimatedTimeMin: 5,
      questions: [
        {
          id: "q-1",
          prompt: "When an opportunity arises to speak in a meeting, how do you typically react?",
          orderIndex: 1,
          options: [
            { id: "opt-1", text: "I wait until someone explicitly calls on me.", orderIndex: 1 },
            { id: "opt-2", text: "I rehearse multiple times in my head and often miss the window.", orderIndex: 2 },
            { id: "opt-3", text: "I share concise thoughts during natural conversational pauses.", orderIndex: 3 },
            { id: "opt-4", text: "I actively shape the agenda and speak with clarity.", orderIndex: 4 },
          ],
        },
        {
          id: "q-2",
          prompt: "How do you handle unexpected challenges or pushback to your suggestions?",
          orderIndex: 2,
          options: [
            { id: "opt-5", text: "I immediately retract or apologize to avoid conflict.", orderIndex: 1 },
            { id: "opt-6", text: "I feel flustered and struggle to explain my logic in the moment.", orderIndex: 2 },
            { id: "opt-7", text: "I pause, acknowledge the perspective, and clarify my reasoning.", orderIndex: 3 },
            { id: "opt-8", text: "I welcome the critique and use it to refine the outcome.", orderIndex: 4 },
          ],
        },
        {
          id: "q-3",
          prompt: "How do you feel right after delivering an important presentation?",
          orderIndex: 3,
          options: [
            { id: "opt-9", text: "Exhausted and hyper-fixated on the one thing that went wrong.", orderIndex: 1 },
            { id: "opt-10", text: "Relieved it's over, but doubting whether I did well.", orderIndex: 2 },
            { id: "opt-11", text: "Satisfied with my key points while noting areas to polish.", orderIndex: 3 },
            { id: "opt-12", text: "Energized and proud of delivering genuine value.", orderIndex: 4 },
          ],
        },
      ],
    },
  ];

  listAssessments(): AssessmentSummaryDto[] {
    return this.assessments.map(({ questions, ...summary }) => summary);
  }

  getAssessment(id: string): PublicAssessmentDto {
    const found = this.assessments.find((a) => a.id === id);
    if (!found) {
      throw new NotFoundException(`Assessment ${id} not found`);
    }
    return found;
  }

  submit(id: string, dto: SubmitAssessmentDto): AssessmentResultDto {
    const assessment = this.getAssessment(id);
    const count = dto.answers?.length || 1;
    const score = Math.min(100, Math.round(65 + count * 8 + Math.random() * 10));
    const level = score >= 85 ? 4 : score >= 70 ? 3 : 2;
    const levelTitles: Record<number, string> = {
      2: "Level 2: Emerging Communicator",
      3: "Level 3: Strategic Contributor",
      4: "Level 4: Impactful Leader",
    };

    return {
      attemptId: `att-${Date.now()}`,
      score,
      level,
      levelTitle: levelTitles[level] ?? "Level 3: Strategic Contributor",
      pointsAwarded: 50,
      recommendations: [
        "Use the 3-second breathing technique before replying to tough questions.",
        "Aim to speak at least once within the first 10 minutes of every team session.",
        "Practice summarizing your key idea in one headline sentence.",
      ],
    };
  }
}

