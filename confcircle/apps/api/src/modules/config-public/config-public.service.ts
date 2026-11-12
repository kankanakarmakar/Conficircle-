import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class ConfigPublicService {
  constructor(private readonly prisma: PrismaService) {}

  async getConfig() {
    let configs: Record<string, any> = {};
    let flags: Record<string, boolean> = {};

    try {
      const dbConfigs = await this.prisma.appConfig.findMany();
      for (const c of dbConfigs) {
        configs[c.key] = c.value;
      }

      const dbFlags = await this.prisma.featureFlag.findMany();
      for (const f of dbFlags) {
        flags[f.key] = f.enabled;
      }
    } catch {
      // Fallback defaults
    }

    // Baseline fallbacks if DB empty
    return {
      version: '1.0.0',
      theme: {
        primaryColor: '#6366F1',
        secondaryColor: '#EC4899',
        mode: 'light',
      },
      quotas: {
        guestQuickTipQuota: configs['GUEST_QUICKTIP_QUOTA'] ?? 3,
        guestTtlSeconds: configs['GUEST_TTL_SECONDS'] ?? 3600,
        guestQuestionCount: configs['GUEST_QUESTION_COUNT'] ?? 3,
        videoCompletionThreshold: configs['VIDEO_COMPLETION_THRESHOLD'] ?? 0.9,
      },
      featureFlags: {
        circleEnabled: flags['circleEnabled'] ?? true,
        coursesEnabled: flags['coursesEnabled'] ?? true,
        assessmentsEnabled: flags['assessmentsEnabled'] ?? true,
        videoSolutionsEnabled: flags['videoSolutionsEnabled'] ?? true,
        ...flags,
      },
      config: configs,
    };
  }
}

