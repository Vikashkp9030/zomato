# Dummy Data Quick Reference

**One-page cheat sheet for dummy data**

---

## 🔐 Login Credentials

```
Email:    vikash798561@gmail.com
Password: Vikash@123
Role:     Admin
```

---

## 📊 Data Summary

| Entity | Count | Details |
|--------|-------|---------|
| Users | 10 | 1 admin, 1 principal, 4 teachers, 4 students |
| Classes | 8 | Grades 8, 9, 10 with sections A, B, C |
| Teachers | 8 | Multiple specializations |
| Subjects | 10 | Core, advanced, and electives |
| Students | 40 | 5 per class, ages 14-18 |
| Exams | 18 | Mid-term and final exams |
| Exam Results | 145 | All students with grades A+, A, B |
| Attendance | 200 | Last 30 days (present, absent, late, leave) |
| Parents | 50 | 2-3 parents per student |

---

## 🎓 Class Distribution

```
Grade 10:  10A (5 students), 10B (5), 10C (5)
Grade 9:   9A (5 students), 9B (5)
Grade 8:   8A (5 students), 8B (5), 8C (5)
Total:     40 students
```

---

## 👨‍🏫 Teachers

| ID | Name | Specialization | Salary | Experience |
|----|------|-----------------|--------|------------|
| 1 | Rajesh Singh | Mathematics | 50,000 | 8 years |
| 2 | Priya Patel | English | 48,000 | 7 years |
| 3 | Amit Kumar | Science | 52,000 | 6 years |
| 4 | Neha Verma | History | 46,000 | 5 years |
| 5 | Vikram Malhotra | Mathematics | 54,000 | 10 years |
| 6 | Ritu Sharma | Science | 50,000 | 7 years |
| 7 | Sanjay Reddy | Physical Education | 44,000 | 6 years |
| 8 | Anjali Nair | Computer Science | 56,000 | 5 years |

---

## 📚 Subjects

| Code | Subject | Credits |
|------|---------|---------|
| MATH101 | Mathematics | 4 |
| ENG101 | English | 4 |
| SCI101 | Science | 4 |
| SOC101 | Social Studies | 3 |
| CS101 | Computer Science | 4 |
| PE101 | Physical Education | 2 |
| ART101 | Art and Craft | 2 |
| HIN101 | Hindi | 3 |
| SCI201 | Science (Advanced) | 4 |
| MATH201 | Mathematics (Advanced) | 4 |

---

## 📅 Exam Schedule

### Mid-Term Exams
- **July 15:** Mathematics (9:00 AM) - 80 marks
- **July 16:** English (10:30 AM) - 80 marks
- **July 17:** Science (2:00 PM) - 80 marks
- **July 18:** Social Studies (10:30 AM) - 80 marks

### Final Exams
- **November 20:** Mathematics (9:00 AM) - 100 marks
- **November 21:** English (10:30 AM) - 100 marks
- **November 22:** Science (2:00 PM) - 100 marks

---

## 👥 Sample Users

### Admin (Test Account)
- Email: `vikash798561@gmail.com`
- Password: `Vikash@123`
- Role: Admin

### Other Users
- principal@school.com (Admin)
- teacher1@school.com (Teacher - Math)
- teacher2@school.com (Teacher - English)
- teacher3@school.com (Teacher - Science)
- teacher4@school.com (Teacher - History)
- student1@school.com (Student)
- student2@school.com (Student)
- student3@school.com (Student)
- student4@school.com (Student)

**All passwords:** `Vikash@123`

---

## 📋 Sample Student Data

**Student 1: Rahul Singh**
- ID: 1
- Class: 10A
- Email: rahul.singh@student.com
- Phone: 9999111111
- DOB: 2008-05-15
- Parents: Mr. Singh (Engineer), Mrs. Singh (Teacher)

**Student 2: Anjali Gupta**
- ID: 2
- Class: 10A
- Email: anjali.gupta@student.com
- Phone: 9999111112
- DOB: 2008-07-22
- Parents: Mr. Gupta (Doctor), Mrs. Gupta (Business)

---

## 📊 Exam Results

### Sample Marks Distribution
```
Marks Range: 60-84
Grades:      A+ (80+), A (70-79), B (60-69)
Status:      All passing
Attempts:    1 (first attempt)
```

### Sample Average by Subject
- Mathematics: 72-75 average
- English: 68-74 average
- Science: 70-79 average

---

