# Architecture — FondosBTG

## Overview

FondosBTG follows **Clean Architecture** principles in both the Flutter and Angular implementations. Each app is structured in three layers with unidirectional dependencies.

## Layer Diagram

```
┌─────────────────────────────────────────┐
│  PRESENTATION (UI)                      │
│  - Pages / Screens                      │
│  - Widgets / Components                 │
│  - State Management (BLoC / Signals)    │
│  - View Models                          │
├─────────────────────────────────────────┤
│  DOMAIN (Business Logic)                │
│  - Entities                             │
│  - Use Cases                            │
│  - Repository Interfaces (abstractions) │
│  - Failures / Exceptions                │
├─────────────────────────────────────────┤
│  DATA (Infrastructure)                  │
│  - Repository Implementations           │
│  - Data Sources (Remote)                │
│  - DTOs / Mappers                       │
│  - API Client                           │
└─────────────────────────────────────────┘
```

## Dependency Rule

Dependencies only flow **inward** — outer layers depend on inner layers, never the reverse:

```
Presentation → Domain ← Data
```

- **Domain** has no dependencies on external packages or frameworks
- **Data** implements interfaces defined in Domain
- **Presentation** uses Domain entities and orchestrates through Use Cases

## Design Patterns

### 1. Repository Pattern
Abstract repository interfaces are defined in the Domain layer. Concrete implementations live in the Data layer and can be swapped without affecting business logic.

### 2. Use Case / Interactor Pattern
Each business action is encapsulated in a dedicated Use Case class with a single `call()` (Flutter) or `execute()` (Angular) method.

| Use Case | Description |
|----------|-------------|
| `GetFundsUseCase` | Fetches all available funds |
| `SubscribeToFundUseCase` | Validates and subscribes user to a fund |
| `CancelSubscriptionUseCase` | Cancels subscription and restores balance |
| `GetActiveSubscriptionsUseCase` | Fetches user's active subscriptions |
| `GetTransactionsUseCase` | Fetches transaction history |
| `GetBalanceUseCase` | Fetches current user balance info |

### 3. DTO + Mapper Pattern
API responses are mapped to DTOs (Data Transfer Objects), which are then converted to domain entities. This decouples the API contract from business logic.

### 4. Observer Pattern
- **Flutter**: BLoC pattern with `flutter_bloc` — events trigger state changes reactively
- **Angular**: Signal-based stores using Angular's built-in `signal()`, `computed()`, and `effect()`

### 5. Dependency Injection
- **Flutter**: `get_it` service locator — all dependencies registered at app startup
- **Angular**: Provider-based DI with `InjectionToken` and `providedIn` annotations

### 6. Result/Either Pattern
Errors are handled functionally using `Either<Failure, Success>` (Flutter/dartz) or `Result<T, E>` (Angular). No try/catch in the domain layer.

### 7. Factory Pattern
Entities and transactions use factory constructors for creation from different sources.

## Feature-Based Structure

Both apps organize code by feature (funds, portfolio, transactions, balance), each containing its own domain/data/presentation layers:

```
features/
├── funds/
│   ├── domain/
│   ├── data/
│   └── presentation/
├── portfolio/
│   ├── domain/
│   ├── data/
│   └── presentation/
├── transactions/
│   ├── domain/
│   ├── data/
│   └── presentation/
└── balance/
    ├── domain/
    ├── data/
    └── presentation/
```

## Data Flow

```
User Action → BLoC/Store Event → Use Case → Repository → DataSource → API
                                                                        ↓
UI Update ← BLoC/Store State ← Use Case Result ← Repository ← DTO/Mapper
```

## Technology Stack

| Aspect | Flutter | Angular |
|--------|---------|---------|
| Language | Dart | TypeScript |
| State | BLoC (flutter_bloc) | Signals |
| DI | get_it | Angular DI |
| HTTP | Dio | HttpClient |
| Routing | go_router | @angular/router |
| Error Handling | dartz Either | Custom Result type |
