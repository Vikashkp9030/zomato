package models

import "time"

type Report struct {
	ID            int       `json:"id"`
	ReportType    string    `json:"report_type"` // academic, fees, attendance, inventory, etc.
	Title         string    `json:"title"`
	Description   string    `json:"description"`
	GeneratedBy   int       `json:"generated_by"`
	GeneratedDate time.Time `json:"generated_date"`
	Data          interface{} `json:"data"`
	Status        string    `json:"status"`
	CreatedAt     time.Time `json:"created_at"`
}

type AcademicReport struct {
	ClassID       int       `json:"class_id"`
	ClassName     string    `json:"class_name"`
	TotalStudents int       `json:"total_students"`
	AverageGPA    float64   `json:"average_gpa"`
	TopPerformers []StudentPerformance `json:"top_performers"`
	NeedSupport   []StudentPerformance `json:"need_support"`
	GeneratedDate time.Time `json:"generated_date"`
}

type StudentPerformance struct {
	StudentID   int     `json:"student_id"`
	StudentName string  `json:"student_name"`
	GPA         float64 `json:"gpa"`
	Attendance  float64 `json:"attendance"`
	Grade       string  `json:"grade"`
}

type AttendanceReport struct {
	ClassID         int       `json:"class_id"`
	ClassName       string    `json:"class_name"`
	Month           string    `json:"month"`
	TotalStudents   int       `json:"total_students"`
	AverageAttendance float64  `json:"average_attendance"`
	StudentDetails  []StudentAttendanceDetail `json:"student_details"`
	GeneratedDate   time.Time `json:"generated_date"`
}

type StudentAttendanceDetail struct {
	StudentID      int     `json:"student_id"`
	StudentName    string  `json:"student_name"`
	DaysPresent    int     `json:"days_present"`
	DaysAbsent     int     `json:"days_absent"`
	AttendanceRate float64 `json:"attendance_rate"`
}

type FeesReport struct {
	Month           string    `json:"month"`
	TotalFees       float64   `json:"total_fees"`
	CollectedFees   float64   `json:"collected_fees"`
	PendingFees     float64   `json:"pending_fees"`
	CollectionRate  float64   `json:"collection_rate"`
	ClassWiseStats  []ClassFeeStats `json:"class_wise_stats"`
	GeneratedDate   time.Time `json:"generated_date"`
}

type ClassFeeStats struct {
	ClassID       int     `json:"class_id"`
	ClassName     string  `json:"class_name"`
	TotalStudents int     `json:"total_students"`
	TotalFees     float64 `json:"total_fees"`
	Collected     float64 `json:"collected"`
	Pending       float64 `json:"pending"`
}

type ReportFilter struct {
	ReportType string    `json:"report_type"`
	StartDate  time.Time `json:"start_date"`
	EndDate    time.Time `json:"end_date"`
	ClassID    *int      `json:"class_id"`
	StudentID  *int      `json:"student_id"`
}