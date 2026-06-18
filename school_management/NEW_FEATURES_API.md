# New Features API Documentation

**Generated:** June 16, 2026  
**Last Updated:** June 16, 2026

---

## Table of Contents

1. [Class Management API](#class-management-api)
2. [Teacher Management API](#teacher-management-api)
3. [Subject Management API](#subject-management-api)
4. [Exam Results API](#exam-results-api)
5. [Parent/Guardian Management API](#parentguardian-management-api)
6. [Quick Reference](#quick-reference)

---

## Class Management API

Manage school classes/sections with capacity tracking and grade levels.

### Create Class
```
POST /api/v1/classes
```

**Request Body:**
```json
{
  "class_name": "10A",
  "grade_level": 10,
  "section": "A",
  "capacity": 40,
  "class_teacher_id": 1,
  "room_number": "101"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Class created successfully",
  "data": {
    "id": 1,
    "class_name": "10A",
    "grade_level": 10,
    "section": "A",
    "capacity": 40,
    "class_teacher_id": 1,
    "room_number": "101",
    "created_at": "2026-06-16T10:00:00Z",
    "updated_at": "2026-06-16T10:00:00Z"
  }
}
```

### Get All Classes
```
GET /api/v1/classes?page=1&limit=10
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Classes retrieved successfully",
  "data": {
    "data": [...],
    "total": 25,
    "page": 1,
    "limit": 10,
    "totalPages": 3
  }
}
```

### Get Class by ID
```
GET /api/v1/classes/{id}
```

### Get Class Info (with capacity details)
```
GET /api/v1/classes/{id}/info
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Class information retrieved",
  "data": {
    "class": {...},
    "studentCount": 35,
    "availableSeats": 5
  }
}
```

### Get Classes by Grade Level
```
GET /api/v1/grade-levels/{grade_level}/classes
```

### Update Class
```
PUT /api/v1/classes/{id}
```

### Delete Class
```
DELETE /api/v1/classes/{id}
```

---

## Teacher Management API

Manage teacher records, assignments, and specializations.

### Create Teacher
```
POST /api/v1/teachers
```

**Request Body:**
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@school.com",
  "phone": "9876543210",
  "hire_date": "2020-01-15",
  "specialization": "Mathematics",
  "salary": 50000.00,
  "experience_years": 5
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Teacher created successfully",
  "data": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "email": "john.doe@school.com",
    "phone": "9876543210",
    "hire_date": "2020-01-15T00:00:00Z",
    "specialization": "Mathematics",
    "salary": 50000.00,
    "experience_years": 5,
    "created_at": "2026-06-16T10:00:00Z",
    "updated_at": "2026-06-16T10:00:00Z"
  }
}
```

### Get All Teachers
```
GET /api/v1/teachers?page=1&limit=10
```

### Get Teacher by ID
```
GET /api/v1/teachers/{id}
```

### Get Teachers by Specialization
```
GET /api/v1/teachers/specialization?specialization=Mathematics
```

### Get Assigned Classes
```
GET /api/v1/teachers/{id}/classes
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Assigned classes retrieved successfully",
  "data": {
    "teacher_id": 1,
    "classes": [...],
    "count": 3
  }
}
```

### Update Teacher
```
PUT /api/v1/teachers/{id}
```

### Delete Teacher
```
DELETE /api/v1/teachers/{id}
```

---

## Subject Management API

Manage academic subjects with codes and credit hours.

### Create Subject
```
POST /api/v1/subjects
```

**Request Body:**
```json
{
  "subject_name": "Advanced Mathematics",
  "subject_code": "MATH301",
  "credits": 4,
  "description": "Advanced calculus and analytical geometry"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Subject created successfully",
  "data": {
    "id": 1,
    "subject_name": "Advanced Mathematics",
    "subject_code": "MATH301",
    "credits": 4,
    "description": "Advanced calculus and analytical geometry",
    "created_at": "2026-06-16T10:00:00Z",
    "updated_at": "2026-06-16T10:00:00Z"
  }
}
```

### Get All Subjects
```
GET /api/v1/subjects?page=1&limit=10
```

### Get Subject by ID
```
GET /api/v1/subjects/{id}
```

### Get Subject by Code
```
GET /api/v1/subjects/code/{code}
```

### Search Subjects
```
GET /api/v1/subjects/search?q=mathematics
```

### Update Subject
```
PUT /api/v1/subjects/{id}
```

### Delete Subject
```
DELETE /api/v1/subjects/{id}
```

---

## Exam Results API

Track exam results, grades, and student performance metrics.

### Create Exam Result
```
POST /api/v1/exam-results
```

**Request Body:**
```json
{
  "exam_id": 5,
  "student_id": 10,
  "marks_obtained": 85.5,
  "grade": "A",
  "status": "pass",
  "attempt": 1
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Exam result created successfully",
  "data": {
    "id": 1,
    "exam_id": 5,
    "student_id": 10,
    "marks_obtained": 85.5,
    "grade": "A",
    "status": "pass",
    "attempt": 1,
    "created_at": "2026-06-16T10:00:00Z",
    "updated_at": "2026-06-16T10:00:00Z"
  }
}
```

### Get Exam Result by ID
```
GET /api/v1/exam-results/{id}
```

### Get Results for an Exam
```
GET /api/v1/exams/{exam_id}/results?page=1&limit=10
```

### Get Exam Statistics
```
GET /api/v1/exams/{exam_id}/results/stats
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Exam statistics retrieved successfully",
  "data": {
    "total_results": 50,
    "average_marks": 72.5,
    "highest_marks": 98.0,
    "lowest_marks": 35.0,
    "passed": 45,
    "failed": 5,
    "pass_percentage": 90
  }
}
```

### Get Student Results
```
GET /api/v1/students/{student_id}/results?page=1&limit=10
```

### Get Student GPA
```
GET /api/v1/students/{student_id}/gpa
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Student GPA retrieved successfully",
  "data": {
    "student_id": 10,
    "gpa": 3.8
  }
}
```

### Get Specific Student Exam Result
```
GET /api/v1/exams/{exam_id}/students/{student_id}/result
```

### Update Exam Result
```
PUT /api/v1/exam-results/{id}
```

### Delete Exam Result
```
DELETE /api/v1/exam-results/{id}
```

---

## Parent/Guardian Management API

Manage parent and guardian information for students.

### Create Parent Record
```
POST /api/v1/parents
```

**Request Body:**
```json
{
  "student_id": 10,
  "parent_name": "Mr. Smith",
  "relationship": "Father",
  "phone": "9876543210",
  "email": "smith@email.com",
  "occupation": "Engineer"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Parent record created successfully",
  "data": {
    "id": 1,
    "student_id": 10,
    "parent_name": "Mr. Smith",
    "relationship": "Father",
    "phone": "9876543210",
    "email": "smith@email.com",
    "occupation": "Engineer",
    "created_at": "2026-06-16T10:00:00Z",
    "updated_at": "2026-06-16T10:00:00Z"
  }
}
```

### Get All Parents
```
GET /api/v1/parents?page=1&limit=10
```

### Get Parent by ID
```
GET /api/v1/parents/{id}
```

### Get Parents of a Student
```
GET /api/v1/students/{student_id}/parents
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Parent records retrieved successfully",
  "data": {
    "student_id": 10,
    "parents": [...],
    "count": 2
  }
}
```

### Get Parents by Email
```
GET /api/v1/parents/email?email=smith@email.com
```

### Get Parents by Phone
```
GET /api/v1/parents/phone?phone=9876543210
```

### Update Parent Record
```
PUT /api/v1/parents/{id}
```

### Delete Parent Record
```
DELETE /api/v1/parents/{id}
```

---

## Quick Reference

### All New Endpoints Summary

#### Classes (7 endpoints)
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/classes` | Create class |
| GET | `/classes` | List all classes |
| GET | `/classes/{id}` | Get class details |
| GET | `/classes/{id}/info` | Get class info with capacity |
| GET | `/grade-levels/{grade_level}/classes` | Get classes by grade |
| PUT | `/classes/{id}` | Update class |
| DELETE | `/classes/{id}` | Delete class |

