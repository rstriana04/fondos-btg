# Deployment Guide — FondosBTG

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [1. Mock API (json-server)](#1-mock-api-json-server)
  - [Local](#local)
  - [Deploy to Railway](#deploy-to-railway)
  - [Deploy to Render](#deploy-to-render)
  - [Deploy to Glitch](#deploy-to-glitch)
- [2. Angular App](#2-angular-app)
  - [Local Development](#local-development)
  - [Production Build](#production-build)
  - [Configure API URL](#configure-api-url-angular)
  - [Deploy to Vercel](#deploy-to-vercel)
  - [Deploy to Netlify](#deploy-to-netlify)
  - [Deploy to Firebase Hosting](#deploy-to-firebase-hosting)
- [3. Flutter Web App](#3-flutter-web-app)
  - [Local Development](#local-development-1)
  - [Production Build](#production-build-1)
  - [Configure API URL](#configure-api-url-flutter)
  - [Deploy to Firebase Hosting](#deploy-to-firebase-hosting-1)
  - [Deploy to Vercel](#deploy-to-vercel-1)
  - [Deploy to Netlify](#deploy-to-netlify-1)
- [4. Full Stack (All Services)](#4-full-stack-all-services)
  - [Docker Compose](#docker-compose)
  - [Quick Start Scripts](#quick-start-scripts)
- [5. Environment Configuration](#5-environment-configuration)
- [6. CI/CD with GitHub Actions](#6-cicd-with-github-actions)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| **Node.js** | >= 18.x | Angular app, Mock API |
| **npm** | >= 9.x | Package management |
| **Flutter SDK** | >= 3.2.0 | Flutter web app |
| **Dart SDK** | >= 3.2.0 | Included with Flutter |
| **Angular CLI** | >= 19.x | `npm install -g @angular/cli` |
| **Git** | >= 2.x | Version control |

Verify installations:

```bash
node -v        # v18.x or higher
npm -v         # 9.x or higher
flutter --version  # 3.2.0 or higher
ng version     # 19.x
```

---

## Project Structure

```
fondos-btg/
├── apps/
│   ├── flutter-app/           # Flutter web application
│   │   ├── lib/               # Dart source code
│   │   ├── web/               # Web entry point (index.html)
│   │   ├── test/              # Unit tests
│   │   └── pubspec.yaml       # Flutter dependencies
│   └── angular-app/           # Angular SPA
│       ├── src/               # TypeScript source code
│       ├── angular.json        # Angular build config
│       └── package.json       # Node dependencies
├── packages/
│   └── shared/
│       ├── mock-api/          # json-server + db.json
│       │   ├── db.json        # Database file
│       │   └── package.json   # json-server dependency
│       └── api-contract/      # Shared TypeScript types
├── docs/                      # Documentation
└── package.json               # Root workspace config
```

---

## 1. Mock API (json-server)

The mock API runs [json-server](https://github.com/typicode/json-server) serving `db.json` on port **3000**.

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/funds` | List all investment funds |
| GET | `/funds/:id` | Get a single fund |
| GET | `/user` | Get user profile (balance, subscriptions) |
| PATCH | `/user` | Update user balance/subscriptions |
| GET | `/transactions` | List all transactions |
| POST | `/transactions` | Create a transaction record |

### Local

```bash
# From the repository root
npm install
npm run api:start

# Or from the mock-api directory
cd packages/shared/mock-api
npm install
npm start
```

The API will be available at `http://localhost:3000`.

### Deploy to Railway

1. Create a new project on [railway.app](https://railway.app).
2. Connect your GitHub repository.
3. Set the following configuration:

| Setting | Value |
|---------|-------|
| Root Directory | `packages/shared/mock-api` |
| Build Command | `npm install` |
| Start Command | `npx json-server db.json --port $PORT --host 0.0.0.0` |

> Railway sets the `$PORT` environment variable automatically.

### Deploy to Render

1. Create a new **Web Service** on [render.com](https://render.com).
2. Connect your repository.
3. Configure:

| Setting | Value |
|---------|-------|
| Root Directory | `packages/shared/mock-api` |
| Build Command | `npm install` |
| Start Command | `npx json-server db.json --port $PORT --host 0.0.0.0` |
| Plan | Free (spins down after inactivity) |

### Deploy to Glitch

1. Create a new project on [glitch.com](https://glitch.com).
2. Import from GitHub.
3. In `package.json` set the start script:

```json
{
  "scripts": {
    "start": "npx json-server db.json --port 3000 --host 0.0.0.0"
  }
}
```

> **Note:** `db.json` is mutable on these platforms. Redeploying resets data to the committed state. For persistent data, use a real database.

---

## 2. Angular App

### Local Development

```bash
# Install dependencies
cd apps/angular-app
npm install

# Start dev server (port 4200)
ng serve --port 4200

# Or from root
npm run angular:serve
```

Open `http://localhost:4200`. Requires the Mock API running on port 3000.

### Production Build

```bash
cd apps/angular-app
ng build

# Output: apps/angular-app/dist/angular-app/
```

The build produces static files in `dist/angular-app/` ready for any static hosting.

### Configure API URL (Angular)

The API base URL is defined in:

```
apps/angular-app/src/app/core/http/api-client.service.ts
```

```typescript
private readonly baseUrl = 'http://localhost:3000';  // Change this
```

**For production**, update this to your deployed Mock API URL:

```typescript
private readonly baseUrl = 'https://your-api.railway.app';
```

**Recommended approach** — use Angular environment files:

1. Create `src/environments/environment.ts`:
```typescript
export const environment = {
  apiUrl: 'http://localhost:3000',
};
```

2. Create `src/environments/environment.prod.ts`:
```typescript
export const environment = {
  apiUrl: 'https://your-api.railway.app',
};
```

3. Add file replacements in `angular.json` under `build > configurations > production`:
```json
"fileReplacements": [
  {
    "replace": "src/environments/environment.ts",
    "with": "src/environments/environment.prod.ts"
  }
]
```

4. Update `api-client.service.ts`:
```typescript
import { environment } from '../../../../environments/environment';
// ...
private readonly baseUrl = environment.apiUrl;
```

### Deploy to Vercel

1. Install the Vercel CLI: `npm i -g vercel`
2. From the Angular app directory:

```bash
cd apps/angular-app
vercel
```

Or configure via the Vercel dashboard:

| Setting | Value |
|---------|-------|
| Framework Preset | Other |
| Root Directory | `apps/angular-app` |
| Build Command | `ng build` |
| Output Directory | `dist/angular-app/browser` |

Create `apps/angular-app/vercel.json` for SPA routing:

```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

### Deploy to Netlify

1. Create a new site on [netlify.com](https://netlify.com).
2. Configure:

| Setting | Value |
|---------|-------|
| Base Directory | `apps/angular-app` |
| Build Command | `ng build` |
| Publish Directory | `apps/angular-app/dist/angular-app/browser` |

Create `apps/angular-app/netlify.toml`:

```toml
[build]
  base = "apps/angular-app"
  command = "ng build"
  publish = "dist/angular-app/browser"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### Deploy to Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting

# Select: apps/angular-app/dist/angular-app/browser as public directory
# Configure as SPA: Yes
# Set up automatic builds: No
```

Update `firebase.json`:

```json
{
  "hosting": {
    "public": "apps/angular-app/dist/angular-app/browser",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

Deploy:

```bash
cd apps/angular-app && ng build
firebase deploy --only hosting
```

---

## 3. Flutter Web App

### Local Development

```bash
cd apps/flutter-app

# Get dependencies
flutter pub get

# Run in Chrome
flutter run -d chrome

# Or from root
npm run flutter:run
```

Requires the Mock API running on port 3000.

### Production Build

```bash
cd apps/flutter-app

# Build for web (optimized)
flutter build web --release

# Output: apps/flutter-app/build/web/
```

The build produces static files in `build/web/` ready for any static hosting.

**With a custom base path** (if hosting under a subdirectory):

```bash
flutter build web --release --base-href /app/
```

### Configure API URL (Flutter)

The API base URL is defined in:

```
apps/flutter-app/lib/core/network/api_client.dart
```

```dart
static const String _baseUrl = 'http://localhost:3000';  // Change this
```

**For production**, update to your deployed Mock API URL:

```dart
static const String _baseUrl = 'https://your-api.railway.app';
```

**Recommended approach** — use Dart compile-time variables:

1. Update `api_client.dart`:
```dart
static const String _baseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://localhost:3000',
);
```

2. Build with the variable:
```bash
flutter build web --release --dart-define=API_URL=https://your-api.railway.app
```

3. Run locally with a custom URL:
```bash
flutter run -d chrome --dart-define=API_URL=http://localhost:3000
```

### Deploy to Firebase Hosting

```bash
firebase init hosting
# Public directory: apps/flutter-app/build/web
# SPA: Yes

cd apps/flutter-app && flutter build web --release
firebase deploy --only hosting
```

### Deploy to Vercel

Create `apps/flutter-app/vercel.json`:

```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

| Setting | Value |
|---------|-------|
| Root Directory | `apps/flutter-app` |
| Build Command | `flutter build web --release` |
| Output Directory | `build/web` |

> Vercel needs Flutter SDK in the build environment. Use a custom build script or pre-build locally and deploy the `build/web` folder.

### Deploy to Netlify

Create `apps/flutter-app/netlify.toml`:

```toml
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

Since Netlify does not have Flutter SDK, **build locally and deploy the output**:

```bash
cd apps/flutter-app
flutter build web --release
npx netlify-cli deploy --dir=build/web --prod
```

---

## 4. Full Stack (All Services)

### Docker Compose

Create `docker-compose.yml` at the repository root:

```yaml
version: "3.8"

services:
  mock-api:
    image: node:18-alpine
    working_dir: /app
    volumes:
      - ./packages/shared/mock-api:/app
    ports:
      - "3000:3000"
    command: sh -c "npm install && npx json-server db.json --port 3000 --host 0.0.0.0"

  angular-app:
    image: node:18-alpine
    working_dir: /app
    volumes:
      - ./apps/angular-app:/app
    ports:
      - "4200:4200"
    depends_on:
      - mock-api
    command: sh -c "npm install && npx ng serve --host 0.0.0.0 --port 4200"

  flutter-app:
    build:
      context: ./apps/flutter-app
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    depends_on:
      - mock-api
```

For Flutter, create `apps/flutter-app/Dockerfile`:

```dockerfile
# Build stage
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Serve stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

And `apps/flutter-app/nginx.conf`:

```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

Run everything:

```bash
docker compose up -d
```

| Service | URL |
|---------|-----|
| Mock API | http://localhost:3000 |
| Angular App | http://localhost:4200 |
| Flutter App | http://localhost:8080 |

### Quick Start Scripts

From the repository root, no Docker required:

```bash
# Install all dependencies
npm install
cd apps/angular-app && npm install && cd ../..
cd apps/flutter-app && flutter pub get && cd ../..

# Start everything (API + Angular)
npm run start:all

# In a separate terminal, start Flutter
npm run flutter:run
```

---

## 5. Environment Configuration

### Summary of URLs to Configure

| App | File | Default |
|-----|------|---------|
| Flutter | `lib/core/network/api_client.dart` | `http://localhost:3000` |
| Angular | `src/app/core/http/api-client.service.ts` | `http://localhost:3000` |
| Mock API | `packages/shared/mock-api/db.json` | Port 3000 |

### Port Assignments

| Service | Default Port | Configurable Via |
|---------|-------------|------------------|
| Mock API | 3000 | `--port` flag in start script |
| Angular | 4200 | `--port` flag in `ng serve` |
| Flutter | Random | `--web-port` flag in `flutter run` |

### Initial Data

The mock API loads `packages/shared/mock-api/db.json` which contains:

- **5 funds** (3 FPV, 2 FIC) with minimum amounts from $50,000 to $250,000
- **1 user** with initial balance of $500,000
- **Pre-seeded transactions** for demonstration

To reset data to the initial state, redeploy or restore `db.json` from Git:

```bash
git checkout packages/shared/mock-api/db.json
```

---

## 6. CI/CD with GitHub Actions

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  flutter-tests:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: apps/flutter-app
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.22.0"
          channel: stable
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test

  angular-build:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: apps/angular-app
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: npm
          cache-dependency-path: apps/angular-app/package-lock.json
      - run: npm ci
      - run: npx ng build

  api-check:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: packages/shared/mock-api
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 18
      - run: npm install
      - run: npx json-server db.json --port 3000 &
      - run: sleep 3 && curl -f http://localhost:3000/funds
```

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| `CORS errors` in browser | json-server enables CORS by default. If using a custom backend, add `Access-Control-Allow-Origin: *` headers |
| `Connection refused` on port 3000 | Ensure the Mock API is running: `npm run api:start` |
| Flutter build fails on CI | Ensure Flutter SDK version matches: `flutter --version` |
| Angular build exceeds budget | Check `angular.json` budgets under `configurations.production` (currently 500kB warning, 1MB error) |
| `db.json` data corrupted | Reset: `git checkout packages/shared/mock-api/db.json` |
| SPA routes return 404 | Add rewrite rules (see Vercel/Netlify/Firebase configs above) |
| Flutter `--base-href` issues | Ensure the base href matches the hosting path (e.g., `/` for root, `/app/` for subdirectory) |

### Verifying a Deployment

After deploying all services, verify each endpoint:

```bash
# Mock API
curl https://your-api-url.com/funds
curl https://your-api-url.com/user

# Angular App — should return HTML
curl https://your-angular-url.com

# Flutter App — should return HTML
curl https://your-flutter-url.com
```

### Logs

- **Mock API**: json-server logs all requests to stdout
- **Angular**: Browser DevTools > Console/Network tabs
- **Flutter**: Browser DevTools > Console; Dio LogInterceptor prints request/response details
