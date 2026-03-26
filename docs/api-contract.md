# API Contract — FondosBTG

## Base URL

```
http://localhost:3000
```

## Endpoints

### Funds

#### GET /funds
List all available investment funds.

**Response** `200 OK`
```json
[
  {
    "id": "1",
    "name": "FPV_BTG_PACTUAL_RECAUDADORA",
    "minAmount": 75000,
    "category": "FPV"
  },
  {
    "id": "2",
    "name": "FPV_BTG_PACTUAL_ECOPETROL",
    "minAmount": 125000,
    "category": "FPV"
  }
]
```

#### GET /funds/:id
Get a single fund by ID.

**Response** `200 OK`
```json
{
  "id": "1",
  "name": "FPV_BTG_PACTUAL_RECAUDADORA",
  "minAmount": 75000,
  "category": "FPV"
}
```

---

### User

#### GET /user
Get the current user profile with balance and subscribed funds.

**Response** `200 OK`
```json
{
  "id": "1",
  "name": "Usuario Demo",
  "balance": 500000,
  "subscribedFunds": [
    {
      "fundId": "1",
      "fundName": "FPV_BTG_PACTUAL_RECAUDADORA",
      "amount": 75000,
      "date": "2026-03-25T10:15:00.000Z",
      "category": "FPV"
    }
  ]
}
```

#### PATCH /user
Update user balance and/or subscribed funds.

**Request Body** (partial update)
```json
{
  "balance": 425000,
  "subscribedFunds": [
    {
      "fundId": "1",
      "fundName": "FPV_BTG_PACTUAL_RECAUDADORA",
      "amount": 75000,
      "date": "2026-03-25T10:15:00.000Z",
      "category": "FPV"
    }
  ]
}
```

**Response** `200 OK` — Returns the updated user object.

---

### Transactions

#### GET /transactions
List all transactions, ordered by date (newest first).

**Response** `200 OK`
```json
[
  {
    "id": "tx-001",
    "fundId": "1",
    "fundName": "FPV_BTG_PACTUAL_RECAUDADORA",
    "type": "subscription",
    "amount": 75000,
    "date": "2026-03-25T10:15:00.000Z",
    "notificationMethod": "EMAIL"
  },
  {
    "id": "tx-002",
    "fundId": "1",
    "fundName": "FPV_BTG_PACTUAL_RECAUDADORA",
    "type": "cancellation",
    "amount": 75000,
    "date": "2026-03-25T15:30:00.000Z"
  }
]
```

#### POST /transactions
Create a new transaction record.

**Request Body**
```json
{
  "fundId": "1",
  "fundName": "FPV_BTG_PACTUAL_RECAUDADORA",
  "type": "subscription",
  "amount": 75000,
  "date": "2026-03-25T10:15:00.000Z",
  "notificationMethod": "EMAIL"
}
```

**Response** `201 Created` — Returns the created transaction with generated ID.

---

## Data Types

### Fund
| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique fund identifier |
| name | string | Fund name (API format, uppercase with underscores) |
| minAmount | number | Minimum investment amount in COP |
| category | string | Fund category: `"FPV"` or `"FIC"` |

### User
| Field | Type | Description |
|-------|------|-------------|
| id | string | User identifier |
| name | string | Display name |
| balance | number | Available balance in COP |
| subscribedFunds | SubscribedFund[] | List of active subscriptions |

### SubscribedFund
| Field | Type | Description |
|-------|------|-------------|
| fundId | string | Reference to fund ID |
| fundName | string | Fund name (API format) |
| amount | number | Invested amount in COP |
| date | string | ISO 8601 subscription date |
| category | string | Fund category |

### Transaction
| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique transaction identifier (auto-generated) |
| fundId | string | Reference to fund ID |
| fundName | string | Fund name (API format) |
| type | string | `"subscription"` or `"cancellation"` |
| amount | number | Transaction amount in COP |
| date | string | ISO 8601 transaction date |
| notificationMethod | string? | `"EMAIL"` or `"SMS"` (only for subscriptions) |

## Enums

### FundCategory
- `FPV` — Fondo de Pensiones Voluntarias
- `FIC` — Fondo de Inversión Colectiva

### NotificationMethod
- `EMAIL`
- `SMS`

### TransactionType
- `subscription` — Fund subscription (money out)
- `cancellation` — Subscription cancellation (money in)

## Business Rules

1. **Subscription**: User balance must be >= fund's `minAmount`
2. **Subscription**: User cannot subscribe to the same fund twice
3. **Subscription**: Balance is reduced by `minAmount` on subscribe
4. **Cancellation**: Balance is restored by the subscribed amount
5. **Cancellation**: Fund is removed from `subscribedFunds`
6. **Transactions**: Every subscribe/cancel creates a transaction record
