package handler

import (
	"encoding/json"
	"net/http"
	"strconv"
	"time"

	"github.com/gorilla/mux"
	"school-management/internal/models"
	"school-management/internal/repository"
	"school-management/internal/utils"
)

type AttendanceHandler struct {
	attendanceRepo *repository.AttendanceRepository
}

func NewAttendanceHandler(attendanceRepo *repository.AttendanceRepository) *AttendanceHandler {
	return &AttendanceHandler{attendanceRepo: attendanceRepo}
}

func (h *AttendanceHandler) Create(w http.ResponseWriter, r *http.Request) {
	var attendance models.Attendance
	if err := json.NewDecoder(r.Body).Decode(&attendance); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	if attendance.AttendanceDate.IsZero() {
		attendance.AttendanceDate = time.Now()
	}

	if err := h.attendanceRepo.Create(&attendance); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create attendance", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusCreated, "Attendance recorded successfully", attendance)
}

func (h *AttendanceHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid attendance ID", "")
		return
	}

	attendance, err := h.attendanceRepo.GetByID(id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Attendance record not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Attendance retrieved successfully", attendance)
}

func (h *AttendanceHandler) GetStudentAttendance(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	studentID, err := strconv.Atoi(vars["student_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	startDateStr := r.URL.Query().Get("start_date")
	endDateStr := r.URL.Query().Get("end_date")

	startDate := time.Now().AddDate(0, -1, 0)
	endDate := time.Now()

	if startDateStr != "" {
		if t, err := time.Parse("2006-01-02", startDateStr); err == nil {
			startDate = t
		}
	}

	if endDateStr != "" {
		if t, err := time.Parse("2006-01-02", endDateStr); err == nil {
			endDate = t
		}
	}

	attendances, err := h.attendanceRepo.GetStudentAttendance(studentID, startDate, endDate)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve attendance", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Attendance retrieved successfully", attendances)
}

func (h *AttendanceHandler) GetClassAttendance(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	classID, err := strconv.Atoi(vars["class_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid class ID", "")
		return
	}

	dateStr := r.URL.Query().Get("date")
	attendanceDate := time.Now()

	if dateStr != "" {
		if t, err := time.Parse("2006-01-02", dateStr); err == nil {
			attendanceDate = t
		}
	}

	attendances, err := h.attendanceRepo.GetClassAttendance(classID, attendanceDate)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve attendance", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Class attendance retrieved successfully", attendances)
}

func (h *AttendanceHandler) GetAttendanceSummary(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	studentID, err := strconv.Atoi(vars["student_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	summary, err := h.attendanceRepo.GetAttendanceSummary(studentID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve summary", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Attendance summary retrieved successfully", summary)
}

func (h *AttendanceHandler) Update(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid attendance ID", "")
		return
	}

	var attendance models.Attendance
	if err := json.NewDecoder(r.Body).Decode(&attendance); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	attendance.ID = id
	if err := h.attendanceRepo.Update(&attendance); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update attendance", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Attendance updated successfully", attendance)
}

func (h *AttendanceHandler) Delete(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid attendance ID", "")
		return
	}

	if err := h.attendanceRepo.Delete(id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete attendance", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Attendance deleted successfully", nil)
}
