# School Management API - Complete cURL Commands

**Base URL:** `http://localhost:8080`

**Note:** Replace `{token}` with the JWT token from login response, and replace placeholders like `{id}`, `{student_id}`, etc. with actual values.

---

## Authentication (No Auth Required)

### Register
```bash
curl --location 'http://localhost:8080/api/v1/auth/register' \
--header 'Content-Type: application/json' \
--data-raw '{
  "email": "user@example.com",
  "password": "Password@123",
  "first_name": "John",
  "last_name": "Doe",
  "phone": "1234567890",
  "role": "admin"
}'
```

### Login
```bash
curl --location 'http://localhost:8080/api/v1/auth/login' \
--header 'Content-Type: application/json' \
--data-raw '{
  "email": "vikash798561@gmail.com",
  "password": "Vikash@123"
}'
```

### Refresh Token
```bash
curl --location 'http://localhost:8080/api/v1/auth/refresh' \
--header 'Content-Type: application/json' \
--data-raw '{
  "refresh_token": "your_refresh_token_here"
}'
```

### Health Check
```bash
curl --location 'http://localhost:8080/api/v1/health'
```

---

## User Profile (Auth Required)

### Get Profile
```bash
curl --location 'http://localhost:8080/api/v1/profile' \
--header 'Authorization: Bearer {token}'
```

### Change Password
```bash
curl --location 'http://localhost:8080/api/v1/change-password' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "current_password": "Vikash@123",
  "new_password": "NewPassword@123"
}'
```

---

## Dashboard (Auth Required)

### Get Stats
```bash
curl --location 'http://localhost:8080/api/v1/dashboard/stats' \
--header 'Authorization: Bearer {token}'
```

### Get Weekly Attendance
```bash
curl --location 'http://localhost:8080/api/v1/dashboard/attendance/weekly' \
--header 'Authorization: Bearer {token}'
```

### Get Performance
```bash
curl --location 'http://localhost:8080/api/v1/dashboard/performance' \
--header 'Authorization: Bearer {token}'
```

### Get Upcoming Exams
```bash
curl --location 'http://localhost:8080/api/v1/dashboard/exams/upcoming' \
--header 'Authorization: Bearer {token}'
```

### Get Pending Fees
```bash
curl --location 'http://localhost:8080/api/v1/dashboard/fees/pending' \
--header 'Authorization: Bearer {token}'
```

### Get Notifications
```bash
curl --location 'http://localhost:8080/api/v1/dashboard/notifications' \
--header 'Authorization: Bearer {token}'
```

---

## Classes (Auth Required)

### List Classes
```bash
curl --location 'http://localhost:8080/api/v1/classes' \
--header 'Authorization: Bearer {token}'
```

### Create Class
```bash
curl --location 'http://localhost:8080/api/v1/classes' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "name": "Class 10-A",
  "grade_level": "10",
  "capacity": 50,
  "room_number": "101"
}'
```

### Get Class by ID
```bash
curl --location 'http://localhost:8080/api/v1/classes/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Class
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/classes/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "name": "Class 10-A",
  "grade_level": "10",
  "capacity": 50,
  "room_number": "101"
}'
```

### Delete Class
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/classes/{id}' \
--header 'Authorization: Bearer {token}'
```

### Get Class Info
```bash
curl --location 'http://localhost:8080/api/v1/classes/{id}/info' \
--header 'Authorization: Bearer {token}'
```

### Get Classes by Grade Level
```bash
curl --location 'http://localhost:8080/api/v1/grade-levels/{grade_level}/classes' \
--header 'Authorization: Bearer {token}'
```

---

## Teachers (Auth Required)

### List Teachers
```bash
curl --location 'http://localhost:8080/api/v1/teachers' \
--header 'Authorization: Bearer {token}'
```

### Create Teacher
```bash
curl --location 'http://localhost:8080/api/v1/teachers' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "first_name": "John",
  "last_name": "Smith",
  "email": "john@example.com",
  "phone": "9876543210",
  "specialization": "Mathematics",
  "hire_date": "2023-01-15"
}'
```

### Get Teacher by ID
```bash
curl --location 'http://localhost:8080/api/v1/teachers/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Teacher
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/teachers/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "first_name": "John",
  "last_name": "Smith",
  "email": "john@example.com",
  "phone": "9876543210",
  "specialization": "Mathematics",
  "hire_date": "2023-01-15"
}'
```

### Delete Teacher
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/teachers/{id}' \
--header 'Authorization: Bearer {token}'
```

