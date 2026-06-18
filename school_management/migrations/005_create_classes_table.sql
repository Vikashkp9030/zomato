CREATE TABLE IF NOT EXISTS classes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(100) NOT NULL,
    grade_level INT NOT NULL,
    section VARCHAR(10) NOT NULL,
    capacity INT NOT NULL DEFAULT 30,
    class_teacher_id INT,
    room_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY unique_class (grade_level, section),
    INDEX idx_grade_level (grade_level),
    INDEX idx_class_teacher_id (class_teacher_id),
    FOREIGN KEY (class_teacher_id) REFERENCES users(id) ON DELETE SET NULL
);
