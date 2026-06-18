# Security Implementation Guide

## JWT Authentication System - Banking-Grade Security

This document describes the comprehensive JWT-based authentication system with security best practices following banking sector standards.

## Architecture Overview

### Authentication Flow

```
1. User Signup/Login → Hashed Password Storage (Bcrypt)
2. Successful Auth → Access Token (15 min) + Refresh Token (7 days)
3. Access Token → JWT with Claims (UserID, Username, Email)
4. Refresh Token → Longer-lived token for obtaining new Access Tokens
5. Token Validation → Middleware verification on protected routes
```

## Security Features

### 1. Password Security

**Bcrypt Hashing** (Cost Factor: 12)
- Industry-standard one-way hashing algorithm
- Resistant to rainbow table attacks
- Adaptive: computation cost increases over time
- Cost factor of 12 provides security margin while maintaining reasonable performance

```go
// Password is hashed with Bcrypt (12 rounds)
hash, _ := bcrypt.GenerateFromPassword([]byte(password), 12)
// Verification
bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
```

### 2. Token Security

**Access Token (JWT)**
- Duration: 15 minutes
- Contains: UserID, Username, Email
- Algorithm: HS256 (HMAC-SHA256)
- Claims: Standard JWT claims (iss, iat, exp, nbf)
- Revocation: Short lifespan mitigates compromise risk

**Refresh Token (JWT)**
- Duration: 7 days
- Contains: UserID only (minimal scope)
- Can be revoked via blacklist
- Must be stored securely (HttpOnly cookies in production)

### 3. Account Lockout Protection

**Brute Force Attack Mitigation**
- Max Failed Login Attempts: 5
- Lockout Duration: 15 minutes
- Failed attempts counter resets on successful login
- Lockout status checked before password verification
- Automatic unlock after timeout

```go
const (
    MaxFailedAttempts = 5
    LockoutDuration = 15 * time.Minute
)
```

### 4. Password Reset Security

**Secure Token Generation**
- Cryptographically secure random tokens (32 bytes)
- Base64 URL encoding for safety
- One-time use only
- Expiration: 1 hour
- Token stored in database (not email)
- Verification of token expiry before reset

**Reset Flow**
1. User requests password reset with email
2. System generates cryptographic token
3. Token stored with 1-hour expiration
4. User submits token + new password
5. Token validated and expired before password change
6. All refresh tokens revoked on password reset

### 5. Token Revocation

**Refresh Token Blacklist**
- Tokens added to blacklist on:
  - Password change
  - Password reset
  - Explicit logout
- Checked on token refresh requests
- Prevents use of compromised tokens

**Implementation**
```go
// Blacklist stored as array in User model
RefreshTokenBlacklist []string `gorm:"type:text"`
```

### 6. Session Management

**Last Login Tracking**
- Records last successful login timestamp
- Useful for suspicious activity detection
- Helps with audit logging

**User Account States**
- Email verification flag
- Account lockout status with expiry
- Failed login attempt counter
- Password reset token with expiry

## API Endpoints

### Public (No Authentication Required)

```
POST   /api/auth/signup              - Register new user
POST   /api/auth/login               - Login with email & password
POST   /api/auth/refresh             - Get new access token using refresh token
POST   /api/auth/request-reset       - Request password reset
POST   /api/auth/confirm-reset       - Confirm password reset with token
```

### Protected (Authentication Required)

```
POST   /api/auth/change-password     - Change password while logged in
POST   /api/auth/logout              - Logout (revoke tokens)
```

## Request/Response Examples

### Signup
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "SecurePass123!",
    "password_confirm": "SecurePass123!"
  }'
```

**Response**
```json
{
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "is_email_verified": false,
    "created_at": 1623456789
  },
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "expires_in": 900
}
```

### Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "SecurePass123!"
  }'
```

### Refresh Token
```bash
curl -X POST http://localhost:8080/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
  }'
```

### Access Protected Route
```bash
curl -X GET http://localhost:8080/api/todos \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

### Request Password Reset
```bash
curl -X POST http://localhost:8080/api/auth/request-reset \
  -H "Content-Type: application/json" \
  -d '{"email": "john@example.com"}'
```

### Confirm Password Reset
```bash
curl -X POST http://localhost:8080/api/auth/confirm-reset \
  -H "Content-Type: application/json" \
  -d '{
    "token": "cryptographic_token_from_email",
    "new_password": "NewSecurePass456!",
    "confirm": "NewSecurePass456!"
  }'
```

### Change Password (Logged In)
```bash
curl -X POST http://localhost:8080/api/auth/change-password \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..." \
  -H "Content-Type: application/json" \
  -d '{
    "old_password": "SecurePass123!",
    "new_password": "NewSecurePass456!",
    "confirm": "NewSecurePass456!"
  }'
```

### Logout
```bash
curl -X POST http://localhost:8080/api/auth/logout \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

## Environment Variables

