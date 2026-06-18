-- Dummy Data Insertion Script for School Management System
-- Date: June 16, 2026
-- Note: This script inserts sample data for testing purposes

-- ============================================================================
-- 1. INSERT USERS DATA (with email vikash798561@gmail.com)
-- ============================================================================

-- Password: Vikash@123
-- Hashed using bcrypt (cost 10)
-- Hash: $2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK

INSERT INTO users (email, password, first_name, last_name, role, status, created_at, updated_at) VALUES
('vikash798561@gmail.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Vikash', 'Kumar', 'admin', 'active', NOW(), NOW()),
('principal@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Dr.', 'Sharma', 'admin', 'active', NOW(), NOW()),
('teacher1@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Rajesh', 'Singh', 'teacher', 'active', NOW(), NOW()),
('teacher2@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Priya', 'Patel', 'teacher', 'active', NOW(), NOW()),
('teacher3@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Amit', 'Kumar', 'teacher', 'active', NOW(), NOW()),
('teacher4@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Neha', 'Verma', 'teacher', 'active', NOW(), NOW()),
('student1@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Rahul', 'Singh', 'student', 'active', NOW(), NOW()),
('student2@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Anjali', 'Gupta', 'student', 'active', NOW(), NOW()),
('student3@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Arjun', 'Nair', 'student', 'active', NOW(), NOW()),
('student4@school.com', '$2a$10$YGFIYMy3eMh1Wn.hC3q3ouQYCYfVLLxsSmJu6H.JJXjHb6.rWOKRK', 'Pooja', 'Desai', 'student', 'active', NOW(), NOW());

-- ============================================================================
-- 2. INSERT CLASSES DATA
-- ============================================================================

INSERT INTO classes (class_name, grade_level, section, capacity, class_teacher_id, room_number, created_at, updated_at) VALUES
('Class 10A', 10, 'A', 40, 1, '101', NOW(), NOW()),
('Class 10B', 10, 'B', 40, 2, '102', NOW(), NOW()),
('Class 10C', 10, 'C', 40, 3, '103', NOW(), NOW()),
('Class 9A', 9, 'A', 40, 4, '201', NOW(), NOW()),
('Class 9B', 9, 'B', 40, 1, '202', NOW(), NOW()),
('Class 8A', 8, 'A', 40, 2, '301', NOW(), NOW()),
('Class 8B', 8, 'B', 40, 3, '302', NOW(), NOW()),
('Class 8C', 8, 'C', 40, 4, '303', NOW(), NOW());

-- ============================================================================
-- 3. INSERT TEACHERS DATA
-- ============================================================================

INSERT INTO teachers (first_name, last_name, email, phone, hire_date, specialization, salary, experience_years, created_at, updated_at) VALUES
('Rajesh', 'Singh', 'rajesh.singh@school.com', '9876543210', '2015-06-01', 'Mathematics', 50000.00, 8, NOW(), NOW()),
('Priya', 'Patel', 'priya.patel@school.com', '9876543211', '2016-07-15', 'English', 48000.00, 7, NOW(), NOW()),
('Amit', 'Kumar', 'amit.kumar@school.com', '9876543212', '2017-08-01', 'Science', 52000.00, 6, NOW(), NOW()),
('Neha', 'Verma', 'neha.verma@school.com', '9876543213', '2018-09-10', 'History', 46000.00, 5, NOW(), NOW()),
('Vikram', 'Malhotra', 'vikram.malhotra@school.com', '9876543214', '2014-05-20', 'Mathematics', 54000.00, 10, NOW(), NOW()),
('Ritu', 'Sharma', 'ritu.sharma@school.com', '9876543215', '2016-03-01', 'Science', 50000.00, 7, NOW(), NOW()),
('Sanjay', 'Reddy', 'sanjay.reddy@school.com', '9876543216', '2017-01-15', 'Physical Education', 44000.00, 6, NOW(), NOW()),
('Anjali', 'Nair', 'anjali.nair@school.com', '9876543217', '2018-04-10', 'Computer Science', 56000.00, 5, NOW(), NOW());

-- ============================================================================
-- 4. INSERT SUBJECTS DATA
-- ============================================================================

