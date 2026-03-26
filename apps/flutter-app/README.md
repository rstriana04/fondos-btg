# FondosBTG — Flutter App

Flutter implementation of the FondosBTG investment funds management app using Clean Architecture, BLoC pattern, and Material Design.

## Architecture

```
lib/
├── core/                  # Cross-cutting concerns
│   ├── di/                # Dependency injection (get_it)
│   ├── error/             # Failures and exceptions
│   ├── network/           # Dio API client
│   ├── theme/             # Colors, text styles, theme
│   └── utils/             # Formatters (currency, date, fund names)
├── features/
│   ├── funds/             # Fund listing and subscription
│   ├── portfolio/         # Active subscriptions management
│   ├── transactions/      # Transaction history
│   └── balance/           # User balance display
├── app.dart               # MaterialApp with router and providers
└── main.dart              # Entry point
```

Each feature follows Clean Architecture:
- **domain/** — Entities, Use Cases, Repository interfaces
- **data/** — DTOs, DataSources, Repository implementations
- **presentation/** — BLoC (events/states), Pages, Widgets

## Tech Stack

| Concern | Library |
|---------|---------|
| State Management | flutter_bloc ^8.x |
| Dependency Injection | get_it ^7.x |
| HTTP Client | dio ^5.x |
| Routing | go_router ^14.x |
| Error Handling | dartz ^0.10.x (Either type) |
| Equality | equatable ^2.x |
| Formatting | intl ^0.19.x |

## Prerequisites

- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0
- Mock API running on `http://localhost:3000`

## Run

```bash
# Start the mock API first
cd ../../packages/shared/mock-api && npm start

# Run on Chrome
flutter run -d chrome

# Or from monorepo root
npm run flutter:run
```

## Test

```bash
flutter test
```

## Design

The app follows the BTG Pactual brand design system with:
- Navy (#0A2647) header with balance display
- FPV (blue) and FIC (purple) category badges
- Bottom navigation with 3 tabs
- Subscribe bottom sheet with notification selector
- Responsive layout for mobile and web
