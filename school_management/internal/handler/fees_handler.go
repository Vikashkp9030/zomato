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

type FeesHandler struct {
	feesRepo  *repository.FeesRepository
	studentRepo *repository.StudentRepository
}

func NewFeesHandler(feesRepo *repository.FeesRepository, studentRepo *repository.StudentRepository) *FeesHandler {
	return &FeesHandler{
		feesRepo: feesRepo,
		studentRepo: studentRepo,
	}
}

func (h *FeesHandler) Create(w http.ResponseWriter, r *http.Request) {
	var fee models.Fee
	if err := json.NewDecoder(r.Body).Decode(&fee); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	fee.Status = "pending"
	fee.CreatedAt = time.Now()
	fee.UpdatedAt = time.Now()

	if err := h.feesRepo.Create(&fee); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create fee", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusCreated, "Fee created successfully", fee)
}

func (h *FeesHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid fee ID", "")
		return
	}

	fee, err := h.feesRepo.GetByID(id)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Fee not found", "")
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Fee retrieved successfully", fee)
}

func (h *FeesHandler) List(w http.ResponseWriter, r *http.Request) {
	limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))
	page, _ := strconv.Atoi(r.URL.Query().Get("page"))
	status := r.URL.Query().Get("status")

	if limit <= 0 {
		limit = 10
	}
	if page < 1 {
		page = 1
	}

	offset := (page - 1) * limit

	fees, err := h.feesRepo.List(limit, offset, status)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve fees", err.Error())
		return
	}

	if fees == nil {
		fees = []*models.Fee{}
	}

	response := map[string]interface{}{
		"success": true,
		"data":    fees,
		"page":    page,
		"limit":   limit,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func (h *FeesHandler) GetStudentFees(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	studentID, err := strconv.Atoi(vars["student_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	fees, err := h.feesRepo.GetByStudentID(studentID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve student fees", err.Error())
		return
	}

	if fees == nil {
		fees = []*models.Fee{}
	}

	utils.SuccessResponse(w, http.StatusOK, "Student fees retrieved successfully", fees)
}

func (h *FeesHandler) GetFeeSummary(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	studentID, err := strconv.Atoi(vars["student_id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid student ID", "")
		return
	}

	summary, err := h.feesRepo.GetStudentFeesSummary(studentID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to retrieve fee summary", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Fee summary retrieved successfully", summary)
}

func (h *FeesHandler) PayFee(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	feeID, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid fee ID", "")
		return
	}

	var paymentData map[string]interface{}
	if err := json.NewDecoder(r.Body).Decode(&paymentData); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	fee, err := h.feesRepo.GetByID(feeID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Fee not found", "")
		return
	}

	// Update fee status to paid
	now := time.Now()
	fee.PaidDate = &now
	fee.Status = "paid"

	if paymentMethod, ok := paymentData["payment_method"].(string); ok {
		fee.PaymentMethod = paymentMethod
	}
	if transactionID, ok := paymentData["transaction_id"].(string); ok {
		fee.TransactionID = transactionID
	}

	if err := h.feesRepo.Update(fee); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update fee", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Fee paid successfully", fee)
}

func (h *FeesHandler) GetReceipt(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	feeID, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid fee ID", "")
		return
	}

	fee, err := h.feesRepo.GetByID(feeID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Fee not found", "")
		return
	}

	if fee.Status != "paid" {
		utils.ErrorResponse(w, http.StatusBadRequest, "Fee is not paid", "")
		return
	}

	student, err := h.studentRepo.GetByID(fee.StudentID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "Student not found", "")
		return
	}

	receipt := models.FeeReceipt{
		ID:            fee.ID,
		StudentName:   student.FirstName + " " + student.LastName,
		Amount:        fee.Amount,
		PaidDate:      *fee.PaidDate,
		TransactionID: fee.TransactionID,
		PaymentMethod: fee.PaymentMethod,
	}

	utils.SuccessResponse(w, http.StatusOK, "Receipt generated successfully", receipt)
}

func (h *FeesHandler) Update(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid fee ID", "")
		return
	}

	var fee models.Fee
	if err := json.NewDecoder(r.Body).Decode(&fee); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	fee.ID = id
	fee.UpdatedAt = time.Now()

	if err := h.feesRepo.Update(&fee); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update fee", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Fee updated successfully", fee)
}

func (h *FeesHandler) Delete(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid fee ID", "")
		return
	}

	if err := h.feesRepo.Delete(id); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to delete fee", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Fee deleted successfully", nil)
}