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

type StudentHandler struct {
	studentRepo *repository.StudentRepository
}

func NewStudentHandler(studentRepo *repository.StudentRepository) *StudentHandler {
	return &StudentHandler{studentRepo: studentRepo}
}

func (h *StudentHandler) Create(w http.ResponseWriter, r *http.Request) {
	var student models.Student
	if err := json.NewDecoder(r.Body).Decode(&student); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	if student.EnrollmentDate.IsZero() {
		student.EnrollmentDate = time.Now()
	}

	if err := h.studentRepo.Create(&student); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create student", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusCreated, "Student created successfully", student)
}

func (h *StudentHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	student, err := h.studentRepo.GetByID(id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Student not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Student retrieved successfully", student)
}

func (h *StudentHandler) GetByClassID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	classID, err := strconv.Atoi(vars["class_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid class ID", "")
		return
	}

	students, err := h.studentRepo.GetByClassID(classID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve students", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Students retrieved successfully", students)
}

func (h *StudentHandler) List(w http.ResponseWriter, r *http.Request) {
	limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))
	offset, _ := strconv.Atoi(r.URL.Query().Get("offset"))

	if limit <= 0 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}

	students, err := h.studentRepo.List(limit, offset)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve students", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Students retrieved successfully", students)
}

func (h *StudentHandler) Update(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	var student models.Student
	if err := json.NewDecoder(r.Body).Decode(&student); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	student.ID = id
	if err := h.studentRepo.Update(&student); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update student", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Student updated successfully", student)
}

func (h *StudentHandler) Delete(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	if err := h.studentRepo.Delete(id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete student", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Student deleted successfully", nil)
}

func (h *StudentHandler) GetPerformance(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	performance, err := h.studentRepo.GetStudentPerformance(id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve performance", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Performance retrieved successfully", performance)
}
