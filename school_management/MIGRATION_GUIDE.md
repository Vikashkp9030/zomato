# Database Migration Guide

**Last Updated:** June 16, 2026

---

## Overview

Five new database tables have been added to support the new school management features. This guide explains how to run the migrations.

---

## Migration Files Added

### 1. `migrations/005_create_classes_table.sql`
**Purpose:** Store school class/section information  
**Tables:** `classes`

**Key Features:**
- Tracks class name, grade level, section
- Stores capacity and room assignment
- Links to class teacher (foreign key to users table)
- Unique constraint on (grade_level, section) combination
- Indexes on grade_level and class_teacher_id

### 2. `migrations/006_create_teachers_table.sql`
**Purpose:** Store teacher information  
**Tables:** `teachers`

**Key Features:**
- Personal information (name, email, phone)
- Professional details (hire_date, specialization, salary)
- Experience tracking
- Unique constraint on email
- Indexes on specialization and hire_date

### 3. `migrations/007_create_subjects_table.sql`
**Purpose:** Store academic subject information  
**Tables:** `subjects`

**Key Features:**
- Subject name and unique code
- Credit hours
- Description
- Unique constraint on subject_code
- Indexes on subject_code and subject_name

### 4. `migrations/008_create_exam_results_table.sql`
**Purpose:** Track exam results and grades  
**Tables:** `exam_results`

**Key Features:**
- Links exam_id, student_id, and attempt
- Stores marks obtained and grade
- Pass/fail status
- Unique composite constraint on (exam_id, student_id, attempt)
- Indexes for performance
- Foreign keys with CASCADE delete

### 5. `migrations/009_create_parents_table.sql`
**Purpose:** Store parent/guardian information  
**Tables:** `parents`

**Key Features:**
- Links to student (student_id)
- Parent details (name, relationship, contact)
- Occupation field
- Indexes on email and phone
- Foreign key with CASCADE delete

---

## Running Migrations

### Option 1: Using Make Commands (Recommended)

If you have a Makefile with migration support:

```bash
make migrate
```

This will execute all migration files in the `migrations/` directory in order.

### Option 2: Manual MySQL Execution

Execute migrations in order:

```bash
# 1. Create classes table
mysql -u root -p school_management < migrations/005_create_classes_table.sql

# 2. Create teachers table
mysql -u root -p school_management < migrations/006_create_teachers_table.sql

# 3. Create subjects table
mysql -u root -p school_management < migrations/007_create_subjects_table.sql

# 4. Create exam results table
mysql -u root -p school_management < migrations/008_create_exam_results_table.sql

# 5. Create parents table
mysql -u root -p school_management < migrations/009_create_parents_table.sql
```

### Option 3: Using MySQL Client Directly

```bash
mysql -u root -p
USE school_management;

# Copy-paste the SQL from each migration file

SOURCE migrations/005_create_classes_table.sql;
SOURCE migrations/006_create_teachers_table.sql;
SOURCE migrations/007_create_subjects_table.sql;
SOURCE migrations/008_create_exam_results_table.sql;
SOURCE migrations/009_create_parents_table.sql;
```

### Option 4: Docker Compose

If using Docker:

```bash
# Start containers
docker-compose up -d

# Wait for MySQL to be ready, then migrations will run automatically
```

---

## Verification

After running migrations, verify the tables were created:

```bash
mysql -u root -p school_management -e "SHOW TABLES;"
```

You should see the new tables:
- `classes`
- `teachers`
- `subjects`
- `exam_results`
- `parents`

Check table structure:

```bash
# Describe a table
mysql -u root -p school_management -e "DESCRIBE classes;"
```

---

## Rollback (If Needed)

To remove all new tables (be careful with production data):

```bash
mysql -u root -p school_management << EOF
DROP TABLE IF EXISTS parents;
DROP TABLE IF EXISTS exam_results;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS classes;
EOF
```

---

## Foreign Key Relationships

The new tables have the following relationships:

```
users (id) ──┬─→ classes (class_teacher_id)
             └─→ teachers (implied - class_teacher_id references users)

students (id) ──┬─→ parents (student_id)
                └─→ exam_results (student_id)

exams (id) ──→ exam_results (exam_id)

subjects (id) ──→ exams (subject_id)
```

---

## Data Integrity Notes

1. **Cascade Deletes:** 
   - Deleting a parent record will CASCADE delete all related exam results
   - Deleting a student will CASCADE delete all parent records

2. **Unique Constraints:**
   - Class: Only one class per (grade_level, section)
   - Teacher: Only one teacher per email
   - Subject: Only one subject per code
   - Exam Result: Only one result per (exam_id, student_id, attempt)

3. **Foreign Keys:**
   - class_teacher_id in classes must reference an existing user
   - student_id in parents must reference an existing student
   - student_id in exam_results must reference an existing student
   - exam_id in exam_results must reference an existing exam

---

## Migration Order

**Important:** Run migrations in this exact order:

1. `005_create_classes_table.sql` - Independent table
2. `006_create_teachers_table.sql` - Independent table
3. `007_create_subjects_table.sql` - Independent table
4. `008_create_exam_results_table.sql` - Depends on exams and students
5. `009_create_parents_table.sql` - Depends on students

---

## Troubleshooting

### Foreign Key Constraint Error

If you get a foreign key constraint error:

```
Error 1215: Cannot add foreign key constraint
```

**Solution:** Ensure the referenced table and columns exist:
- `users` table must exist with `id` column
- `students` table must exist with `id` column
- `exams` table must exist with `id` column

### Table Already Exists

If you get:
```
Error 1050: Table 'classes' already exists
```

The migrations use `CREATE TABLE IF NOT EXISTS`, so this shouldn't happen. But if it does, check if the table exists and drop it first.

### Charset Issues

If you encounter charset issues, ensure the database uses UTF-8:

```bash
ALTER DATABASE school_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

---

## Performance Optimization

All tables include appropriate indexes:

- **classes:** Index on grade_level, class_teacher_id
- **teachers:** Index on email, specialization, hire_date
- **subjects:** Index on subject_code, subject_name
- **exam_results:** Index on exam_id, student_id, status
- **parents:** Index on student_id, email, phone

These indexes optimize common queries like filtering by grade, searching teachers by specialization, and finding results by exam or student.

---

## Backup Before Migration

Always backup your database before running migrations:

```bash
mysqldump -u root -p school_management > school_management_backup_$(date +%Y%m%d_%H%M%S).sql
```

---

## Next Steps

After running migrations:

1. ✅ All tables are created with proper constraints
2. ✅ Test endpoints using Postman or cURL
3. ✅ Insert sample data to verify relationships
4. ✅ Monitor performance with large datasets
5. ✅ Consider adding more features (fees, library, etc.)

---

**Migration Guide Complete**
