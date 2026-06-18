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

type ExamHandler struct {
	examRepo *repository.ExamRepository
}

func NewExamHandler(examRepo *repository.ExamRepository) *ExamHandler {
	return &ExamHandler{examRepo: examRepo}
}

func (h *ExamHandler) Create(w http.ResponseWriter, r *http.Request) {
	var exam models.Exam
	if err := json.NewDecoder(r.Body).Decode(&exam); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	if err := h.examRepo.Create(&exam); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create exam", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusCreated, "Exam created successfully", exam)
}

func (h *ExamHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid exam ID", "")
		return
	}

	exam, err := h.examRepo.GetByID(id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Exam not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exam retrieved successfully", exam)
}

func (h *ExamHandler) GetByClassID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	classID, err := strconv.Atoi(vars["class_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid class ID", "")
		return
	}

	exams, err := h.examRepo.GetByClassID(classID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve exams", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exams retrieved successfully", exams)
}

func (h *ExamHandler) List(w http.ResponseWriter, r *http.Request) {
	limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))
	offset, _ := strconv.Atoi(r.URL.Query().Get("offset"))

	if limit <= 0 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}

	exams, err := h.examRepo.List(limit, offset)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve exams", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exams retrieved successfully", exams)
}

func (h *ExamHandler) Update(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid exam ID", "")
		return
	}

	var exam models.Exam
	if err := json.NewDecoder(r.Body).Decode(&exam); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	exam.ID = id
	if err := h.examRepo.Update(&exam); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update exam", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exam updated successfully", exam)
}

func (h *ExamHandler) Delete(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid exam ID", "")
		return
	}

	if err := h.examRepo.Delete(id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete exam", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Exam deleted successfully", nil)
}

func (h *ExamHandler) GetUpcomingExams(w http.ResponseWriter, r *http.Request) {
	rows, err := h.examRepo.GetByClassID(0)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve exams", err.Error())
		return
	}

	filteredExams := []*models.Exam{}
	for _, exam := range rows {
		if exam.ExamDate.After(time.Now()) {
			filteredExams = append(filteredExams, exam)
		}
	}

	utils.SuccessResponse(w, http.StatusOK, "Upcoming exams retrieved successfully", filteredExams)
}
