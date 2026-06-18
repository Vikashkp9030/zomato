# School Management System - Go REST API

A comprehensive REST API for managing school operations built with Go, featuring authentication, JWT tokens, password management, and complete school management functionality.

## Features

- ✅ User Authentication (Register, Login, Refresh Token)
- ✅ Password Management (Change Password, Secure Hashing)
- ✅ JWT Token-based Authorization
- ✅ Student Management (CRUD operations)
- ✅ Exam Management
- ✅ Attendance Tracking
- ✅ Student Performance Analytics
- ✅ Role-based Access Control
- ✅ Input Validation
- ✅ Error Handling
- ✅ Database Indexing for Performance
- ✅ Proper Project Structure
- ✅ Environment Configuration

## Project Structure

```
school_management/
├── cmd/
│   └── main.go                          # Application entry point
├── config/
│   └── config.go                        # Configuration management
├── internal/
│   ├── database/
│   │   └── db.go                        # Database connection
│   ├── handler/
│   │   ├── auth_handler.go              # Authentication endpoints
│   │   ├── student_handler.go           # Student management
│   │   ├── exam_handler.go              # Exam management
│   │   └── attendance_handler.go        # Attendance tracking
│   ├── middleware/
│   │   ├── auth.go                      # JWT authentication middleware
│   │   └── logger.go                    # Request logging middleware
│   ├── models/
│   │   ├── user.go                      # User models
│   │   └── school.go                    # School entity models
│   ├── repository/
│   │   ├── user_repo.go                 # User data access
│   │   ├── student_repo.go              # Student data access
│   │   ├── exam_repo.go                 # Exam data access
│   │   └── attendance_repo.go           # Attendance data access
│   ├── routes/
│   │   └── routes.go                    # API route definitions
│   └── utils/
│       ├── jwt.go                       # JWT utilities
│       ├── password.go                  # Password hashing
│       └── response.go                  # API response helpers
├── migrations/
│   ├── 001_create_users_table.sql
│   ├── 002_create_students_table.sql
│   ├── 003_create_exams_table.sql
│   └── 004_create_attendance_table.sql
├── .env.example                         # Environment variables template
├── .gitignore                           # Git ignore rules
├── go.mod                               # Go module file
└── README.md                            # This file
```

## Prerequisites

- Go 1.21+
- MySQL 8.0+
- Git

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/school_management.git
cd school_management
```

2. Install dependencies:
```bash
go mod download
```

3. Create `.env` file from `.env.example`:
```bash
cp .env.example .env
```

4. Update `.env` with your database credentials:
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=school_management
SERVER_PORT=8080
JWT_SECRET=your_super_secret_key
```

5. Create the database:
```sql
CREATE DATABASE school_management;
```

6. Run migrations:
```bash
mysql -u root -p school_management < migrations/001_create_users_table.sql
mysql -u root -p school_management < migrations/002_create_students_table.sql
mysql -u root -p school_management < migrations/003_create_exams_table.sql
mysql -u root -p school_management < migrations/004_create_attendance_table.sql
```

## Running the Application

```bash
go run cmd/main.go
```

The server will start on `http://localhost:8080`

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh access token

### Protected Endpoints (Require JWT Token)

#### User Profile
- `GET /api/v1/profile` - Get user profile
- `POST /api/v1/change-password` - Change password

#### Students
- `GET /api/v1/students` - List all students (paginated)
- `POST /api/v1/students` - Create new student
- `GET /api/v1/students/{id}` - Get student by ID
- `PUT /api/v1/students/{id}` - Update student
- `DELETE /api/v1/students/{id}` - Delete student
- `GET /api/v1/students/{id}/performance` - Get student performance
- `GET /api/v1/classes/{class_id}/students` - Get students by class

#### Exams
- `GET /api/v1/exams` - List all exams (paginated)
- `POST /api/v1/exams` - Create new exam
- `GET /api/v1/exams/{id}` - Get exam by ID
- `PUT /api/v1/exams/{id}` - Update exam
- `DELETE /api/v1/exams/{id}` - Delete exam
- `GET /api/v1/exams/upcoming` - Get upcoming exams
- `GET /api/v1/classes/{class_id}/exams` - Get exams by class

#### Attendance
- `POST /api/v1/attendance` - Record attendance
- `GET /api/v1/attendance/{id}` - Get attendance record
- `PUT /api/v1/attendance/{id}` - Update attendance
- `DELETE /api/v1/attendance/{id}` - Delete attendance
- `GET /api/v1/students/{student_id}/attendance` - Get student attendance
- `GET /api/v1/students/{student_id}/attendance/summary` - Get attendance summary
- `GET /api/v1/classes/{class_id}/attendance` - Get class attendance

### Health Check
- `GET /api/v1/health` - API health status

## API Examples

### Register
```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "first_name": "John",
    "last_name": "Doe",
    "role": "teacher"
  }'
```

### Login
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Create Student (with JWT token)
```bash
curl -X POST http://localhost:8080/api/v1/students \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
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

### Get Student Attendance
```bash
curl -X GET "http://localhost:8080/api/v1/students/1/attendance?start_date=2024-01-01&end_date=2024-02-01" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. 

1. User registers or logs in
2. Server returns `access_token` and `refresh_token`
3. Include `Authorization: Bearer <access_token>` in protected endpoints
4. When token expires, use `refresh_token` to get a new `access_token`

## Database Schema

The project uses the comprehensive school management database schema with the following tables:

- **users** - System users with authentication
- **students** - Student information
- **exams** - Exam schedules and details
- **attendance** - Student attendance records
- And all other school management tables (uses partial schema, can be extended)

## Security Features

- Bcrypt password hashing
- JWT token-based authentication
- Refresh token mechanism
- Protected API endpoints
- Input validation
- Secure error handling

## Configuration

All configuration is managed via `.env` file:

```env
# Database
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=password
DB_NAME=school_management

# Server
SERVER_HOST=0.0.0.0
SERVER_PORT=8080

# JWT
JWT_SECRET=your_secret_key
JWT_EXPIRY=15m
REFRESH_TOKEN_EXPIRY=7d

# App
APP_ENV=development
LOG_LEVEL=info
```

## Error Handling

All errors are returned in a consistent format:

```json
{
  "success": false,
  "message": "Error message",
  "error": "Detailed error information"
}
```

## Success Response Format

```json
{
  "success": true,
  "message": "Success message",
  "data": {}
}
```

## Development

### Running Tests
```bash
go test ./...
```

### Building for Production
```bash
go build -o bin/school-management cmd/main.go
```

### Code Formatting
```bash
go fmt ./...
```

### Linting
```bash
golangci-lint run
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@example.com or open an issue on GitHub.

## Roadmap

- [ ] Complete school management tables in database
- [ ] Teacher management endpoints
- [ ] Fee management endpoints
- [ ] Exam results management
- [ ] Parent portal
- [ ] Email notifications
- [ ] SMS notifications
- [ ] Advanced analytics
- [ ] File uploads (documents, certificates)
- [ ] Unit tests
- [ ] Integration tests
- [ ] API documentation (Swagger)
- [ ] Docker support
- [ ] CI/CD pipeline
