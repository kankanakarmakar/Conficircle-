import { Test } from "@nestjs/testing";
import { INestApplication, ValidationPipe } from "@nestjs/common";
import request from "supertest";
import { AppModule } from "../src/app.module";

describe("ConfCircle API Gateway — Core Foundations & Swagger Endpoints", () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
    await app.init();
  });

  afterAll(async () => {
    await app?.close();
  });

  describe("Auth endpoints (/v1/auth)", () => {
    it("POST /v1/auth/login succeeds with valid credentials", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/auth/login")
        .send({ email: "demo@conficircle.com", password: "password123" })
        .expect(200);

      expect(res.body).toHaveProperty("accessToken");
      expect(res.body).toHaveProperty("refreshToken");
      expect(res.body.user).toMatchObject({
        email: "demo@conficircle.com",
        role: "user",
      });
    });

    it("POST /v1/auth/register creates new account and returns token pair", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/auth/register")
        .send({
          displayName: "Sam Rivera",
          email: `sam_${Date.now()}@example.com`,
          password: "securePassword123",
        })
        .expect(201);

      expect(res.body).toHaveProperty("accessToken");
      expect(res.body.user.displayName).toBe("Sam Rivera");
    });

    it("POST /v1/auth/refresh rotates token pair", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/auth/refresh")
        .send({ refreshToken: "valid_demo_refresh_token_string" })
        .expect(200);

      expect(res.body).toHaveProperty("accessToken");
    });

    it("POST /v1/auth/logout invalidates session", async () => {
      const res = await request(app.getHttpServer()).post("/v1/auth/logout").expect(200);
      expect(res.body.message).toContain("logged out");
    });
  });

  describe("Guest endpoints (/v1/guest)", () => {
    it("POST /v1/guest/session initializes guest quota", async () => {
      const res = await request(app.getHttpServer()).post("/v1/guest/session").expect(201);
      expect(res.body).toHaveProperty("guestRef");
      expect(res.body.quotaRemaining).toBe(3);
    });

    it("GET /v1/guest/questions returns Level 4 discovery prompts", async () => {
      const res = await request(app.getHttpServer()).get("/v1/guest/questions").expect(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.length).toBeGreaterThanOrEqual(1);
      expect(res.body[0]).toHaveProperty("prompt");
    });
  });

  describe("QuickTips & Quota Deductions (/v1/quicktips)", () => {
    it("POST /v1/quicktips/:id/open deducts quota with idempotency guard", async () => {
      const session = await request(app.getHttpServer()).post("/v1/guest/session").expect(201);
      const guestRef = session.body.guestRef;

      const res = await request(app.getHttpServer())
        .post("/v1/quicktips/qt-1/open")
        .set("X-Guest-Ref", guestRef)
        .set("Idempotency-Key", "idemp-001")
        .expect(200);

      expect(res.body.isUnlocked).toBe(true);
      expect(res.body.quotaRemaining).toBe(2);

      // Repeat with same idempotency key — quota should remain 2
      const repeatRes = await request(app.getHttpServer())
        .post("/v1/quicktips/qt-1/open")
        .set("X-Guest-Ref", guestRef)
        .set("Idempotency-Key", "idemp-001")
        .expect(200);

      expect(repeatRes.body.quotaRemaining).toBe(2);
    });
  });

  describe("Discovery endpoints (/v1/discovery)", () => {
    it("GET /v1/discovery/guest returns batch of questions", async () => {
      const res = await request(app.getHttpServer())
        .get("/v1/discovery/guest")
        .query({ limit: 8 })
        .expect(200);

      expect(res.body.audience).toBe("guest");
      expect(res.body.items.length).toBe(8);
      expect(res.body.items[0]).toHaveProperty("questionId");
    });

    it("POST /v1/discovery/guest/shuffle returns randomized batch", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/discovery/guest/shuffle")
        .send({ previousBatchId: "prev_batch_01", excludedIds: ["l4-001"] })
        .expect(200);

      expect(res.body).toHaveProperty("batchId");
      expect(res.body.items.length).toBe(8);
    });

    it("POST /v1/discovery/events accepts telemetry event", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/discovery/events")
        .send({
          eventType: "card_click",
          questionId: "l4-001",
          metadata: { dwellMs: 3200 },
        })
        .expect(201);

      expect(res.body.status).toBe("recorded");
    });
  });

  describe("Questions catalog (/v1/questions)", () => {
    it("GET /v1/questions/:id returns detail with permitted actions, tips, and video teasers", async () => {
      const res = await request(app.getHttpServer()).get("/v1/questions/l4-001").expect(200);

      expect(res.body.questionId).toBe("l4-001");
      expect(res.body.permittedActions.length).toBeGreaterThan(0);
      expect(res.body.quickTips.length).toBeGreaterThan(0);
      expect(res.body.videoSolutions.length).toBeGreaterThan(0);
      expect(res.body.assessments.length).toBeGreaterThan(0);
    });
  });

  describe("Problem Profile (/v1/problem-profile)", () => {
    it("GET /v1/problem-profile/concerns returns curated concerns", async () => {
      const res = await request(app.getHttpServer()).get("/v1/problem-profile/concerns").expect(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.length).toBe(8);
    });

    it("POST /v1/problem-profile saves concern selections", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/problem-profile")
        .send({ concernPromptIds: ["concern-01", "concern-03"], priority: 1 })
        .expect(201);

      expect(res.body.activeConcernCount).toBe(2);
    });
  });

  describe("Content & Curriculum (/v1/content)", () => {
    it("GET /v1/content/topics returns learning topics", async () => {
      const res = await request(app.getHttpServer()).get("/v1/content/topics").expect(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.length).toBeGreaterThan(0);
      expect(res.body[0]).toHaveProperty("title");
    });

    it("GET /v1/content/topics/:id returns lessons and exercises", async () => {
      const res = await request(app.getHttpServer()).get("/v1/content/topics/top-001").expect(200);
      expect(res.body.lessons.length).toBeGreaterThan(0);
      expect(res.body.exercises.length).toBeGreaterThan(0);
    });

    it("GET /v1/content/resources returns downloadable resources", async () => {
      const res = await request(app.getHttpServer()).get("/v1/content/resources").expect(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.length).toBeGreaterThan(0);
    });
  });

  describe("Assessments (/v1/assessment)", () => {
    it("GET /v1/assessment lists assessments", async () => {
      const res = await request(app.getHttpServer()).get("/v1/assessment").expect(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.length).toBeGreaterThan(0);
    });

    it("POST /v1/assessment/:id/submit returns evaluated scores and level titles", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/assessment/ass-1/submit")
        .send({
          answers: [
            { questionId: "q-1", selectedOptionId: "opt-3" },
            { questionId: "q-2", selectedOptionId: "opt-7" },
          ],
        })
        .expect(200);

      expect(res.body).toHaveProperty("attemptId");
      expect(res.body).toHaveProperty("score");
      expect(res.body).toHaveProperty("levelTitle");
      expect(res.body.recommendations.length).toBeGreaterThan(0);
    });
  });

  describe("Progress & Analytics (/v1/progress)", () => {
    it("GET /v1/progress returns user stats, streak, and badges", async () => {
      const res = await request(app.getHttpServer()).get("/v1/progress").expect(200);
      expect(res.body).toHaveProperty("confyPoints");
      expect(res.body).toHaveProperty("streakDays");
      expect(res.body.badges.length).toBeGreaterThan(0);
    });

    it("POST /v1/progress/video records playback milestone", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/progress/video")
        .send({
          videoId: "vid-1",
          topicId: "top-001",
          positionSeconds: 120,
          durationSeconds: 240,
        })
        .expect(200);

      expect(res.body.recorded).toBe(true);
      expect(res.body.percentComplete).toBe(50);
    });

    it("POST /v1/analytics/events ingests telemetry", async () => {
      const res = await request(app.getHttpServer())
        .post("/v1/analytics/events")
        .send({
          events: [
            {
              event: "action_click",
              entity_id: "l4-001",
              timestamp: new Date().toISOString(),
            },
          ],
        })
        .expect(202);

      expect(res.body.status).toBe("accepted");
    });
  });
});

