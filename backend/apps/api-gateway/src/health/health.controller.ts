import { Controller, Get } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";

@ApiTags("health")
@Controller("health")
export class HealthController {
  @Get()
  check() {
    // Low-risk static info: identity comes from config, never from requests.
    return {
      status: "ok",
      service: "conficircle.api-gateway",
      version: "0.1.0",
      timestamp: new Date().toISOString(),
    };
  }
}
