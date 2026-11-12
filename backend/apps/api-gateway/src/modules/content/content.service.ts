import { Injectable, NotFoundException } from "@nestjs/common";
import { TopicDto, TopicDetailDto, ResourceDto } from "./dto/content.dto";

@Injectable()
export class ContentService {
  private readonly topics: TopicDetailDto[] = [
    {
      id: "top-001",
      title: "Speaking Up in Meetings",
      description: "Master the psychology and timing of making impactful contributions in meetings.",
      difficultyLevel: "beginner",
      isPublished: true,
      orderIndex: 1,
      lessonCount: 4,
      thumbnailUrl: "assets/images/topics/meeting.png",
      lessons: [
        { id: "les-1", title: "Breaking the 5-Minute Hesitation Window", durationSec: 240, isCompleted: true },
        { id: "les-2", title: "Structuring a Concise Point (The Rule of 3)", durationSec: 310, isCompleted: false },
        { id: "les-3", title: "Interjecting Gracefully without Apologizing", durationSec: 190, isCompleted: false },
        { id: "les-4", title: "Handling Sudden Questions Under Pressure", durationSec: 280, isCompleted: false },
      ],
      exercises: [
        { id: "ex-1", title: "Meeting Prep Drill", prompt: "Write down 2 observations you can make in your next standup or meeting." },
      ],
    },
    {
      id: "top-002",
      title: "Defeating Imposter Syndrome",
      description: "Overcome fear of exposure and cultivate authentic internal validation.",
      difficultyLevel: "intermediate",
      isPublished: true,
      orderIndex: 2,
      lessonCount: 3,
      thumbnailUrl: "assets/images/topics/imposter.png",
      lessons: [
        { id: "les-5", title: "The Anatomy of Imposter Thoughts", durationSec: 360, isCompleted: false },
        { id: "les-6", title: "Evidence Journaling: Documenting Real Wins", durationSec: 220, isCompleted: false },
        { id: "les-7", title: "Embracing Imperfection as Growth", durationSec: 400, isCompleted: false },
      ],
      exercises: [
        { id: "ex-2", title: "Win Log", prompt: "List three challenging technical or interpersonal hurdles you overcame this past year." },
      ],
    },
    {
      id: "top-003",
      title: "Setting Clean Boundaries",
      description: "Say no comfortably and protect your focus without guilt or social friction.",
      difficultyLevel: "intermediate",
      isPublished: true,
      orderIndex: 3,
      lessonCount: 3,
      thumbnailUrl: "assets/images/topics/boundaries.png",
      lessons: [
        { id: "les-8", title: "The Boundary Playbook: 5 Scripts for Saying No", durationSec: 300, isCompleted: false },
        { id: "les-9", title: "Dealing with Guilt After Declining", durationSec: 250, isCompleted: false },
        { id: "les-10", title: "Negotiating Deadlines Confidently", durationSec: 290, isCompleted: false },
      ],
      exercises: [
        { id: "ex-3", title: "Script Practice", prompt: "Draft a polite decline to an over-demanding weekend project request." },
      ],
    },
  ];

  private readonly resources: ResourceDto[] = [
    {
      id: "res-001",
      title: "Meeting Speaking Framework & Cheat Sheet",
      type: "PDF",
      category: "Communication",
      downloadUrl: "https://conficircle.com/downloads/meeting-cheatsheet.pdf",
      fileSizeBytes: 1048576,
    },
    {
      id: "res-002",
      title: "Imposter Syndrome Cognitive Reframing Worksheet",
      type: "Worksheet",
      category: "Mindset",
      downloadUrl: "https://conficircle.com/downloads/imposter-worksheet.pdf",
      fileSizeBytes: 524288,
    },
    {
      id: "res-003",
      title: "Boundary Scripts for High-Pressure Environments",
      type: "Guide",
      category: "Assertiveness",
      downloadUrl: "https://conficircle.com/downloads/boundary-scripts.pdf",
      fileSizeBytes: 786432,
    },
  ];

  getTopics(difficulty?: string): TopicDto[] {
    if (difficulty) {
      return this.topics.filter((t) => t.difficultyLevel === difficulty);
    }
    return this.topics;
  }

  getTopicById(id: string): TopicDetailDto {
    const topic = this.topics.find((t) => t.id === id);
    if (!topic) {
      throw new NotFoundException(`Topic ${id} not found`);
    }
    return topic;
  }

  getResources(category?: string, type?: string): ResourceDto[] {
    return this.resources.filter((r) => {
      const matchCat = category ? r.category.toLowerCase() === category.toLowerCase() : true;
      const matchType = type ? r.type.toLowerCase() === type.toLowerCase() : true;
      return matchCat && matchType;
    });
  }
}