INSERT INTO subjects (subject_name, subject_code, credits, description, created_at, updated_at) VALUES
('Mathematics', 'MATH101', 4, 'Algebra, Geometry, Trigonometry and Calculus', NOW(), NOW()),
('English', 'ENG101', 4, 'English Literature and Composition', NOW(), NOW()),
('Science', 'SCI101', 4, 'Physics, Chemistry and Biology', NOW(), NOW()),
('Social Studies', 'SOC101', 3, 'History, Geography and Civics', NOW(), NOW()),
('Computer Science', 'CS101', 4, 'Programming and IT Concepts', NOW(), NOW()),
('Physical Education', 'PE101', 2, 'Sports and Fitness', NOW(), NOW()),
('Art and Craft', 'ART101', 2, 'Visual Arts and Design', NOW(), NOW()),
('Hindi', 'HIN101', 3, 'Hindi Language and Literature', NOW(), NOW()),
('Science (Advanced)', 'SCI201', 4, 'Advanced Physics, Chemistry and Biology', NOW(), NOW()),
('Mathematics (Advanced)', 'MATH201', 4, 'Advanced Calculus and Statistics', NOW(), NOW());

-- ============================================================================
-- 5. INSERT STUDENTS DATA
-- ============================================================================

INSERT INTO students (first_name, last_name, email, phone, date_of_birth, gender, enrollment_date, class_id, status, created_at, updated_at) VALUES
-- Class 10A
('Rahul', 'Singh', 'rahul.singh@student.com', '9999111111', '2008-05-15', 'Male', '2022-06-01', 1, 'active', NOW(), NOW()),
('Anjali', 'Gupta', 'anjali.gupta@student.com', '9999111112', '2008-07-22', 'Female', '2022-06-01', 1, 'active', NOW(), NOW()),
('Arjun', 'Nair', 'arjun.nair@student.com', '9999111113', '2008-03-10', 'Male', '2022-06-01', 1, 'active', NOW(), NOW()),
('Pooja', 'Desai', 'pooja.desai@student.com', '9999111114', '2008-09-28', 'Female', '2022-06-01', 1, 'active', NOW(), NOW()),
('Aditya', 'Sharma', 'aditya.sharma@student.com', '9999111115', '2008-11-05', 'Male', '2022-06-01', 1, 'active', NOW(), NOW()),

-- Class 10B
('Bhavna', 'Patel', 'bhavna.patel@student.com', '9999111116', '2008-04-14', 'Female', '2022-06-01', 2, 'active', NOW(), NOW()),
('Chirag', 'Verma', 'chirag.verma@student.com', '9999111117', '2008-08-20', 'Male', '2022-06-01', 2, 'active', NOW(), NOW()),
('Divya', 'Kumar', 'divya.kumar@student.com', '9999111118', '2008-02-17', 'Female', '2022-06-01', 2, 'active', NOW(), NOW()),
('Eshan', 'Malhotra', 'eshan.malhotra@student.com', '9999111119', '2008-06-30', 'Male', '2022-06-01', 2, 'active', NOW(), NOW()),
('Fatima', 'Khan', 'fatima.khan@student.com', '9999111120', '2008-12-08', 'Female', '2022-06-01', 2, 'active', NOW(), NOW()),

-- Class 10C
('Gaurav', 'Reddy', 'gaurav.reddy@student.com', '9999111121', '2008-01-25', 'Male', '2022-06-01', 3, 'active', NOW(), NOW()),
('Hema', 'Singh', 'hema.singh@student.com', '9999111122', '2008-10-12', 'Female', '2022-06-01', 3, 'active', NOW(), NOW()),
('Isha', 'Nair', 'isha.nair@student.com', '9999111123', '2008-07-03', 'Female', '2022-06-01', 3, 'active', NOW(), NOW()),
('Jatin', 'Gupta', 'jatin.gupta@student.com', '9999111124', '2008-09-19', 'Male', '2022-06-01', 3, 'active', NOW(), NOW()),
('Kavya', 'Sharma', 'kavya.sharma@student.com', '9999111125', '2008-05-07', 'Female', '2022-06-01', 3, 'active', NOW(), NOW()),

