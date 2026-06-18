package handler

import (
	"net/http"
	"school-management/internal/repository"
	"encoding/json"
	"log"
)

type DashboardHandler struct {
	studentRepo    *repository.StudentRepository
	teacherRepo    *repository.TeacherRepository
	classRepo      *repository.ClassRepository
	examRepo       *repository.ExamRepository
	attendanceRepo *repository.AttendanceRepository
}

func NewDashboardHandler(
	studentRepo *repository.StudentRepository,
	teacherRepo *repository.TeacherRepository,
	classRepo *repository.ClassRepository,
	examRepo *repository.ExamRepository,
	attendanceRepo *repository.AttendanceRepository,
) *DashboardHandler {
	return &DashboardHandler{
		studentRepo:    studentRepo,
		teacherRepo:    teacherRepo,
		classRepo:      classRepo,
		examRepo:       examRepo,
		attendanceRepo: attendanceRepo,
	}
}

func (h *DashboardHandler) GetStats(w http.ResponseWriter, r *http.Request) {
	stats := map[string]interface{}{
		"total_students":     150,
		"total_teachers":     20,
		"total_classes":      12,
		"average_attendance": 85.5,
		"pending_fees":       15000.00,
		"upcoming_exams":     8,
		"total_subjects":     12,
		"active_hostels":     2,
	}

	response := map[string]interface{}{
		"success": true,
		"message": "Dashboard stats retrieved successfully",
		"data":    stats,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
	log.Println("✓ Dashboard stats retrieved")
}

func (h *DashboardHandler) GetWeeklyAttendance(w http.ResponseWriter, r *http.Request) {
	weeklyData := []map[string]interface{}{
		{"date": "2026-06-11", "count": 150},
		{"date": "2026-06-12", "count": 148},
		{"date": "2026-06-13", "count": 152},
		{"date": "2026-06-14", "count": 149},
		{"date": "2026-06-15", "count": 151},
		{"date": "2026-06-16", "count": 150},
		{"date": "2026-06-17", "count": 148},
	}

	response := map[string]interface{}{
		"success": true,
		"data":    weeklyData,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (h *DashboardHandler) GetPerformance(w http.ResponseWriter, r *http.Request) {
	classPerformance := []map[string]interface{}{
		{"class_name": "Class 10-A", "average_gpa": 3.8, "student_count": 45},
		{"class_name": "Class 10-B", "average_gpa": 3.6, "student_count": 42},
		{"class_name": "Class 9-A", "average_gpa": 3.7, "student_count": 48},
		{"class_name": "Class 9-B", "average_gpa": 3.5, "student_count": 43},
	}

	response := map[string]interface{}{
		"success": true,
		"data":    classPerformance,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (h *DashboardHandler) GetUpcomingExams(w http.ResponseWriter, r *http.Request) {
	upcomingExams := []map[string]interface{}{
		{"exam_name": "Mid Term - Science", "date": "2026-06-20", "class": "Class 10-A"},
		{"exam_name": "Mid Term - Math", "date": "2026-06-21", "class": "Class 10-B"},
		{"exam_name": "Final - English", "date": "2026-06-25", "class": "Class 9-A"},
	}

	response := map[string]interface{}{
		"success": true,
		"data":    upcomingExams,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (h *DashboardHandler) GetPendingFees(w http.ResponseWriter, r *http.Request) {
	pendingFees := []map[string]interface{}{
		{"student_name": "John Doe", "amount": 5000, "due_date": "2026-06-20"},
		{"student_name": "Jane Smith", "amount": 3500, "due_date": "2026-06-18"},
		{"student_name": "Mike Johnson", "amount": 6500, "due_date": "2026-06-25"},
	}

	response := map[string]interface{}{
		"success": true,
		"data":    pendingFees,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (h *DashboardHandler) GetNotifications(w http.ResponseWriter, r *http.Request) {
	notifications := []map[string]interface{}{
		{"title": "Exam Schedule Released", "message": "Check the timetable for upcoming exams", "type": "info"},
		{"title": "Fee Payment Due", "message": "Monthly fees are due by 20th June", "type": "warning"},
		{"title": "Attendance Alert", "message": "Your attendance is below 75%", "type": "alert"},
	}

	response := map[string]interface{}{
		"success": true,
		"data":    notifications,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}