### Get Assigned Classes
```bash
curl --location 'http://localhost:8080/api/v1/teachers/{id}/classes' \
--header 'Authorization: Bearer {token}'
```

### Get Teachers by Specialization
```bash
curl --location 'http://localhost:8080/api/v1/teachers/specialization?spec=Mathematics' \
--header 'Authorization: Bearer {token}'
```

---

## Subjects (Auth Required)

### List Subjects
```bash
curl --location 'http://localhost:8080/api/v1/subjects' \
--header 'Authorization: Bearer {token}'
```

### Create Subject
```bash
curl --location 'http://localhost:8080/api/v1/subjects' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "name": "Mathematics",
  "code": "MATH101",
  "description": "Basic Mathematics"
}'
```

### Get Subject by ID
```bash
curl --location 'http://localhost:8080/api/v1/subjects/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Subject
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/subjects/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "name": "Mathematics",
  "code": "MATH101",
  "description": "Basic Mathematics"
}'
```

### Delete Subject
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/subjects/{id}' \
--header 'Authorization: Bearer {token}'
```

### Get Subject by Code
```bash
curl --location 'http://localhost:8080/api/v1/subjects/code/MATH101' \
--header 'Authorization: Bearer {token}'
```

### Search Subjects
```bash
curl --location 'http://localhost:8080/api/v1/subjects/search?q=Math' \
--header 'Authorization: Bearer {token}'
```

---

## Students (Auth Required)

### List Students
```bash
curl --location 'http://localhost:8080/api/v1/students' \
--header 'Authorization: Bearer {token}'
```

### Create Student
```bash
curl --location 'http://localhost:8080/api/v1/students' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "first_name": "Alice",
  "last_name": "Johnson",
  "email": "alice@example.com",
  "phone": "5555555555",
  "date_of_birth": "2005-06-15",
  "class_id": 1,
  "enrollment_date": "2023-04-01"
}'
```

### Get Student by ID
```bash
curl --location 'http://localhost:8080/api/v1/students/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Student
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/students/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "first_name": "Alice",
  "last_name": "Johnson",
  "email": "alice@example.com",
  "phone": "5555555555",
  "date_of_birth": "2005-06-15",
  "class_id": 1,
  "enrollment_date": "2023-04-01"
}'
```

### Delete Student
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/students/{id}' \
--header 'Authorization: Bearer {token}'
```

### Get Student Performance
```bash
curl --location 'http://localhost:8080/api/v1/students/{id}/performance' \
--header 'Authorization: Bearer {token}'
```

### Get Students by Class
```bash
curl --location 'http://localhost:8080/api/v1/classes/{class_id}/students' \
--header 'Authorization: Bearer {token}'
```

---

## Exams (Auth Required)

### List Exams
```bash
curl --location 'http://localhost:8080/api/v1/exams' \
--header 'Authorization: Bearer {token}'
```

### Create Exam
```bash
curl --location 'http://localhost:8080/api/v1/exams' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "name": "Midterm Exam",
  "subject_id": 1,
  "exam_date": "2024-06-15",
  "total_marks": 100,
  "passing_marks": 40
}'
```

### Get Exam by ID
```bash
curl --location 'http://localhost:8080/api/v1/exams/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Exam
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/exams/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "name": "Midterm Exam",
  "subject_id": 1,
  "exam_date": "2024-06-15",
  "total_marks": 100,
  "passing_marks": 40
}'
```