#### Teachers (7 endpoints)
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/teachers` | Create teacher |
| GET | `/teachers` | List all teachers |
| GET | `/teachers/{id}` | Get teacher details |
| GET | `/teachers/specialization` | Filter by specialization |
| GET | `/teachers/{id}/classes` | Get assigned classes |
| PUT | `/teachers/{id}` | Update teacher |
| DELETE | `/teachers/{id}` | Delete teacher |

#### Subjects (7 endpoints)
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/subjects` | Create subject |
| GET | `/subjects` | List all subjects |
| GET | `/subjects/{id}` | Get subject details |
| GET | `/subjects/code/{code}` | Get by subject code |
| GET | `/subjects/search` | Search subjects |
| PUT | `/subjects/{id}` | Update subject |
| DELETE | `/subjects/{id}` | Delete subject |

#### Exam Results (9 endpoints)
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/exam-results` | Create result |
| GET | `/exam-results/{id}` | Get result details |
| GET | `/exams/{exam_id}/results` | Get results for exam |
| GET | `/exams/{exam_id}/results/stats` | Get exam statistics |
| GET | `/students/{student_id}/results` | Get student's results |
| GET | `/students/{student_id}/gpa` | Get student GPA |
| GET | `/exams/{exam_id}/students/{student_id}/result` | Get specific result |
| PUT | `/exam-results/{id}` | Update result |
| DELETE | `/exam-results/{id}` | Delete result |

#### Parents (8 endpoints)
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/parents` | Create parent record |
| GET | `/parents` | List all parents |
| GET | `/parents/{id}` | Get parent details |
| GET | `/students/{student_id}/parents` | Get student's parents |
| GET | `/parents/email` | Find by email |
| GET | `/parents/phone` | Find by phone |
| PUT | `/parents/{id}` | Update parent |
| DELETE | `/parents/{id}` | Delete parent |

