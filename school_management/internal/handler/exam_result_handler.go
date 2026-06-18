package handler

import (
	"context"
	"encoding/json"
	"net/http"
	"strconv"
	"time"

	"github.com/gorilla/mux"
	"school-management/internal/models"
	"school-management/internal/repository"
	"school-management/internal/utils"
)

type ExamResultHandler struct {
	repo *repository.ExamResultRepository
}

func NewExamResultHandler(repo *repository.ExamResultRepository) *ExamResultHandler {
	return &ExamResultHandler{repo: repo}
}

type CreateExamResultRequest struct {
	ExamID         int     `json:"exam_id" validate:"required"`
	StudentID      int     `json:"student_id" validate:"required"`
	MarksObtained  float64 `json:"marks_obtained" validate:"required,min=0"`
	Grade          string  `json:"grade" validate:"max=5"`
	Status         string  `json:"status" validate:"required,oneof=pass fail"`
	Attempt        int     `json:"attempt" validate:"min=1"`
}

type UpdateExamResultRequest struct {
	MarksObtained float64 `json:"marks_obtained" validate:"min=0"`
	Grade         string  `json:"grade" validate:"max=5"`
	Status        string  `json:"status" validate:"oneof=pass fail"`
	Attempt       int     `json:"attempt" validate:"min=1"`
}

func (h *ExamResultHandler) Create(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	var req CreateExamResultRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.ExamID == 0 || req.StudentID == 0 || req.Status == "" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Missing required fields", "")
		return
	}

	result := &models.ExamResult{
		ExamID:        req.ExamID,
		StudentID:     req.StudentID,
		MarksObtained: req.MarksObtained,
		Grade:         req.Grade,
		Status:        req.Status,
		Attempt:       req.Attempt,
	}

	if result.Attempt == 0 {
		result.Attempt = 1
	}

	id, err := h.repo.Create(ctx, result)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create exam result", "")
		return
	}

	result.ID = int(id)
	result.CreatedAt = time.Now()
	result.UpdatedAt = time.Now()

	utils.SuccessResponse(w, http.StatusCreated, "Exam result created successfully", result)
}

func (h *ExamResultHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid result ID", "")
		return
	}

	result, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Exam result not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exam result retrieved successfully", result)
}

func (h *ExamResultHandler) GetByExamID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	examID, err := strconv.Atoi(vars["exam_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid exam ID", "")
		return
	}

	page := 1
	limit := 10

	if pageStr := r.URL.Query().Get("page"); pageStr != "" {
		if p, err := strconv.Atoi(pageStr); err == nil && p > 0 {
			page = p
		}
	}

	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 && l <= 100 {
			limit = l
		}
	}

	offset := (page - 1) * limit

	results, err := h.repo.GetByExamID(ctx, examID, limit, offset)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve exam results", "")
		return
	}

	response := map[string]interface{}{
		"data":   results,
		"page":   page,
		"limit":  limit,
		"count":  len(results),
	}

	utils.SuccessResponse(w, http.StatusOK, "Exam results retrieved successfully", response)
}

func (h *ExamResultHandler) GetByStudentID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	studentID, err := strconv.Atoi(vars["student_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	page := 1
	limit := 10

	if pageStr := r.URL.Query().Get("page"); pageStr != "" {
		if p, err := strconv.Atoi(pageStr); err == nil && p > 0 {
			page = p
		}
	}

	if limitStr := r.URL.Query().Get("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 && l <= 100 {
			limit = l
		}
	}

	offset := (page - 1) * limit

	results, err := h.repo.GetByStudentID(ctx, studentID, limit, offset)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve student results", "")
		return
	}

	response := map[string]interface{}{
		"data":        results,
		"student_id":  studentID,
		"page":        page,
		"limit":       limit,
		"count":       len(results),
	}

	utils.SuccessResponse(w, http.StatusOK, "Student results retrieved successfully", response)
}

func (h *ExamResultHandler) Update(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid result ID", "")
		return
	}

	result, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Exam result not found", "")
		return
	}

	var req UpdateExamResultRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.MarksObtained != 0 {
		result.MarksObtained = req.MarksObtained
	}
	if req.Grade != "" {
		result.Grade = req.Grade
	}
	if req.Status != "" {
		result.Status = req.Status
	}
	if req.Attempt != 0 {
		result.Attempt = req.Attempt
	}

	if err := h.repo.Update(ctx, result); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update exam result", "")
		return
	}

	result.UpdatedAt = time.Now()
	utils.SuccessResponse(w, http.StatusOK, "Exam result updated successfully", result)
}

func (h *ExamResultHandler) Delete(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid result ID", "")
		return
	}

	if err := h.repo.Delete(ctx, id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete exam result", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exam result deleted successfully", nil)
}

func (h *ExamResultHandler) GetExamStats(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	examID, err := strconv.Atoi(vars["exam_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid exam ID", "")
		return
	}

	stats, err := h.repo.GetExamStats(ctx, examID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve exam statistics", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exam statistics retrieved successfully", stats)
}

func (h *ExamResultHandler) GetStudentGPA(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	studentID, err := strconv.Atoi(vars["student_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	gpa, err := h.repo.GetStudentGPA(ctx, studentID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to calculate GPA", "")
		return
	}

	response := map[string]interface{}{
		"student_id": studentID,
		"gpa":        gpa,
	}

	utils.SuccessResponse(w, http.StatusOK, "Student GPA retrieved successfully", response)
}

func (h *ExamResultHandler) GetStudentExamResult(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	examID, err := strconv.Atoi(vars["exam_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid exam ID", "")
		return
	}

	studentID, err := strconv.Atoi(vars["student_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	result, err := h.repo.GetStudentExamResult(ctx, examID, studentID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Exam result not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exam result retrieved successfully", result)
}
