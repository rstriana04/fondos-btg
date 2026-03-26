# Prompt para Claude Code — FondosBTG Monorepo

## Contexto del proyecto

Crea un **monorepo** para la aplicación **FondosBTG**, una app de manejo de Fondos de Inversión (FPV/FIC) para clientes BTG Pactual. El monorepo debe contener **dos implementaciones frontend** del mismo producto: una en **Flutter** (Dart) y otra en **Angular** (TypeScript). Ambas comparten la misma lógica de negocio, modelos de datos y diseño visual.

Este es un proyecto de prueba técnica. El objetivo es demostrar **excelente calidad de código**, arquitectura escalable, y dominio de patrones de diseño. No se requiere backend real — se usa mock data / json-server.

---

## Estructura del monorepo

```
fondos-btg/
├── README.md                          # Documentación general del monorepo
├── docs/
│   ├── architecture.md                # Diagrama y explicación de arquitectura
│   ├── design-system.md               # Paleta, tipografía, componentes
│   └── api-contract.md                # Contrato de la API simulada
├── packages/
│   └── shared/
│       ├── mock-api/                  # JSON Server o mock data compartido
│       │   ├── db.json                # Base de datos mock
│       │   ├── package.json
│       │   └── README.md
│       └── api-contract/              # Definición de tipos/interfaces compartidas (TypeScript)
│           ├── src/
│           │   ├── models/
│           │   │   ├── fund.ts
│           │   │   ├── transaction.ts
│           │   │   └── user.ts
│           │   ├── enums/
│           │   │   ├── fund-category.ts
│           │   │   └── notification-method.ts
│           │   └── index.ts
│           ├── package.json
│           └── tsconfig.json
├── apps/
│   ├── flutter-app/                   # Implementación Flutter
│   └── angular-app/                   # Implementación Angular
├── .gitignore
├── .editorconfig
└── package.json                       # Workspace root (npm/yarn workspaces)
```

---

## Datos del negocio (hardcoded en mock)

### Usuario único
- Saldo inicial: COP $500.000

### Fondos disponibles

| ID | Nombre | Monto mínimo | Categoría |
|----|--------|-------------|-----------|
| 1 | FPV_BTG_PACTUAL_RECAUDADORA | $75.000 | FPV |
| 2 | FPV_BTG_PACTUAL_ECOPETROL | $125.000 | FPV |
| 3 | DEUDAPRIVADA | $50.000 | FIC |
| 4 | FDO-ACCIONES | $250.000 | FIC |
| 5 | FPV_BTG_PACTUAL_DINAMICA | $100.000 | FPV |

### Mock API (`db.json` para json-server)

```json
{
  "funds": [
    { "id": "1", "name": "FPV_BTG_PACTUAL_RECAUDADORA", "minAmount": 75000, "category": "FPV" },
    { "id": "2", "name": "FPV_BTG_PACTUAL_ECOPETROL", "minAmount": 125000, "category": "FPV" },
    { "id": "3", "name": "DEUDAPRIVADA", "minAmount": 50000, "category": "FIC" },
    { "id": "4", "name": "FDO-ACCIONES", "minAmount": 250000, "category": "FIC" },
    { "id": "5", "name": "FPV_BTG_PACTUAL_DINAMICA", "minAmount": 100000, "category": "FPV" }
  ],
  "user": {
    "id": "1",
    "name": "Usuario Demo",
    "balance": 500000,
    "subscribedFunds": []
  },
  "transactions": []
}
```

---

## Requisitos funcionales

1. **Visualizar fondos disponibles** — lista con nombre, monto mínimo, categoría (FPV/FIC)
2. **Suscribirse a un fondo** — validar saldo ≥ monto mínimo, descontar del saldo, registrar transacción
3. **Seleccionar método de notificación** — email o SMS al suscribirse (solo UI, sin lógica real de envío)
4. **Cancelar suscripción** — devolver monto al saldo, registrar transacción de cancelación
5. **Ver saldo actualizado** — permanente en header, reactivo a cada operación
6. **Historial de transacciones** — lista ordenada por fecha con tipo, fondo, monto y fecha
7. **Mensajes de error** — saldo insuficiente, fondo ya suscrito, validaciones de formulario

---

## Arquitectura y patrones de diseño

### Clean Architecture (ambas apps)