```bash
# JWT Secret (minimum 32 characters, MUST be changed in production)
JWT_SECRET=your-secret-key-min-32-chars-long-change-in-production

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=todos

# Server Configuration
PORT=8080
GIN_MODE=debug  # Set to 'release' in production
```

## Production Security Checklist

### ✅ Cryptography
- [x] Bcrypt password hashing (cost 12)
- [x] HMAC-SHA256 for token signing
- [x] Cryptographically secure token generation
- [x] JWT with standard claims

### ✅ Token Management
- [x] Short-lived access tokens (15 minutes)
- [x] Longer-lived refresh tokens (7 days)
- [x] Token revocation mechanism
- [x] Automatic token invalidation on password change

### ✅ Account Protection
- [x] Account lockout after failed attempts
- [x] Temporary lockout (15 minutes)
- [x] Failed attempt counter
- [x] Last login tracking

### ✅ Password Management
- [x] Password strength validation (min 8 chars)
- [x] Password confirmation on signup
- [x] Secure password reset flow
- [x] Password reset token expiration

### ⚠️ Production Recommendations

**BEFORE DEPLOYING TO PRODUCTION:**

1. **Change JWT Secret**
   ```bash
   # Generate a secure 32+ character secret
   openssl rand -base64 32
   export JWT_SECRET="your-generated-secret"
   ```

2. **Use HTTPS/TLS**
   - All endpoints must use HTTPS
   - Set Secure flag on cookies
   - Enable HSTS headers

3. **Token Storage**
   - Store access tokens in memory (JavaScript)
   - Store refresh tokens in HttpOnly, Secure cookies
   - Never store tokens in localStorage

4. **CORS Configuration**
   - Whitelist only trusted origins
   - Update in `middleware/cors.go`

5. **Rate Limiting**
   - Implement rate limiting on login endpoint
   - Implement rate limiting on password reset
   - Example: 5 attempts per 15 minutes per IP

6. **Database Security**
   - Use environment variables for credentials
   - Enable database encryption
   - Implement database backups
   - Use prepared statements (GORM handles this)

7. **Monitoring & Logging**
   - Log failed login attempts
   - Log password resets
   - Monitor for brute force patterns
   - Alert on multiple lockouts

8. **Email Verification**
   - Implement email verification on signup
   - Send verification link to email
   - Set `is_email_verified` to true only after verification
   - Consider requiring email verification for password resets

9. **Two-Factor Authentication**
   - Consider implementing TOTP (Time-based One-Time Password)
   - Backup codes for account recovery
   - Available libraries: pquart/otp

10. **Audit Logging**
    - Log all authentication events
    - Log password changes
    - Log IP addresses
    - Keep audit logs for compliance

### Code Examples

**Securing Endpoints**
```go
// Public endpoint - no auth required
router.POST("/api/auth/login", handlers.Login)

// Protected endpoint - requires valid JWT
protected := router.Group("/api")
protected.Use(middleware.AuthMiddleware())
{
    protected.GET("/todos", handlers.GetAllTodos)
}
```

**Using User Context in Handlers**
```go
func GetUserTodos(c *gin.Context) {
    userID, exists := c.Get("user_id")
    if !exists {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
        return
    }
    
    // Use userID to fetch user-specific todos
}
```

**Password Hashing**
```go
// Hash password
hashedPassword, _ := utils.HashPassword(plainPassword)

// Verify password
err := utils.ComparePassword(hashedPassword, plainPassword)
if err != nil {
    // Incorrect password
}
```

## Testing

### Login Flow Test
```bash
# 1. Signup
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "TestPass123!",
    "password_confirm": "TestPass123!"
  }' | jq -r '.access_token')

# 2. Access protected route
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/todos

# 3. Test token expiration (wait 15+ minutes or manually expire)

# 4. Refresh token
curl -X POST http://localhost:8080/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{"refresh_token": "your-refresh-token"}'
```

### Failed Login Test
```bash
# 1. Try 5 times with wrong password
for i in {1..5}; do
  curl -X POST http://localhost:8080/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{
      "email": "test@example.com",
      "password": "WrongPassword"
    }'
  sleep 1
done

# 2. 6th attempt should return "account is temporarily locked"
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123!"
  }'

# 3. Wait 15 minutes or check lockout expiry in database
# 4. Try again - should work
```

## Compliance & Standards

- **OWASP**: Follows OWASP Authentication Cheat Sheet
- **JWT**: RFC 7519 compliant
- **Password Hashing**: NIST SP 800-63B recommendations
- **Cryptography**: Industry-standard algorithms

## References

- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [JWT.io](https://jwt.io/)
- [Bcrypt Documentation](https://en.wikipedia.org/wiki/Bcrypt)
- [NIST Password Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html)
- [RFC 7519 - JSON Web Token (JWT)](https://tools.ietf.org/html/rfc7519)

## Version History

- **v1.0** (2026-06-16): Initial implementation with JWT auth, Bcrypt hashing, account lockout, password reset, token revocation
