# School Management API - Complete Documentation

## Base URL
```
http://localhost:8080/api/v1
```

## Authentication

All protected endpoints require a JWT token in the `Authorization` header:
```
Authorization: Bearer <your_jwt_token>
```

---

## Authentication Endpoints

### Register User
**POST** `/auth/register`

Register a new user in the system.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "secure_password",
  "first_name": "John",
  "last_name": "Doe",
  "role": "teacher"
}
```

**Roles:** `admin`, `teacher`, `student`, `parent`

**Response (201 Created):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "id": 1,
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "teacher",
    "status": "Active",
    "created_at": "2024-06-16T10:30:00Z",
    "updated_at": "2024-06-16T10:30:00Z"
  }
}
```

---

### Login User
**POST** `/auth/login`

Authenticate user and get JWT tokens.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "secure_password"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "id": 1,
      "email": "user@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "role": "teacher",
      "status": "Active"
    }
  }
}
```

---

### Refresh Access Token
**POST** `/auth/refresh`

Get a new access token using refresh token.

**Request Body:**
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "id": 1,
      "email": "user@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "role": "teacher",
      "status": "Active"
    }
  }
}
```

---

### Get User Profile
**GET** `/profile` (Protected)

Get current logged-in user's profile.

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "id": 1,
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "teacher",
    "status": "Active",
    "created_at": "2024-06-16T10:30:00Z",
    "updated_at": "2024-06-16T10:30:00Z"
  }
}
```

---

### Change Password
**POST** `/change-password` (Protected)

Change the password of logged-in user.

**Request Body:**
```json
{
  "old_password": "current_password",
  "new_password": "new_secure_password"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

---

## Student Management Endpoints

### Create Student
**POST** `/students` (Protected)

Create a new student record.

**Request Body:**
```json
{
  "first_name": "Arjun",
  "last_name": "Singh",
  "email": "arjun@example.com",
  "phone": "9876543210",
  "date_of_birth": "2008-05-15T00:00:00Z",
  "gender": "Male",
  "class_id": 1,
  "status": "Active"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Student created successfully",
  "data": {
    "id": 1,
    "first_name": "Arjun",
    "last_name": "Singh",
    "email": "arjun@example.com",
    "phone": "9876543210",
    "date_of_birth": "2008-05-15T00:00:00Z",
    "gender": "Male",
    "enrollment_date": "2024-06-16T00:00:00Z",
    "class_id": 1,
    "status": "Active",
    "created_at": "2024-06-16T10:30:00Z",
    "updated_at": "2024-06-16T10:30:00Z"
  }
}
```

---

### List Students
**GET** `/students` (Protected)

Get paginated list of all students.

**Query Parameters:**
- `limit` (optional, default: 10) - Number of records per page
- `offset` (optional, default: 0) - Number of records to skip

**Example:**
```
GET /students?limit=20&offset=0
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Students retrieved successfully",
  "data": [
    {
      "id": 1,
      "first_name": "Arjun",
      "last_name": "Singh",
      "email": "arjun@example.com",
      "phone": "9876543210",
      "date_of_birth": "2008-05-15T00:00:00Z",
      "gender": "Male",
      "enrollment_date": "2024-06-16T00:00:00Z",
      "class_id": 1,
      "status": "Active",
      "created_at": "2024-06-16T10:30:00Z",
      "updated_at": "2024-06-16T10:30:00Z"
    }
  ]
}
```

---

### Get Student by ID
**GET** `/students/{id}` (Protected)

Get a specific student by ID.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Student retrieved successfully",
  "data": {
    "id": 1,
    "first_name": "Arjun",
    "last_name": "Singh",
    "email": "arjun@example.com",
    "phone": "9876543210",
    "date_of_birth": "2008-05-15T00:00:00Z",
    "gender": "Male",
    "enrollment_date": "2024-06-16T00:00:00Z",
    "class_id": 1,
    "status": "Active",
    "created_at": "2024-06-16T10:30:00Z",
    "updated_at": "2024-06-16T10:30:00Z"
  }
}
```

---

### Update Student
**PUT** `/students/{id}` (Protected)

Update a student's information.

**Request Body:**
```json
{
  "first_name": "Arjun",
  "last_name": "Singh",
  "email": "arjun.new@example.com",
  "phone": "9876543211",
  "gender": "Male",
  "class_id": 2,
  "status": "Active"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Student updated successfully",
  "data": {
    "id": 1,
    "first_name": "Arjun",
    "last_name": "Singh",
    "email": "arjun.new@example.com",
    "phone": "9876543211",
    "date_of_birth": "2008-05-15T00:00:00Z",
    "gender": "Male",
    "enrollment_date": "2024-06-16T00:00:00Z",
    "class_id": 2,
    "status": "Active",
    "created_at": "2024-06-16T10:30:00Z",
    "updated_at": "2024-06-16T11:00:00Z"
  }
}
```

---

### Delete Student
**DELETE** `/students/{id}` (Protected)

Delete a student record.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Student deleted successfully"
}
```