Implementar **3 capas** con dependencias unidireccionales (Domain ← Data ← Presentation):

```
┌─────────────────────────────────────────┐
│  PRESENTATION (UI)                      │
│  - Pages / Screens                      │
│  - Widgets / Components                 │
│  - State Management (BLoC / Services)   │
│  - View Models                          │
├─────────────────────────────────────────┤
│  DOMAIN (Business Logic)                │
│  - Entities                             │
│  - Use Cases                            │
│  - Repository Interfaces (abstractions) │
│  - Value Objects                        │
│  - Failures / Exceptions                │
├─────────────────────────────────────────┤
│  DATA (Infrastructure)                  │
│  - Repository Implementations           │
│  - Data Sources (Remote / Local)        │
│  - DTOs / Mappers                       │
│  - API Client                           │
└─────────────────────────────────────────┘
```

### Patrones de diseño requeridos

1. **Repository Pattern** — abstracción de acceso a datos con interface en Domain e implementación en Data
2. **Use Case / Interactor Pattern** — cada acción de negocio es un Use Case independiente (`SubscribeToFundUseCase`, `CancelSubscriptionUseCase`, `GetFundsUseCase`, `GetTransactionsUseCase`)
3. **DTO + Mapper Pattern** — separación entre modelos de API (DTOs) y entidades de dominio
4. **Observer Pattern** — manejo reactivo del estado (BLoC en Flutter, RxJS/Signals en Angular)
5. **Dependency Injection** — inversión de dependencias en ambas apps
6. **Result/Either Pattern** — manejo funcional de errores (no try/catch en dominio). Usar `Either<Failure, Success>` o similar
7. **Factory Pattern** — para crear instancias de entidades o transacciones
8. **Singleton Pattern** — para el API client y servicios compartidos

---

## Especificación por tecnología

### Flutter App (`apps/flutter-app/`)

**Estado**: BLoC (flutter_bloc) como primera opción. Si prefieres simplificar, Provider + ChangeNotifier.

**Estructura interna**:
```
lib/
├── core/
│   ├── di/                    # Dependency injection (get_it + injectable)
│   │   └── injection.dart
│   ├── error/
│   │   ├── failures.dart      # Failure classes (sealed class)
│   │   └── exceptions.dart
│   ├── network/
│   │   └── api_client.dart    # Dio HTTP client wrapper
│   ├── theme/
│   │   ├── app_theme.dart     # ThemeData con la paleta FondosBTG
│   │   ├── app_colors.dart    # Constantes de color
│   │   └── app_text_styles.dart
│   ├── utils/
│   │   ├── currency_formatter.dart
│   │   └── date_formatter.dart
│   └── either.dart            # Either<L, R> implementation o usar dartz/fpdart
├── features/
│   ├── funds/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── fund.dart
│   │   │   ├── repositories/
│   │   │   │   └── fund_repository.dart       # Abstract
│   │   │   └── usecases/
│   │   │       ├── get_funds.dart
│   │   │       └── subscribe_to_fund.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── fund_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── fund_dto.dart              # fromJson, toEntity()
│   │   │   └── repositories/
│   │   │       └── fund_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/                          # o provider/
│   │       │   ├── fund_bloc.dart
│   │       │   ├── fund_event.dart
│   │       │   └── fund_state.dart
│   │       ├── pages/
│   │       │   └── funds_page.dart
│   │       └── widgets/
│   │           ├── fund_card.dart
│   │           ├── fund_category_badge.dart
│   │           └── subscribe_bottom_sheet.dart
│   ├── portfolio/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── subscription.dart
│   │   │   ├── repositories/
│   │   │   │   └── portfolio_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_active_subscriptions.dart
│   │   │       └── cancel_subscription.dart
│   │   ├── data/  ...
│   │   └── presentation/ ...
│   ├── transactions/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── transaction.dart
│   │   │   ├── repositories/
│   │   │   │   └── transaction_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_transactions.dart
│   │   ├── data/ ...
│   │   └── presentation/ ...
│   └── balance/
│       ├── domain/ ...
│       ├── data/ ...
│       └── presentation/
│           └── widgets/
│               └── balance_header.dart
├── app.dart                   # MaterialApp con router y theme
└── main.dart                  # Entry point con DI setup
```

