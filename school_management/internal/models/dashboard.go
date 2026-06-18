package models

type DashboardStats struct {
	TotalStudents      int     `json:"total_students"`
	TotalTeachers      int     `json:"total_teachers"`
	TotalClasses       int     `json:"total_classes"`
	AverageAttendance  float64 `json:"average_attendance"`
	PendingFees        float64 `json:"pending_fees"`
	UpcomingExams      int     `json:"upcoming_exams"`
	TotalSubjects      int     `json:"total_subjects"`
	ActiveHostels      int     `json:"active_hostels"`
}

type ChartData struct {
	Label string      `json:"label"`
	Value interface{} `json:"value"`
}

type DashboardResponse struct {
	Stats        DashboardStats `json:"stats"`
	AttendanceChart []ChartData   `json:"attendance_chart"`
	ResultsChart  []ChartData   `json:"results_chart"`
	FeesChart     []ChartData   `json:"fees_chart"`
}

type WeeklyAttendance struct {
	Date  string `json:"date"`
	Count int    `json:"count"`
}

type ClassPerformance struct {
	ClassName    string  `json:"class_name"`
	AverageGPA   float64 `json:"average_gpa"`
	StudentCount int     `json:"student_count"`
}