# Quick Reference - New Features

**For detailed information, see:** `NEW_FEATURES_API.md`, `MIGRATION_GUIDE.md`, `IMPLEMENTATION_SUMMARY.md`

---

## 🚀 Quick Start

### 1. Run Migrations
```bash
make migrate
```

### 2. Start Server
```bash
make run
```

### 3. Test Endpoints
```bash
# Authenticate first
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'

# Use the token for all new features (add Authorization: Bearer {token})
```

---

## 📚 Complete Endpoint List (38 Total)

### Classes (7 endpoints)
```
POST   /api/v1/classes
GET    /api/v1/classes
GET    /api/v1/classes/{id}
GET    /api/v1/classes/{id}/info
GET    /api/v1/grade-levels/{grade_level}/classes
PUT    /api/v1/classes/{id}
DELETE /api/v1/classes/{id}
```

### Teachers (7 endpoints)
```
POST   /api/v1/teachers
GET    /api/v1/teachers
GET    /api/v1/teachers/{id}
GET    /api/v1/teachers/specialization?specialization=Math
GET    /api/v1/teachers/{id}/classes
PUT    /api/v1/teachers/{id}
DELETE /api/v1/teachers/{id}
```

### Subjects (7 endpoints)
```
POST   /api/v1/subjects
GET    /api/v1/subjects
GET    /api/v1/subjects/{id}
GET    /api/v1/subjects/code/{code}
GET    /api/v1/subjects/search?q=math
PUT    /api/v1/subjects/{id}
DELETE /api/v1/subjects/{id}
```

### Exam Results (9 endpoints)
```
POST   /api/v1/exam-results
GET    /api/v1/exam-results/{id}
GET    /api/v1/exams/{exam_id}/results
GET    /api/v1/exams/{exam_id}/results/stats
GET    /api/v1/students/{student_id}/results
GET    /api/v1/students/{student_id}/gpa
GET    /api/v1/exams/{exam_id}/students/{student_id}/result
PUT    /api/v1/exam-results/{id}
DELETE /api/v1/exam-results/{id}
```

### Parents (8 endpoints)
```
POST   /api/v1/parents
GET    /api/v1/parents
GET    /api/v1/parents/{id}
GET    /api/v1/students/{student_id}/parents
GET    /api/v1/parents/email?email=...
GET    /api/v1/parents/phone?phone=...
PUT    /api/v1/parents/{id}
DELETE /api/v1/parents/{id}
```

---

## 💾 Database Tables (5 New)

| Table | Purpose | Key Feature |
|-------|---------|------------|
| classes | School classes/sections | Unique (grade_level, section) |
| teachers | Teacher information | Email unique, specialization index |
| subjects | Academic subjects | Subject code unique, searchable |
| exam_results | Student exam results | GPA calculation, pass/fail tracking |
| parents | Parent/guardian info | Multiple per student, searchable |

---

## 📋 Common Operations

### Create a Class
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

### Create a Teacher
```bash
curl -X POST http://localhost:8080/api/v1/teachers \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@school.com",
    "phone": "9876543210",
    "hire_date": "2020-01-15",
    "specialization": "Mathematics",
    "salary": 50000,
    "experience_years": 5
  }'
```

### Add Exam Result
```bash
curl -X POST http://localhost:8080/api/v1/exam-results \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "exam_id": 1,
    "student_id": 5,
    "marks_obtained": 85.5,
    "grade": "A",
    "status": "pass",
    "attempt": 1
  }'
```

### Get Student GPA
```bash
curl -X GET http://localhost:8080/api/v1/students/5/gpa \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Get Exam Statistics
```bash
curl -X GET http://localhost:8080/api/v1/exams/1/results/stats \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 🔑 Data Relationships

```
User (teacher)
  ↓ (class_teacher_id)
Class
  ↓
Student
  ├→ Parent (multiple)
  └→ Exam Result
      ├→ Exam
      │  ├→ Subject
      │  └→ Class
      └→ Student
```

---

## ✅ Validation Rules

