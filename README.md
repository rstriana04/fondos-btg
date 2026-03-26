# FondosBTG — Investment Funds Management App

Monorepo for the **FondosBTG** application, a fund management platform for BTG Pactual clients. Contains two independent frontend implementations sharing the same business logic, data models, and visual design.

## Architecture

Both apps follow **Clean Architecture** with three layers:

```
Presentation → Domain ← Data
```

- **Domain**: Entities, Use Cases, Repository interfaces (pure Dart/TypeScript)
- **Data**: DTOs, Mappers, DataSources, Repository implementations
- **Presentation**: BLoC (Flutter) / Signals (Angular), Pages, Components

See [docs/architecture.md](docs/architecture.md) for details.

## Project Structure

```
fondos-btg/
├── apps/
│   ├── flutter-app/          # Flutter implementation (Dart + BLoC)
│   └── angular-app/          # Angular implementation (TypeScript + Signals)
├── packages/
│   └── shared/
│       ├── mock-api/          # JSON Server mock backend
│       └── api-contract/      # Shared TypeScript type definitions
├── docs/
│   ├── architecture.md        # Architecture diagrams and patterns
│   ├── design-system.md       # Colors, typography, components
│   ├── api-contract.md        # API endpoint documentation
│   └── mockups/               # HTML mockups (mobile + desktop)
└── package.json               # Workspace root
```

## Quick Start

### Prerequisites

- Node.js >= 18
- Flutter SDK >= 3.2 (for Flutter app)
- Angular CLI (for Angular app)

### 1. Install dependencies

```bash
npm install
```

### 2. Start the Mock API

```bash
npm run api:start
# Runs on http://localhost:3000
```

### 3. Run Flutter App

```bash
npm run flutter:run
# Or: cd apps/flutter-app && flutter run -d chrome
```

### 4. Run Angular App

```bash
npm run angular:serve
# Or: cd apps/angular-app && ng serve --port 4200
# Opens on http://localhost:4200
```

### 5. Run both (Angular + API)

```bash
npm run start:all
```

## Features

| Feature | Description |
|---------|-------------|
| View Funds | Browse available investment funds (FPV/FIC) |
| Subscribe | Subscribe to a fund with balance validation |
| Notification | Choose email or SMS notification on subscribe |
| Portfolio | View active subscriptions with invested amounts |
| Cancel | Cancel subscription and restore balance |
| History | View all transactions with type, date, and amount |
| Balance | Real-time balance display, reactive to operations |

## Design Patterns

- **Repository Pattern** — Data access abstraction
- **Use Case / Interactor** — Single-responsibility business actions
- **DTO + Mapper** — API/domain model separation
- **Observer (BLoC/Signals)** — Reactive state management
- **Dependency Injection** — Inversion of control
- **Either/Result** — Functional error handling
- **Factory** — Entity creation
- **Singleton** — API client instances

## Tech Stack

| | Flutter | Angular |
|---|---------|---------|
| Language | Dart | TypeScript |
| State | BLoC (flutter_bloc) | Signals |
| DI | get_it | Angular DI + InjectionTokens |
| HTTP | Dio | HttpClient |
| Routing | go_router | @angular/router |
| Error Handling | dartz Either | Custom Result type |
| Testing | flutter_test + bloc_test + mocktail | Jasmine + TestBed |

## Documentation

- [Architecture](docs/architecture.md)
- [Design System](docs/design-system.md)
- [API Contract](docs/api-contract.md)
- [Flutter App README](apps/flutter-app/README.md)
- [Angular App README](apps/angular-app/README.md)
- [Mock API README](packages/shared/mock-api/README.md)

## Deployment

Both apps can be deployed to free-tier hosting services:

- **Flutter (Web)**: Firebase Hosting, Vercel, or Netlify
- **Angular**: Vercel, Netlify, or Firebase Hosting
- **Mock API**: Railway, Render, or Glitch

## License

This project is a technical assessment. All rights reserved.
