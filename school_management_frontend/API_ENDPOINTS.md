# Complete API Endpoints Reference

## Base Configuration
```
BASE_URL: http://localhost:8080/api/v1
Timeout: 30 seconds
Headers: Content-Type: application/json
Auth: Bearer token in Authorization header
```

---

## 1. Authentication Endpoints

### Login
```
POST /auth/login
Content-Type: application/json

Request:
{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "accessToken": "jwt_token",
  "refreshToken": "refresh_token",
  "user": {
    "id": "user_id",
    "firstName": "John",
    "lastName": "Doe",
    "email": "user@example.com",
    "phoneNumber": "+1234567890",
    "role": "admin|teacher|student|parent",
    "profileImage": "url_or_null",
    "isActive": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  },
  "message": "Login successful"
}

Status: 200, 401, 400
```

### Register
```
POST /auth/register
Content-Type: application/json

Request:
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "password": "password123",
  "confirmPassword": "password123",
  "phoneNumber": "+1234567890",
  "role": "student|teacher|parent"
}

Response:
{
  "accessToken": "jwt_token",
  "refreshToken": "refresh_token",
  "user": { ... },
  "message": "Registration successful"
}

Status: 201, 400, 409
```

### Logout
```
POST /auth/logout
Authorization: Bearer {token}

Response:
{
  "message": "Logout successful"
}

Status: 200
```

### Refresh Token
```
POST /auth/refresh-token
Content-Type: application/json

Request:
{
  "refreshToken": "refresh_token"
}

Response:
{
  "accessToken": "new_jwt_token",
  "refreshToken": "new_refresh_token",
  "user": { ... }
}

Status: 200, 401
```

### Forgot Password
```
POST /auth/forgot-password
Content-Type: application/json

Request:
{
  "email": "user@example.com"
}

Response:
{
  "message": "Password reset email sent"
}

Status: 200, 404
```

### Reset Password
```
POST /auth/reset-password
Content-Type: application/json

Request:
{
  "token": "reset_token",
  "newPassword": "newpassword123",
  "confirmPassword": "newpassword123"
}

Response:
{
  "message": "Password reset successful"
}

Status: 200, 400
```

### Verify Email
```
POST /auth/verify-email
Content-Type: application/json

Request:
{
  "token": "verification_token"
}

Response:
{
  "message": "Email verified successfully"
}

Status: 200, 400
```

---

## 2. Classes Endpoints

### Get All Classes
```
GET /classes?page=1&limit=10&search=&grade=

Query Parameters:
- page (int): Page number (default: 1)
- limit (int): Items per page (default: 10)
- search (string): Search by class name
- grade (string): Filter by grade (A, B, C, etc.)

Response:
{
  "data": [
    {
      "id": "class_id",
      "name": "Class A",
      "grade": "10",
      "section": "A",
      "capacity": 50,
      "currentStudents": 45,
      "classTeacherId": "teacher_id",
      "room": "101",
      "description": "Class description",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "total": 5,
    "page": 1,
    "limit": 10,
    "pages": 1
  }
}

Status: 200
```

### Get Class by ID
```
GET /classes/:id
Authorization: Bearer {token}

Response:
{
  "id": "class_id",
  "name": "Class A",
  "grade": "10",
  "section": "A",
  "capacity": 50,
  "currentStudents": 45,
  "classTeacherId": "teacher_id",
  "classTeacher": { ... },
  "students": [ ... ],
  "subjects": [ ... ]
}

Status: 200, 404
```

### Create Class
```
POST /classes
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "name": "Class A",
  "grade": "10",
  "section": "A",
  "capacity": 50,
  "classTeacherId": "teacher_id",
  "room": "101",
  "description": "Class description"
}

Response:
{
  "id": "new_class_id",
  "name": "Class A",
  ...
}

Status: 201, 400
```