### Classes
- ✅ Unique (grade_level, section)
- ✅ Capacity 1-100
- ✅ Grade level 1-12

### Teachers
- ✅ Unique email
- ✅ Required: name, email, phone, specialization
- ✅ Experience years ≥ 0

### Subjects
- ✅ Unique subject_code
- ✅ Credits 1-10
- ✅ Required: name, code

### Exam Results
- ✅ Marks 0-100
- ✅ Status: 'pass' or 'fail'
- ✅ Unique (exam_id, student_id, attempt)

### Parents
- ✅ Required: student_id, name, relationship, phone
- ✅ Email optional but indexed
- ✅ Multiple per student allowed

---

## 🧪 Testing with Postman

1. Import the updated `postman_collection.json`
2. Set environment variable: `base_url = http://localhost:8080`
3. Authenticate with `/auth/login` to get token
4. Use the token in all new feature requests

---

## 🐛 Troubleshooting

### Foreign Key Error
- Ensure `users` table exists for class_teacher_id
- Ensure `students` table exists for exam_results

### Table Not Found
- Check all migrations ran: `SHOW TABLES;` in MySQL
- Verify no migration errors in logs

### Validation Error
- Check request body matches schema
- Ensure all required fields are present
- Validate data types (strings vs numbers)

---

## 📊 Performance Tips

### Optimize Queries
- Use pagination: `?page=1&limit=10`
- Filter by date ranges when possible
- Use indexes on grade_level, specialization, email

### Batch Operations
- Insert multiple records in transactions
- Use bulk update for class changes

---

## 🔐 Security Notes

- All endpoints require JWT authentication
- Input validation on all fields
- SQL injection prevented with parameterized queries
- Proper error handling without sensitive data exposure

---

## 📞 File Structure

```
school_management/
├── internal/
│   ├── handler/
│   │   ├── class_handler.go         ✨ NEW
│   │   ├── teacher_handler.go       ✨ NEW
│   │   ├── subject_handler.go       ✨ NEW
│   │   ├── exam_result_handler.go   ✨ NEW
│   │   └── parent_handler.go        ✨ NEW
│   └── repository/
│       ├── class_repo.go            ✨ NEW
│       ├── teacher_repo.go          ✨ NEW
│       ├── subject_repo.go          ✨ NEW
│       ├── exam_result_repo.go      ✨ NEW
│       └── parent_repo.go           ✨ NEW
├── migrations/
│   ├── 005_create_classes_table.sql       ✨ NEW
│   ├── 006_create_teachers_table.sql      ✨ NEW
│   ├── 007_create_subjects_table.sql      ✨ NEW
│   ├── 008_create_exam_results_table.sql  ✨ NEW
│   └── 009_create_parents_table.sql       ✨ NEW
├── NEW_FEATURES_API.md             ✨ NEW (detailed API docs)
├── MIGRATION_GUIDE.md              ✨ NEW (migration instructions)
├── IMPLEMENTATION_SUMMARY.md       ✨ NEW (summary & checklist)
└── QUICK_REFERENCE_NEW_FEATURES.md ✨ NEW (this file)
```

---

## 📌 What's NOT Implemented Yet

Still to come:
- [ ] Fee Management
- [ ] Library System
- [ ] Lab Management
- [ ] Campus Information
- [ ] Notification System
- [ ] Advanced Analytics

---

## 🚀 Next Steps

1. ✅ Run migrations
2. ✅ Test all endpoints
3. ✅ Update Postman collection
4. ✅ Review API documentation
5. ✅ Plan implementation of remaining features

---

## 📖 Documentation Links

- **Full API Docs:** `NEW_FEATURES_API.md`
- **Migration Help:** `MIGRATION_GUIDE.md`
- **Implementation Details:** `IMPLEMENTATION_SUMMARY.md`
- **Feature Status:** `FEATURES_STATUS.md`
- **Project Overview:** `PROJECT_SUMMARY.md`

---

**Version:** 1.0  
**Last Updated:** June 16, 2026  
**Status:** ✅ Complete & Ready for Testing
