import { Injectable } from "@nestjs/common";
import {
  ConcernPromptDto,
  SaveProblemProfileDto,
  UpdateProblemProfileDto,
  UserConcernProfileDto,
  ProblemProfileSavedResponseDto,
} from "./dto/problem-profile.dto";

@Injectable()
export class ProblemProfileService {
  private readonly curatedConcerns: ConcernPromptDto[] = [
    { id: "concern-01", promptText: "I hesitate to speak up in group discussions", order: 1 },
    { id: "concern-02", promptText: "I worry that others will realize I do not belong here", order: 2 },
    { id: "concern-03", promptText: "I struggle to make decisions without asking for multiple opinions", order: 3 },
    { id: "concern-04", promptText: "I constantly compare my progress to people around me", order: 4 },
    { id: "concern-05", promptText: "I feel guilty when I say no to requests or extra commitments", order: 5 },
    { id: "concern-06", promptText: "I freeze or panic when someone asks me an unexpected question", order: 6 },
    { id: "concern-07", promptText: "I dread introducing myself or small talk at networking events", order: 7 },
    { id: "concern-08", promptText: "I want better study habits and learning productivity", order: 8 },
  ];

  private userSelectedConcerns: Set<string> = new Set(["concern-01", "concern-02"]);

  getCuratedConcerns(): ConcernPromptDto[] {
    return this.curatedConcerns.map((c) => ({
      ...c,
      isSelected: this.userSelectedConcerns.has(c.id),
    }));
  }

  getUserProfile(): UserConcernProfileDto[] {
    return Array.from(this.userSelectedConcerns).map((id) => {
      const concern = this.curatedConcerns.find((c) => c.id === id) ?? this.curatedConcerns[0];
      return {
        id: `upp-${id}`,
        concernPromptId: id,
        promptText: concern.promptText,
        status: "active",
        priority: 1,
      };
    });
  }

  saveProfile(dto: SaveProblemProfileDto): ProblemProfileSavedResponseDto {
    this.userSelectedConcerns = new Set(dto.concernPromptIds);
    const matchedConcerns = Array.from(this.userSelectedConcerns).map((id) => {
      const c = this.curatedConcerns.find((item) => item.id === id) ?? this.curatedConcerns[0];
      return { id: c.id, promptText: c.promptText };
    });

    return {
      message: "Problem profile saved successfully",
      activeConcernCount: this.userSelectedConcerns.size,
      concerns: matchedConcerns,
    };
  }

  updateProfile(id: string, dto: UpdateProblemProfileDto): UserConcernProfileDto {
    const rawConcernId = id.replace("upp-", "");
    const concern = this.curatedConcerns.find((c) => c.id === rawConcernId) ?? this.curatedConcerns[0];

    return {
      id,
      concernPromptId: concern.id,
      promptText: concern.promptText,
      status: dto.status ?? "active",
      priority: dto.priority ?? 1,
    };
  }
}

