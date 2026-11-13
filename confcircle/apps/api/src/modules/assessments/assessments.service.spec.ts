import { Test, TestingModule } from '@nestjs/testing';
import { AssessmentsService } from './assessments.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('AssessmentsService', () => {
  let service: AssessmentsService;
  let prismaService: any;

  beforeEach(async () => {
    prismaService = {
      assessment: { findUnique: jest.fn(), create: jest.fn() },
      assessmentAttempt: { findUnique: jest.fn(), create: jest.fn(), update: jest.fn(), count: jest.fn() },
      attemptAnswer: { upsert: jest.fn() },
      confyPointsLedger: { create: jest.fn() },
      topicProgress: { upsert: jest.fn() },
      $transaction: jest.fn().mockImplementation(async (callback) => callback(prismaService)),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AssessmentsService,
        { provide: PrismaService, useValue: prismaService },
      ],
    }).compile();

    service = module.get<AssessmentsService>(AssessmentsService);
  });

  it('should compute score strictly server-side from answer options', async () => {
    const expiresAt = new Date(Date.now() + 60000);
    prismaService.assessmentAttempt.findUnique.mockResolvedValue({
      id: 'att-1',
      userId: 'user-1',
      state: 'draft',
      expiresAt,
      assessment: {
        id: 'ass-1',
        topicId: 'top-1',
        title: 'Confidence Quiz',
        questions: [
          {
            question: {
              id: 'q-1',
              options: [
                { id: 'opt-1', isCorrect: true },
                { id: 'opt-2', isCorrect: false },
              ],
            },
          },
          {
            question: {
              id: 'q-2',
              options: [
                { id: 'opt-3', isCorrect: true },
                { id: 'opt-4', isCorrect: false },
              ],
            },
          },
        ],
      },
      answers: [
        { questionId: 'q-1', selectedOptionId: 'opt-1', answeredAt: new Date() },
        { questionId: 'q-2', selectedOptionId: 'opt-4', answeredAt: new Date() }, // Incorrect
      ],
    });

    const result = await service.submitAttempt('att-1', 'user-1');
    expect(result.score).toBe(50); // 1 out of 2 correct = 50%
    expect(result.status).toBe('fail'); // pass mark is 60
  });

  it('should replay existing result on double submit (idempotency)', async () => {
    prismaService.assessmentAttempt.findUnique.mockResolvedValue({
      id: 'att-1',
      userId: 'user-1',
      state: 'scored',
      score: 80,
      status: 'pass',
      submittedAt: new Date(),
    });

    const result = await service.submitAttempt('att-1', 'user-1');
    expect(result.alreadySubmitted).toBe(true);
    expect(result.score).toBe(80);
    expect(prismaService.assessmentAttempt.update).not.toHaveBeenCalled();
  });

  it('should only score answers saved before expiry + grace period', async () => {
    const expiredTime = new Date(Date.now() - 60000); // 1 min ago
    const lateAnswerTime = new Date(Date.now()); // after expiry

    prismaService.assessmentAttempt.findUnique.mockResolvedValue({
      id: 'att-2',
      userId: 'user-1',
      state: 'draft',
      expiresAt: expiredTime,
      assessment: {
        id: 'ass-1',
        topicId: 'top-1',
        title: 'Quiz',
        questions: [
          {
            question: {
              id: 'q-1',
              options: [{ id: 'opt-1', isCorrect: true }],
            },
          },
        ],
      },
      answers: [
        { questionId: 'q-1', selectedOptionId: 'opt-1', answeredAt: lateAnswerTime }, // late
      ],
    });

    const result = await service.submitAttempt('att-2', 'user-1');
    expect(result.score).toBe(0); // Late answer ignored
  });
});

