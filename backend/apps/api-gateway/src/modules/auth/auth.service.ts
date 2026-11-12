import { Injectable, UnauthorizedException, ConflictException } from "@nestjs/common";
import { LoginDto, RegisterDto, RefreshTokenDto, AuthResponseDto, UserDto } from "./dto/auth.dto";

@Injectable()
export class AuthService {
  // In-memory persistent demo store
  private readonly users: Map<string, { user: UserDto; passwordHash: string }> = new Map([
    [
      "demo@conficircle.com",
      {
        user: {
          id: "usr-demo-001",
          email: "demo@conficircle.com",
          displayName: "Alex Rivera",
          role: "user",
          isGuest: false,
          createdAt: new Date().toISOString(),
        },
        passwordHash: "password123",
      },
    ],
  ]);

  login(dto: LoginDto): AuthResponseDto {
    const record = this.users.get(dto.email.toLowerCase());
    if (!record || record.passwordHash !== dto.password) {
      throw new UnauthorizedException("Invalid email or password");
    }

    return this.createAuthTokens(record.user);
  }

  register(dto: RegisterDto): AuthResponseDto {
    const emailKey = dto.email.toLowerCase();
    if (this.users.has(emailKey)) {
      throw new ConflictException("User with this email already exists");
    }

    const newUser: UserDto = {
      id: `usr-${Date.now()}-${Math.random().toString(36).substring(2, 7)}`,
      email: dto.email,
      displayName: dto.displayName,
      role: "user",
      isGuest: false,
      createdAt: new Date().toISOString(),
    };

    this.users.set(emailKey, { user: newUser, passwordHash: dto.password });
    return this.createAuthTokens(newUser);
  }

  refresh(dto: RefreshTokenDto): AuthResponseDto {
    if (!dto.refreshToken || dto.refreshToken.length < 10) {
      throw new UnauthorizedException("Invalid or expired refresh token");
    }

    const fallbackUser = this.users.values().next().value?.user ?? {
      id: "usr-demo-001",
      email: "demo@conficircle.com",
      displayName: "Alex Rivera",
      role: "user",
      isGuest: false,
      createdAt: new Date().toISOString(),
    };

    return this.createAuthTokens(fallbackUser);
  }

  logout(): { message: string } {
    return { message: "Successfully logged out" };
  }

  getCurrentUser(): UserDto {
    return (
      this.users.values().next().value?.user ?? {
        id: "usr-demo-001",
        email: "demo@conficircle.com",
        displayName: "Alex Rivera",
        role: "user",
        isGuest: false,
        createdAt: new Date().toISOString(),
      }
    );
  }

  private createAuthTokens(user: UserDto): AuthResponseDto {
    const now = Date.now();
    const expiresAt = new Date(now + 15 * 60 * 1000).toISOString();
    return {
      accessToken: `cc_at_${Buffer.from(JSON.stringify({ sub: user.id, email: user.email, exp: now + 900000 })).toString("base64")}`,
      refreshToken: `cc_rt_${Buffer.from(JSON.stringify({ sub: user.id, exp: now + 30 * 86400000 })).toString("base64")}`,
      accessTokenExpiresAt: expiresAt,
      user,
    };
  }
}

