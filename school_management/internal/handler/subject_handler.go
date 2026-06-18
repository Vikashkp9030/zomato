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

type SubjectHandler struct {
	repo *repository.SubjectRepository
}

func NewSubjectHandler(repo *repository.SubjectRepository) *SubjectHandler {
	return &SubjectHandler{repo: repo}
}

type CreateSubjectRequest struct {
	SubjectName string `json:"subject_name" validate:"required,max=100"`
	SubjectCode string `json:"subject_code" validate:"required,max=20"`
	Credits     int    `json:"credits" validate:"required,min=1,max=10"`
	Description string `json:"description" validate:"max=500"`
}

type UpdateSubjectRequest struct {
	SubjectName string `json:"subject_name" validate:"max=100"`
	SubjectCode string `json:"subject_code" validate:"max=20"`
	Credits     int    `json:"credits" validate:"min=1,max=10"`
	Description string `json:"description" validate:"max=500"`
}

func (h *SubjectHandler) Create(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	var req CreateSubjectRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.SubjectName == "" || req.SubjectCode == "" || req.Credits == 0 {
		utils.ErrorResponse(w, http.StatusBadRequest, "Missing required fields", "")
		return
	}

	exists, err := h.repo.CheckCodeExists(ctx, req.SubjectCode)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to check subject code", "")
		return
	}
	if exists {
		utils.ErrorResponse(w, http.StatusConflict, "Subject code already exists", "")
		return
	}

	subject := &models.Subject{
		SubjectName: req.SubjectName,
		SubjectCode: req.SubjectCode,
		Credits:     req.Credits,
		Description: req.Description,
	}

	id, err := h.repo.Create(ctx, subject)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create subject", "")
		return
	}

	subject.ID = int(id)
	subject.CreatedAt = time.Now()
	subject.UpdatedAt = time.Now()

	utils.SuccessResponse(w, http.StatusCreated, "Subject created successfully", subject)
}

func (h *SubjectHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid subject ID", "")
		return
	}

	subject, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Subject not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Subject retrieved successfully", subject)
}

func (h *SubjectHandler) List(w http.ResponseWriter, r *http.Request) {
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

	subjects, err := h.repo.GetAll(ctx, limit, offset)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve subjects", "")
		return
	}

	total, err := h.repo.GetCount(ctx)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to get total count", "")
		return
	}

	response := map[string]interface{}{
		"data":       subjects,
		"total":      total,
		"page":       page,
		"limit":      limit,
		"totalPages": (total + limit - 1) / limit,
	}

	utils.SuccessResponse(w, http.StatusOK, "Subjects retrieved successfully", response)
}

func (h *SubjectHandler) Update(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid subject ID", "")
		return
	}

	subject, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Subject not found", "")
		return
	}

	var req UpdateSubjectRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.SubjectName != "" {
		subject.SubjectName = req.SubjectName
	}
	if req.SubjectCode != "" {
		subject.SubjectCode = req.SubjectCode
	}
	if req.Credits != 0 {
		subject.Credits = req.Credits
	}
	if req.Description != "" {
		subject.Description = req.Description
	}

	if err := h.repo.Update(ctx, subject); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update subject", "")
		return
	}

	subject.UpdatedAt = time.Now()
	utils.SuccessResponse(w, http.StatusOK, "Subject updated successfully", subject)
}

func (h *SubjectHandler) Delete(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid subject ID", "")
		return
	}

	if err := h.repo.Delete(ctx, id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete subject", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Subject deleted successfully", nil)
}

func (h *SubjectHandler) Search(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	keyword := r.URL.Query().Get("q")
	if keyword == "" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Search keyword is required", "")
		return
	}

	subjects, err := h.repo.Search(ctx, keyword)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to search subjects", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Subjects retrieved successfully", subjects)
}

func (h *SubjectHandler) GetByCode(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	code := vars["code"]
	if code == "" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Subject code is required", "")
		return
	}

	subject, err := h.repo.GetByCode(ctx, code)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Subject not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Subject retrieved successfully", subject)
}
