import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { SaveAnswerDto } from './assessments.dto';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class AssessmentsService {
  constructor(private readonly prisma: PrismaService) {}

  async getAssessment(id: string) {
    const assessment = await this.prisma.assessment.findUnique({
      where: { id },
      include: {
        questions: {
          orderBy: { order: 'asc' },
          include: {
            question: {
              include: {
                options: {
                  select: { id: true, content: true }, // NEVER select isCorrect
                },
              },
            },
          },
        },
      },
    });

    if (!assessment) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Assessment not found',
      });
    }

    return {
      id: assessment.id,
      title: assessment.title,
      timerSec: assessment.timerSec,
      maxAttempts: assessment.maxAttempts,
      questions: assessment.questions.map((aq) => ({
        id: aq.question.id,
        content: aq.question.content,
        options: aq.question.options,
      })),
    };
  }

  async startAttempt(assessmentId: string, userId: string) {
    const assessment = await this.prisma.assessment.findUnique({
      where: { id: assessmentId },
    });

    if (!assessment) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Assessment not found',
      });
    }

    // Check attempt policy
    const attemptCount = await this.prisma.assessmentAttempt.count({
      where: { assessmentId, userId },
    });

    if (attemptCount >= assessment.maxAttempts) {
      throw new ForbiddenException({
        code: ErrorCode.FORBIDDEN,
        message: `Maximum attempts (${assessment.maxAttempts}) reached for this assessment`,
      });
    }

    // Compute expiration server-side
    const expiresAt = new Date(Date.now() + assessment.timerSec * 1000);

    const attempt = await this.prisma.assessmentAttempt.create({
      data: {
        userId,
        assessmentId,
        state: 'draft',
        expiresAt,
      },
    });

    return {
      attemptId: attempt.id,
      expiresAt: attempt.expiresAt,
      timerSec: assessment.timerSec,
    };
  }

  async saveAnswer(attemptId: string, userId: string, dto: SaveAnswerDto) {
    const attempt = await this.prisma.assessmentAttempt.findUnique({
      where: { id: attemptId },
    });

    if (!attempt || attempt.userId !== userId) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Attempt not found',
      });
    }

    if (attempt.state !== 'draft') {
      throw new BadRequestException({
        code: ErrorCode.VALIDATION_FAILED,
        message: 'Attempt is already submitted or closed',
      });
    }

    if (new Date() > attempt.expiresAt) {
      throw new BadRequestException({
        code: ErrorCode.VALIDATION_FAILED,
        message: 'Time expired for this assessment attempt',
      });
    }

    const answer = await this.prisma.attemptAnswer.upsert({
      where: {
        attemptId_questionId: {
          attemptId,
          questionId: dto.questionId,
        },
      },
      update: {
        selectedOptionId: dto.selectedOptionId,
        answeredAt: new Date(),
      },
      create: {
        attemptId,
        questionId: dto.questionId,
        selectedOptionId: dto.selectedOptionId,
      },
    });

    return { success: true, savedAt: answer.answeredAt };
  }

  async submitAttempt(attemptId: string, userId: string) {
    const attempt = await this.prisma.assessmentAttempt.findUnique({
      where: { id: attemptId },
      include: {
        assessment: {
          include: {
            questions: {
              include: {
                question: {
                  include: { options: true },
                },
              },
            },
          },
        },
        answers: true,
      },
    });

    if (!attempt || attempt.userId !== userId) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Attempt not found',
      });
    }

    // If already submitted, return existing result (idempotency)
    if (attempt.state === 'scored' || attempt.state === 'submitted') {
      return {
        score: attempt.score,
        status: attempt.status,
        submittedAt: attempt.submittedAt,
        alreadySubmitted: true,
      };
    }

    // Calculate score strictly server-side (never trust client)
    const questions = attempt.assessment.questions.map((aq) => aq.question);
    const totalQuestions = questions.length;
    let correctCount = 0;

    const graceMs = 5000; // 5-second grace period
    const cutoff = new Date(attempt.expiresAt.getTime() + graceMs);

    // Only score answers saved before cutoff
    const eligibleAnswers = attempt.answers.filter((a) => a.answeredAt <= cutoff);
    const answerMap = new Map(eligibleAnswers.map((a) => [a.questionId, a.selectedOptionId]));

    for (const q of questions) {
      const selectedId = answerMap.get(q.id);
      const correctOption = q.options.find((opt) => opt.isCorrect);
      if (selectedId && correctOption && selectedId === correctOption.id) {
        correctCount++;
      }
    }

    const score = totalQuestions > 0 ? Math.round((correctCount / totalQuestions) * 100) : 0;
    const passed = score >= 60;
    const status = passed ? 'pass' : 'fail';

    await this.prisma.$transaction(async (tx) => {
      // 1. Update attempt
      await tx.assessmentAttempt.update({
        where: { id: attemptId },
        data: {
          state: 'scored',
          score,
          status,
          submittedAt: new Date(),
        },
      });

      // 2. Award points if passed
      if (passed) {
        const refEventId = `assessment_${attemptId}`;
        try {
          await tx.confyPointsLedger.create({
            data: {
              userId,
              delta: 30,
              reason: `Passed assessment: ${attempt.assessment.title}`,
              refEventId,
            },
          });
        } catch {
          // Idempotent
        }

        // 3. Update TopicProgress
        await tx.topicProgress.upsert({
          where: { userId_topicId: { userId, topicId: attempt.assessment.topicId } },
          update: {
            assessmentsDone: { increment: 1 },
            percentComplete: { increment: 25 },
          },
          create: {
            userId,
            topicId: attempt.assessment.topicId,
            assessmentsDone: 1,
            percentComplete: 25,
          },
        });
      }
    });

    return {
      score,
      status,
      correctCount,
      totalQuestions,
      passed,
      nextActions: [
        { title: 'Review Answers', type: 'review' },
        { title: 'Back to Topic', type: 'navigation' },
      ],
    };
  }
}

