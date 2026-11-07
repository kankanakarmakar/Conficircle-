import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { ConflictException, UnauthorizedException } from '@nestjs/common';
import * as argon2 from 'argon2';
import { AuthService } from './auth.service';
import { PrismaService } from '../../prisma/prisma.service';
import { RedisService } from '../../redis/redis.service';

jest.mock('argon2');

describe('AuthService', () => {
  let service: AuthService;
  let prisma: any;
  let redis: any;
  let jwt: any;
  let config: any;

  beforeEach(async () => {
    prisma = {
      user: {
        findFirst: jest.fn(),
        findUnique: jest.fn(),
      },
      refreshSession: {
        create: jest.fn().mockResolvedValue({ id: 'ref-1' }),
        findFirst: jest.fn(),
        update: jest.fn().mockResolvedValue({ id: 'ref-1' }),
        updateMany: jest.fn().mockResolvedValue({ count: 1 }),
      },
      activityEvent: {
        upsert: jest.fn().mockResolvedValue({ id: 'act-1' }),
      },
      guestMigration: {
        create: jest.fn().mockResolvedValue({ id: 'mig-1' }),
      },
      $transaction: jest.fn().mockImplementation(async (callback) => {
        return callback(prisma);
      }),
    };

    redis = {
      lrange: jest.fn().mockResolvedValue([]),
      del: jest.fn().mockResolvedValue(1),
    };

    jwt = {
      signAsync: jest.fn().mockResolvedValue('mock-access-token'),
    };

    config = {
      get: jest.fn().mockImplementation((key: string, def?: any) => {
        if (key === 'JWT_SECRET') return 'test-jwt-secret-minimum-32-characters';
        if (key === 'JWT_ACCESS_TTL') return '900s';
        return def;
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: PrismaService, useValue: prisma },
        { provide: RedisService, useValue: redis },
        { provide: JwtService, useValue: jwt },
        { provide: ConfigService, useValue: config },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  describe('register', () => {
    it('creates a new user, hashes password, and returns tokens', async () => {
      prisma.user.findFirst.mockResolvedValue(null);
      (argon2.hash as jest.Mock).mockResolvedValue('hashed-pwd');
      prisma.user.create = jest.fn().mockResolvedValue({
        id: 'usr-1',
        email: 'test@example.com',
        role: 'user',
        status: 'active',
        profile: { name: 'Test User' },
      });

      const res = await service.register({
        email: 'test@example.com',
        password: 'Password123!',
        name: 'Test User',
      });

      expect(res.accessToken).toBe('mock-access-token');
      expect(res.refreshToken).toBeDefined();
      expect(res.user.email).toBe('test@example.com');
      expect(prisma.refreshSession.create).toHaveBeenCalled();
    });

    it('throws ConflictException if email is already registered', async () => {
      prisma.user.findFirst.mockResolvedValue({ id: 'usr-existing' });

      await expect(
        service.register({
          email: 'test@example.com',
          password: 'Password123!',
          name: 'Test User',
        }),
      ).rejects.toThrow(ConflictException);
    });
  });

  describe('login', () => {
    it('validates password hash and returns auth tokens', async () => {
      prisma.user.findFirst.mockResolvedValue({
        id: 'usr-1',
        email: 'test@example.com',
        passwordHash: 'hashed-pwd',
        role: 'user',
        profile: { name: 'Test User' },
      });
      (argon2.verify as jest.Mock).mockResolvedValue(true);

      const res = await service.login({
        email: 'test@example.com',
        password: 'Password123!',
      });

      expect(res.accessToken).toBe('mock-access-token');
      expect(res.user.id).toBe('usr-1');
    });

    it('throws UnauthorizedException if user does not exist', async () => {
      prisma.user.findFirst.mockResolvedValue(null);

      await expect(
        service.login({
          email: 'wrong@example.com',
          password: 'Password123!',
        }),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('throws UnauthorizedException if password does not match', async () => {
      prisma.user.findFirst.mockResolvedValue({
        id: 'usr-1',
        email: 'test@example.com',
        passwordHash: 'hashed-pwd',
      });
      (argon2.verify as jest.Mock).mockResolvedValue(false);

      await expect(
        service.login({
          email: 'test@example.com',
          password: 'WrongPassword',
        }),
      ).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('refresh', () => {
    it('rotates refresh token and returns new tokens for valid session', async () => {
      prisma.refreshSession.findFirst.mockResolvedValue({
        id: 'sess-1',
        user: {
          id: 'usr-1',
          email: 'test@example.com',
          role: 'user',
          profile: { name: 'Test User' },
        },
      });

      const res = await service.refresh({ refreshToken: 'valid-refresh-token' });

      expect(res.accessToken).toBe('mock-access-token');
      expect(prisma.refreshSession.update).toHaveBeenCalledWith({
        where: { id: 'sess-1' },
        data: { revokedAt: expect.any(Date) },
      });
    });

    it('throws UnauthorizedException when refresh token is invalid or expired', async () => {
      prisma.refreshSession.findFirst.mockResolvedValue(null);

      await expect(
        service.refresh({ refreshToken: 'invalid-token' }),
      ).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('migrateGuestData', () => {
    it('migrates only whitelisted events into ActivityEvent and purges Redis keys', async () => {
      const guestEvents = [
        JSON.stringify({ type: 'quicktip.viewed', refId: 'qt-1', sourceEventId: 'ev-1' }),
        JSON.stringify({ type: 'unsupported.event', refId: 'bad' }),
        JSON.stringify({ type: 'topic.explored', refId: 'top-1', sourceEventId: 'ev-2' }),
      ];
      redis.lrange.mockResolvedValue(guestEvents);

      await service.migrateGuestData('guest-ref-123', 'usr-1');

      expect(prisma.activityEvent.upsert).toHaveBeenCalledTimes(2);
      expect(prisma.guestMigration.create).toHaveBeenCalledWith({
        data: {
          guestRef: 'guest-ref-123',
          userId: 'usr-1',
          eventsMigrated: 2,
        },
      });
      expect(redis.del).toHaveBeenCalledWith(
        'guest:session:guest-ref-123',
        'guest:quota:quicktip:guest-ref-123',
        'guest:events:guest-ref-123',
        'guest:questions:guest-ref-123',
      );
    });
  });
});

