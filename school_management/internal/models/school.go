package models

import "time"

type Student struct {
	ID             int       `json:"id"`
	FirstName      string    `json:"first_name"`
	LastName       string    `json:"last_name"`
	Email          string    `json:"email"`
	Phone          string    `json:"phone"`
	DateOfBirth    time.Time `json:"date_of_birth"`
	Gender         string    `json:"gender"`
	EnrollmentDate time.Time `json:"enrollment_date"`
	ClassID        int       `json:"class_id"`
	Status         string    `json:"status"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
}

type Teacher struct {
	ID              int       `json:"id"`
	FirstName       string    `json:"first_name"`
	LastName        string    `json:"last_name"`
	Email           string    `json:"email"`
	Phone           string    `json:"phone"`
	HireDate        time.Time `json:"hire_date"`
	Specialization  string    `json:"specialization"`
	Salary          float64   `json:"salary"`
	ExperienceYears int       `json:"experience_years"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

type Class struct {
	ID             int       `json:"id"`
	ClassName      string    `json:"class_name"`
	GradeLevel     int       `json:"grade_level"`
	Section        string    `json:"section"`
	Capacity       int       `json:"capacity"`
	ClassTeacherID int       `json:"class_teacher_id"`
	RoomNumber     string    `json:"room_number"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
}

type Subject struct {
	ID          int       `json:"id"`
	SubjectName string    `json:"subject_name"`
	SubjectCode string    `json:"subject_code"`
	Credits     int       `json:"credits"`
	Description string    `json:"description"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type Exam struct {
	ID           int       `json:"id"`
	ExamName     string    `json:"exam_name"`
	ExamType     string    `json:"exam_type"`
	ExamDate     time.Time `json:"exam_date"`
	ExamTime     string    `json:"exam_time"`
	TotalMarks   int       `json:"total_marks"`
	PassingMarks int       `json:"passing_marks"`
	SubjectID    int       `json:"subject_id"`
	ClassID      int       `json:"class_id"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type ExamResult struct {
	ID           int       `json:"id"`
	ExamID       int       `json:"exam_id"`
	StudentID    int       `json:"student_id"`
	MarksObtained float64   `json:"marks_obtained"`
	Grade        string    `json:"grade"`
	Status       string    `json:"status"`
	Attempt      int       `json:"attempt"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type Attendance struct {
	ID             int       `json:"id"`
	StudentID      int       `json:"student_id"`
	ClassID        int       `json:"class_id"`
	AttendanceDate time.Time `json:"attendance_date"`
	Status         string    `json:"status"`
	Remarks        string    `json:"remarks"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
}

type Parent struct {
	ID           int       `json:"id"`
	StudentID    int       `json:"student_id"`
	ParentName   string    `json:"parent_name"`
	Relationship string    `json:"relationship"`
	Phone        string    `json:"phone"`
	Email        string    `json:"email"`
	Occupation   string    `json:"occupation"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}
