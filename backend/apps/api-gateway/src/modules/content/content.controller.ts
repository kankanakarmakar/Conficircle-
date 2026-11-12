import { Controller, Get, Param, Query } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiParam, ApiQuery } from "@nestjs/swagger";
import { ContentService } from "./content.service";
import { TopicDto, TopicDetailDto, ResourceDto } from "./dto/content.dto";

@ApiTags("Content")
@Controller("v1/content")
export class ContentController {
  constructor(private readonly contentService: ContentService) {}

  @Get("topics")
  @ApiOperation({ summary: "List learning topics and courses with lesson counts" })
  @ApiQuery({ name: "difficulty", required: false, enum: ["beginner", "intermediate", "advanced"] })
  @ApiResponse({ status: 200, description: "List of topics", type: [TopicDto] })
  getTopics(@Query("difficulty") difficulty?: string): TopicDto[] {
    return this.contentService.getTopics(difficulty);
  }

  @Get("topics/:id")
  @ApiOperation({ summary: "Get detailed curriculum, lessons, and exercises for a topic" })
  @ApiParam({ name: "id", example: "top-001" })
  @ApiResponse({ status: 200, description: "Topic curriculum details", type: TopicDetailDto })
  @ApiResponse({ status: 404, description: "Topic not found" })
  getTopicDetail(@Param("id") id: string): TopicDetailDto {
    return this.contentService.getTopicById(id);
  }

  @Get("resources")
  @ApiOperation({ summary: "Browse downloadable worksheets, cheat sheets, and templates" })
  @ApiQuery({ name: "category", required: false, example: "Communication" })
  @ApiQuery({ name: "type", required: false, example: "PDF" })
  @ApiResponse({ status: 200, description: "List of resources", type: [ResourceDto] })
  getResources(
    @Query("category") category?: string,
    @Query("type") type?: string,
  ): ResourceDto[] {
    return this.contentService.getResources(category, type);
  }
}