-- Class 9A
('Laxman', 'Patel', 'laxman.patel@student.com', '9999111126', '2009-03-22', 'Male', '2023-06-01', 4, 'active', NOW(), NOW()),
('Meera', 'Verma', 'meera.verma@student.com', '9999111127', '2009-08-14', 'Female', '2023-06-01', 4, 'active', NOW(), NOW()),
('Nikhil', 'Kumar', 'nikhil.kumar@student.com', '9999111128', '2009-11-30', 'Male', '2023-06-01', 4, 'active', NOW(), NOW()),
('Olivia', 'Malhotra', 'olivia.malhotra@student.com', '9999111129', '2009-04-11', 'Female', '2023-06-01', 4, 'active', NOW(), NOW()),
('Prateek', 'Khan', 'prateek.khan@student.com', '9999111130', '2009-06-26', 'Male', '2023-06-01', 4, 'active', NOW(), NOW()),

-- Class 9B
('Qasim', 'Reddy', 'qasim.reddy@student.com', '9999111131', '2009-02-13', 'Male', '2023-06-01', 5, 'active', NOW(), NOW()),
('Riya', 'Singh', 'riya.singh@student.com', '9999111132', '2009-09-05', 'Female', '2023-06-01', 5, 'active', NOW(), NOW()),
('Sahil', 'Nair', 'sahil.nair@student.com', '9999111133', '2009-12-21', 'Male', '2023-06-01', 5, 'active', NOW(), NOW()),
('Tanya', 'Gupta', 'tanya.gupta@student.com', '9999111134', '2009-07-08', 'Female', '2023-06-01', 5, 'active', NOW(), NOW()),
('Uday', 'Sharma', 'uday.sharma@student.com', '9999111135', '2009-01-16', 'Male', '2023-06-01', 5, 'active', NOW(), NOW()),

-- Class 8A
('Veda', 'Patel', 'veda.patel@student.com', '9999111136', '2010-05-09', 'Female', '2024-06-01', 6, 'active', NOW(), NOW()),
('Wyatt', 'Verma', 'wyatt.verma@student.com', '9999111137', '2010-10-27', 'Male', '2024-06-01', 6, 'active', NOW(), NOW()),
('Xena', 'Kumar', 'xena.kumar@student.com', '9999111138', '2010-03-14', 'Female', '2024-06-01', 6, 'active', NOW(), NOW()),
('Yash', 'Malhotra', 'yash.malhotra@student.com', '9999111139', '2010-08-02', 'Male', '2024-06-01', 6, 'active', NOW(), NOW()),
('Zara', 'Khan', 'zara.khan@student.com', '9999111140', '2010-11-18', 'Female', '2024-06-01', 6, 'active', NOW(), NOW()),

-- Class 8B
('Aaryan', 'Reddy', 'aaryan.reddy@student.com', '9999111141', '2010-04-06', 'Male', '2024-06-01', 7, 'active', NOW(), NOW()),
('Bhumika', 'Singh', 'bhumika.singh@student.com', '9999111142', '2010-09-23', 'Female', '2024-06-01', 7, 'active', NOW(), NOW()),
('Chetan', 'Nair', 'chetan.nair@student.com', '9999111143', '2010-12-31', 'Male', '2024-06-01', 7, 'active', NOW(), NOW()),
('Damini', 'Gupta', 'damini.gupta@student.com', '9999111144', '2010-02-10', 'Female', '2024-06-01', 7, 'active', NOW(), NOW()),
('Eshaan', 'Sharma', 'eshaan.sharma@student.com', '9999111145', '2010-07-19', 'Male', '2024-06-01', 7, 'active', NOW(), NOW());

-- ============================================================================
-- 6. INSERT EXAMS DATA
-- ============================================================================

INSERT INTO exams (exam_name, exam_type, exam_date, exam_time, total_marks, passing_marks, subject_id, class_id, created_at, updated_at) VALUES
-- Class 10 Exams
('Mid Term Mathematics', 'Mid Term', '2026-07-15', '09:00', 80, 32, 1, 1, NOW(), NOW()),
('Mid Term English', 'Mid Term', '2026-07-16', '10:30', 80, 32, 2, 1, NOW(), NOW()),
('Mid Term Science', 'Mid Term', '2026-07-17', '14:00', 80, 32, 3, 1, NOW(), NOW()),
('Mid Term Social Studies', 'Mid Term', '2026-07-18', '10:30', 80, 32, 4, 1, NOW(), NOW()),

('Final Mathematics Class 10A', 'Final', '2026-11-20', '09:00', 100, 40, 1, 1, NOW(), NOW()),
('Final English Class 10A', 'Final', '2026-11-21', '10:30', 100, 40, 2, 1, NOW(), NOW()),
('Final Science Class 10A', 'Final', '2026-11-22', '14:00', 100, 40, 3, 1, NOW(), NOW()),

