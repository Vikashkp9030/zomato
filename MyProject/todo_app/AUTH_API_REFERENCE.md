# Authentication API Reference

Complete documentation for JWT authentication endpoints.

## Base URL
```
http://localhost:8080/api
```

## Authentication Header Format
```
Authorization: Bearer <access_token>
```

---

## Public Endpoints (No Authentication Required)

### 1. User Signup

**Endpoint:** `POST /auth/signup`

**Description:** Register a new user account

**Request Body:**
```json
{
  "username": "string (required, 3-50 chars)",
  "email": "string (required, valid email)",
  "password": "string (required, min 8 chars)",
  "password_confirm": "string (required, must match password)"
}
```

**Response (201 Created):**
```json
{
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "is_email_verified": false,
    "last_login": null,
    "failed_login_attempts": 0,
    "is_locked": false,
    "created_at": 1623456789,
    "updated_at": 1623456789
  },
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 900
}
```

**Error Responses:**
```json
// 400 Bad Request - Missing required field
{"error": "Field 'username' is required"}

// 400 Bad Request - Passwords don't match
{"error": "passwords do not match"}

// 400 Bad Request - Password too short
{"error": "Field 'password' must be at least 8 characters"}

// 409 Conflict - User already exists
{"error": "user already exists"}

// 500 Internal Server Error
{"error": "failed to create user"}
```

---

### 2. User Login

**Endpoint:** `POST /auth/login`

**Description:** Authenticate user and receive tokens

**Request Body:**
```json
{
  "email": "string (required, valid email)",
  "password": "string (required)"
}
```

**Response (200 OK):**
```json
{
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "is_email_verified": false,
    "last_login": 1623456789,
    "failed_login_attempts": 0,
    "is_locked": false,
    "created_at": 1623456789,
    "updated_at": 1623456789
  },
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 900
}
```

**Error Responses:**
```json
// 400 Bad Request
{"error": "Field 'email' is required"}

// 401 Unauthorized - Invalid credentials
{"error": "invalid credentials"}

// 403 Forbidden - Account locked after failed attempts
{"error": "account is temporarily locked"}

// 500 Internal Server Error
{"error": "failed to generate token"}
```

**Notes:**
- Maximum 5 failed login attempts before 15-minute lockout
- Last login timestamp is updated on success
- Failed attempt counter resets on successful login

---

### 3. Refresh Access Token

**Endpoint:** `POST /auth/refresh`

**Description:** Get a new access token using refresh token

**Request Body:**
```json
{
  "refresh_token": "string (required)"
}
```

**Response (200 OK):**
```json
{
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "is_email_verified": false,
    "last_login": 1623456789,
    "failed_login_attempts": 0,
    "is_locked": false,
    "created_at": 1623456789,
    "updated_at": 1623456789
  },
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 900
}
```

**Error Responses:**
```json
// 400 Bad Request
{"error": "Field 'refresh_token' is required"}

// 401 Unauthorized - Invalid token
{"error": "invalid refresh token"}

// 401 Unauthorized - Token revoked
{"error": "token has been revoked"}

// 401 Unauthorized - User not found
{"error": "user not found"}

// 500 Internal Server Error
{"error": "failed to generate token"}
```

**Notes:**
- Access token expires in 15 minutes
- Refresh token can be used multiple times until revoked
- Token is revoked on password change, password reset, or explicit logout

---

### 4. Request Password Reset

**Endpoint:** `POST /auth/request-reset`

**Description:** Request a password reset link (sends to email)

**Request Body:**
```json
{
  "email": "string (required, valid email)"
}
```

**Response (200 OK):**
```json
{
  "message": "if email exists, reset link has been sent",
  "token": "base64_url_encoded_secure_token"
}
```

**Notes:**
- Returns same response regardless of email validity (security)
- Reset token valid for 1 hour
- Token sent via email in production
- In development, token returned in response

---

### 5. Confirm Password Reset

**Endpoint:** `POST /auth/confirm-reset`

**Description:** Reset password using token from email

**Request Body:**
```json
{
  "token": "string (required, from password reset email)",
  "new_password": "string (required, min 8 chars)",
  "confirm": "string (required, must match new_password)"
}
```

**Response (200 OK):**
```json
{
  "message": "password has been reset successfully"
}
```

**Error Responses:**
```json
// 400 Bad Request - Passwords don't match
{"error": "passwords do not match"}

// 401 Unauthorized - Invalid token
{"error": "invalid or expired reset token"}

// 401 Unauthorized - Token expired
{"error": "reset token has expired"}

// 500 Internal Server Error
{"error": "failed to reset password"}
```

**Notes:**
- All refresh tokens revoked after password reset
- Failed login attempts counter reset
- Account lockout status cleared
- Token must be from password reset request

---

## Protected Endpoints (Authentication Required)

All protected endpoints require the `Authorization: Bearer <access_token>` header.

### 6. Change Password (Logged In)

**Endpoint:** `POST /auth/change-password`

**Authentication:** Required

**Description:** Change password while logged in (requires old password)

