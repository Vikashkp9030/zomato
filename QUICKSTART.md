# 🚀 Quick Start - Run Both Frontend & Backend

**Status**: ✅ Ready to go  
**Time**: ~5 minutes setup

---

## 📍 Project Locations

```
Frontend: /Users/vikashkumarpatel/GoCourse/school_management_frontend
Backend:  /Users/vikashkumarpatel/GoCourse/school_management
```

---

## 1️⃣ Backend Setup (Go + MySQL)

### Step 1: Setup Database
```bash
# Create database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS school_management;"

# Verify
mysql -u root -p -e "SHOW DATABASES;"
```

### Step 2: Configure Backend
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management

# Copy example config
cp .env.example .env

# Edit .env with your MySQL credentials
nano .env
# Or edit in your preferred editor
```

**Minimal .env Setup:**
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=<your_password>
DB_NAME=school_management
SERVER_PORT=8080
SERVER_HOST=0.0.0.0
JWT_SECRET=your_secret_key_here
```

### Step 3: Start Backend
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management

# Download dependencies
go mod download

# Run backend
go run ./cmd/main.go
```

**Expected Output:**
```
✓ Database connected successfully
🚀 Server starting on 0.0.0.0:8080
```

**Keep this terminal running!**

---

## 2️⃣ Frontend Setup (Flutter)

### Open NEW Terminal Window

```bash
cd /Users/vikashkumarpatel/GoCourse/school_management_frontend

# Get dependencies (one time)
flutter pub get

# Run app
flutter run
```

**Expected Output:**
```
✓ Built example/main.dart.
Launching lib/main.dart on...
```

---

## 3️⃣ Test the App

### Backend API Test
```bash
# In a third terminal, test the API
curl http://localhost:8080/api/v1/health
```

### Frontend Login
Once the app loads:
- Email: `test@example.com`
- Password: `password`

Or create a new account via Register.

---

## 🎯 Summary - 3 Terminal Windows

| # | Terminal | Command | Status |
|---|----------|---------|--------|
| 1 | Backend | `cd school_management && go run ./cmd/main.go` | 🟢 Port 8080 |
| 2 | Frontend | `cd school_management_frontend && flutter run` | 🟢 Device/Emulator |
| 3 | Testing | Any curl/test commands | 🔵 As needed |

---

## ✅ Verification

- [ ] Backend running on `localhost:8080`
- [ ] Frontend shows splash screen
- [ ] Can log in with test credentials
- [ ] Dashboard loads with 8 feature cards
- [ ] Can navigate to Classes page
- [ ] API calls working (no network errors)

---

## 🐛 Quick Troubleshooting

### Backend fails: "connection refused"
```bash
# Check MySQL is running
mysql -u root -p -e "SELECT 1;"

# Check .env DATABASE credentials
cat .env
```

### Frontend can't connect to API
```bash
# Verify backend is running
curl http://localhost:8080/api/v1/health

# Check frontend .env BASE_URL
cat school_management_frontend/.env
```

### Port 8080 already in use
```bash
# Kill process using 8080
lsof -i :8080
kill -9 <PID>

# Or use different port in .env
SERVER_PORT=8081
```

---

## 📊 Architecture

```
Flutter App (Device/Emulator)
         ↓ HTTP
API Requests (localhost:8080)
         ↓
Go Backend (Port 8080)
         ↓
MySQL Database
```

---

## 🔄 Development Workflow

### Hot Reload Flutter
In frontend terminal, press `r` to reload code without rebuilding.

### Restart Backend
In backend terminal, press `Ctrl+C` and run `go run ./cmd/main.go` again.

---

## 📚 Full Documentation

- **Backend**: `school_management/API_DOCUMENTATION.md`
- **Frontend**: `school_management_frontend/QUICK_REFERENCE.md`
- **Complete Guide**: `RUN_INSTRUCTIONS.md`

---

## 🎬 You're Ready!

Both are fully integrated and ready to develop. 

**Start with these 3 commands:**

```bash
# Terminal 1 - Backend
cd school_management && go run ./cmd/main.go

# Terminal 2 - Frontend  
cd school_management_frontend && flutter run

# Terminal 3 - Testing (optional)
curl http://localhost:8080/api/v1/health
```

---

**Next**: Build the remaining UI pages using ClassesPage as reference!

---

Generated: June 16, 2026
