package routes

import (
	"net/http"

	"github.com/gorilla/mux"
	"school-management/config"
	"school-management/internal/database"
	"school-management/internal/handler"
	"school-management/internal/middleware"
	"school-management/internal/repository"
)

func RegisterRoutes(router *mux.Router, db *database.Database, cfg *config.AppConfig) {
	conn := db.GetConnection()

	userRepo := repository.NewUserRepository(conn)
	studentRepo := repository.NewStudentRepository(conn)
	examRepo := repository.NewExamRepository(conn)
	attendanceRepo := repository.NewAttendanceRepository(conn)
	classRepo := repository.NewClassRepository(conn)
	teacherRepo := repository.NewTeacherRepository(conn)
	subjectRepo := repository.NewSubjectRepository(conn)
	examResultRepo := repository.NewExamResultRepository(conn)
	parentRepo := repository.NewParentRepository(conn)
	feesRepo := repository.NewFeesRepository(conn)

	authHandler := handler.NewAuthHandler(userRepo, cfg)
	studentHandler := handler.NewStudentHandler(studentRepo)
	examHandler := handler.NewExamHandler(examRepo)
	attendanceHandler := handler.NewAttendanceHandler(attendanceRepo)
	classHandler := handler.NewClassHandler(classRepo)
	teacherHandler := handler.NewTeacherHandler(teacherRepo)
	subjectHandler := handler.NewSubjectHandler(subjectRepo)
	examResultHandler := handler.NewExamResultHandler(examResultRepo)
	parentHandler := handler.NewParentHandler(parentRepo)
	dashboardHandler := handler.NewDashboardHandler(studentRepo, teacherRepo, classRepo, examRepo, attendanceRepo)
	feesHandler := handler.NewFeesHandler(feesRepo, studentRepo)

	auth := router.PathPrefix("/api/v1/auth").Subrouter()
	{
		auth.HandleFunc("/register", authHandler.Register).Methods("POST")
		auth.HandleFunc("/login", authHandler.Login).Methods("POST")
		auth.HandleFunc("/refresh", authHandler.RefreshToken).Methods("POST")
	}

	protected := router.PathPrefix("/api/v1").Subrouter()
	protected.Use(middleware.AuthMiddleware(cfg))
	{
		protected.HandleFunc("/profile", authHandler.GetProfile).Methods("GET")
		protected.HandleFunc("/change-password", authHandler.ChangePassword).Methods("POST")

		// Dashboard
		protected.HandleFunc("/dashboard/stats", dashboardHandler.GetStats).Methods("GET")
		protected.HandleFunc("/dashboard/attendance/weekly", dashboardHandler.GetWeeklyAttendance).Methods("GET")
		protected.HandleFunc("/dashboard/performance", dashboardHandler.GetPerformance).Methods("GET")
		protected.HandleFunc("/dashboard/exams/upcoming", dashboardHandler.GetUpcomingExams).Methods("GET")
		protected.HandleFunc("/dashboard/fees/pending", dashboardHandler.GetPendingFees).Methods("GET")
		protected.HandleFunc("/dashboard/notifications", dashboardHandler.GetNotifications).Methods("GET")

		// Fees
		protected.HandleFunc("/fees", feesHandler.List).Methods("GET")
		protected.HandleFunc("/fees", feesHandler.Create).Methods("POST")
		protected.HandleFunc("/fees/{id}", feesHandler.GetByID).Methods("GET")
		protected.HandleFunc("/fees/{id}", feesHandler.Update).Methods("PUT")
		protected.HandleFunc("/fees/{id}", feesHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/fees/{id}/pay", feesHandler.PayFee).Methods("POST")
		protected.HandleFunc("/fees/{id}/receipt", feesHandler.GetReceipt).Methods("GET")
		protected.HandleFunc("/students/{student_id}/fees", feesHandler.GetStudentFees).Methods("GET")
		protected.HandleFunc("/students/{student_id}/fees/summary", feesHandler.GetFeeSummary).Methods("GET")

		// Classes
		protected.HandleFunc("/classes", classHandler.List).Methods("GET")
		protected.HandleFunc("/classes", classHandler.Create).Methods("POST")
		protected.HandleFunc("/classes/{id}", classHandler.GetByID).Methods("GET")
		protected.HandleFunc("/classes/{id}", classHandler.Update).Methods("PUT")
		protected.HandleFunc("/classes/{id}", classHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/classes/{id}/info", classHandler.GetClassInfo).Methods("GET")
		protected.HandleFunc("/grade-levels/{grade_level}/classes", classHandler.GetByGradeLevel).Methods("GET")

		// Teachers
		protected.HandleFunc("/teachers", teacherHandler.List).Methods("GET")
		protected.HandleFunc("/teachers", teacherHandler.Create).Methods("POST")
		protected.HandleFunc("/teachers/{id}", teacherHandler.GetByID).Methods("GET")
		protected.HandleFunc("/teachers/{id}", teacherHandler.Update).Methods("PUT")
		protected.HandleFunc("/teachers/{id}", teacherHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/teachers/{id}/classes", teacherHandler.GetAssignedClasses).Methods("GET")
		protected.HandleFunc("/teachers/specialization", teacherHandler.GetBySpecialization).Methods("GET")

		// Subjects
		protected.HandleFunc("/subjects", subjectHandler.List).Methods("GET")
		protected.HandleFunc("/subjects", subjectHandler.Create).Methods("POST")
		protected.HandleFunc("/subjects/{id}", subjectHandler.GetByID).Methods("GET")
		protected.HandleFunc("/subjects/{id}", subjectHandler.Update).Methods("PUT")
		protected.HandleFunc("/subjects/{id}", subjectHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/subjects/code/{code}", subjectHandler.GetByCode).Methods("GET")
		protected.HandleFunc("/subjects/search", subjectHandler.Search).Methods("GET")

		// Students
		protected.HandleFunc("/students", studentHandler.List).Methods("GET")
		protected.HandleFunc("/students", studentHandler.Create).Methods("POST")
		protected.HandleFunc("/students/{id}", studentHandler.GetByID).Methods("GET")
		protected.HandleFunc("/students/{id}", studentHandler.Update).Methods("PUT")
		protected.HandleFunc("/students/{id}", studentHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/students/{id}/performance", studentHandler.GetPerformance).Methods("GET")
		protected.HandleFunc("/classes/{class_id}/students", studentHandler.GetByClassID).Methods("GET")

		// Exams
		protected.HandleFunc("/exams", examHandler.List).Methods("GET")
		protected.HandleFunc("/exams", examHandler.Create).Methods("POST")
		protected.HandleFunc("/exams/{id}", examHandler.GetByID).Methods("GET")
		protected.HandleFunc("/exams/{id}", examHandler.Update).Methods("PUT")
		protected.HandleFunc("/exams/{id}", examHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/exams/upcoming", examHandler.GetUpcomingExams).Methods("GET")
		protected.HandleFunc("/classes/{class_id}/exams", examHandler.GetByClassID).Methods("GET")

		// Exam Results
		protected.HandleFunc("/exam-results", examResultHandler.Create).Methods("POST")
		protected.HandleFunc("/exam-results/{id}", examResultHandler.GetByID).Methods("GET")
		protected.HandleFunc("/exam-results/{id}", examResultHandler.Update).Methods("PUT")
		protected.HandleFunc("/exam-results/{id}", examResultHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/exams/{exam_id}/results", examResultHandler.GetByExamID).Methods("GET")
		protected.HandleFunc("/exams/{exam_id}/results/stats", examResultHandler.GetExamStats).Methods("GET")
		protected.HandleFunc("/students/{student_id}/results", examResultHandler.GetByStudentID).Methods("GET")
		protected.HandleFunc("/students/{student_id}/gpa", examResultHandler.GetStudentGPA).Methods("GET")
		protected.HandleFunc("/exams/{exam_id}/students/{student_id}/result", examResultHandler.GetStudentExamResult).Methods("GET")

		// Attendance
		protected.HandleFunc("/attendance", attendanceHandler.Create).Methods("POST")
		protected.HandleFunc("/attendance/{id}", attendanceHandler.GetByID).Methods("GET")
		protected.HandleFunc("/attendance/{id}", attendanceHandler.Update).Methods("PUT")
		protected.HandleFunc("/attendance/{id}", attendanceHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/students/{student_id}/attendance", attendanceHandler.GetStudentAttendance).Methods("GET")
		protected.HandleFunc("/students/{student_id}/attendance/summary", attendanceHandler.GetAttendanceSummary).Methods("GET")
		protected.HandleFunc("/classes/{class_id}/attendance", attendanceHandler.GetClassAttendance).Methods("GET")

		// Parents/Guardians
		protected.HandleFunc("/parents", parentHandler.List).Methods("GET")
		protected.HandleFunc("/parents", parentHandler.Create).Methods("POST")
		protected.HandleFunc("/parents/{id}", parentHandler.GetByID).Methods("GET")
		protected.HandleFunc("/parents/{id}", parentHandler.Update).Methods("PUT")
		protected.HandleFunc("/parents/{id}", parentHandler.Delete).Methods("DELETE")
		protected.HandleFunc("/students/{student_id}/parents", parentHandler.GetByStudentID).Methods("GET")
		protected.HandleFunc("/parents/email", parentHandler.GetByEmail).Methods("GET")
		protected.HandleFunc("/parents/phone", parentHandler.GetByPhone).Methods("GET")
	}

	router.HandleFunc("/api/v1/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(200)
		w.Write([]byte(`{"status":"ok"}`))
	}).Methods("GET")
}
