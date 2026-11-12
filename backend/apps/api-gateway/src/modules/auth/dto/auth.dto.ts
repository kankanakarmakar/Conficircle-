import { ApiProperty } from "@nestjs/swagger";
import { IsEmail, IsNotEmpty, IsString, MinLength } from "class-validator";

export class LoginDto {
  @ApiProperty({ example: "user@example.com", description: "Registered email address" })
  @IsEmail()
  email!: string;

  @ApiProperty({ example: "password123", description: "User password (minimum 6 chars)" })
  @IsString()
  @MinLength(6)
  password!: string;
}

export class RegisterDto {
  @ApiProperty({ example: "Jane Doe", description: "Display name" })
  @IsString()
  @IsNotEmpty()
  displayName!: string;

  @ApiProperty({ example: "jane@example.com", description: "User email address" })
  @IsEmail()
  email!: string;

  @ApiProperty({ example: "password123", description: "Account password (min 6 characters)" })
  @IsString()
  @MinLength(6)
  password!: string;
}

export class RefreshTokenDto {
  @ApiProperty({ example: "eyJhbGciOi...", description: "Valid refresh token string" })
  @IsString()
  @IsNotEmpty()
  refreshToken!: string;
}

export class UserDto {
  @ApiProperty({ example: "usr-001", description: "Unique user UUID" })
  id!: string;

  @ApiProperty({ example: "Jane Doe", description: "User full or display name" })
  displayName!: string;

  @ApiProperty({ example: "jane@example.com", description: "Email address" })
  email!: string;

  @ApiProperty({ example: "user", enum: ["user", "admin", "guest"], description: "Role" })
  role!: string;

  @ApiProperty({ example: false, description: "Whether this profile is an unauthenticated guest" })
  isGuest!: boolean;

  @ApiProperty({ example: "2026-11-12T00:00:00.000Z", description: "Creation ISO timestamp" })
  createdAt!: string;
}

export class AuthResponseDto {
  @ApiProperty({ example: "eyJhbGciOi...", description: "JWT Bearer access token" })
  accessToken!: string;

  @ApiProperty({ example: "eyJhbGciOi...", description: "Long-lived refresh token" })
  refreshToken!: string;

  @ApiProperty({ example: "2026-11-12T00:15:00.000Z", description: "Access token expiration timestamp" })
  accessTokenExpiresAt!: string;

  @ApiProperty({ type: () => UserDto, description: "Authenticated user details" })
  user!: UserDto;
}

