# 🚀 Running the School Management Backend

## Prerequisites
- Go 1.19+ installed
- MySQL database running
- Environment variables configured

## Step 1: Check Go Installation
```bash
go version
```

## Step 2: Install Dependencies
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management
go mod tidy
go mod download
```

## Step 3: Configure Environment Variables

Create a `.env` file in the backend directory:

```bash
# Server Configuration
SERVER_HOST=0.0.0.0
SERVER_PORT=8080

# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=school_management

# JWT Configuration
JWT_SECRET=your-secret-key-here
JWT_EXPIRY=15m
REFRESH_TOKEN_EXPIRY=7d

# Email Configuration (Optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Environment
APP_ENV=development
LOG_LEVEL=info
```

## Step 4: Verify Database Connection

Make sure MySQL is running:

```bash
# macOS with Homebrew
brew services start mysql

# Or manually
mysql -u root -p
```

## Step 5: Run the Backend

```bash
cd /Users/vikashkumarpatel/GoCourse/school_management
go run ./cmd/main.go
```

### Expected Output:
```
✓ Database connected successfully
✅ CORS Preflight OK
🚀 Server starting on 0.0.0.0:8080
```

## Step 6: Test the Connection

### From Terminal (curl):
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "vikash798561@gmail.com",
    "password": "Vikash@123"
  }'
```

### From Flutter Web App:
The app is already configured to connect to `http://localhost:8080/api/v1`

Just make sure:
1. ✅ Backend is running on port 8080
2. ✅ Database is connected
3. ✅ CORS is enabled (✅ Already done!)
4. ✅ Interceptors are logging (✅ Already done!)

## Troubleshooting

### Port Already in Use
```bash
# Find process using port 8080
lsof -i :8080

# Kill the process
kill -9 <PID>
```

### Database Connection Error
Check your `.env` file and verify:
- MySQL is running
- Credentials are correct
- Database exists

### CORS Still Not Working
Check backend logs for:
```
🔄 CORS Request - Origin: http://localhost:port
✅ CORS Preflight OK
```

### The Interceptors Will Show
Once backend is running, you'll see in Flutter web console:

```
✅ RESPONSE [200] Duration: 234ms
📦 Response Body: {token: abc123..., user: {...}}
```

Instead of:

```
❌ ERROR [connectionError]
```

## Quick Start (All in One)

```bash
# Terminal 1: Start Backend
cd /Users/vikashkumarpatel/GoCourse/school_management
go run ./cmd/main.go

# Terminal 2: Start Flutter Web
cd /Users/vikashkumarpatel/GoCourse/school_management_frontend
flutter run -d chrome
```

---

## 📋 Checklist Before Testing

- [ ] Go dependencies installed (`go mod tidy`)
- [ ] MySQL database running
- [ ] `.env` file created with correct credentials
- [ ] Backend running on `http://localhost:8080`
- [ ] Flutter web app running on `http://localhost:xxxxx`
- [ ] Backend logs show "Server starting on 0.0.0.0:8080"
- [ ] Browser console shows login requests being sent
- [ ] Backend logs show "✅ CORS Preflight OK"

Once all checked, the interceptors will log the successful response! 🎉