### Update Class
```
PUT /classes/:id
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "name": "Class A",
  "grade": "10",
  "section": "A",
  "capacity": 50,
  "classTeacherId": "teacher_id",
  "room": "101",
  "description": "Updated description"
}

Response:
{
  "id": "class_id",
  ...
}

Status: 200, 400, 404
```

### Delete Class
```
DELETE /classes/:id
Authorization: Bearer {token}

Response:
{
  "message": "Class deleted successfully"
}

Status: 204, 404
```

### Get Class Students
```
GET /classes/:id/students
Authorization: Bearer {token}

Response:
{
  "classId": "class_id",
  "students": [
    {
      "id": "student_id",
      "firstName": "John",
      "lastName": "Doe",
      "rollNumber": "001",
      "email": "john@example.com",
      "status": "active"
    }
  ]
}

Status: 200
```

### Get Class Subjects
```
GET /classes/:id/subjects
Authorization: Bearer {token}

Response:
{
  "classId": "class_id",
  "subjects": [
    {
      "id": "subject_id",
      "name": "Mathematics",
      "code": "MTH",
      "teacher": { ... }
    }
  ]
}

Status: 200
```

---

## 3. Teachers Endpoints

### Get All Teachers
```
GET /teachers?page=1&limit=10&search=&specialization=&department=

Query Parameters:
- page (int): Page number
- limit (int): Items per page
- search (string): Search by name
- specialization (string): Filter by specialization
- department (string): Filter by department

Response:
{
  "data": [
    {
      "id": "teacher_id",
      "firstName": "Jane",
      "lastName": "Smith",
      "email": "jane@example.com",
      "phoneNumber": "+1234567890",
      "specialization": "Mathematics",
      "department": "Science",
      "qualifications": "B.Tech, M.Ed",
      "experience": 5,
      "hireDate": "2019-01-15",
      "status": "active"
    }
  ],
  "pagination": { ... }
}

Status: 200
```

### Get Teacher by ID
```
GET /teachers/:id
Authorization: Bearer {token}

Response:
{
  "id": "teacher_id",
  "firstName": "Jane",
  "lastName": "Smith",
  ...
  "classes": [ ... ],
  "subjects": [ ... ]
}

Status: 200, 404
```

### Create Teacher
```
POST /teachers
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "firstName": "Jane",
  "lastName": "Smith",
  "email": "jane@example.com",
  "phoneNumber": "+1234567890",
  "specialization": "Mathematics",
  "department": "Science",
  "qualifications": "B.Tech, M.Ed",
  "experience": 5,
  "hireDate": "2019-01-15"
}

Response:
{
  "id": "new_teacher_id",
  ...
}

Status: 201, 400
```

### Update Teacher
```
PUT /teachers/:id
Authorization: Bearer {token}
Content-Type: application/json

Request: (same as create)

Response: { ... }

Status: 200, 400, 404
```

### Delete Teacher
```
DELETE /teachers/:id
Authorization: Bearer {token}

Status: 204, 404
```

### Get Teacher Classes
```
GET /teachers/:id/classes
Authorization: Bearer {token}

Response:
{
  "teacherId": "teacher_id",
  "classes": [ ... ]
}

Status: 200
```

### Get Teacher Subjects
```
GET /teachers/:id/subjects
Authorization: Bearer {token}

Response:
{
  "teacherId": "teacher_id",
  "subjects": [ ... ]
}

Status: 200
```

### Assign Teacher to Class
```
POST /teachers/:id/assign-class
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "classId": "class_id"
}

Response:
{
  "message": "Teacher assigned successfully"
}

Status: 200, 400, 404
```

---

## 4. Subjects Endpoints

### Get All Subjects
```
GET /subjects?page=1&limit=10&search=&category=

Query Parameters:
- page (int): Page number
- limit (int): Items per page
- search (string): Search by name
- category (string): Filter by category

Response:
{
  "data": [
    {
      "id": "subject_id",
      "name": "Mathematics",
      "code": "MTH",
      "category": "Science",
      "description": "Basic math",
      "creditHours": 4,
      "maxMarks": 100,
      "passMarks": 40
    }
  ],
  "pagination": { ... }
}

Status: 200
```

