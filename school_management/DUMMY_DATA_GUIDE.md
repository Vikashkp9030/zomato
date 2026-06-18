# Dummy Data Insertion Guide

**Date:** June 16, 2026  
**File:** `migrations/010_insert_dummy_data.sql`

---

## Overview

A comprehensive SQL script (`010_insert_dummy_data.sql`) has been created to populate all tables with dummy data for testing purposes.

---

## Login Credentials

Use these credentials to test the system:

```
Email: vikash798561@gmail.com
Password: Vikash@123
Role: Admin
```

---

## Data Inserted

### 1. Users (10 records)
- **1 Admin:** vikash798561@gmail.com (test user)
- **1 Principal:** principal@school.com
- **4 Teachers:** Various specializations (Math, English, Science, History)
- **4 Students:** Different classes

All users have the same password hashed: `Vikash@123`

### 2. Classes (8 records)
- Grade 10: Classes 10A, 10B, 10C
- Grade 9: Classes 9A, 9B
- Grade 8: Classes 8A, 8B, 8C
- Each class has capacity 40, teacher assignment, and room number

### 3. Teachers (8 records)
- Specializations: Mathematics, English, Science, History, PE, Computer Science
- Salary ranges: 44,000 - 56,000
- Experience: 5-10 years
- All with contact information

### 4. Subjects (10 records)
- Core subjects: Math, English, Science, Social Studies
- Advanced subjects: Advanced Math, Advanced Science
- Electives: Computer Science, Art, Hindi, PE
- Each with subject code and credits

### 5. Students (40 records)
- Distributed across 8 classes
- 5 students per class
- Various names, emails, phone numbers
- DOB: 2008-2010 (ages 14-18)
- Status: Active
- Enrollment dates: 2022-2024

### 6. Exams (18 records)
- Mid Term exams for all classes
- Final exams for main classes
- Different subjects per exam
- Scheduled dates: July 15-18 (Mid Term), November 20-22 (Final)
- Total marks: 80-100
- Passing marks: 32-40

### 7. Exam Results (145 records)
- Results for all students in all exams
- Marks obtained: 60-84
- Grades: A+, A, B
- Status: Pass (all passing)
- Attempt: 1 (first attempt)

### 8. Attendance (200 records)
- Last 30 days of attendance
- 5 students from Class 10A with 10 records each
- Status variations:
  - Present: ~80%
  - Absent: ~10%
  - Late: ~5%
  - Leave: ~5%
- Includes remarks for absent/late entries

### 9. Parents (50 records)
- Multiple parents per student (2-3 per student)
- Relationships: Father, Mother
- Occupations: Various professions
- Contact information: Email and phone

---

## How to Insert the Data

### Option 1: Using Make Command (Recommended)

If your Makefile has migration support:

```bash
make migrate
```

This will automatically run all migrations including `010_insert_dummy_data.sql`

### Option 2: Using MySQL Client Command

```bash
mysql -u root -p school_management < migrations/010_insert_dummy_data.sql
```

Replace credentials as needed:
- `-u root` → your MySQL username
- `-p` → prompts for password
- `school_management` → your database name

### Option 3: Manual Execution via MySQL CLI

```bash
# Login to MySQL
mysql -u root -p

# Select database
USE school_management;

# Run the script
SOURCE migrations/010_insert_dummy_data.sql;
```

### Option 4: Using Docker

If using Docker Compose:

```bash
# Enter MySQL container
docker-compose exec mysql mysql -u root -ppassword school_management < migrations/010_insert_dummy_data.sql

# Or
docker exec school-management-mysql mysql -u root -ppassword school_management < migrations/010_insert_dummy_data.sql
```

---

## Verification

After inserting the dummy data, verify with these queries:

### Count Records in Each Table

```sql
SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'classes', COUNT(*) FROM classes
UNION ALL
SELECT 'teachers', COUNT(*) FROM teachers
UNION ALL
SELECT 'subjects', COUNT(*) FROM subjects
UNION ALL
SELECT 'students', COUNT(*) FROM students
UNION ALL
SELECT 'exams', COUNT(*) FROM exams
UNION ALL
SELECT 'exam_results', COUNT(*) FROM exam_results
UNION ALL
SELECT 'attendance', COUNT(*) FROM attendance
UNION ALL
SELECT 'parents', COUNT(*) FROM parents;
```

