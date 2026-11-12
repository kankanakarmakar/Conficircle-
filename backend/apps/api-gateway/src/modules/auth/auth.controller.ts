import { Controller, Post, Body, Get, HttpCode, HttpStatus } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from "@nestjs/swagger";
import { AuthService } from "./auth.service";
import { LoginDto, RegisterDto, RefreshTokenDto, AuthResponseDto, UserDto } from "./dto/auth.dto";

@ApiTags("Auth")
@Controller("v1/auth")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post("login")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Authenticate user and issue JWT access & refresh tokens" })
  @ApiResponse({ status: 200, description: "Successfully authenticated", type: AuthResponseDto })
  @ApiResponse({ status: 401, description: "Invalid credentials" })
  login(@Body() dto: LoginDto): AuthResponseDto {
    return this.authService.login(dto);
  }

  @Post("register")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: "Register a new user account" })
  @ApiResponse({ status: 201, description: "Account created successfully", type: AuthResponseDto })
  @ApiResponse({ status: 409, description: "Email already registered" })
  register(@Body() dto: RegisterDto): AuthResponseDto {
    return this.authService.register(dto);
  }

  @Post("refresh")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Exchange a valid refresh token for a fresh token pair" })
  @ApiResponse({ status: 200, description: "Tokens refreshed", type: AuthResponseDto })
  @ApiResponse({ status: 401, description: "Invalid refresh token" })
  refresh(@Body() dto: RefreshTokenDto): AuthResponseDto {
    return this.authService.refresh(dto);
  }

  @Post("logout")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Invalidate the active session" })
  @ApiResponse({ status: 200, description: "Logged out successfully" })
  logout(): { message: string } {
    return this.authService.logout();
  }

  @Get("me")
  @ApiBearerAuth()
  @ApiOperation({ summary: "Retrieve the authenticated user's profile" })
  @ApiResponse({ status: 200, description: "Current user profile", type: UserDto })
  getProfile(): UserDto {
    return this.authService.getCurrentUser();
  }
}

