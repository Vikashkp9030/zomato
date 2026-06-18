# Quick Start Guide - School Management System

## Option 1: Run Locally (Without Docker)

### Prerequisites
- Go 1.21+
- MySQL 8.0+
- Git

### Step 1: Clone and Setup
```bash
cd GoCourse
```

### Step 2: Configure Environment
```bash
cp .env.example .env
```

Edit `.env` and add your database credentials:
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=school_management
JWT_SECRET=change_this_to_something_secret
```

### Step 3: Create Database
```bash
mysql -u root -p -e "CREATE DATABASE school_management;"
```

### Step 4: Run Migrations
```bash
make migrate
```

Or manually:
```bash
mysql -u root -p school_management < migrations/001_create_users_table.sql
mysql -u root -p school_management < migrations/002_create_students_table.sql
mysql -u root -p school_management < migrations/003_create_exams_table.sql
mysql -u root -p school_management < migrations/004_create_attendance_table.sql
```

### Step 5: Install Dependencies
```bash
make deps
```

### Step 6: Run Application
```bash
make run
```

Server will start at `http://localhost:8080`

---

## Option 2: Run with Docker (Recommended)

### Prerequisites
- Docker
- Docker Compose

### Step 1: Clone and Setup
```bash
cd GoCourse/school_management
```

### Step 2: Create Environment File
```bash
cp .env.example .env
```

Update `.env`:
```env
DB_HOST=mysql
DB_PORT=3306
DB_USER=school_user
DB_PASSWORD=school_password
DB_NAME=school_management
SERVER_PORT=8080
JWT_SECRET=your_secret_key_here
```

### Step 3: Start Docker Containers
```bash
make docker-up
```

Or:
```bash
docker-compose up -d
```

This will:
- Start MySQL database
- Build the Go API
- Create the database
- Run all migrations automatically

### Step 4: Verify Setup
```bash
curl http://localhost:8080/api/v1/health
```

Response:
```json
{"status":"ok"}
```

---

## Testing the API

### 1. Register a User
```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teacher@example.com",
    "password": "password123",
    "first_name": "John",
    "last_name": "Doe",
    "role": "teacher"
  }'
```

**Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "id": 1,
    "email": "teacher@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "teacher",
    "status": "Active"
  }
}
```

### 2. Login
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teacher@example.com",
    "password": "password123"
  }'
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "id": 1,
      "email": "teacher@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "role": "teacher"
    }
  }
}
```

**Save the `access_token` for the next requests!**

### 3. Create a Student (use your access_token)
```bash
export TOKEN="your_access_token_here"

curl -X POST http://localhost:8080/api/v1/students \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "first_name": "Arjun",
    "last_name": "Singh",
    "email": "arjun@example.com",
    "phone": "9876543210",
    "gender": "Male",
    "class_id": 1,
    "status": "Active"
  }'
```

### 4. Get All Students
```bash
curl -X GET "http://localhost:8080/api/v1/students?limit=10&offset=0" \
  -H "Authorization: Bearer $TOKEN"
```

### 5. Create an Exam
```bash
curl -X POST http://localhost:8080/api/v1/exams \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "exam_name": "Mid Term - Mathematics",
    "exam_type": "Mid Term",
    "exam_date": "2024-07-15T00:00:00Z",
    "exam_time": "09:00:00",
    "total_marks": 100,
    "passing_marks": 40,
    "subject_id": 1,
    "class_id": 1
  }'
```

### 6. Record Attendance
```bash
curl -X POST http://localhost:8080/api/v1/attendance \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "student_id": 1,
    "class_id": 1,
    "attendance_date": "2024-06-16T00:00:00Z",
    "status": "Present",
    "remarks": ""
  }'
```

### 7. Get Student Performance
```bash
curl -X GET http://localhost:8080/api/v1/students/1/performance \
  -H "Authorization: Bearer $TOKEN"
```

### 8. Get Attendance Summary
```bash
curl -X GET http://localhost:8080/api/v1/students/1/attendance/summary \
  -H "Authorization: Bearer $TOKEN"
```

