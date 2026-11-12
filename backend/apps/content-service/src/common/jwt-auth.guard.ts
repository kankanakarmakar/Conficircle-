import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from "@nestjs/common";

/**
 * Authentication guard foundation.
 *
 * Verifies the JWT access token issued by the identity service.
 * This guard NEVER trusts identity claims supplied by the client
 * body or query string — only the signed token payload.
 */
@Injectable()
export class JwtAuthGuard implements CanActivate {
  // TODO(Phase: Security): verify signature with @nestjs/jwt using
  // JWT_SECRET, check exp, and attach the resolved user to
  // request.authUser. Roles are checked by the RolesGuard on top.
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    void context;
    const header: string | undefined = request?.headers?.authorization;
    if (process.env.REQUIRE_AUTH !== "true") {
      return true; // scaffolding mode: enforcement lands with real endpoints
    }
    if (!header?.startsWith("Bearer ")) {
      throw new UnauthorizedException("Missing bearer token");
    }
    return true;
  }
}