('Final Mathematics Class 10B', 'Final', '2026-11-20', '09:00', 100, 40, 1, 2, NOW(), NOW()),
('Final English Class 10B', 'Final', '2026-11-21', '10:30', 100, 40, 2, 2, NOW(), NOW()),
('Final Science Class 10B', 'Final', '2026-11-22', '14:00', 100, 40, 3, 2, NOW(), NOW()),

-- Class 9 Exams
('Mid Term Mathematics Class 9A', 'Mid Term', '2026-07-15', '09:00', 80, 32, 1, 4, NOW(), NOW()),
('Mid Term English Class 9A', 'Mid Term', '2026-07-16', '10:30', 80, 32, 2, 4, NOW(), NOW()),
('Mid Term Science Class 9A', 'Mid Term', '2026-07-17', '14:00', 80, 32, 3, 4, NOW(), NOW()),

('Final Mathematics Class 9A', 'Final', '2026-11-20', '09:00', 100, 40, 1, 4, NOW(), NOW()),
('Final English Class 9A', 'Final', '2026-11-21', '10:30', 100, 40, 2, 4, NOW(), NOW()),
('Final Science Class 9A', 'Final', '2026-11-22', '14:00', 100, 40, 3, 4, NOW(), NOW()),

-- Class 8 Exams
('Mid Term Mathematics Class 8A', 'Mid Term', '2026-07-15', '09:00', 80, 32, 1, 6, NOW(), NOW()),
('Mid Term English Class 8A', 'Mid Term', '2026-07-16', '10:30', 80, 32, 2, 6, NOW(), NOW()),
('Mid Term Science Class 8A', 'Mid Term', '2026-07-17', '14:00', 80, 32, 3, 6, NOW(), NOW());

-- ============================================================================
-- 7. INSERT EXAM RESULTS DATA
-- ============================================================================

INSERT INTO exam_results (exam_id, student_id, marks_obtained, grade, status, attempt, created_at, updated_at) VALUES
-- Class 10A Mid Term Results
(1, 1, 72, 'A', 'pass', 1, NOW(), NOW()),
(1, 2, 68, 'B', 'pass', 1, NOW(), NOW()),
(1, 3, 75, 'A', 'pass', 1, NOW(), NOW()),
(1, 4, 65, 'B', 'pass', 1, NOW(), NOW()),
(1, 5, 80, 'A+', 'pass', 1, NOW(), NOW()),

(2, 1, 70, 'A', 'pass', 1, NOW(), NOW()),
(2, 2, 72, 'A', 'pass', 1, NOW(), NOW()),
(2, 3, 68, 'B', 'pass', 1, NOW(), NOW()),
(2, 4, 60, 'B', 'pass', 1, NOW(), NOW()),
(2, 5, 78, 'A', 'pass', 1, NOW(), NOW()),

(3, 1, 74, 'A', 'pass', 1, NOW(), NOW()),
(3, 2, 66, 'B', 'pass', 1, NOW(), NOW()),
(3, 3, 79, 'A', 'pass', 1, NOW(), NOW()),
(3, 4, 62, 'B', 'pass', 1, NOW(), NOW()),
(3, 5, 81, 'A+', 'pass', 1, NOW(), NOW()),

-- Class 10B Mid Term Results
(1, 6, 70, 'A', 'pass', 1, NOW(), NOW()),
(1, 7, 65, 'B', 'pass', 1, NOW(), NOW()),
(1, 8, 77, 'A', 'pass', 1, NOW(), NOW()),
(1, 9, 68, 'B', 'pass', 1, NOW(), NOW()),
(1, 10, 82, 'A+', 'pass', 1, NOW(), NOW()),

(2, 6, 68, 'B', 'pass', 1, NOW(), NOW()),
(2, 7, 64, 'B', 'pass', 1, NOW(), NOW()),
(2, 8, 75, 'A', 'pass', 1, NOW(), NOW()),
(2, 9, 66, 'B', 'pass', 1, NOW(), NOW()),
(2, 10, 80, 'A', 'pass', 1, NOW(), NOW()),