---

### Get Student Performance
**GET** `/students/{id}/performance` (Protected)

Get performance metrics for a student.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Performance retrieved successfully",
  "data": {
    "average_marks": 82.5,
    "passed_exams": 8,
    "failed_exams": 0,
    "total_exams": 8
  }
}
```

---

### Get Students by Class
**GET** `/classes/{class_id}/students` (Protected)

Get all students in a specific class.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Students retrieved successfully",
  "data": [
    {
      "id": 1,
      "first_name": "Arjun",
      "last_name": "Singh",
      "email": "arjun@example.com",
      "class_id": 1,
      "status": "Active"
    },
    {
      "id": 2,
      "first_name": "Priya",
      "last_name": "Verma",
      "email": "priya@example.com",
      "class_id": 1,
      "status": "Active"
    }
  ]
}
```

---

## Exam Management Endpoints

### Create Exam
**POST** `/exams` (Protected)

Create a new exam.

**Request Body:**
```json
{
  "exam_name": "Mid Term - Mathematics",
  "exam_type": "Mid Term",
  "exam_date": "2024-07-15T00:00:00Z",
  "exam_time": "09:00:00",
  "total_marks": 100,
  "passing_marks": 40,
  "subject_id": 1,
  "class_id": 1
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Exam created successfully",
  "data": {
    "id": 1,
    "exam_name": "Mid Term - Mathematics",
    "exam_type": "Mid Term",
    "exam_date": "2024-07-15T00:00:00Z",
    "exam_time": "09:00:00",
    "total_marks": 100,
    "passing_marks": 40,
    "subject_id": 1,
    "class_id": 1,
    "created_at": "2024-06-16T10:30:00Z",
    "updated_at": "2024-06-16T10:30:00Z"
  }
}
```

---

### List Exams
**GET** `/exams` (Protected)

Get paginated list of all exams.

**Query Parameters:**
- `limit` (optional, default: 10)
- `offset` (optional, default: 0)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Exams retrieved successfully",
  "data": [
    {
      "id": 1,
      "exam_name": "Mid Term - Mathematics",
      "exam_type": "Mid Term",
      "exam_date": "2024-07-15T00:00:00Z",
      "exam_time": "09:00:00",
      "total_marks": 100,
      "passing_marks": 40,
      "subject_id": 1,
      "class_id": 1
    }
  ]
}
```

---

### Get Exam by ID
**GET** `/exams/{id}` (Protected)

Get a specific exam by ID.

---

### Update Exam
**PUT** `/exams/{id}` (Protected)

Update exam details.

---

### Delete Exam
**DELETE** `/exams/{id}` (Protected)

Delete an exam record.

---

### Get Upcoming Exams
**GET** `/exams/upcoming` (Protected)

Get list of upcoming exams.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Upcoming exams retrieved successfully",
  "data": [
    {
      "id": 1,
      "exam_name": "Mid Term - Mathematics",
      "exam_type": "Mid Term",
      "exam_date": "2024-07-15T00:00:00Z",
      "exam_time": "09:00:00",
      "total_marks": 100,
      "passing_marks": 40,
      "subject_id": 1,
      "class_id": 1
    }
  ]
}
```

---

### Get Exams by Class
**GET** `/classes/{class_id}/exams` (Protected)

Get all exams for a specific class.

---

## Attendance Management Endpoints

### Record Attendance
**POST** `/attendance` (Protected)

Record attendance for a student.

**Request Body:**
```json
{
  "student_id": 1,
  "class_id": 1,
  "attendance_date": "2024-06-16T00:00:00Z",
  "status": "Present",
  "remarks": ""
}
```