### Get Subject by ID
```
GET /subjects/:id
Authorization: Bearer {token}

Response: { ... }

Status: 200, 404
```

### Create Subject
```
POST /subjects
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "name": "Mathematics",
  "code": "MTH",
  "category": "Science",
  "description": "Basic math",
  "creditHours": 4,
  "maxMarks": 100,
  "passMarks": 40
}

Response:
{
  "id": "new_subject_id",
  ...
}

Status: 201, 400
```

### Update Subject
```
PUT /subjects/:id
Authorization: Bearer {token}
Content-Type: application/json

Request: (same as create)

Response: { ... }

Status: 200, 400, 404
```

### Delete Subject
```
DELETE /subjects/:id
Authorization: Bearer {token}

Status: 204, 404
```

### Get Subject Teachers
```
GET /subjects/:id/teachers
Authorization: Bearer {token}

Response:
{
  "subjectId": "subject_id",
  "teachers": [ ... ]
}

Status: 200
```

### Get Subject Classes
```
GET /subjects/:id/classes
Authorization: Bearer {token}

Response:
{
  "subjectId": "subject_id",
  "classes": [ ... ]
}

Status: 200
```

### Assign Subject to Class
```
POST /subjects/:id/assign-class
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "classId": "class_id"
}

Response:
{
  "message": "Subject assigned successfully"
}

Status: 200, 400
```

---

## 5. Students Endpoints

### Get All Students
```
GET /students?page=1&limit=10&search=&classId=&status=

Query Parameters:
- page (int): Page number
- limit (int): Items per page
- search (string): Search by name or roll number
- classId (string): Filter by class
- status (string): active, inactive, suspended

Response:
{
  "data": [
    {
      "id": "student_id",
      "firstName": "Alice",
      "lastName": "Johnson",
      "rollNumber": "001",
      "email": "alice@example.com",
      "classId": "class_id",
      "className": "Class A",
      "dateOfBirth": "2005-06-15",
      "parentId": "parent_id",
      "status": "active",
      "enrollmentDate": "2023-01-01"
    }
  ],
  "pagination": { ... }
}

Status: 200
```

### Get Student by ID
```
GET /students/:id
Authorization: Bearer {token}

Response: { ... with class, parent, results, attendance }

Status: 200, 404
```

### Create Student
```
POST /students
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "firstName": "Alice",
  "lastName": "Johnson",
  "rollNumber": "001",
  "email": "alice@example.com",
  "classId": "class_id",
  "dateOfBirth": "2005-06-15",
  "parentId": "parent_id"
}

Response:
{
  "id": "new_student_id",
  ...
}

Status: 201, 400
```

### Update Student
```
PUT /students/:id
Authorization: Bearer {token}
Content-Type: application/json

Request: (same as create)

Response: { ... }

Status: 200, 400, 404
```

### Delete Student
```
DELETE /students/:id
Authorization: Bearer {token}

Status: 204, 404
```

### Get Student Performance
```
GET /students/:id/performance
Authorization: Bearer {token}

Response:
{
  "studentId": "student_id",
  "gpa": 3.8,
  "averageMarks": 85,
  "totalExams": 10,
  "passedExams": 10,
  "failedExams": 0,
  "trends": [ ... ]
}

Status: 200
```

### Get Student Results
```
GET /students/:id/results
Authorization: Bearer {token}

Response:
{
  "studentId": "student_id",
  "results": [ ... ]
}

Status: 200
```

### Get Student Attendance
```
GET /students/:id/attendance
Authorization: Bearer {token}

Response:
{
  "studentId": "student_id",
  "totalDays": 200,
  "presentDays": 185,
  "absentDays": 15,
  "percentage": 92.5
}

Status: 200
```