### Total New Endpoints: 38

---

## Database Migrations

All new tables have been created with proper indexes and foreign key constraints:

### 005_create_classes_table.sql
- Tables created with grade_level and section uniqueness constraint
- Index on grade_level and class_teacher_id

### 006_create_teachers_table.sql
- Unique constraint on email
- Indexes on specialization and hire_date

### 007_create_subjects_table.sql
- Unique constraint on subject_code
- Indexes on subject_code and subject_name

### 008_create_exam_results_table.sql
- Unique composite constraint on (exam_id, student_id, attempt)
- Indexes on exam_id, student_id, and status
- Foreign keys with CASCADE delete

### 009_create_parents_table.sql
- Indexes on student_id, email, and phone
- Foreign key with CASCADE delete

---

## Error Responses

All endpoints return standardized error responses:

```json
{
  "success": false,
  "message": "Error message",
  "error": "Detailed error information"
}
```

### HTTP Status Codes
- **200** - OK
- **201** - Created
- **400** - Bad Request
- **401** - Unauthorized
- **404** - Not Found
- **409** - Conflict (duplicate data)
- **500** - Internal Server Error

---

## Usage Examples

### Create a Complete Class Setup

1. **Create a Class:**
```bash
curl -X POST http://localhost:8080/api/v1/classes \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "class_name": "10A",
    "grade_level": 10,
    "section": "A",
    "capacity": 40,
    "class_teacher_id": 1,
    "room_number": "101"
  }'
```

2. **Get Classes for a Grade Level:**
```bash
curl -X GET http://localhost:8080/api/v1/grade-levels/10/classes \
  -H "Authorization: Bearer YOUR_TOKEN"
```

3. **Get Class Info with Capacity:**
```bash
curl -X GET http://localhost:8080/api/v1/classes/1/info \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Track Student Results

1. **Create Exam Result:**
```bash
curl -X POST http://localhost:8080/api/v1/exam-results \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "exam_id": 5,
    "student_id": 10,
    "marks_obtained": 85.5,
    "grade": "A",
    "status": "pass",
    "attempt": 1
  }'
```

2. **Get Exam Statistics:**
```bash
curl -X GET http://localhost:8080/api/v1/exams/5/results/stats \
  -H "Authorization: Bearer YOUR_TOKEN"
```

3. **Get Student GPA:**
```bash
curl -X GET http://localhost:8080/api/v1/students/10/gpa \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## Notes

- All endpoints require JWT authentication (except `/auth` routes)
- Pagination is supported with `?page=X&limit=Y` parameters
- Default limit is 10, maximum limit is 100
- All timestamps are in UTC format (ISO 8601)
- Empty lists return empty arrays, not null values

---

## Next Steps

Consider implementing these additional features:

1. **Fee Management** - Track tuition fees and payments
2. **Library System** - Book catalog and borrowing records
3. **Lab Management** - Lab schedules and equipment
4. **Campus Information** - Buildings and departments
5. **Notifications** - Email/SMS alerts for parents and teachers

---

**End of Documentation**
