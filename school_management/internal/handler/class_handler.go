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

type ClassHandler struct {
	repo *repository.ClassRepository
}

func NewClassHandler(repo *repository.ClassRepository) *ClassHandler {
	return &ClassHandler{repo: repo}
}

type CreateClassRequest struct {
	ClassName     string `json:"class_name" validate:"required,max=100"`
	GradeLevel    int    `json:"grade_level" validate:"required,min=1,max=12"`
	Section       string `json:"section" validate:"required,max=10"`
	Capacity      int    `json:"capacity" validate:"required,min=1,max=100"`
	ClassTeacherID int   `json:"class_teacher_id"`
	RoomNumber    string `json:"room_number" validate:"max=20"`
}

type UpdateClassRequest struct {
	ClassName      string `json:"class_name" validate:"max=100"`
	GradeLevel     int    `json:"grade_level" validate:"min=1,max=12"`
	Section        string `json:"section" validate:"max=10"`
	Capacity       int    `json:"capacity" validate:"min=1,max=100"`
	ClassTeacherID int    `json:"class_teacher_id"`
	RoomNumber     string `json:"room_number" validate:"max=20"`
}

func (h *ClassHandler) Create(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	var req CreateClassRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	if req.ClassName == "" || req.Section == "" || req.Capacity == 0 {
		utils.ErrorResponse(w, http.StatusBadRequest, "Missing required fields", "Required fields not provided")
		return
	}

	class := &models.Class{
		ClassName:      req.ClassName,
		GradeLevel:     req.GradeLevel,
		Section:        req.Section,
		Capacity:       req.Capacity,
		ClassTeacherID: req.ClassTeacherID,
		RoomNumber:     req.RoomNumber,
	}

	id, err := h.repo.Create(ctx, class)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create class", err.Error())
		return
	}

	class.ID = int(id)
	class.CreatedAt = time.Now()
	class.UpdatedAt = time.Now()

	utils.SuccessResponse(w, http.StatusCreated, "Class created successfully", class)
}

func (h *ClassHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid class ID", "")
		return
	}

	class, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Class not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Class retrieved successfully", class)
}

func (h *ClassHandler) List(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

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

	classes, err := h.repo.GetAll(ctx, limit, offset)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve classes", "")
		return
	}

	total, err := h.repo.GetCount(ctx)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to get total count", "")
		return
	}

	response := map[string]interface{}{
		"data":       classes,
		"total":      total,
		"page":       page,
		"limit":      limit,
		"totalPages": (total + limit - 1) / limit,
	}

	utils.SuccessResponse(w, http.StatusOK, "Classes retrieved successfully", response)
}

func (h *ClassHandler) Update(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid class ID", "")
		return
	}

	class, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Class not found", "")
		return
	}

	var req UpdateClassRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.ClassName != "" {
		class.ClassName = req.ClassName
	}
	if req.GradeLevel != 0 {
		class.GradeLevel = req.GradeLevel
	}
	if req.Section != "" {
		class.Section = req.Section
	}
	if req.Capacity != 0 {
		class.Capacity = req.Capacity
	}
	if req.ClassTeacherID != 0 {
		class.ClassTeacherID = req.ClassTeacherID
	}
	if req.RoomNumber != "" {
		class.RoomNumber = req.RoomNumber
	}

	if err := h.repo.Update(ctx, class); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update class", "")
		return
	}

	class.UpdatedAt = time.Now()
	utils.SuccessResponse(w, http.StatusOK, "Class updated successfully", class)
}

func (h *ClassHandler) Delete(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid class ID", "")
		return
	}

	if err := h.repo.Delete(ctx, id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete class", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Class deleted successfully", nil)
}

func (h *ClassHandler) GetByGradeLevel(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	gradeLevel, err := strconv.Atoi(vars["grade_level"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid grade level", "")
		return
	}

	classes, err := h.repo.GetByGradeLevel(ctx, gradeLevel)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve classes", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Classes retrieved successfully", classes)
}

func (h *ClassHandler) GetClassInfo(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	classID, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid class ID", "")
		return
	}

	class, err := h.repo.GetByID(ctx, classID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Class not found", "")
		return
	}

	studentCount, err := h.repo.GetStudentCount(ctx, classID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to get student count", "")
		return
	}

	info := map[string]interface{}{
		"class":          class,
		"studentCount":   studentCount,
		"availableSeats": class.Capacity - studentCount,
	}

	utils.SuccessResponse(w, http.StatusOK, "Class information retrieved", info)
}
