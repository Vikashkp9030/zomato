package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/vikashkp9030/zomato/services/delivery-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type DeliveryHandler struct {
	usecase *usecase.DeliveryUsecase
}

func NewDeliveryHandler(usecase *usecase.DeliveryUsecase) *DeliveryHandler {
	return &DeliveryHandler{usecase}
}

func (h *DeliveryHandler) AssignDelivery(c *gin.Context) {
	var input usecase.AssignDeliveryInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	delivery, err := h.usecase.AssignDelivery(c.Request.Context(), input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, delivery)
}

func (h *DeliveryHandler) TrackDelivery(c *gin.Context) {
	orderID := c.Param("orderId")

	delivery, err := h.usecase.GetDelivery(c.Request.Context(), orderID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, delivery)
}

func (h *DeliveryHandler) UpdatePartnerLocation(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input struct {
		OrderID   string  `json:"order_id" binding:"required"`
		Latitude  float64 `json:"latitude" binding:"required"`
		Longitude float64 `json:"longitude" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdatePartnerLocation(c.Request.Context(), userID.(string), input.OrderID, input.Latitude, input.Longitude)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "location updated"})
}

func (h *DeliveryHandler) UpdatePartnerStatus(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input struct {
		Status string `json:"status" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdatePartnerStatus(c.Request.Context(), userID.(string), input.Status)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "status updated"})
}

func (h *DeliveryHandler) GetPartnerEarnings(c *gin.Context) {
	userID, _ := c.Get("user_id")

	earnings, err := h.usecase.GetPartnerEarnings(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, earnings)
}

func (h *DeliveryHandler) GetPartnerOrders(c *gin.Context) {
	userID, _ := c.Get("user_id")

	orders, err := h.usecase.GetPartnerOrders(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, orders)
}

func (h *DeliveryHandler) AcceptOrder(c *gin.Context) {
	userID, _ := c.Get("user_id")
	orderID := c.Param("orderId")

	err := h.usecase.AcceptOrder(c.Request.Context(), userID.(string), orderID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "order accepted"})
}

func (h *DeliveryHandler) RejectOrder(c *gin.Context) {
	userID, _ := c.Get("user_id")
	orderID := c.Param("orderId")

	err := h.usecase.RejectOrder(c.Request.Context(), userID.(string), orderID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "order rejected"})
}

func (h *DeliveryHandler) CompleteOrder(c *gin.Context) {
	userID, _ := c.Get("user_id")
	orderID := c.Param("orderId")

	err := h.usecase.CompleteOrder(c.Request.Context(), userID.(string), orderID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "order completed"})
}
