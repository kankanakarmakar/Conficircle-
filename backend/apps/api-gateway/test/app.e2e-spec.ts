import { Test } from "@nestjs/testing";
import { INestApplication, ValidationPipe } from "@nestjs/common";
import request from "supertest";
import { AppModule } from "../src/app.module";

describe("conficircle.api-gateway — health", () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
    await app.init();
  });

  afterAll(async () => {
    await app?.close();
  });

  it("GET /health returns ok", async () => {
    const res = await request(app.getHttpServer()).get("/health").expect(200);
    expect(res.body).toMatchObject({
      status: "ok",
      service: expect.stringContaining("gateway"),
    });
  });
});