## 📝 Attendance Statistics

### Last 30 Days
- **Present:** ~80% of students
- **Absent:** ~10% (with reasons like Sick, Medical)
- **Late:** ~5% (with reasons like Traffic)
- **Leave:** ~5% (with reasons like Family Event)

### Sample: Student 1 (Rahul Singh)
- Total Days: 10 recorded
- Present: 8 days
- Absent: 1 day (Sick)
- Late: 1 day (Traffic)
- **Attendance %:** 80%

---

## 👨‍👩‍👧 Parent Data

Each student has 2-3 parents registered:

**Example: Student 1 (Rahul Singh)**
- Father: Mr. Singh, Engineer, 9876543220
- Mother: Mrs. Singh, Teacher, 9876543221

**Parent Occupations (Sample)**
- Engineer, Doctor, Teacher, Business Owner, Accountant
- Software Developer, Consultant, Manager, Architect
- Lawyer, Designer, Banker, HR Manager, Entrepreneur

---

## 🔗 Relationships

### Student → Class
```
All 40 students assigned to 8 classes (5 per class)
```

### Class → Teacher
```
Each class has a class teacher assigned
10A → Rajesh Singh (ID: 1)
10B → Priya Patel (ID: 2)
10C → Amit Kumar (ID: 3)
```

### Exam → Subject → Class
```
Exams created for specific subjects and classes
Math exam → Math subject → Class 10A
```

### Student → Exam Results
```
All 40 students have exam results
Total 145 results across 18 exams
```

### Student → Attendance
```
Class 10A students: 10 records each (200 total for 20 sampled)
Status mix: present, absent, late, leave
```

### Student → Parents
```
Each student has 2-3 parent records
Total 50 parent records for 40 students
```

---

## 🧪 Quick Tests

### List All Classes
```bash
curl -X GET http://localhost:8080/api/v1/classes \
  -H "Authorization: Bearer {TOKEN}"
```
**Expected:** 8 classes returned

### Get Class 10A Students
```bash
curl -X GET http://localhost:8080/api/v1/classes/1/students \
  -H "Authorization: Bearer {TOKEN}"
```
**Expected:** 5 students in Class 10A

### Get Exam Results for Exam 1
```bash
curl -X GET http://localhost:8080/api/v1/exams/1/results \
  -H "Authorization: Bearer {TOKEN}"
```
**Expected:** Results for all students in that exam

### Get Student 1 Attendance
```bash
curl -X GET http://localhost:8080/api/v1/students/1/attendance \
  -H "Authorization: Bearer {TOKEN}"
```
**Expected:** 10 attendance records for last 30 days

### Get Student 1 Parents
```bash
curl -X GET http://localhost:8080/api/v1/students/1/parents \
  -H "Authorization: Bearer {TOKEN}"
```
**Expected:** 2 parent records

---

## 🔄 Data Consistency

✅ All foreign key relationships validated
✅ Email uniqueness enforced
✅ Class capacity realistic
✅ Marks within expected ranges
✅ Attendance dates in past 30 days
✅ Phone numbers properly formatted
✅ All timestamps current

---

## 📋 Insert Instructions

### Option 1 (Recommended)
```bash
make migrate
```

### Option 2
```bash
mysql -u root -p school_management < migrations/010_insert_dummy_data.sql
```

### Option 3 (Manual)
```bash
mysql -u root -p
USE school_management;
SOURCE migrations/010_insert_dummy_data.sql;
```

---

## ✅ Verification Queries

```sql
-- Count records
SELECT 'users', COUNT(*) FROM users UNION ALL
SELECT 'classes', COUNT(*) FROM classes UNION ALL
SELECT 'teachers', COUNT(*) FROM teachers;

-- Check admin user
SELECT * FROM users WHERE email = 'vikash798561@gmail.com';

-- Check class distribution
SELECT c.class_name, COUNT(s.id) as students FROM classes c
LEFT JOIN students s ON c.id = s.class_id GROUP BY c.id;

-- Check exam results
SELECT COUNT(*) as total_results FROM exam_results;

-- Check attendance
SELECT COUNT(*) as total_records FROM attendance;
```

---

## 🎯 Ready to Use!

All data is properly structured and related. You can:
- ✅ Test all CRUD operations
- ✅ Verify relationships
- ✅ Check pagination
- ✅ Filter and search
- ✅ Generate reports

**Login:** vikash798561@gmail.com / Vikash@123

Happy testing! 🚀
