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

type TeacherHandler struct {
	repo *repository.TeacherRepository
}

func NewTeacherHandler(repo *repository.TeacherRepository) *TeacherHandler {
	return &TeacherHandler{repo: repo}
}

type CreateTeacherRequest struct {
	FirstName          string    `json:"first_name" validate:"required,max=100"`
	LastName           string    `json:"last_name" validate:"required,max=100"`
	Email              string    `json:"email" validate:"required,email"`
	Phone              string    `json:"phone" validate:"required,max=20"`
	HireDate           time.Time `json:"hire_date"`
	Specialization     string    `json:"specialization" validate:"required,max=100"`
	Salary             float64   `json:"salary"`
	ExperienceYears    int       `json:"experience_years"`
}

type UpdateTeacherRequest struct {
	FirstName       string    `json:"first_name" validate:"max=100"`
	LastName        string    `json:"last_name" validate:"max=100"`
	Email           string    `json:"email" validate:"email"`
	Phone           string    `json:"phone" validate:"max=20"`
	HireDate        time.Time `json:"hire_date"`
	Specialization  string    `json:"specialization" validate:"max=100"`
	Salary          float64   `json:"salary"`
	ExperienceYears int       `json:"experience_years"`
}

func (h *TeacherHandler) Create(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	var req CreateTeacherRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.FirstName == "" || req.LastName == "" || req.Email == "" || req.Phone == "" || req.Specialization == "" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Missing required fields", "")
		return
	}

	exists, err := h.repo.CheckEmailExists(ctx, req.Email)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to check email", "")
		return
	}
	if exists {
		utils.ErrorResponse(w, http.StatusConflict, "Email already exists", "")
		return
	}

	teacher := &models.Teacher{
		FirstName:       req.FirstName,
		LastName:        req.LastName,
		Email:           req.Email,
		Phone:           req.Phone,
		HireDate:        req.HireDate,
		Specialization:  req.Specialization,
		Salary:          req.Salary,
		ExperienceYears: req.ExperienceYears,
	}

	id, err := h.repo.Create(ctx, teacher)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create teacher", "")
		return
	}

	teacher.ID = int(id)
	teacher.CreatedAt = time.Now()
	teacher.UpdatedAt = time.Now()

	utils.SuccessResponse(w, http.StatusCreated, "Teacher created successfully", teacher)
}

func (h *TeacherHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid teacher ID", "")
		return
	}

	teacher, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Teacher not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Teacher retrieved successfully", teacher)
}

func (h *TeacherHandler) List(w http.ResponseWriter, r *http.Request) {
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

	teachers, err := h.repo.GetAll(ctx, limit, offset)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve teachers", "")
		return
	}

	total, err := h.repo.GetCount(ctx)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to get total count", "")
		return
	}

	response := map[string]interface{}{
		"data":       teachers,
		"total":      total,
		"page":       page,
		"limit":      limit,
		"totalPages": (total + limit - 1) / limit,
	}

	utils.SuccessResponse(w, http.StatusOK, "Teachers retrieved successfully", response)
}

func (h *TeacherHandler) Update(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid teacher ID", "")
		return
	}

	teacher, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Teacher not found", "")
		return
	}

	var req UpdateTeacherRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.FirstName != "" {
		teacher.FirstName = req.FirstName
	}
	if req.LastName != "" {
		teacher.LastName = req.LastName
	}
	if req.Email != "" {
		teacher.Email = req.Email
	}
	if req.Phone != "" {
		teacher.Phone = req.Phone
	}
	if !req.HireDate.IsZero() {
		teacher.HireDate = req.HireDate
	}
	if req.Specialization != "" {
		teacher.Specialization = req.Specialization
	}
	if req.Salary != 0 {
		teacher.Salary = req.Salary
	}
	if req.ExperienceYears != 0 {
		teacher.ExperienceYears = req.ExperienceYears
	}

	if err := h.repo.Update(ctx, teacher); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update teacher", "")
		return
	}

	teacher.UpdatedAt = time.Now()
	utils.SuccessResponse(w, http.StatusOK, "Teacher updated successfully", teacher)
}

func (h *TeacherHandler) Delete(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid teacher ID", "")
		return
	}

	if err := h.repo.Delete(ctx, id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete teacher", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Teacher deleted successfully", nil)
}

func (h *TeacherHandler) GetBySpecialization(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	specialization := r.URL.Query().Get("specialization")
	if specialization == "" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Specialization is required", "")
		return
	}

	teachers, err := h.repo.GetBySpecialization(ctx, specialization)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve teachers", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Teachers retrieved successfully", teachers)
}

func (h *TeacherHandler) GetAssignedClasses(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	teacherID, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid teacher ID", "")
		return
	}

	classes, err := h.repo.GetAssignedClasses(ctx, teacherID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve assigned classes", "")
		return
	}

	response := map[string]interface{}{
		"teacher_id": teacherID,
		"classes":    classes,
		"count":      len(classes),
	}

	utils.SuccessResponse(w, http.StatusOK, "Assigned classes retrieved successfully", response)
}
