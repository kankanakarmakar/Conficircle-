import { Injectable } from "@nestjs/common";
import {
  UserProgressDto,
  RecordVideoProgressDto,
  VideoProgressResponseDto,
  AnalyticsBatchDto,
} from "./dto/progress.dto";

@Injectable()
export class ProgressService {
  private confyPoints = 180;
  private streakDays = 4;

  getProgress(): UserProgressDto {
    return {
      confyPoints: this.confyPoints,
      streakDays: this.streakDays,
      completedTopicsCount: 2,
      badges: [
        {
          id: "badge-first-step",
          name: "First Step Taken",
          description: "Unlocked your first micro-coaching quick tip.",
          iconUrl: "assets/icons/badge_first.png",
          unlockedAt: new Date(Date.now() - 3 * 86400000).toISOString(),
        },
        {
          id: "badge-consistency-3",
          name: "3-Day Streak",
          description: "Practiced confidence routines 3 days in a row.",
          iconUrl: "assets/icons/badge_streak.png",
          unlockedAt: new Date(Date.now() - 86400000).toISOString(),
        },
        {
          id: "badge-assessment-ace",
          name: "Strategic Contributor",
          description: "Completed the Communication & Decisiveness Assessment.",
          iconUrl: "assets/icons/badge_assessment.png",
          unlockedAt: new Date().toISOString(),
        },
      ],
      recentActivity: [
        {
          id: "act-01",
          title: "Watched: Breaking the 5-Minute Hesitation Window",
          rewardText: "+15 Confy Points",
          timestamp: new Date().toISOString(),
        },
        {
          id: "act-02",
          title: "Unlocked Quick Tip: Meeting Preparation",
          rewardText: "+10 Confy Points",
          timestamp: new Date(Date.now() - 3600000).toISOString(),
        },
      ],
    };
  }

  recordVideoProgress(dto: RecordVideoProgressDto): VideoProgressResponseDto {
    const percent = Math.min(100, Math.round((dto.positionSeconds / dto.durationSeconds) * 100));
    const points = percent >= 90 ? 25 : 10;
    this.confyPoints += points;

    return {
      recorded: true,
      pointsAwarded: points,
      percentComplete: percent,
    };
  }

  ingestAnalytics(dto: AnalyticsBatchDto): { status: string; count: number } {
    return {
      status: "accepted",
      count: dto.events?.length ?? 0,
    };
  }
}