**Dependencias sugeridas para Flutter** (pubspec.yaml):
```yaml
dependencies:
  flutter_bloc: ^8.x
  get_it: ^7.x
  dio: ^5.x
  equatable: ^2.x
  dartz: ^0.10.x   # Either type
  go_router: ^14.x  # Navigation
  intl: ^0.19.x     # Formatting

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.x
  mocktail: ^1.x
```

**Routing**: Usar `go_router` con 3 rutas principales:
- `/` → FundsPage (Home)
- `/portfolio` → PortfolioPage (Mis fondos)
- `/transactions` → TransactionsPage (Historial)

**Navegación**: BottomNavigationBar con `ShellRoute` de go_router.

---

### Angular App (`apps/angular-app/`)

**Estado**: Signals (Angular 21) como primera opción. Si no, servicios con BehaviorSubject/RxJS.

**Estructura interna**:
```
src/
├── app/
│   ├── core/
│   │   ├── di/
│   │   │   └── tokens.ts              # InjectionTokens
│   │   ├── errors/
│   │   │   ├── failures.ts
│   │   │   └── either.ts             # Result<T, E> type
│   │   ├── http/
│   │   │   ├── api-client.service.ts
│   │   │   └── api.interceptor.ts
│   │   ├── theme/
│   │   │   └── variables.scss         # CSS custom properties
│   │   └── utils/
│   │       ├── currency.pipe.ts       # COP formatter pipe
│   │       └── date.pipe.ts
│   ├── features/
│   │   ├── funds/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── fund.entity.ts
│   │   │   │   ├── repositories/
│   │   │   │   │   └── fund.repository.ts        # Abstract class
│   │   │   │   └── usecases/
│   │   │   │       ├── get-funds.usecase.ts
│   │   │   │       └── subscribe-to-fund.usecase.ts
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── fund-remote.datasource.ts
│   │   │   │   ├── dtos/
│   │   │   │   │   └── fund.dto.ts
│   │   │   │   ├── mappers/
│   │   │   │   │   └── fund.mapper.ts
│   │   │   │   └── repositories/
│   │   │   │       └── fund.repository-impl.ts
│   │   │   └── presentation/
│   │   │       ├── components/
│   │   │       │   ├── fund-card/
│   │   │       │   │   ├── fund-card.component.ts
│   │   │       │   │   ├── fund-card.component.html
│   │   │       │   │   └── fund-card.component.scss
│   │   │       │   ├── fund-category-badge/
│   │   │       │   └── subscribe-dialog/
│   │   │       ├── pages/
│   │   │       │   └── funds-page/
│   │   │       │       ├── funds-page.component.ts
│   │   │       │       └── funds-page.component.html
│   │   │       └── state/
│   │   │           └── funds.store.ts             # Signal-based store
│   │   ├── portfolio/
│   │   │   ├── domain/ ...
│   │   │   ├── data/ ...
│   │   │   └── presentation/ ...
│   │   ├── transactions/
│   │   │   ├── domain/ ...
│   │   │   ├── data/ ...
│   │   │   └── presentation/ ...
│   │   └── balance/
│   │       └── presentation/
│   │           └── components/
│   │               └── balance-header/
│   ├── shared/
│   │   └── components/
│   │       ├── bottom-nav/
│   │       ├── error-message/
│   │       └── loading-spinner/
│   ├── app.component.ts
│   ├── app.config.ts
│   └── app.routes.ts
├── styles/
│   ├── _variables.scss
│   ├── _mixins.scss
│   └── styles.scss
└── main.ts
```

**Angular CLI**: Usar Angular 21 con standalone components, signals, y el nuevo control flow (`@if`, `@for`).

**Routing**:
```typescript
export const routes: Routes = [
  { path: '', component: FundsPageComponent },
  { path: 'portfolio', component: PortfolioPageComponent },
  { path: 'transactions', component: TransactionsPageComponent },
  { path: '**', redirectTo: '' }
];
```

**TypeScript strict mode**: Habilitar `strict: true` en tsconfig.

---

## Paleta de colores (Design System)