### Promote Student
```
POST /students/:id/promote
Authorization: Bearer {token}

Request: {}

Response:
{
  "message": "Student promoted successfully",
  "newGrade": "11"
}

Status: 200, 400
```

---

## 6. Exams Endpoints

### Get All Exams
```
GET /exams?page=1&limit=10&search=&classId=&subjectId=&status=

Query Parameters:
- page, limit, search: standard pagination
- classId, subjectId: filters
- status: scheduled, completed, cancelled

Response:
{
  "data": [
    {
      "id": "exam_id",
      "name": "Midterm Exam",
      "classId": "class_id",
      "subjectId": "subject_id",
      "totalMarks": 100,
      "duration": 120,
      "examDate": "2024-03-15",
      "startTime": "10:00:00",
      "status": "scheduled"
    }
  ],
  "pagination": { ... }
}

Status: 200
```

### Get Exam by ID
```
GET /exams/:id
Authorization: Bearer {token}

Response: { ... with details and results count }

Status: 200, 404
```

### Create Exam
```
POST /exams
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "name": "Midterm Exam",
  "classId": "class_id",
  "subjectId": "subject_id",
  "totalMarks": 100,
  "duration": 120,
  "examDate": "2024-03-15",
  "startTime": "10:00:00",
  "description": "Exam description"
}

Response:
{
  "id": "new_exam_id",
  ...
}

Status: 201, 400
```

### Update Exam
```
PUT /exams/:id
Authorization: Bearer {token}
Content-Type: application/json

Request: (same as create)

Response: { ... }

Status: 200, 400, 404
```

### Delete Exam
```
DELETE /exams/:id
Authorization: Bearer {token}

Status: 204, 404
```

### Get Exam Schedule
```
GET /exams/schedule?classId=&startDate=&endDate=

Query Parameters:
- classId: optional
- startDate, endDate: date range (YYYY-MM-DD)

Response:
{
  "schedule": [
    {
      "date": "2024-03-15",
      "exams": [ ... ]
    }
  ]
}

Status: 200
```

### Get Exam Results
```
GET /exams/:id/results
Authorization: Bearer {token}

Response:
{
  "examId": "exam_id",
  "results": [ ... ],
  "totalStudents": 45,
  "submittedResults": 45
}

Status: 200
```

### Publish Exam
```
POST /exams/:id/publish
Authorization: Bearer {token}

Response:
{
  "message": "Exam published successfully"
}

Status: 200, 400
```

---

## 7. Results Endpoints

### Get All Results
```
GET /results?page=1&limit=10&examId=&studentId=&classId=

Response:
{
  "data": [
    {
      "id": "result_id",
      "studentId": "student_id",
      "studentName": "Alice Johnson",
      "examId": "exam_id",
      "examName": "Midterm",
      "subjectId": "subject_id",
      "marksObtained": 85,
      "totalMarks": 100,
      "percentage": 85,
      "grade": "A",
      "status": "pass",
      "remarks": "Good performance"
    }
  ],
  "pagination": { ... }
}

Status: 200
```

### Get Result by ID
```
GET /results/:id
Authorization: Bearer {token}

Response: { ... }

Status: 200, 404
```

### Create Result
```
POST /results
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "studentId": "student_id",
  "examId": "exam_id",
  "marksObtained": 85,
  "remarks": "Good performance"
}

Response:
{
  "id": "new_result_id",
  "percentage": 85,
  "grade": "A",
  "status": "pass"
}

Status: 201, 400
```

### Update Result
```
PUT /results/:id
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "marksObtained": 88,
  "remarks": "Updated remarks"
}

Response: { ... }

Status: 200, 400, 404
```

### Delete Result
```
DELETE /results/:id
Authorization: Bearer {token}

Status: 204, 404
```

### Get Student Results
```
GET /results/student/:studentId
Authorization: Bearer {token}

Response:
{
  "studentId": "student_id",
  "results": [ ... ]
}

Status: 200
```

