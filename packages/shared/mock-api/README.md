# Mock API — FondosBTG

Simulated REST API using [json-server](https://github.com/typicode/json-server).

## Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /funds | List all available funds |
| GET | /funds/:id | Get fund by ID |
| GET | /user | Get current user (balance, subscribed funds) |
| PATCH | /user | Update user balance/subscriptions |
| GET | /transactions | List all transactions |
| POST | /transactions | Create a new transaction |

## Run

```bash
npm start
# or from monorepo root:
npm run api:start
```

Server runs at `http://localhost:3000`.
