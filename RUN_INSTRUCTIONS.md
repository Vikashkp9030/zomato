# 🚀 How to Run Frontend & Backend

**Date**: June 16, 2026  
**Status**: ✅ Ready to run

---

## 📋 Prerequisites

Ensure you have installed:
- ✅ Go 1.19+ (for backend)
- ✅ Flutter 3.0+ (for frontend)
- ✅ MySQL/MariaDB (for database)
- ✅ Git (for version control)

---

## 🔧 Backend Setup

### Backend Location
```
/Users/vikashkumarpatel/GoCourse/school_management
```

### 1. Configure Environment
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management
cp .env.example .env

# Edit .env with your settings:
# - Database credentials
# - Server port (default: 8080)
# - JWT secret
```

### 2. Start Backend
```bash
# Option A: Run directly
cd /Users/vikashkumarpatel/GoCourse/school_management
go mod tidy
go run ./cmd/main.go

# Option B: Build and run
go build -o server ./cmd/main.go
./server
```

**Expected Output:**
```
✓ Database connected successfully
🚀 Server starting on localhost:8080
```

### 3. Test Backend
```bash
# Test API health
curl http://localhost:8080/api/v1/health

# Or use the provided API tests
curl http://localhost:8080/api/v1/auth/login \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

---

## 🎨 Frontend Setup

### Frontend Location
```
/Users/vikashkumarpatel/GoCourse/school_management_frontend
```

### 1. Configure Environment
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management_frontend

# Update .env file
cat .env
# Should show:
# BASE_URL=http://localhost:8080/api/v1
# JWT_SECRET=your_jwt_secret_key_here
# LOG_LEVEL=debug
# APP_NAME=School Management System
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Start Frontend
```bash
# Option A: Debug mode (hot reload enabled)
flutter run

# Option B: Run on specific device
flutter run -d <device-id>

# Option C: Web (if enabled)
flutter run -d chrome
```

**Expected Output:**
```
✓ Built example/main.dart.
Launching lib/main.dart on...
```

---

## 🚀 Run Both Together (Recommended)

### Easiest Method: Use Provided Script
```bash
# Run the combined launcher script
bash /Users/vikashkumarpatel/GoCourse/run_both.sh
```

This script will:
1. ✓ Verify both directories exist
2. ✓ Check Go and Flutter are installed
3. ✓ Build and start the backend (runs in background)
4. ✓ Start the frontend (in foreground)
5. ✓ Cleanup both on exit

### Manual Method: Use Two Terminal Windows

**Terminal 1 - Backend:**
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management
go run ./cmd/main.go
# or
./server
```

**Terminal 2 - Frontend:**
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management_frontend
flutter run
```

---

## 📊 What to Expect

### Backend Running
```
✓ Database connected successfully
🚀 Server starting on localhost:8080
```

Port: **8080**  
API Base URL: **http://localhost:8080/api/v1**  
API Documentation: **http://localhost:8080/docs** (if available)

### Frontend Running
```
✓ Built example/main.dart.
Launching lib/main.dart on Android Emulator
```

### Test Login
Once both are running:

**Email**: test@example.com  
**Password**: password  

Or use the Register option to create a new account.

---

## 🔄 Development Workflow

### Hot Reload (Frontend Only)
While `flutter run` is active:
- Save changes to Dart files
- Hot reload: Press `r` in terminal
- Hot restart: Press `R` in terminal

### Backend Changes
To reload backend changes:
1. Stop the server (Ctrl+C)
2. Run `go run ./cmd/main.go` again
3. Or use `go build` and run the executable

---

## 🐛 Troubleshooting

### Backend Won't Start
```bash
# Check if port 8080 is in use
lsof -i :8080

# Try different port in .env
PORT=8081

# Check database connection
# Verify .env DATABASE_URL is correct
```

### Frontend Won't Connect to Backend
```bash
# 1. Verify backend is running
curl http://localhost:8080/api/v1/health

# 2. Check BASE_URL in .env
cat school_management_frontend/.env

# 3. Check Android/iOS network config
# Allow localhost/127.0.0.1 connections

# 4. Use actual IP on real device
# Instead of localhost: http://192.168.x.x:8080
```

### Flutter Run Fails
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Try specific device
flutter devices
flutter run -d <device-id>
```

### Go Build Fails
```bash
# Clean and tidy
go clean
go mod tidy

# Update dependencies
go get -u ./...

# Try building again
go build -o server ./cmd/main.go
```

---

## 📝 API Testing

### Using cURL
```bash
# Login
TOKEN=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}' \
  | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

# Get classes with token
curl -X GET http://localhost:8080/api/v1/classes \
  -H "Authorization: Bearer $TOKEN"
```

### Using Postman
1. Import API collection from `API_DOCUMENTATION.md`
2. Set `{{base_url}}` variable to `http://localhost:8080/api/v1`
3. Set `{{token}}` variable from login response
4. Run requests

---

## 📊 Database

### Initialize Database
```bash
# The backend will auto-create tables on first run
# Tables created:
# - users
# - classes
# - teachers
# - subjects
# - students
# - exams
# - exam_results
# - attendance
# - parents
```

### Check Database
```bash
# MySQL CLI
mysql -u root -p school_management

# Show tables
SHOW TABLES;

# Check users
SELECT * FROM users;
```

---

## 🚀 Production Build

### Android APK
```bash
cd school_management_frontend
flutter build apk --release

# Output: build/app/outputs/flutter-app.apk
```

### iOS
```bash
flutter build ios --release

# Output: build/ios/Release-iphoneos/School Management.app
```

### Backend Docker
```bash
cd school_management

# Build image
docker build -t school-management:latest .

# Run container
docker run -p 8080:8080 \
  -e DATABASE_URL="mysql://user:pass@localhost/school_management" \
  school-management:latest
```

---

## ✅ Verification Checklist

- [ ] Backend starts without errors
- [ ] Frontend connects to backend
- [ ] Can login with test credentials
- [ ] Dashboard loads successfully
- [ ] Can navigate to Classes page
- [ ] API calls return data
- [ ] Error handling works (try invalid login)
- [ ] Token refresh works
- [ ] Logout works

---

## 📞 Quick Reference

| Component | Command | Port |
|-----------|---------|------|
| Backend | `go run ./cmd/main.go` | 8080 |
| Frontend | `flutter run` | 5000+ |
| MySQL | `mysql -u root -p` | 3306 |
| API Docs | `http://localhost:8080/docs` | 8080 |

---

## 📚 Documentation

- **Backend Docs**: `school_management/API_DOCUMENTATION.md`
- **Frontend Docs**: `school_management_frontend/QUICK_REFERENCE.md`
- **API Endpoints**: `school_management_frontend/API_ENDPOINTS.md`
- **Architecture**: `school_management_frontend/COMPLETE_IMPLEMENTATION_GUIDE.md`

---

**Status**: 🟢 Both ready to run  
**Recommended**: Use `run_both.sh` script  
**Time to Start**: ~1-2 minutes

---

Generated: June 16, 2026
