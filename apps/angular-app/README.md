# FondosBTG — Angular App

Angular implementation of the FondosBTG investment funds management app using Clean Architecture, Signal-based stores, and standalone components.

## Architecture

```
src/app/
├── core/                  # Cross-cutting concerns
│   ├── di/                # InjectionTokens
│   ├── errors/            # Either/Result type, Failure classes
│   ├── http/              # HttpClient API wrapper
│   └── utils/             # Pipes (currency, date, fund-name)
├── features/
│   ├── funds/             # Fund listing and subscription
│   ├── portfolio/         # Active subscriptions management
│   ├── transactions/      # Transaction history
│   └── balance/           # User balance (global store)
├── shared/
│   └── components/        # Bottom nav, sidebar, layout, error, spinner
├── app.component.ts       # Root component
├── app.config.ts          # Providers and DI configuration
└── app.routes.ts          # Route definitions
```

Each feature follows Clean Architecture:
- **domain/** — Entities, Use Cases, Repository abstract classes
- **data/** — DTOs, Mappers, DataSources, Repository implementations
- **presentation/** — Signal stores, Pages, Components

## Tech Stack

| Concern | Implementation |
|---------|---------------|
| State Management | Angular Signals (signal, computed) |
| Components | Standalone with new control flow (@if, @for) |
| HTTP Client | Angular HttpClient |
| Routing | @angular/router |
| Error Handling | Custom Either/Result type |
| DI | InjectionTokens + Angular DI |
| Styling | SCSS with CSS custom properties |

## Prerequisites

- Node.js >= 18
- Angular CLI
- Mock API running on `http://localhost:3000`

## Run

```bash
# Install dependencies
npm install

# Start the mock API first
cd ../../packages/shared/mock-api && npm start

# Serve the app
ng serve --port 4200

# Or from monorepo root
npm run angular:serve
```

Open http://localhost:4200

## Build

```bash
ng build
# Output: dist/angular-app/
```

## Test

```bash
ng test
```

## Design

The app follows the BTG Pactual brand design system with:
- Responsive layout: sidebar on desktop (>= 960px), bottom nav on mobile
- Navy (#0A2647) theme with FPV (blue) and FIC (purple) badges
- Signal-based reactive stores for all state management
- Subscribe dialog (desktop) / bottom sheet (mobile)
- Transaction table (desktop) / list (mobile)