**Expected Results:**
```
users:          10
classes:         8
teachers:        8
subjects:       10
students:       40
exams:          18
exam_results:  145
attendance:    200
parents:        50
```

### Verify Admin User

```sql
SELECT id, email, role, status FROM users WHERE email = 'vikash798561@gmail.com';
```

**Expected Output:**
```
id: 1
email: vikash798561@gmail.com
role: admin
status: active
```

### Check Student-Class Distribution

```sql
SELECT c.class_name, COUNT(s.id) as student_count
FROM classes c
LEFT JOIN students s ON c.id = s.class_id
GROUP BY c.class_name
ORDER BY c.grade_level, c.section;
```

**Expected Output:** Each class should have 5 students (except possibly some with 0)

### View Exam Schedule

```sql
SELECT e.exam_name, e.exam_date, e.exam_type, s.subject_name, c.class_name
FROM exams e
JOIN subjects s ON e.subject_id = s.id
JOIN classes c ON e.class_id = c.id
ORDER BY e.exam_date;
```

### Check Attendance Summary

```sql
SELECT 
    CONCAT(st.first_name, ' ', st.last_name) as student_name,
    COUNT(*) as total_days,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) as present,
    SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) as absent,
    ROUND(SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as percentage
FROM attendance a
JOIN students st ON a.student_id = st.id
GROUP BY a.student_id;
```

---

## Testing the API with Dummy Data

### 1. Login with Test Credentials

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "vikash798561@gmail.com",
    "password": "Vikash@123"
  }'
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "id": 1,
      "email": "vikash798561@gmail.com",
      "first_name": "Vikash",
      "last_name": "Kumar",
      "role": "admin"
    }
  }
}
```

### 2. Get All Classes

```bash
curl -X GET http://localhost:8080/api/v1/classes \
  -H "Authorization: Bearer {ACCESS_TOKEN}"
```

Should return 8 classes with their details.

### 3. Get Students in a Class

```bash
curl -X GET http://localhost:8080/api/v1/classes/1/students \
  -H "Authorization: Bearer {ACCESS_TOKEN}"
```

Should return 5 students in Class 10A.

### 4. Get All Teachers

```bash
curl -X GET http://localhost:8080/api/v1/teachers \
  -H "Authorization: Bearer {ACCESS_TOKEN}"
```

Should return 8 teachers with their specializations.

### 5. Get Exam Results

```bash
curl -X GET http://localhost:8080/api/v1/exams/1/results \
  -H "Authorization: Bearer {ACCESS_TOKEN}"
```

Should return exam results for the first exam.

### 6. Get Exam Statistics

```bash
curl -X GET http://localhost:8080/api/v1/exams/1/results/stats \
  -H "Authorization: Bearer {ACCESS_TOKEN}"
```

Should return statistics including average marks, pass percentage, etc.

### 7. Get Student Attendance

```bash
curl -X GET http://localhost:8080/api/v1/students/1/attendance \
  -H "Authorization: Bearer {ACCESS_TOKEN}"
```

Should return attendance records for the student.

### 8. Get Student Parents

```bash
curl -X GET http://localhost:8080/api/v1/students/1/parents \
  -H "Authorization: Bearer {ACCESS_TOKEN}"