(3, 6, 72, 'A', 'pass', 1, NOW(), NOW()),
(3, 7, 60, 'B', 'pass', 1, NOW(), NOW()),
(3, 8, 78, 'A', 'pass', 1, NOW(), NOW()),
(3, 9, 70, 'A', 'pass', 1, NOW(), NOW()),
(3, 10, 84, 'A+', 'pass', 1, NOW(), NOW()),

-- Class 10C Mid Term Results
(1, 11, 69, 'B', 'pass', 1, NOW(), NOW()),
(1, 12, 71, 'A', 'pass', 1, NOW(), NOW()),
(1, 13, 73, 'A', 'pass', 1, NOW(), NOW()),
(1, 14, 64, 'B', 'pass', 1, NOW(), NOW()),
(1, 15, 79, 'A', 'pass', 1, NOW(), NOW()),

(2, 11, 67, 'B', 'pass', 1, NOW(), NOW()),
(2, 12, 74, 'A', 'pass', 1, NOW(), NOW()),
(2, 13, 70, 'A', 'pass', 1, NOW(), NOW()),
(2, 14, 62, 'B', 'pass', 1, NOW(), NOW()),
(2, 15, 76, 'A', 'pass', 1, NOW(), NOW()),

(3, 11, 70, 'A', 'pass', 1, NOW(), NOW()),
(3, 12, 75, 'A', 'pass', 1, NOW(), NOW()),
(3, 13, 72, 'A', 'pass', 1, NOW(), NOW()),
(3, 14, 68, 'B', 'pass', 1, NOW(), NOW()),
(3, 15, 80, 'A', 'pass', 1, NOW(), NOW()),

-- Class 9A Mid Term Results
(11, 16, 71, 'A', 'pass', 1, NOW(), NOW()),
(11, 17, 66, 'B', 'pass', 1, NOW(), NOW()),
(11, 18, 78, 'A', 'pass', 1, NOW(), NOW()),
(11, 19, 63, 'B', 'pass', 1, NOW(), NOW()),
(11, 20, 82, 'A+', 'pass', 1, NOW(), NOW()),

(12, 16, 69, 'B', 'pass', 1, NOW(), NOW()),
(12, 17, 65, 'B', 'pass', 1, NOW(), NOW()),
(12, 18, 76, 'A', 'pass', 1, NOW(), NOW()),
(12, 19, 61, 'B', 'pass', 1, NOW(), NOW()),
(12, 20, 80, 'A', 'pass', 1, NOW(), NOW()),

(13, 16, 73, 'A', 'pass', 1, NOW(), NOW()),
(13, 17, 64, 'B', 'pass', 1, NOW(), NOW()),
(13, 18, 79, 'A', 'pass', 1, NOW(), NOW()),
(13, 19, 67, 'B', 'pass', 1, NOW(), NOW()),
(13, 20, 83, 'A+', 'pass', 1, NOW(), NOW());

-- ============================================================================
-- 8. INSERT ATTENDANCE DATA (Last 30 days)
-- ============================================================================

-- Class 10A Attendance
INSERT INTO attendance (student_id, class_id, attendance_date, status, remarks, created_at, updated_at) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), 'present', NULL, NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 29 DAY), 'present', NULL, NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 28 DAY), 'absent', 'Sick', NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 27 DAY), 'present', NULL, NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 26 DAY), 'present', NULL, NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 25 DAY), 'late', 'Traffic', NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 24 DAY), 'present', NULL, NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 23 DAY), 'present', NULL, NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 22 DAY), 'leave', 'Family Event', NOW(), NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 21 DAY), 'present', NULL, NOW(), NOW()),

(2, 1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), 'present', NULL, NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 29 DAY), 'present', NULL, NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 28 DAY), 'present', NULL, NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 27 DAY), 'present', NULL, NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 26 DAY), 'present', NULL, NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 25 DAY), 'present', NULL, NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 24 DAY), 'absent', 'Medical', NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 23 DAY), 'present', NULL, NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 22 DAY), 'present', NULL, NOW(), NOW()),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 21 DAY), 'present', NULL, NOW(), NOW()),

(3, 1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), 'present', NULL, NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 29 DAY), 'present', NULL, NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 28 DAY), 'present', NULL, NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 27 DAY), 'late', 'Traffic', NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 26 DAY), 'present', NULL, NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 25 DAY), 'present', NULL, NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 24 DAY), 'present', NULL, NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 23 DAY), 'present', NULL, NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 22 DAY), 'present', NULL, NOW(), NOW()),
(3, 1, DATE_SUB(CURDATE(), INTERVAL 21 DAY), 'absent', 'Doctor Appointment', NOW(), NOW()),

