# Authentication Quick Start Guide

Get up and running with JWT authentication in 5 minutes.

## Setup

### 1. Set Environment Variables

```bash
# Copy example config
cp .env.example .env

# Edit .env and set JWT secret (IMPORTANT!)
export JWT_SECRET="$(openssl rand -base64 32)"
export PORT=8080
export GIN_MODE=debug
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=postgres
export DB_PASS=postgres
export DB_NAME=todos
```

### 2. Start the Server

```bash
go run main.go
```

Expected output:
```
Server starting on port 8080
PostgreSQL database initialized successfully
```

## Basic Workflow

### 1. Sign Up (Create Account)

```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "MyPassword123!",
    "password_confirm": "MyPassword123!"
  }'
```

**Save the tokens from response:**
```
access_token: eyJhbGciOiJIUzI1NiIs...
refresh_token: eyJhbGciOiJIUzI1NiIs...
```

### 2. Login (Get Tokens)

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "MyPassword123!"
  }'
```

### 3. Use Token to Access Protected Resources

```bash
# Set your token
TOKEN="eyJhbGciOiJIUzI1NiIs..."

# Access API
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/todos
```

### 4. Refresh Token When Expired

Access tokens expire in 15 minutes. Use refresh token to get a new one:

```bash
REFRESH_TOKEN="eyJhbGciOiJIUzI1NiIs..."

curl -X POST http://localhost:8080/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d "{\"refresh_token\": \"$REFRESH_TOKEN\"}"
```

### 5. Logout

```bash
TOKEN="eyJhbGciOiJIUzI1NiIs..."

curl -X POST http://localhost:8080/api/auth/logout \
  -H "Authorization: Bearer $TOKEN"
```

## Common Tasks

### Change Password (While Logged In)

```bash
TOKEN="your-access-token"

curl -X POST http://localhost:8080/api/auth/change-password \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "old_password": "MyPassword123!",
    "new_password": "NewPassword456!",
    "confirm": "NewPassword456!"
  }'
```

### Reset Forgotten Password

```bash
# Step 1: Request reset
curl -X POST http://localhost:8080/api/auth/request-reset \
  -H "Content-Type: application/json" \
  -d '{"email": "john@example.com"}'

# Response will include a token
# In production, this token is sent via email

# Step 2: Use token to reset password
TOKEN="base64_token_from_response"

curl -X POST http://localhost:8080/api/auth/confirm-reset \
  -H "Content-Type: application/json" \
  -d "{
    \"token\": \"$TOKEN\",
    \"new_password\": \"NewPassword456!\",
    \"confirm\": \"NewPassword456!\"
  }"

# Step 3: Login with new password
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "NewPassword456!"
  }'
```

## Testing Account Lockout

```bash
# Try to login with wrong password 5 times
for i in {1..5}; do
  curl -X POST http://localhost:8080/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{
      "email": "john@example.com",
      "password": "WrongPassword"
    }'
  echo "Attempt $i"
  sleep 1
done

# 6th attempt (with correct password) will be blocked
# Wait 15 minutes or check account unlock in database

# Try again after 15 minutes
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "MyPassword123!"
  }'
```

## Using with Frontend

### JavaScript/React Example

```javascript
// Login
const loginResponse = await fetch('http://localhost:8080/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    email: 'john@example.com',
    password: 'MyPassword123!'
  })
});

const { access_token, refresh_token } = await loginResponse.json();

// Store tokens
localStorage.setItem('access_token', access_token);
localStorage.setItem('refresh_token', refresh_token);

// Use token in requests
const todos = await fetch('http://localhost:8080/api/todos', {
  headers: {
    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
  }
});
```

### Token Refresh Logic

```javascript
async function apiCall(url, options = {}) {
  let token = localStorage.getItem('access_token');
  
  let response = await fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      'Authorization': `Bearer ${token}`
    }
  });
  
  // If token expired, refresh and retry
  if (response.status === 401) {
    const refreshToken = localStorage.getItem('refresh_token');
    const refreshResponse = await fetch(
      'http://localhost:8080/api/auth/refresh',
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ refresh_token: refreshToken })
      }
    );
    
    const { access_token } = await refreshResponse.json();
    localStorage.setItem('access_token', access_token);
    
    // Retry with new token
    response = await fetch(url, {
      ...options,
      headers: {
        ...options.headers,
        'Authorization': `Bearer ${access_token}`
      }
    });
  }
  
  return response;
}

// Usage
const todos = await apiCall('http://localhost:8080/api/todos');
```

## All Endpoints Summary

### Public (No Auth)
- `POST /api/auth/signup` - Register
- `POST /api/auth/login` - Login
- `POST /api/auth/refresh` - Refresh token
- `POST /api/auth/request-reset` - Request password reset
- `POST /api/auth/confirm-reset` - Confirm password reset

### Protected (Need Token)
- `POST /api/auth/change-password` - Change password
- `POST /api/auth/logout` - Logout
- `GET /api/todos` - Get todos
- `POST /api/todos` - Create todo
- `PUT /api/todos/:id` - Update todo
- `DELETE /api/todos/:id` - Delete todo
- ... (all other Todo, Category, Tag, User endpoints)

## Error Handling

### Invalid Credentials
```json
{"error": "invalid credentials"}
```

### Account Locked
```json
{"error": "account is temporarily locked"}
```

### Invalid Token
```json
{"error": "invalid or expired token"}
```

### Passwords Don't Match
```json
{"error": "passwords do not match"}
```

### User Already Exists
```json
{"error": "user already exists"}
```

## Troubleshooting

### "invalid credentials" on valid password
- Verify email/password are correct
- Check if account is locked (5+ failed attempts)
- Wait 15 minutes if locked

### "invalid or expired token"
- Token expires in 15 minutes
- Use refresh token to get new access token
- Need to login again if refresh token expired

### "unauthorized" on protected route
- Missing Authorization header
- Invalid token format (should be "Bearer token")
- Token doesn't contain required claims

### Server won't start
- Check JWT_SECRET is set: `echo $JWT_SECRET`
- Verify database connection
- Check port 8080 is not in use

## Security Notes

⚠️ **Important for Production:**

1. **Change JWT Secret**
   ```bash
   export JWT_SECRET="$(openssl rand -base64 32)"
   ```

2. **Use HTTPS**
   - All endpoints must use HTTPS in production
   - Never send tokens over HTTP

3. **Secure Token Storage**
   - Frontend: Store in memory or secure HttpOnly cookies
   - Never in localStorage (XSS vulnerable)

4. **Refresh Token Rotation** (Advanced)
   - Implement refresh token rotation for extra security
   - Revoke old refresh token when issuing new one

5. **CORS Configuration**
   - Whitelist specific origins in production
   - Update in `middleware/cors.go`

## Learning Resources

- See `SECURITY.md` for detailed security explanations
- See `AUTH_API_REFERENCE.md` for complete API documentation
- See `JWT_IMPLEMENTATION_SUMMARY.md` for architecture details

## Next Steps

1. ✅ Test signup/login flow
2. ✅ Verify token refresh works
3. ✅ Test protected endpoints
4. ✅ Integrate with frontend
5. ✅ Set up HTTPS for production
6. ✅ Configure email service for password resets
7. ✅ Enable logging and monitoring

---

**Need help?** Check the comprehensive documentation files included with this project.