### Get Class Results
```
GET /results/class/:classId
Authorization: Bearer {token}

Response:
{
  "classId": "class_id",
  "results": [ ... ]
}

Status: 200
```

### Calculate GPA
```
GET /results/student/:studentId/gpa
Authorization: Bearer {token}

Response:
{
  "studentId": "student_id",
  "gpa": 3.8,
  "gradePoints": 380,
  "totalCredits": 100,
  "interpretation": "Excellent"
}

Status: 200
```

### Get Result Statistics
```
GET /results/exam/:examId/statistics
Authorization: Bearer {token}

Response:
{
  "examId": "exam_id",
  "totalStudents": 45,
  "passedStudents": 42,
  "failedStudents": 3,
  "averageMarks": 82,
  "highestMarks": 98,
  "lowestMarks": 35,
  "distribution": { ... }
}

Status: 200
```

### Get Top Performers
```
GET /results/class/:classId/top-performers
Authorization: Bearer {token}

Response:
{
  "classId": "class_id",
  "topPerformers": [
    {
      "rank": 1,
      "studentId": "student_id",
      "studentName": "Alice Johnson",
      "gpa": 3.9
    }
  ]
}

Status: 200
```

---

## 8. Attendance Endpoints

### Get All Attendance
```
GET /attendance?page=1&limit=10&classId=&studentId=&date=

Response:
{
  "data": [
    {
      "id": "attendance_id",
      "studentId": "student_id",
      "studentName": "Alice Johnson",
      "classId": "class_id",
      "date": "2024-01-15",
      "status": "present|absent|leave",
      "remarks": "Sick leave"
    }
  ],
  "pagination": { ... }
}

Status: 200
```

### Get Attendance by ID
```
GET /attendance/:id
Authorization: Bearer {token}

Response: { ... }

Status: 200, 404
```

### Mark Attendance
```
POST /attendance
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "studentId": "student_id",
  "date": "2024-01-15",
  "status": "present|absent|leave",
  "remarks": "Optional remarks"
}

Response:
{
  "id": "attendance_id",
  ...
}

Status: 201, 400
```

### Update Attendance
```
PUT /attendance/:id
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "status": "present|absent|leave",
  "remarks": "Updated remarks"
}

Response: { ... }

Status: 200, 400, 404
```

### Delete Attendance
```
DELETE /attendance/:id
Authorization: Bearer {token}

Status: 204, 404
```

### Get Student Attendance
```
GET /attendance/student/:studentId
Authorization: Bearer {token}

Response:
{
  "studentId": "student_id",
  "attendance": [ ... ],
  "summary": {
    "total": 200,
    "present": 185,
    "absent": 15,
    "leave": 0,
    "percentage": 92.5
  }
}

Status: 200
```

### Get Class Attendance
```
GET /attendance/class/:classId?date=

Response:
{
  "classId": "class_id",
  "date": "2024-01-15",
  "attendance": [ ... ]
}

Status: 200
```

### Get Attendance Summary
```
GET /attendance/student/:studentId/summary
Authorization: Bearer {token}

Response:
{
  "studentId": "student_id",
  "totalDays": 200,
  "presentDays": 185,
  "absentDays": 15,
  "leaveDays": 0,
  "percentage": 92.5,
  "trend": "improving"
}

Status: 200
```

### Mark Bulk Attendance
```
POST /attendance/bulk
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "records": [
    {
      "studentId": "student_id_1",
      "date": "2024-01-15",
      "status": "present"
    },
    {
      "studentId": "student_id_2",
      "date": "2024-01-15",
      "status": "absent"
    }
  ]
}

Response:
{
  "message": "Attendance marked for 45 students",
  "successful": 45,
  "failed": 0
}

Status: 201, 400
```

### Generate Attendance Report
```
GET /attendance/report?classId=&month=

Query Parameters:
- classId: required
- month: YYYY-MM format

Response:
{
  "classId": "class_id",
  "month": "2024-01",
  "report": {
    "totalWorkingDays": 22,
    "students": [
      {
        "studentId": "student_id",
        "studentName": "Alice",
        "presentDays": 20,
        "absentDays": 2,
        "percentage": 90.9
      }
    ]
  }
}

Status: 200
```