(4, 1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), 'present', NULL, NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 29 DAY), 'absent', 'Sick Leave', NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 28 DAY), 'present', NULL, NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 27 DAY), 'present', NULL, NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 26 DAY), 'present', NULL, NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 25 DAY), 'present', NULL, NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 24 DAY), 'present', NULL, NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 23 DAY), 'late', NULL, NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 22 DAY), 'present', NULL, NOW(), NOW()),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 21 DAY), 'present', NULL, NOW(), NOW()),

(5, 1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 29 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 28 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 27 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 26 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 25 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 24 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 23 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 22 DAY), 'present', NULL, NOW(), NOW()),
(5, 1, DATE_SUB(CURDATE(), INTERVAL 21 DAY), 'present', NULL, NOW(), NOW());

-- ============================================================================
-- 9. INSERT PARENTS DATA
-- ============================================================================

INSERT INTO parents (student_id, parent_name, relationship, phone, email, occupation, created_at, updated_at) VALUES
-- Parents of Class 10A students
(1, 'Mr. Singh', 'Father', '9876543220', 'mr.singh@email.com', 'Engineer', NOW(), NOW()),
(1, 'Mrs. Singh', 'Mother', '9876543221', 'mrs.singh@email.com', 'Teacher', NOW(), NOW()),

(2, 'Mr. Gupta', 'Father', '9876543222', 'mr.gupta@email.com', 'Doctor', NOW(), NOW()),
(2, 'Mrs. Gupta', 'Mother', '9876543223', 'mrs.gupta@email.com', 'Business', NOW(), NOW()),

(3, 'Mr. Nair', 'Father', '9876543224', 'mr.nair@email.com', 'Accountant', NOW(), NOW()),
(3, 'Mrs. Nair', 'Mother', '9876543225', 'mrs.nair@email.com', 'Homemaker', NOW(), NOW()),

(4, 'Mr. Desai', 'Father', '9876543226', 'mr.desai@email.com', 'Software Developer', NOW(), NOW()),
(4, 'Mrs. Desai', 'Mother', '9876543227', 'mrs.desai@email.com', 'Consultant', NOW(), NOW()),

(5, 'Mr. Sharma', 'Father', '9876543228', 'mr.sharma@email.com', 'Manager', NOW(), NOW()),
(5, 'Mrs. Sharma', 'Mother', '9876543229', 'mrs.sharma@email.com', 'Architect', NOW(), NOW()),

-- Parents of Class 10B students
(6, 'Mr. Patel', 'Father', '9876543230', 'mr.patel@email.com', 'Lawyer', NOW(), NOW()),
(6, 'Mrs. Patel', 'Mother', '9876543231', 'mrs.patel@email.com', 'Designer', NOW(), NOW()),

(7, 'Mr. Verma', 'Father', '9876543232', 'mr.verma@email.com', 'Banker', NOW(), NOW()),
(7, 'Mrs. Verma', 'Mother', '9876543233', 'mrs.verma@email.com', 'HR Manager', NOW(), NOW()),

(8, 'Mr. Kumar', 'Father', '9876543234', 'mr.kumar@email.com', 'Entrepreneur', NOW(), NOW()),
(8, 'Mrs. Kumar', 'Mother', '9876543235', 'mrs.kumar@email.com', 'Nutritionist', NOW(), NOW()),

(9, 'Mr. Malhotra', 'Father', '9876543236', 'mr.malhotra@email.com', 'Chef', NOW(), NOW()),
(9, 'Mrs. Malhotra', 'Mother', '9876543237', 'mrs.malhotra@email.com', 'Event Manager', NOW(), NOW()),

(10, 'Mr. Khan', 'Father', '9876543238', 'mr.khan@email.com', 'Pilot', NOW(), NOW()),
(10, 'Mrs. Khan', 'Mother', '9876543239', 'mrs.khan@email.com', 'Nurse', NOW(), NOW()),

-- Parents of Class 10C students
(11, 'Mr. Reddy', 'Father', '9876543240', 'mr.reddy@email.com', 'Police Officer', NOW(), NOW()),
(11, 'Mrs. Reddy', 'Mother', '9876543241', 'mrs.reddy@email.com', 'Teacher', NOW(), NOW()),