**Attendance Status:** `Present`, `Absent`, `Late`, `Leave`

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Attendance recorded successfully",
  "data": {
    "id": 1,
    "student_id": 1,
    "class_id": 1,
    "attendance_date": "2024-06-16T00:00:00Z",
    "status": "Present",
    "remarks": "",
    "created_at": "2024-06-16T10:30:00Z",
    "updated_at": "2024-06-16T10:30:00Z"
  }
}
```

---

### Get Attendance Record
**GET** `/attendance/{id}` (Protected)

Get a specific attendance record.

---

### Update Attendance
**PUT** `/attendance/{id}` (Protected)

Update attendance record.

---

### Delete Attendance
**DELETE** `/attendance/{id}` (Protected)

Delete attendance record.

---

### Get Student Attendance
**GET** `/students/{student_id}/attendance` (Protected)

Get attendance records for a specific student within a date range.

**Query Parameters:**
- `start_date` (optional) - Format: YYYY-MM-DD
- `end_date` (optional) - Format: YYYY-MM-DD

**Example:**
```
GET /students/1/attendance?start_date=2024-01-01&end_date=2024-02-01
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Attendance retrieved successfully",
  "data": [
    {
      "id": 1,
      "student_id": 1,
      "class_id": 1,
      "attendance_date": "2024-06-16T00:00:00Z",
      "status": "Present",
      "remarks": "",
      "created_at": "2024-06-16T10:30:00Z",
      "updated_at": "2024-06-16T10:30:00Z"
    }
  ]
}
```

---

### Get Attendance Summary
**GET** `/students/{student_id}/attendance/summary` (Protected)

Get attendance summary for a student.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Attendance summary retrieved successfully",
  "data": {
    "total_days": 45,
    "present_days": 42,
    "absent_days": 2,
    "late_days": 1,
    "attendance_percentage": 93.33
  }
}
```

---

### Get Class Attendance
**GET** `/classes/{class_id}/attendance` (Protected)

Get attendance records for an entire class on a specific date.

**Query Parameters:**
- `date` (optional, default: today) - Format: YYYY-MM-DD

**Example:**
```
GET /classes/1/attendance?date=2024-06-16
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Class attendance retrieved successfully",
  "data": [
    {
      "id": 1,
      "student_id": 1,
      "class_id": 1,
      "attendance_date": "2024-06-16T00:00:00Z",
      "status": "Present",
      "remarks": "",
      "created_at": "2024-06-16T10:30:00Z"
    },
    {
      "id": 2,
      "student_id": 2,
      "class_id": 1,
      "attendance_date": "2024-06-16T00:00:00Z",
      "status": "Absent",
      "remarks": "Sick",
      "created_at": "2024-06-16T10:30:00Z"
    }
  ]
}
```

---

## Health Check

### API Health
**GET** `/health`

Check if the API is running and healthy.

**Response (200 OK):**
```json
{
  "status": "ok"
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Invalid request",
  "error": "Email is required"
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "message": "Unauthorized",
  "error": "Invalid credentials"
}
```

### 404 Not Found
```json
{
  "success": false,
  "message": "Student not found",
  "error": ""
}
```

### 409 Conflict
```json
{
  "success": false,
  "message": "Email already registered",
  "error": ""
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "message": "Failed to create student",
  "error": "Database connection error"
}
```

---

## Token Expiry Information

- **Access Token** - Expires in 15 minutes (configurable via JWT_EXPIRY in .env)
- **Refresh Token** - Expires in 7 days (configurable via REFRESH_TOKEN_EXPIRY in .env)

After access token expires, use the refresh token to get a new one without logging in again.

---

## Rate Limiting

Currently, there is no rate limiting implemented. It's recommended to add rate limiting middleware in production.

---

## CORS

Currently, CORS is not enabled. Configure CORS middleware as needed for your frontend application.

---

## Testing the API

### Using cURL

```bash
# Register
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "first_name": "Test",
    "last_name": "User",
    "role": "teacher"
  }'

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'

# Get Profile (replace TOKEN with actual access token)
curl -X GET http://localhost:8080/api/v1/profile \
  -H "Authorization: Bearer TOKEN"
```

### Using Postman

1. Import the API collection
2. Set up environment variables for the access token
3. Test the endpoints with the provided examples

---

## Pagination

List endpoints support pagination using `limit` and `offset` parameters:

- **limit** - Number of records per page (default: 10, max: 100)
- **offset** - Number of records to skip (default: 0)

Example:
```
GET /api/v1/students?limit=20&offset=40
```

This will return 20 students starting from the 41st record.