### Delete Exam
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/exams/{id}' \
--header 'Authorization: Bearer {token}'
```

### Get Upcoming Exams
```bash
curl --location 'http://localhost:8080/api/v1/exams/upcoming' \
--header 'Authorization: Bearer {token}'
```

### Get Exams by Class
```bash
curl --location 'http://localhost:8080/api/v1/classes/{class_id}/exams' \
--header 'Authorization: Bearer {token}'
```

---

## Exam Results (Auth Required)

### Create Exam Result
```bash
curl --location 'http://localhost:8080/api/v1/exam-results' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "exam_id": 1,
  "student_id": 1,
  "marks_obtained": 85
}'
```

### Get Exam Result by ID
```bash
curl --location 'http://localhost:8080/api/v1/exam-results/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Exam Result
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/exam-results/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "exam_id": 1,
  "student_id": 1,
  "marks_obtained": 90
}'
```

### Delete Exam Result
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/exam-results/{id}' \
--header 'Authorization: Bearer {token}'
```

### Get Results by Exam
```bash
curl --location 'http://localhost:8080/api/v1/exams/{exam_id}/results' \
--header 'Authorization: Bearer {token}'
```

### Get Exam Stats
```bash
curl --location 'http://localhost:8080/api/v1/exams/{exam_id}/results/stats' \
--header 'Authorization: Bearer {token}'
```

### Get Student Results
```bash
curl --location 'http://localhost:8080/api/v1/students/{student_id}/results' \
--header 'Authorization: Bearer {token}'
```

### Get Student GPA
```bash
curl --location 'http://localhost:8080/api/v1/students/{student_id}/gpa' \
--header 'Authorization: Bearer {token}'
```

### Get Specific Student Exam Result
```bash
curl --location 'http://localhost:8080/api/v1/exams/{exam_id}/students/{student_id}/result' \
--header 'Authorization: Bearer {token}'
```

---

## Attendance (Auth Required)

### Create Attendance
```bash
curl --location 'http://localhost:8080/api/v1/attendance' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "student_id": 1,
  "attendance_date": "2024-06-15",
  "status": "present"
}'
```

### Get Attendance by ID
```bash
curl --location 'http://localhost:8080/api/v1/attendance/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Attendance
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/attendance/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "student_id": 1,
  "attendance_date": "2024-06-15",
  "status": "absent"
}'
```

### Delete Attendance
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/attendance/{id}' \
--header 'Authorization: Bearer {token}'
```

### Get Student Attendance
```bash
curl --location 'http://localhost:8080/api/v1/students/{student_id}/attendance' \
--header 'Authorization: Bearer {token}'
```

### Get Attendance Summary
```bash
curl --location 'http://localhost:8080/api/v1/students/{student_id}/attendance/summary' \
--header 'Authorization: Bearer {token}'
```

### Get Class Attendance
```bash
curl --location 'http://localhost:8080/api/v1/classes/{class_id}/attendance' \
--header 'Authorization: Bearer {token}'
```

---

## Fees (Auth Required)

### List Fees
```bash
curl --location 'http://localhost:8080/api/v1/fees' \
--header 'Authorization: Bearer {token}'
```

### Create Fee
```bash
curl --location 'http://localhost:8080/api/v1/fees' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "student_id": 1,
  "amount": 5000,
  "due_date": "2024-06-30",
  "description": "Tuition Fee"
}'
```

### Get Fee by ID
```bash
curl --location 'http://localhost:8080/api/v1/fees/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Fee
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/fees/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "student_id": 1,
  "amount": 5000,
  "due_date": "2024-06-30",
  "description": "Tuition Fee"
}'
```

### Delete Fee
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/fees/{id}' \
--header 'Authorization: Bearer {token}'
```

### Pay Fee
```bash
curl --location 'http://localhost:8080/api/v1/fees/{id}/pay' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "payment_method": "online"
}'
```

### Get Fee Receipt
```bash
curl --location 'http://localhost:8080/api/v1/fees/{id}/receipt' \
--header 'Authorization: Bearer {token}'
```

### Get Student Fees
```bash
curl --location 'http://localhost:8080/api/v1/students/{student_id}/fees' \
--header 'Authorization: Bearer {token}'
```

### Get Fee Summary
```bash
curl --location 'http://localhost:8080/api/v1/students/{student_id}/fees/summary' \
--header 'Authorization: Bearer {token}'
```

---

## Parents/Guardians (Auth Required)

### List Parents
```bash
curl --location 'http://localhost:8080/api/v1/parents' \
--header 'Authorization: Bearer {token}'
```