---

## 9. Parents Endpoints

### Get All Parents
```
GET /parents?page=1&limit=10&search=&relationship=

Response:
{
  "data": [
    {
      "id": "parent_id",
      "firstName": "Robert",
      "lastName": "Johnson",
      "email": "robert@example.com",
      "phoneNumber": "+1234567890",
      "occupation": "Engineer",
      "relationship": "Father|Mother|Guardian",
      "address": "123 Main St"
    }
  ],
  "pagination": { ... }
}

Status: 200
```

### Get Parent by ID
```
GET /parents/:id
Authorization: Bearer {token}

Response: { ... with children }

Status: 200, 404
```

### Create Parent
```
POST /parents
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "firstName": "Robert",
  "lastName": "Johnson",
  "email": "robert@example.com",
  "phoneNumber": "+1234567890",
  "occupation": "Engineer",
  "relationship": "Father",
  "address": "123 Main St"
}

Response:
{
  "id": "new_parent_id",
  ...
}

Status: 201, 400
```

### Update Parent
```
PUT /parents/:id
Authorization: Bearer {token}
Content-Type: application/json

Request: (same as create)

Response: { ... }

Status: 200, 400, 404
```

### Delete Parent
```
DELETE /parents/:id
Authorization: Bearer {token}

Status: 204, 404
```

### Get Parent Children
```
GET /parents/:id/children
Authorization: Bearer {token}

Response:
{
  "parentId": "parent_id",
  "children": [
    {
      "id": "student_id",
      "name": "Alice Johnson",
      "class": "Class A"
    }
  ]
}

Status: 200
```

### Link Parent to Student
```
POST /parents/:id/link-student
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "studentId": "student_id"
}

Response:
{
  "message": "Parent linked to student successfully"
}

Status: 200, 400, 404
```

### Unlink Parent from Student
```
POST /parents/:id/unlink-student
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "studentId": "student_id"
}

Response:
{
  "message": "Parent unlinked from student successfully"
}

Status: 200, 400, 404
```

### Get Parent Student Progress
```
GET /parents/:id/student/:studentId/progress
Authorization: Bearer {token}

Response:
{
  "parentId": "parent_id",
  "studentId": "student_id",
  "studentName": "Alice Johnson",
  "performance": {
    "gpa": 3.8,
    "averageMarks": 85,
    "attendance": 92.5
  },
  "recentResults": [ ... ],
  "recentAttendance": [ ... ]
}

Status: 200
```

### Send Message to Parent
```
POST /parents/:id/message
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "subject": "Academic Performance",
  "message": "Your child is performing well",
  "type": "email|sms|notification"
}

Response:
{
  "message": "Message sent successfully"
}

Status: 200, 400
```

---

## Error Response Format

All endpoints return errors in this format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": "Additional details if available"
  },
  "status": 400
}
```

### Common Status Codes
- `200`: Success
- `201`: Created
- `204`: No Content (Delete)
- `400`: Bad Request
- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `409`: Conflict
- `500`: Server Error

---

## Rate Limiting

- **Rate Limit**: 1000 requests per hour
- **Headers**: 
  - `X-RateLimit-Limit`: 1000
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Reset time (Unix timestamp)

---

## Pagination

All list endpoints support pagination:

```
page: 1 (default)
limit: 10 (default, max 100)

Response includes:
{
  "data": [ ... ],
  "pagination": {
    "total": 100,
    "page": 1,
    "limit": 10,
    "pages": 10
  }
}
```

---

## Sorting & Filtering

Most endpoints support:
- `sort=field:asc|desc`
- `filter[field]=value`
- `search=query`

Example:
```
GET /students?sort=name:asc&filter[classId]=123&search=alice
```

---

**Last Updated**: June 16, 2026
