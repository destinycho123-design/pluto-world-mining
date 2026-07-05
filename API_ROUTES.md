# Investment Broker Platform - API Routes

## Authentication Endpoints

### Register
- **POST** `/auth/register`
- **Body:** `{ email, password, firstName, lastName, phone? }`
- **Response:** `{ user, token }`

### Login
- **POST** `/auth/login`
- **Body:** `{ email, password }`
- **Response:** `{ user, token }`

### Admin Login
- **POST** `/auth/admin-login`
- **Body:** `{ email, password }`
- **Response:** `{ token, role }`

### Get Profile
- **GET** `/auth/me`
- **Auth:** Required (JWT)
- **Response:** `{ user }`

---

## KYC Management Endpoints

### Upload KYC Documents
- **POST** `/kyc/upload`
- **Auth:** Required (JWT)
- **Body:** FormData with `idDocument`, `addressProof`, `selfie` files
- **Response:** `{ message, kyc }`

### Get KYC Status
- **GET** `/kyc/status`
- **Auth:** Required (JWT)
- **Response:** `{ status, level, rejectionReason, verifiedAt }`

### Get Pending KYC (Admin)
- **GET** `/kyc/admin/pending`
- **Auth:** Required (JWT + Admin)
- **Response:** `[ { id, userId, user, status, createdAt, ... } ]`

### Get KYC for Review (Admin)
- **GET** `/kyc/admin/:userId`
- **Auth:** Required (JWT + Admin)
- **Response:** `{ id, user, idDocumentUrl, addressProofUrl, selfieUrl, status, ... }`

### Approve KYC (Admin)
- **PATCH** `/kyc/admin/approve/:userId`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ level?, adminNotes? }`
- **Response:** `{ message, kyc }`

### Reject KYC (Admin)
- **PATCH** `/kyc/admin/reject/:userId`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ rejectionReason }`
- **Response:** `{ message, kyc }`

### Get KYC Statistics (Admin)
- **GET** `/kyc/admin/stats`
- **Auth:** Required (JWT + Admin)
- **Response:** `{ PENDING: count, APPROVED: count, REJECTED: count }`

---

## Withdrawal Endpoints

### Request Withdrawal
- **POST** `/withdrawals/request`
- **Auth:** Required (JWT)
- **Body:** `{ amount, method, bankName?, accountNumber?, accountHolder?, walletAddress?, cryptoType? }`
- **Response:** `{ message, withdrawal }`

### Get Withdrawal History
- **GET** `/withdrawals/history`
- **Auth:** Required (JWT)
- **Response:** `[ withdrawal ]`

### Get Specific Withdrawal
- **GET** `/withdrawals/:id`
- **Auth:** Required (JWT)
- **Response:** `{ withdrawal }`

### Get Pending Withdrawals (Admin)
- **GET** `/withdrawals/admin/pending`
- **Auth:** Required (JWT + Admin)
- **Response:** `[ { id, userId, user, amount, status, ... } ]`

### Approve Withdrawal (Admin)
- **PATCH** `/withdrawals/admin/approve/:id`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ adminNotes? }`
- **Response:** `{ message, withdrawal }`

### Reject Withdrawal (Admin)
- **PATCH** `/withdrawals/admin/reject/:id`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ rejectionReason }`
- **Response:** `{ message, withdrawal }`

### Complete Withdrawal (Admin)
- **PATCH** `/withdrawals/admin/complete/:id`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ transactionHash }`
- **Response:** `{ message, withdrawal }`

### Get Withdrawal Statistics (Admin)
- **GET** `/withdrawals/admin/stats`
- **Auth:** Required (JWT + Admin)
- **Response:** `[ { status, _count, _sum: { amount, fee } } ]`

---

## Billing Endpoints

### Get User Invoices
- **GET** `/billing/invoices`
- **Auth:** Required (JWT)
- **Response:** `[ { id, invoiceNumber, amount, status, ... } ]`

### Get Specific Invoice
- **GET** `/billing/invoices/:id`
- **Auth:** Required (JWT)
- **Response:** `{ invoice }`

### Download Invoice PDF
- **GET** `/billing/invoices/:id/download`
- **Auth:** Required (JWT)
- **Response:** PDF file

### Generate Invoice (Admin)
- **POST** `/billing/invoices/generate`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ transactionId, format?, dueDate? }`
- **Response:** `{ message, invoice }`

### Get All Invoices (Admin)
- **GET** `/billing/admin/invoices`
- **Auth:** Required (JWT + Admin)
- **Query:** `status?`
- **Response:** `[ { invoice } ]`

### Export Billing Data (Admin)
- **POST** `/billing/admin/export`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ format: 'PDF'|'CSV'|'JSON', userId? }`
- **Response:** File in specified format

### Get Billing Statistics (Admin)
- **GET** `/billing/admin/stats`
- **Auth:** Required (JWT + Admin)
- **Response:** `[ { status, _count, _sum: { amount, fee, netAmount } } ]`

---

## Admin Settings Endpoints

### Get Settings
- **GET** `/admin/settings`
- **Auth:** Required (JWT + Admin)
- **Response:** `{ kycEnabled, withdrawalEnabled, billingEnabled, minWithdrawal, ... }`

### Update Settings
- **PATCH** `/admin/settings`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ kycEnabled?, withdrawalEnabled?, billingEnabled?, minWithdrawal?, maxWithdrawal?, withdrawalFee?, ... }`
- **Response:** `{ updated settings }`

### Toggle KYC
- **PATCH** `/admin/settings/kyc/toggle`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ enabled }`
- **Response:** `{ updated settings }`

### Toggle Withdrawal
- **PATCH** `/admin/settings/withdrawal/toggle`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ enabled }`
- **Response:** `{ updated settings }`

### Toggle Billing
- **PATCH** `/admin/settings/billing/toggle`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ enabled }`
- **Response:** `{ updated settings }`

---

## Transaction Endpoints

### Get User Transactions
- **GET** `/transactions`
- **Auth:** Required (JWT)
- **Response:** `[ { id, type, amount, status, ... } ]`

### Get Specific Transaction
- **GET** `/transactions/:id`
- **Auth:** Required (JWT)
- **Response:** `{ transaction }`

### Create Transaction (Admin)
- **POST** `/transactions`
- **Auth:** Required (JWT + Admin)
- **Body:** `{ userId, type, amount, fee?, description? }`
- **Response:** `{ transaction }`

### Get All Transactions (Admin)
- **GET** `/transactions/admin/all`
- **Auth:** Required (JWT + Admin)
- **Response:** `[ { transaction with user } ]`

---

## Error Responses

All endpoints may return:

```json
{
  "statusCode": 400|401|403|404|500,
  "message": "Error message",
  "error": "Error type"
}
```

### Status Codes
- `400` - Bad Request (validation error)
- `401` - Unauthorized (missing/invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found (resource not found)
- `500` - Internal Server Error

---

## Authentication

All protected endpoints require JWT token in header:
```
Authorization: Bearer <token>
```

Tokens expire based on `JWT_EXPIRATION` environment variable (default: 24h).

---

## Pagination & Filtering

Some endpoints support query parameters:
- `status` - Filter by status
- `page` - Page number
- `limit` - Items per page
- `sort` - Sort field
- `order` - asc|desc
