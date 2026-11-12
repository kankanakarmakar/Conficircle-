import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreatePostDto } from './circle.dto';
import { AuthenticatedUser } from '../../common/decorators/current-user.decorator';
import { ErrorCode } from '../../common/dto/error.dto';

@Injectable()
export class CircleService {
  constructor(private readonly prisma: PrismaService) {}

  async getGroups(user?: AuthenticatedUser) {
    const isRegistered = user && !user.isGuest;

    const groups = await this.prisma.circleGroup.findMany({
      where: {
        moderationStatus: 'active',
        visibility: isRegistered ? undefined : 'public',
      },
      include: {
        _count: { select: { memberships: true, posts: true } },
      },
    });

    let userMembershipIds = new Set<string>();
    if (isRegistered) {
      const memberships = await this.prisma.groupMembership.findMany({
        where: { userId: user.id },
        select: { groupId: true },
      });
      userMembershipIds = new Set(memberships.map((m) => m.groupId));
    }

    return groups.map((g) => ({
      id: g.id,
      name: g.name,
      description: g.description,
      slug: g.slug,
      visibility: g.visibility,
      memberCount: g._count.memberships,
      postCount: g._count.posts,
      isMember: userMembershipIds.has(g.id),
    }));
  }

  async getFeed(user?: AuthenticatedUser) {
    const isRegistered = user && !user.isGuest;

    let allowedGroupIds: string[] = [];

    if (isRegistered) {
      const memberships = await this.prisma.groupMembership.findMany({
        where: { userId: user.id },
        select: { groupId: true },
      });
      const publicGroups = await this.prisma.circleGroup.findMany({
        where: { visibility: 'public' },
        select: { id: true },
      });
      allowedGroupIds = [
        ...new Set([
          ...memberships.map((m) => m.groupId),
          ...publicGroups.map((g) => g.id),
        ]),
      ];
    } else {
      const publicGroups = await this.prisma.circleGroup.findMany({
        where: { visibility: 'public' },
        select: { id: true },
      });
      allowedGroupIds = publicGroups.map((g) => g.id);
    }

    const posts = await this.prisma.post.findMany({
      where: {
        groupId: { in: allowedGroupIds },
        moderationStatus: 'approved',
      },
      orderBy: { createdAt: 'desc' },
      take: 30,
      include: {
        author: { select: { id: true, profile: { select: { name: true, avatarUrl: true } } } },
        group: { select: { id: true, name: true } },
      },
    });

    return posts.map((p) => ({
      id: p.id,
      content: p.content,
      group: p.group,
      author: {
        id: p.author.id,
        name: p.author.profile?.name || 'Anonymous',
        avatarUrl: p.author.profile?.avatarUrl,
      },
      createdAt: p.createdAt,
    }));
  }

  async joinGroup(groupId: string, userId: string) {
    const group = await this.prisma.circleGroup.findUnique({
      where: { id: groupId },
    });

    if (!group) {
      throw new NotFoundException({
        code: ErrorCode.NOT_FOUND,
        message: 'Group not found',
      });
    }

    const membership = await this.prisma.groupMembership.upsert({
      where: { groupId_userId: { groupId, userId } },
      update: {},
      create: { groupId, userId, role: 'member' },
    });

    // Audit event
    await this.prisma.auditEvent.create({
      data: {
        userId,
        action: 'group.join',
        targetType: 'CircleGroup',
        targetId: groupId,
      },
    });

    return { success: true, groupId, joinedAt: membership.joinedAt };
  }

  async leaveGroup(groupId: string, userId: string) {
    await this.prisma.groupMembership.deleteMany({
      where: { groupId, userId },
    });

    await this.prisma.auditEvent.create({
      data: {
        userId,
        action: 'group.leave',
        targetType: 'CircleGroup',
        targetId: groupId,
      },
    });

    return { success: true, groupId };
  }

  async createPost(userId: string, dto: CreatePostDto) {
    // Check group membership
    const membership = await this.prisma.groupMembership.findUnique({
      where: { groupId_userId: { groupId: dto.groupId, userId } },
    });

    if (!membership) {
      throw new ForbiddenException({
        code: ErrorCode.FORBIDDEN,
        message: 'You must be a member of this group to create a post',
      });
    }

    const post = await this.prisma.post.create({
      data: {
        groupId: dto.groupId,
        authorId: userId,
        content: dto.content,
        visibility: dto.visibility || 'group',
        moderationStatus: 'approved', // auto-approve for testing/standard
      },
    });

    // Audit event
    await this.prisma.auditEvent.create({
      data: {
        userId,
        action: 'post.create',
        targetType: 'Post',
        targetId: post.id,
      },
    });

    return post;
  }
}

