# MySQL Workbench Setup Guide

## ✅ Installation Complete

MySQL Workbench 8.0.47 has been successfully installed on your Mac!

**Location:** `/Applications/MySQLWorkbench.app`

---

## 🚀 How to Connect to Your Database

### Step 1: Open MySQL Workbench
The app should already be opening. If not, open it from Applications folder or use:
```bash
open /Applications/MySQLWorkbench.app
```

### Step 2: Create a New Connection

1. **Look for "MySQL Connections" section** on the home screen
2. Click the **"+"** button or "Create a New Connection"
3. Fill in the following details:

| Field | Value |
|-------|-------|
| **Connection Name** | School Management DB |
| **Connection Method** | Standard (TCP/IP) |
| **Hostname** | localhost |
| **Port** | 3306 |
| **Username** | root |
| **Password** | (leave blank) |
| **Default Schema** | school_management |

### Step 3: Test Connection
- Click **"Test Connection"** button
- If successful, you'll see "Successfully made the MySQL connection"
- Click **"OK"** to save

### Step 4: Connect to Database
- Double-click on the saved connection
- You'll now see your database structure on the left sidebar

---

## 📊 Database Details

**From your `.env` file:**

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=(empty)
DB_NAME=school_management
```

---

## 🔍 Exploring Your Database

Once connected, you can:

### View All Tables
1. Expand `school_management` database in left sidebar
2. Click on **"Tables"** folder

### View Table Structure
- Right-click on any table → **"Select Rows - Limit 1000"**
- Or double-click the table to see its structure

### Query Your Data
1. Click **"File" → "New Query Tab"**
2. Or use keyboard shortcut: **Cmd + T**
3. Write SQL queries:

```sql
-- View all users
SELECT * FROM users;

-- View all students
SELECT * FROM students;

-- View all classes
SELECT * FROM classes;

-- View attendance records
SELECT * FROM attendance;

-- View exam results
SELECT * FROM exam_results;
```

---

## 📋 Common Tables in Your Database

Based on your application routes:

| Table | Purpose |
|-------|---------|
| `users` | User accounts with authentication |
| `students` | Student information |
| `classes` | Class details |
| `teachers` | Teacher information |
| `subjects` | Subject details |
| `exams` | Exam schedules |
| `exam_results` | Student exam scores |
| `attendance` | Attendance records |
| `fees` | Fee management |
| `parents` | Parent/Guardian information |

---

## 💾 Useful Queries

### Count Records in Each Table
```sql
SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'students', COUNT(*) FROM students
UNION ALL
SELECT 'classes', COUNT(*) FROM classes
UNION ALL
SELECT 'teachers', COUNT(*) FROM teachers
UNION ALL
SELECT 'exams', COUNT(*) FROM exams
UNION ALL
SELECT 'attendance', COUNT(*) FROM attendance;
```

### View Recent Users
```sql
SELECT id, email, first_name, last_name, role, created_at 
FROM users 
ORDER BY created_at DESC 
LIMIT 10;
```

### View Student Class Distribution
```sql
SELECT c.name, COUNT(s.id) as student_count
FROM classes c
LEFT JOIN students s ON c.id = s.class_id
GROUP BY c.id, c.name;
```

### View Pending Fees
```sql
SELECT s.first_name, s.last_name, f.amount, f.due_date
FROM fees f
JOIN students s ON f.student_id = s.id
WHERE f.status = 'pending'
ORDER BY f.due_date;
```

---

## 🛠️ Troubleshooting

### Connection Failed?
1. **Check MySQL is running:**
   ```bash
   mysql -u root -p school_management -e "SELECT 1;"
   ```
   
2. **Check port availability:**
   ```bash
   lsof -i :3306
   ```

3. **Restart MySQL:**
   ```bash
   brew services restart mysql
   ```

### Can't see tables?
- Right-click on database name and select **"Refresh"**
- Or press **Cmd + R**

### Password Issues?
- If you set a MySQL root password, enter it in the password field
- If using no password, leave the password field blank

---

## 📝 Useful Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| **Cmd + T** | New SQL tab |
| **Cmd + E** | Execute query |
| **Cmd + R** | Refresh |
| **Cmd + Shift + N** | New connection |
| **Cmd + ;** | Toggle comment |

---

## 🎯 Next Steps

1. **Explore your data** - Browse through tables to understand your database structure
2. **Run some queries** - Test the SQL examples above
3. **Backup your database** - Use Workbench's backup/export features
4. **Monitor data** - Use queries to check your application's data

---

**Status:** ✅ MySQL Workbench is ready to use!

**For API Testing:** Use the curl commands in `API_CURL_COMMANDS.md`

**For Backend:** Use the queries above to verify your data in real-time while testing API endpoints.