```

Should return parent records for the student.

---

## Data Distribution Summary

### By Class
| Class | Grade | Section | Students | Capacity |
|-------|-------|---------|----------|----------|
| 10A   | 10    | A       | 5        | 40       |
| 10B   | 10    | B       | 5        | 40       |
| 10C   | 10    | C       | 5        | 40       |
| 9A    | 9     | A       | 5        | 40       |
| 9B    | 9     | B       | 5        | 40       |
| 8A    | 8     | A       | 5        | 40       |
| 8B    | 8     | B       | 5        | 40       |
| 8C    | 8     | C       | 5        | 40       |

### By User Role
- Admin: 2 (including vikash798561@gmail.com)
- Teachers: 4
- Students: 4
- Total: 10

### By Subject
- Core: Mathematics, English, Science, Social Studies
- Advanced: Advanced Math, Advanced Science
- Electives: Computer Science, Art, Hindi, PE

---

## Modifying Dummy Data

If you need to customize the data:

1. Open `migrations/010_insert_dummy_data.sql`
2. Edit the INSERT statements
3. Re-run the migration (may need to drop tables first)

### Common Modifications

**Change Login Email:**
```sql
-- Find and replace
'vikash798561@gmail.com' → 'your-email@example.com'
```

**Change Capacity:**
```sql
-- Find capacity values and update
capacity: 40 → capacity: 50
```

**Add More Students:**
```sql
-- Copy an existing student INSERT and modify
INSERT INTO students (first_name, last_name, email, ...) VALUES (...)
```

---

## Resetting Dummy Data

If you need to clear and re-insert:

### Option 1: Drop and Re-create Tables

```sql
-- Drop tables in reverse order
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS parents;
DROP TABLE IF EXISTS exam_results;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS users;

-- Then run migrations again
SOURCE migrations/001_create_users_table.sql;
SOURCE migrations/002_create_students_table.sql;
SOURCE migrations/003_create_exams_table.sql;
SOURCE migrations/004_create_attendance_table.sql;
SOURCE migrations/005_create_classes_table.sql;
SOURCE migrations/006_create_teachers_table.sql;
SOURCE migrations/007_create_subjects_table.sql;
SOURCE migrations/008_create_exam_results_table.sql;
SOURCE migrations/009_create_parents_table.sql;
SOURCE migrations/010_insert_dummy_data.sql;
```

### Option 2: Clear Tables and Re-insert

```sql
-- Delete all data (preserves structure)
TRUNCATE TABLE attendance;
TRUNCATE TABLE parents;
TRUNCATE TABLE exam_results;
TRUNCATE TABLE exams;
TRUNCATE TABLE students;
TRUNCATE TABLE subjects;
TRUNCATE TABLE teachers;
TRUNCATE TABLE classes;
TRUNCATE TABLE users;

-- Re-insert data
SOURCE migrations/010_insert_dummy_data.sql;
```

---

## Testing Scenarios

### Scenario 1: Check Student Performance
```sql
SELECT 
    st.first_name, 
    AVG(er.marks_obtained) as avg_marks,
    COUNT(er.id) as exams_taken
FROM exam_results er
JOIN students st ON er.student_id = st.id
GROUP BY er.student_id;
```

### Scenario 2: Class-wise Results
```sql
SELECT 
    c.class_name,
    COUNT(DISTINCT st.id) as student_count,
    AVG(er.marks_obtained) as avg_marks,
    MIN(er.marks_obtained) as lowest_marks,
    MAX(er.marks_obtained) as highest_marks
FROM students st
JOIN classes c ON st.class_id = c.id
LEFT JOIN exam_results er ON st.id = er.student_id
GROUP BY c.id;
```

### Scenario 3: Teacher Workload
```sql
SELECT 
    CONCAT(t.first_name, ' ', t.last_name) as teacher_name,
    t.specialization,
    COUNT(DISTINCT c.id) as classes_assigned,
    COUNT(DISTINCT s.id) as students
FROM teachers t
LEFT JOIN classes c ON t.id = c.class_teacher_id
LEFT JOIN students s ON c.id = s.class_id
GROUP BY t.id;
```

---

## Notes

- All passwords are hashed using bcrypt with cost 10
- Timestamps use current date/time (NOW())
- Attendance data includes last 30 days
- Exam results include realistic marks and grades
- Data is consistent across all tables (proper foreign keys)

---

## Support

For issues with data insertion:
1. Ensure all migrations (001-009) have been run first
2. Check that tables exist: `SHOW TABLES;`
3. Verify MySQL user has INSERT permissions
4. Check for foreign key constraint errors in logs

---

**Dummy Data Setup Complete!**

You can now:
- ✅ Login with: vikash798561@gmail.com / Vikash@123
- ✅ Test all endpoints with realistic data
- ✅ Verify relationships and queries
- ✅ Practice with the full system

Enjoy testing! 🚀