**Request Body:**
```json
{
  "old_password": "string (required)",
  "new_password": "string (required, min 8 chars)",
  "confirm": "string (required, must match new_password)"
}
```

**Response (200 OK):**
```json
{
  "message": "password changed successfully"
}
```

**Error Responses:**
```json
// 400 Bad Request - Passwords don't match
{"error": "passwords do not match"}

// 400 Bad Request - New same as old
{"error": "new password must be different from old password"}

// 401 Unauthorized - Invalid old password
{"error": "invalid password"}

// 401 Unauthorized - No auth header
{"error": "unauthorized"}

// 404 Not Found - User deleted
{"error": "user not found"}

// 500 Internal Server Error
{"error": "failed to change password"}
```

**Notes:**
- Requires verification of current password
- All refresh tokens revoked after change
- Failed login attempts counter reset

---

### 7. Logout

**Endpoint:** `POST /auth/logout`

**Authentication:** Required

**Description:** Logout and revoke refresh tokens

**Response (200 OK):**
```json
{
  "message": "logged out successfully"
}
```

**Error Responses:**
```json
// 401 Unauthorized - No auth header
{"error": "unauthorized"}

// 404 Not Found - User deleted
{"error": "user not found"}

// 500 Internal Server Error
{"error": "failed to logout"}
```

**Notes:**
- Adds current token to blacklist
- Refresh tokens cannot be used after logout
- User must login again to get new tokens

---

## Token Information

### Access Token
- **Type:** JWT (JSON Web Token)
- **Algorithm:** HS256 (HMAC-SHA256)
- **Duration:** 15 minutes (900 seconds)
- **Claims:** 
  - `user_id`: User ID
  - `username`: Username
  - `email`: Email address
  - `iss`: Issuer (todo-app)
  - `iat`: Issued at
  - `exp`: Expiration time
  - `nbf`: Not before

### Refresh Token
- **Type:** JWT (JSON Web Token)
- **Algorithm:** HS256 (HMAC-SHA256)
- **Duration:** 7 days
- **Claims:**
  - `user_id`: User ID
  - `iss`: Issuer (todo-app)
  - `iat`: Issued at
  - `exp`: Expiration time
  - `nbf`: Not before

---

## Security Headers

Recommended headers to include in all requests:
```
Content-Type: application/json
Authorization: Bearer <access_token>  (for protected endpoints)
Accept: application/json
```

## Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK - Request succeeded |
| 201 | Created - Resource created |
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Auth failed or missing |
| 403 | Forbidden - Account locked |
| 404 | Not Found - Resource not found |
| 409 | Conflict - User already exists |
| 500 | Internal Server Error - Server error |

## Common Workflows

### Complete Login to Protected Resource Flow

```bash
# 1. Login
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }')

ACCESS_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.access_token')
REFRESH_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.refresh_token')

# 2. Access protected resource
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  http://localhost:8080/api/todos

# 3. After 15 minutes, refresh token
NEW_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d "{\"refresh_token\": \"$REFRESH_TOKEN\"}")

NEW_ACCESS_TOKEN=$(echo $NEW_RESPONSE | jq -r '.access_token')

# 4. Use new access token
curl -H "Authorization: Bearer $NEW_ACCESS_TOKEN" \
  http://localhost:8080/api/todos

# 5. Logout when done
curl -X POST http://localhost:8080/api/auth/logout \
  -H "Authorization: Bearer $NEW_ACCESS_TOKEN"
```

### Password Reset Flow

```bash
# 1. Request reset
RESET_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/request-reset \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com"}')

RESET_TOKEN=$(echo $RESET_RESPONSE | jq -r '.token')

# 2. Confirm reset with token
curl -X POST http://localhost:8080/api/auth/confirm-reset \
  -H "Content-Type: application/json" \
  -d "{
    \"token\": \"$RESET_TOKEN\",
    \"new_password\": \"newpassword123\",
    \"confirm\": \"newpassword123\"
  }"

# 3. Login with new password
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "newpassword123"
  }'
```

## Error Handling

All error responses follow this format:
```json
{
  "error": "Human-readable error message"
}
```

Common error messages:
- `"invalid credentials"` - Wrong email or password
- `"account is temporarily locked"` - Too many failed attempts
- `"invalid or expired token"` - JWT validation failed
- `"token has been revoked"` - Token was blacklisted
- `"passwords do not match"` - Confirmation password mismatch

## Rate Limiting (Recommended for Production)

Implement rate limiting on:
- Login endpoint: 5 attempts per 15 minutes per IP
- Password reset request: 3 requests per hour per email
- Signup: 10 per hour per IP

## CORS Configuration

For frontend applications, ensure CORS is properly configured:
```go
// Already configured in middleware/cors.go
// Update allowed origins for production
```

## Testing with cURL

See examples in SECURITY.md for comprehensive testing guide.

## Postman Collection

Import this collection for easy API testing:
[Download Postman Collection](./postman_collection.json)

---

**Last Updated:** 2026-06-16
**API Version:** 1.0
**Status:** Production Ready