---

## Common Commands

### Makefile Commands
```bash
make help              # Show all available commands
make build            # Build the application
make run              # Run the application
make test             # Run tests
make clean            # Clean build artifacts
make migrate          # Run database migrations
make fmt              # Format code
make lint             # Run linter
make docker-build     # Build Docker image
make docker-up        # Start Docker containers
make docker-down      # Stop Docker containers
```

### Docker Commands
```bash
# View logs
docker-compose logs -f api
docker-compose logs -f mysql

# Access MySQL
docker exec -it school_management_mysql mysql -u school_user -p school_management

# Restart containers
docker-compose restart

# Stop containers
docker-compose down

# Clean up everything
docker-compose down -v
```

---

## Project Structure Overview

```
school_management/
├── cmd/
│   └── main.go                    # Entry point
├── config/
│   └── config.go                  # Configuration
├── internal/
│   ├── database/                  # Database connection
│   ├── handler/                   # API handlers
│   ├── middleware/                # Auth & logging middleware
│   ├── models/                    # Data models
│   ├── repository/                # Data access layer
│   ├── routes/                    # Route definitions
│   └── utils/                     # Helpers (JWT, password, response)
├── migrations/                    # Database migrations
├── Dockerfile                     # Docker image configuration
├── docker-compose.yml             # Docker Compose configuration
├── Makefile                       # Build commands
├── .env.example                   # Environment template
├── README.md                      # Full documentation
├── API_DOCUMENTATION.md           # API endpoints
└── QUICKSTART.md                  # This file
```

---

## Database Structure

The project uses these main tables:
- **users** - Authentication and user management
- **students** - Student records
- **exams** - Exam schedules
- **attendance** - Attendance records

Additional tables can be created by adding migrations.

---

## Authentication Flow

1. **Register** → Get user credentials
2. **Login** → Get `access_token` and `refresh_token`
3. **Use access_token** → Make API requests with JWT in header
4. **When token expires** → Use `refresh_token` to get new `access_token`
5. **Change password** → Secure password update with authentication

---

## Security Features

✅ Bcrypt password hashing (cost factor: 10)  
✅ JWT token-based authentication  
✅ Token expiry management  
✅ Refresh token mechanism  
✅ Protected endpoints with middleware  
✅ Input validation  
✅ Database connection pooling  

---

## Troubleshooting

### Database Connection Error
**Problem:** `Failed to connect to database`

**Solution:**
```bash
# Check MySQL is running
mysql -u root -p -e "SELECT 1;"

# Verify .env database credentials
cat .env
```

### Port Already in Use
**Problem:** `Port 8080 already in use`

**Solution:**
```bash
# Change port in .env
SERVER_PORT=8081

# Or kill process using port
lsof -i :8080
kill -9 <PID>
```

### Docker Issues
**Problem:** `Docker container fails to start`

**Solution:**
```bash
# Check logs
docker-compose logs api

# Restart containers
docker-compose down
docker-compose up -d

# Clean rebuild
docker-compose down -v
docker-compose up -d --build
```

### Token Expired
**Problem:** `401 Unauthorized`

**Solution:**
Use the refresh token to get a new access token:
```bash
curl -X POST http://localhost:8080/api/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{"refresh_token": "your_refresh_token"}'
```

---

## Next Steps

1. **Read Full Documentation** → See `README.md` and `API_DOCUMENTATION.md`
2. **Implement Additional Endpoints** → Add handlers for more entities
3. **Add Tests** → Create unit and integration tests
4. **Setup CI/CD** → Configure GitHub Actions or similar
5. **Deploy** → Use Docker or cloud platforms (AWS, GCP, Azure)
6. **Monitor** → Add logging and monitoring solutions

---

## Support

For issues or questions:
1. Check `API_DOCUMENTATION.md` for endpoint details
2. Review error messages in logs
3. Verify `.env` configuration
4. Check database connectivity

---

## License

This project is open source and available under the MIT License.

Happy Coding! 🚀
