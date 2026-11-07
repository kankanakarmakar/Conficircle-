# ConfiCircle — Flutter Frontend Client

This directory is the self-contained Flutter mobile and web client for **ConfiCircle**, completely separated from backend and container infrastructure.

---

## 📁 Directory Structure

```
frontend/
├── lib/
│   ├── core/                  # API client, Auth, Guest storage, Error envelopes, Config, Theme, Widgets
│   │   ├── api_client/        # Dio client with Auth, Idempotency, and Error interceptors
│   │   ├── auth/              # Secure token manager (JWT access & refresh tokens)
│   │   ├── guest/             # Device-level guest identity storage
│   │   ├── error/             # 5-state typed errors & error-code mappers
│   │   └── widgets/           # LoadingStateWidget, Skeleton loaders, Offline banners, Access-denied CTA
│   ├── features/              # Feature-first Clean Architecture layers
│   │   ├── auth/              # Domain (Entities, UseCases), Data (DTOs, Mappers, Repos), Presentation (Riverpod)
│   │   ├── guest/             # Guest session orchestration, Level 4 question selection, Quick Tip quotas
│   │   ├── home/              # Dynamic dashboard (Guest vs Registered user views)
│   │   ├── confizone/         # Learning topics, video solutions, quizzes
│   │   ├── resources/         # Downloadable materials, filter by category/tags
│   │   ├── circle/            # Community feeds & groups
│   │   └── me/                # Profile, Confy points ledger, and level badges
│   ├── main.dart              # App bootstrap with Riverpod ProviderScope
│   └── router.dart            # GoRouter configuration & route guards
├── assets/                    # Static images, illustrations, and icons
├── test/                      # Unit & widget test suites (100% passing)
├── web/                       # Web index, manifest, and service worker
├── android/                   # Android Gradle runner
├── ios/                       # iOS runner & Podfile
├── windows/                   # Windows desktop runner
├── pubspec.yaml               # Flutter & package dependencies
└── analysis_options.yaml      # Dart analysis rules
```

---

## 🔌 Backend Connectivity

The frontend automatically resolves the backend connection through `lib/core/api_client/api_client.dart`:

| Environment | Resolved Backend Base URL |
|---|---|
| **Web (`localhost:8080`)** | `http://localhost:3000` *(matches NestJS CORS config)* |
| **Android Emulator** | `http://10.0.2.2:3000` *(routes directly to host machine)* |
| **iOS Simulator / Desktop** | `http://localhost:3000` |
| **Custom / Production** | Pass `--dart-define=API_URL=https://your-api.com` at build time |

Every mutating request automatically carries:
- `Authorization: Bearer <token>` for logged-in users
- `X-Guest-Ref: <guestRef>` for guest users
- `Idempotency-Key: <uuid>` to prevent duplicate operations and quota double-deductions

---

## 🚀 Running the App

### 1. Web
To run in Chrome with hot reload:
```powershell
cd frontend
flutter run -d chrome --web-port 8080
```

To build and serve the production web release:
```powershell
cd frontend
flutter build web --release
python -m http.server 8080 --directory build/web
```

### 2. Tests
Run all 13 unit and widget tests:
```powershell
cd frontend
flutter test
```

### 3. Android / iOS
```powershell
cd frontend
flutter run -d android
# or
flutter run -d ios
```
