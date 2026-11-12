import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const IdempotencyKey = createParamDecorator(
  (data: unknown, ctx: ExecutionContext): string | undefined => {
    const request = ctx.switchToHttp().getRequest();
    return (
      (request.headers['idempotency-key'] as string) ||
      (request.headers['x-idempotency-key'] as string)
    );
  },
);

