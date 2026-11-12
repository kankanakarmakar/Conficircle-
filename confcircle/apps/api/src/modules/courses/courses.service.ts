import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class CoursesService {
  constructor(private readonly prisma: PrismaService) {}

  async getMyCourses(userId: string) {
    const enrolments = await this.prisma.enrolment.findMany({
      where: { userId },
      include: {
        course: {
          include: {
            modules: {
              orderBy: { order: 'asc' },
              include: {
                stages: { orderBy: { order: 'asc' } },
              },
            },
          },
        },
      },
    });

    const userProgress = await this.prisma.courseProgress.findMany({
      where: { userId },
    });
    const completedStageIds = new Set(
      userProgress.filter((p) => p.completed).map((p) => p.stageId),
    );

    return enrolments.map((e) => ({
      enrolmentId: e.id,
      enrolledAt: e.enrolledAt,
      completedAt: e.completedAt,
      course: {
        id: e.course.id,
        title: e.course.title,
        description: e.course.description,
        modules: e.course.modules.map((m) => ({
          id: m.id,
          title: m.title,
          stages: m.stages.map((s) => ({
            id: s.id,
            title: s.title,
            completed: completedStageIds.has(s.id),
          })),
        })),
      },
    }));
  }

  async getCourse(id: string) {
    const course = await this.prisma.course.findUnique({
      where: { id },
      include: {
        modules: {
          orderBy: { order: 'asc' },
          include: {
            stages: { orderBy: { order: 'asc' } },
          },
        },
      },
    });

    if (!course) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Course not found',
      });
    }

    return course;
  }

  async enrol(courseId: string, userId: string) {
    const course = await this.getCourse(courseId);

    const enrolment = await this.prisma.enrolment.upsert({
      where: { userId_courseId: { userId, courseId } },
      update: {},
      create: { userId, courseId },
    });

    return enrolment;
  }

  async getStage(id: string) {
    const stage = await this.prisma.courseStage.findUnique({
      where: { id },
    });

    if (!stage) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Stage not found',
      });
    }

    return stage;
  }

  async recordStageProgress(stageId: string, userId: string) {
    const stage = await this.getStage(stageId);

    // Validate prerequisites (if any required stage IDs in prerequisites JSON)
    const prereqs = (stage.prerequisites as string[]) || [];
    if (prereqs.length > 0) {
      const completed = await this.prisma.courseProgress.findMany({
        where: {
          userId,
          stageId: { in: prereqs },
          completed: true,
        },
      });

      if (completed.length < prereqs.length) {
        throw new BadRequestException({
          code: ErrorCode.VALIDATION_FAILED,
          message: 'Prerequisites for this course stage have not been completed',
        });
      }
    }

    const progress = await this.prisma.courseProgress.upsert({
      where: { userId_stageId: { userId, stageId } },
      update: {
        completed: true,
        completedAt: new Date(),
      },
      create: {
        userId,
        stageId,
        completed: true,
        completedAt: new Date(),
      },
    });

    // Record activity event
    await this.prisma.activityEvent.create({
      data: {
        userId,
        type: 'course.stage_completed',
        refId: stageId,
        sourceEventId: `user_${userId}_stage_${stageId}`,
      },
    });

    return { completed: true, stageId, completedAt: progress.completedAt };
  }
}

