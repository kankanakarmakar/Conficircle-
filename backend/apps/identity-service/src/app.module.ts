import { Module } from "@nestjs/common";
import { config } from "./config/config";
import { HealthModule } from "./health/health.module";
import { PublisherModule } from "./messaging/publisher/publisher.module";
import { ConsumerModule } from "./messaging/consumer/consumer.module";
import { RabbitMQService } from "./messaging/rabbitmq.service";
import { RabbitModule } from "./messaging/rabbit.module";

const rabbitService = new RabbitMQService(config.rabbitUrl, "conficircle.identity-service", config.logLevel);

@Module({
  imports: [HealthModule, PublisherModule, ConsumerModule, RabbitModule.forRoot(rabbitService)],
})
export class AppModule {}
