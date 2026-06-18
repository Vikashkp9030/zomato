package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/vikashkp9030/zomato/services/payment-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type PaymentHandler struct {
	usecase *usecase.PaymentUsecase
}

func NewPaymentHandler(usecase *usecase.PaymentUsecase) *PaymentHandler {
	return &PaymentHandler{usecase}
}

func (h *PaymentHandler) InitiatePayment(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input usecase.InitiatePaymentInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	payment, err := h.usecase.InitiatePayment(c.Request.Context(), userID.(string), input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, payment)
}

func (h *PaymentHandler) ConfirmPayment(c *gin.Context) {
	var input struct {
		PaymentID string `json:"payment_id" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.ConfirmPayment(c.Request.Context(), input.PaymentID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "payment confirmed"})
}

func (h *PaymentHandler) GetPayment(c *gin.Context) {
	id := c.Param("id")

	payment, err := h.usecase.GetPayment(c.Request.Context(), id)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, payment)
}

func (h *PaymentHandler) GetHistory(c *gin.Context) {
	userID, _ := c.Get("user_id")

	payments, err := h.usecase.GetPaymentHistory(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, payments)
}

func (h *PaymentHandler) RefundPayment(c *gin.Context) {
	var input struct {
		PaymentID string  `json:"payment_id" binding:"required"`
		Amount    float64 `json:"amount" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.RefundPayment(c.Request.Context(), input.PaymentID, input.Amount)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "refund initiated"})
}

func (h *PaymentHandler) GetWalletBalance(c *gin.Context) {
	userID, _ := c.Get("user_id")

	balance, err := h.usecase.GetWalletBalance(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"balance": balance})
}

func (h *PaymentHandler) AddToWallet(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input struct {
		Amount float64 `json:"amount" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.AddToWallet(c.Request.Context(), userID.(string), input.Amount)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "added to wallet"})
}

func (h *PaymentHandler) WithdrawFromWallet(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input struct {
		Amount float64 `json:"amount" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.WithdrawFromWallet(c.Request.Context(), userID.(string), input.Amount)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "withdrawn from wallet"})
}

func (h *PaymentHandler) GetPaymentMethods(c *gin.Context) {
	userID, _ := c.Get("user_id")

	methods, err := h.usecase.GetPaymentMethods(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, methods)
}

func (h *PaymentHandler) AddPaymentMethod(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input struct {
		Type    string `json:"type" binding:"required"`
		Details string `json:"details" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.AddPaymentMethod(c.Request.Context(), userID.(string), input.Type, input.Details)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "payment method added"})
}

func (h *PaymentHandler) DeletePaymentMethod(c *gin.Context) {
	id := c.Param("id")

	err := h.usecase.DeletePaymentMethod(c.Request.Context(), id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
