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

type ParentHandler struct {
	repo *repository.ParentRepository
}

func NewParentHandler(repo *repository.ParentRepository) *ParentHandler {
	return &ParentHandler{repo: repo}
}

type CreateParentRequest struct {
	StudentID   int    `json:"student_id" validate:"required"`
	ParentName  string `json:"parent_name" validate:"required,max=100"`
	Relationship string `json:"relationship" validate:"required,max=50"`
	Phone       string `json:"phone" validate:"required,max=20"`
	Email       string `json:"email" validate:"email"`
	Occupation  string `json:"occupation" validate:"max=100"`
}

type UpdateParentRequest struct {
	StudentID    int    `json:"student_id"`
	ParentName   string `json:"parent_name" validate:"max=100"`
	Relationship string `json:"relationship" validate:"max=50"`
	Phone        string `json:"phone" validate:"max=20"`
	Email        string `json:"email" validate:"email"`
	Occupation   string `json:"occupation" validate:"max=100"`
}

func (h *ParentHandler) Create(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	var req CreateParentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.StudentID == 0 || req.ParentName == "" || req.Relationship == "" || req.Phone == "" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Missing required fields", "")
		return
	}

	parent := &models.Parent{
		StudentID:    req.StudentID,
		ParentName:   req.ParentName,
		Relationship: req.Relationship,
		Phone:        req.Phone,
		Email:        req.Email,
		Occupation:   req.Occupation,
	}

	id, err := h.repo.Create(ctx, parent)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create parent record", "")
		return
	}

	parent.ID = int(id)
	parent.CreatedAt = time.Now()
	parent.UpdatedAt = time.Now()

	utils.SuccessResponse(w, http.StatusCreated, "Parent record created successfully", parent)
}

func (h *ParentHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid parent ID", "")
		return
	}

	parent, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Parent record not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Parent record retrieved successfully", parent)
}

func (h *ParentHandler) GetByStudentID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	studentID, err := strconv.Atoi(vars["student_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	parents, err := h.repo.GetByStudentID(ctx, studentID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve parent records", "")
		return
	}

	response := map[string]interface{}{
		"student_id": studentID,
		"parents":    parents,
		"count":      len(parents),
	}

	utils.SuccessResponse(w, http.StatusOK, "Parent records retrieved successfully", response)
}

func (h *ParentHandler) List(w http.ResponseWriter, r *http.Request) {
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

	parents, err := h.repo.GetAll(ctx, limit, offset)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve parent records", "")
		return
	}

	total, err := h.repo.GetCount(ctx)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to get total count", "")
		return
	}

	response := map[string]interface{}{
		"data":       parents,
		"total":      total,
		"page":       page,
		"limit":      limit,
		"totalPages": (total + limit - 1) / limit,
	}

	utils.SuccessResponse(w, http.StatusOK, "Parent records retrieved successfully", response)
}

func (h *ParentHandler) Update(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid parent ID", "")
		return
	}

	parent, err := h.repo.GetByID(ctx, id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Parent record not found", "")
		return
	}

	var req UpdateParentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request body", "")
		return
	}

	if req.StudentID != 0 {
		parent.StudentID = req.StudentID
	}
	if req.ParentName != "" {
		parent.ParentName = req.ParentName
	}
	if req.Relationship != "" {
		parent.Relationship = req.Relationship
	}
	if req.Phone != "" {
		parent.Phone = req.Phone
	}
	if req.Email != "" {
		parent.Email = req.Email
	}
	if req.Occupation != "" {
		parent.Occupation = req.Occupation
	}

	if err := h.repo.Update(ctx, parent); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update parent record", "")
		return
	}

	parent.UpdatedAt = time.Now()
	utils.SuccessResponse(w, http.StatusOK, "Parent record updated successfully", parent)
}

func (h *ParentHandler) Delete(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid parent ID", "")
		return
	}

	if err := h.repo.Delete(ctx, id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete parent record", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Parent record deleted successfully", nil)
}

func (h *ParentHandler) GetByEmail(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	email := r.URL.Query().Get("email")
	if email == "" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Email parameter is required", "")
		return
	}

	parents, err := h.repo.GetByEmail(ctx, email)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve parent records", "")
		return
	}

	response := map[string]interface{}{
		"email":   email,
		"parents": parents,
		"count":   len(parents),
	}

	utils.SuccessResponse(w, http.StatusOK, "Parent records retrieved successfully", response)
}

func (h *ParentHandler) GetByPhone(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	phone := r.URL.Query().Get("phone")
	if phone == "" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Phone parameter is required", "")
		return
	}

	parents, err := h.repo.GetByPhone(ctx, phone)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve parent records", "")
		return
	}

	response := map[string]interface{}{
		"phone":   phone,
		"parents": parents,
		"count":   len(parents),
	}

	utils.SuccessResponse(w, http.StatusOK, "Parent records retrieved successfully", response)
}