```scss
// Primarios (brand BTG Pactual)
$navy:       #0A2647;
$blue-dark:  #144272;
$blue-mid:   #205295;
$blue-accent:#2C74B3;

// Semánticos
$success:    #1D9E75;
$error:      #E24B4A;
$warning:    #EF9F27;

// Superficies
$bg-white:   #FFFFFF;
$bg-surface: #F5F7FA;
$divider:    #E8ECF1;

// Badges de categoría
$fpv-bg:     #E6F1FB;
$fpv-text:   #0C447C;
$fic-bg:     #EEEDFE;
$fic-text:   #3C3489;

// Texto
$text-primary:   #0A2647;
$text-secondary: #888780;
$text-muted:     #B4B2A9;
```

---

## Principios de Clean Code a seguir

1. **Nombrado descriptivo** — variables, funciones y clases con nombres que explican su propósito
2. **Funciones pequeñas** — máximo 20-30 líneas por función, una sola responsabilidad
3. **DRY** — no repetir lógica; extraer a utils, mixins o clases base
4. **SOLID** — aplicar todos los principios:
   - **S**: cada clase/widget tiene una sola razón para cambiar
   - **O**: usar abstracciones e interfaces que permitan extender sin modificar
   - **L**: las implementaciones deben ser intercambiables por sus abstracciones
   - **I**: interfaces específicas, no genéricas (no un `FundService` que haga todo)
   - **D**: depender de abstracciones (Repository interfaces), no de implementaciones
5. **Comentarios mínimos** — el código debe ser autoexplicativo; comentar solo el "por qué", nunca el "qué"
6. **Manejo de errores explícito** — usar Either/Result, nunca swallow exceptions
7. **Inmutabilidad** — entidades inmutables, usar `copyWith` en Flutter, `readonly` en TypeScript
8. **Formateo consistente** — usar linter y formatter configurados

---

## Configuración de linters

### Flutter
```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml
linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
    prefer_final_locals: true
    sort_constructors_first: true
    always_declare_return_types: true
```

### Angular
```json
// .eslintrc.json — usar @angular-eslint
{
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-explicit-any": "error",
    "prefer-const": "error"
  }
}
```

---

## Tests unitarios (extras valorados)

### Flutter — usar `flutter_test` + `bloc_test` + `mocktail`
- Tests de Use Cases (dominio puro, sin dependencias externas)
- Tests de BLoC (estados y eventos)
- Tests de Repositories (con datasource mockeado)

### Angular — usar Jasmine + TestBed
- Tests de Use Cases
- Tests de componentes (con jasmine spy para servicios)
- Tests de stores/servicios de estado

Ejemplo de test de Use Case:
```dart
// Flutter
test('should return failure when balance is insufficient', () async {
  final result = await subscribeToFundUseCase(
    SubscribeParams(fundId: '4', amount: 250000, balance: 100000),
  );
  expect(result.isLeft(), true);
});
```

---

## Entregables esperados

1. **Monorepo funcional** con ambas apps corriendo independientemente
2. **README.md** en cada app con instrucciones de instalación y ejecución
3. **README.md** raíz con overview del proyecto, arquitectura y cómo correr ambas versiones
4. **Mock API** funcional con json-server
5. **Código limpio** que pase los linters sin warnings
6. **Al menos 5 tests unitarios** por app (Use Cases + State Management)

---

## Instrucciones de ejecución

Crea scripts en el `package.json` raíz:
```json
{
  "scripts": {
    "api:start": "cd packages/shared/mock-api && npx json-server db.json --port 3000",
    "flutter:run": "cd apps/flutter-app && flutter run -d chrome",
    "angular:serve": "cd apps/angular-app && ng serve --port 4200",
    "start:all": "concurrently \"npm run api:start\" \"npm run angular:serve\""
  }
}
```

---

## IMPORTANTE

- **No implementes backend, autenticación** — es frontend puro con mock
- **Prioriza calidad sobre cantidad** — es mejor menos código excelente que mucho código mediocre
- **El diseño visual debe seguir la paleta definida** — navy, azul, badges de categoría FPV/FIC
- **Responsivo** — la app debe funcionar en mobile y desktop
- **Empieza por la capa de dominio** — entities y use cases primero, luego data, luego UI
- **Cada Use Case es una clase independiente** con un solo método `call()` o `execute()`
- **Los modelos de dominio (entities) no deben tener dependencias de frameworks** — son Dart/TS puro
- **Implementa una estrategia para desplegar ambas apps, en lo posible en servicios gratuitos dado que es para una prueba tecnica**
- **Todo el codigo como nombres de archivos, variables, etc deberan estar en Ingles** 