### Create Parent
```bash
curl --location 'http://localhost:8080/api/v1/parents' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "first_name": "Robert",
  "last_name": "Johnson",
  "email": "robert@example.com",
  "phone": "1234567890",
  "relationship": "Father"
}'
```

### Get Parent by ID
```bash
curl --location 'http://localhost:8080/api/v1/parents/{id}' \
--header 'Authorization: Bearer {token}'
```

### Update Parent
```bash
curl --location --request PUT 'http://localhost:8080/api/v1/parents/{id}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {token}' \
--data-raw '{
  "first_name": "Robert",
  "last_name": "Johnson",
  "email": "robert@example.com",
  "phone": "1234567890",
  "relationship": "Father"
}'
```

### Delete Parent
```bash
curl --location --request DELETE 'http://localhost:8080/api/v1/parents/{id}' \
--header 'Authorization: Bearer {token}'
```

### Get Parents by Student
```bash
curl --location 'http://localhost:8080/api/v1/students/{student_id}/parents' \
--header 'Authorization: Bearer {token}'
```

### Get Parent by Email
```bash
curl --location 'http://localhost:8080/api/v1/parents/email?email=robert@example.com' \
--header 'Authorization: Bearer {token}'
```

### Get Parent by Phone
```bash
curl --location 'http://localhost:8080/api/v1/parents/phone?phone=1234567890' \
--header 'Authorization: Bearer {token}'
```

---

## Quick Reference

| Endpoint | Method | Auth Required | Description |
|----------|--------|---------------|-------------|
| `/auth/register` | POST | No | Register a new user |
| `/auth/login` | POST | No | Login and get token |
| `/auth/refresh` | POST | No | Refresh access token |
| `/health` | GET | No | Health check |
| `/profile` | GET | Yes | Get user profile |
| `/change-password` | POST | Yes | Change password |
| `/dashboard/stats` | GET | Yes | Get dashboard statistics |
| `/classes` | GET/POST/PUT/DELETE | Yes | Manage classes |
| `/teachers` | GET/POST/PUT/DELETE | Yes | Manage teachers |
| `/subjects` | GET/POST/PUT/DELETE | Yes | Manage subjects |
| `/students` | GET/POST/PUT/DELETE | Yes | Manage students |
| `/exams` | GET/POST/PUT/DELETE | Yes | Manage exams |
| `/exam-results` | GET/POST/PUT/DELETE | Yes | Manage exam results |
| `/attendance` | GET/POST/PUT/DELETE | Yes | Manage attendance |
| `/fees` | GET/POST/PUT/DELETE | Yes | Manage fees |
| `/parents` | GET/POST/PUT/DELETE | Yes | Manage parents |

---

## Testing Workflow

1. **Register a user:**
   ```bash
   curl --location 'http://localhost:8080/api/v1/auth/register' \
   --header 'Content-Type: application/json' \
   --data-raw '{
     "email": "test@example.com",
     "password": "Test@123",
     "first_name": "Test",
     "last_name": "User",
     "phone": "9999999999",
     "role": "admin"
   }'
   ```

2. **Login to get token:**
   ```bash
   curl --location 'http://localhost:8080/api/v1/auth/login' \
   --header 'Content-Type: application/json' \
   --data-raw '{
     "email": "test@example.com",
     "password": "Test@123"
   }'
   ```

3. **Use the token in subsequent requests:**
    - Copy the `access_token` from login response
    - Replace `{token}` with the actual token in other requests
    - Add `Authorization: Bearer {token}` header

---

## Error Handling

All API responses follow this format:

**Success Response (2xx):**
```json
{
  "statusCode": 200,
  "success": true,
  "message": "Request successful",
  "data": {...},
  "timestamp": 1234567890.123456,
  "path": "/api/v1/...",
  "errors": null,
  "fieldErrors": null
}
```

**Error Response (4xx/5xx):**
```json
{
  "statusCode": 400,
  "success": false,
  "message": "Error message",
  "data": null,
  "timestamp": 1234567890.123456,
  "path": "/api/v1/...",
  "errors": ["error1", "error2"],
  "fieldErrors": {"field": "error"}
}
```

---

**Last Updated:** 2026-06-17