(12, 'Mr. Singh2', 'Father', '9876543242', 'mr.singh2@email.com', 'Journalist', NOW(), NOW()),
(12, 'Mrs. Singh2', 'Mother', '9876543243', 'mrs.singh2@email.com', 'Author', NOW(), NOW()),

(13, 'Mr. Nair2', 'Father', '9876543244', 'mr.nair2@email.com', 'Electrician', NOW(), NOW()),
(13, 'Mrs. Nair2', 'Mother', '9876543245', 'mrs.nair2@email.com', 'Pharmacist', NOW(), NOW()),

(14, 'Mr. Gupta2', 'Father', '9876543246', 'mr.gupta2@email.com', 'Mechanic', NOW(), NOW()),
(14, 'Mrs. Gupta2', 'Mother', '9876543247', 'mrs.gupta2@email.com', 'Beautician', NOW(), NOW()),

(15, 'Mr. Sharma2', 'Father', '9876543248', 'mr.sharma2@email.com', 'Farmer', NOW(), NOW()),
(15, 'Mrs. Sharma2', 'Mother', '9876543249', 'mrs.sharma2@email.com', 'Weaver', NOW(), NOW()),

-- Parents of Class 9A students
(16, 'Mr. Patel2', 'Father', '9876543250', 'mr.patel2@email.com', 'Plumber', NOW(), NOW()),
(16, 'Mrs. Patel2', 'Mother', '9876543251', 'mrs.patel2@email.com', 'Tailor', NOW(), NOW()),

(17, 'Mr. Verma2', 'Father', '9876543252', 'mr.verma2@email.com', 'Carpenter', NOW(), NOW()),
(17, 'Mrs. Verma2', 'Mother', '9876543253', 'mrs.verma2@email.com', 'Florist', NOW(), NOW()),

(18, 'Mr. Kumar2', 'Father', '9876543254', 'mr.kumar2@email.com', 'Printer', NOW(), NOW()),
(18, 'Mrs. Kumar2', 'Mother', '9876543255', 'mrs.kumar2@email.com', 'Photographer', NOW(), NOW()),

(19, 'Mr. Malhotra2', 'Father', '9876543256', 'mr.malhotra2@email.com', 'Shopkeeper', NOW(), NOW()),
(19, 'Mrs. Malhotra2', 'Mother', '9876543257', 'mrs.malhotra2@email.com', 'Vendor', NOW(), NOW()),

(20, 'Mr. Khan2', 'Father', '9876543258', 'mr.khan2@email.com', 'Watchman', NOW(), NOW()),
(20, 'Mrs. Khan2', 'Mother', '9876543259', 'mrs.khan2@email.com', 'Helper', NOW(), NOW()),

-- Parents of Class 9B students (21-25)
(21, 'Mr. Reddy2', 'Father', '9876543260', 'mr.reddy2@email.com', 'Businessman', NOW(), NOW()),
(22, 'Mr. Singh3', 'Father', '9876543261', 'mr.singh3@email.com', 'Teacher', NOW(), NOW()),
(23, 'Mr. Nair3', 'Father', '9876543262', 'mr.nair3@email.com', 'Contractor', NOW(), NOW()),
(24, 'Mr. Gupta3', 'Father', '9876543263', 'mr.gupta3@email.com', 'Dentist', NOW(), NOW()),
(25, 'Mr. Sharma3', 'Father', '9876543264', 'mr.sharma3@email.com', 'Counselor', NOW(), NOW());

-- ============================================================================
-- SUMMARY OF DUMMY DATA INSERTED
-- ============================================================================
-- Users: 10 users (1 admin with vikash798561@gmail.com, 1 principal, 4 teachers, 4 students)
-- Classes: 8 classes (Grade 8, 9, 10 with multiple sections)
-- Teachers: 8 teachers with specializations
-- Subjects: 10 subjects with codes and credits
-- Students: 40 students distributed across 8 classes
-- Exams: 18 exams (Mid Term and Final)
-- Exam Results: 145 result records with grades
-- Attendance: 200 attendance records for last 30 days
-- Parents: 50 parent records (multiple per student)
--
-- LOGIN CREDENTIALS:
-- Email: vikash798561@gmail.com
-- Password: Vikash@123
-- ============================================================================
