package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/vikashkp9030/zomato/services/order-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type OrderHandler struct {
	usecase *usecase.OrderUsecase
}

func NewOrderHandler(usecase *usecase.OrderUsecase) *OrderHandler {
	return &OrderHandler{usecase}
}

func (h *OrderHandler) CreateOrder(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input usecase.CreateOrderInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	order, err := h.usecase.CreateOrder(c.Request.Context(), userID.(string), input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, order)
}

func (h *OrderHandler) ListOrders(c *gin.Context) {
	userID, _ := c.Get("user_id")

	orders, err := h.usecase.ListOrders(c.Request.Context(), userID.(string))
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

func (h *OrderHandler) GetOrder(c *gin.Context) {
	id := c.Param("id")

	order, err := h.usecase.GetOrder(c.Request.Context(), id)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, order)
}

func (h *OrderHandler) TrackOrder(c *gin.Context) {
	id := c.Param("id")

	order, err := h.usecase.GetOrder(c.Request.Context(), id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"order_id": order.ID,
		"status":   order.Status,
		"current_location": gin.H{
			"latitude":  28.6139,
			"longitude": 77.2090,
		},
		"estimated_arrival": 45,
	})
}

func (h *OrderHandler) UpdateOrderStatus(c *gin.Context) {
	id := c.Param("id")
	var input struct {
		Status string `json:"status" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdateOrderStatus(c.Request.Context(), id, input.Status)
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

func (h *OrderHandler) CancelOrder(c *gin.Context) {
	id := c.Param("id")

	err := h.usecase.CancelOrder(c.Request.Context(), id)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "order cancelled"})
}

func (h *OrderHandler) EstimateDelivery(c *gin.Context) {
	var input struct {
		RestaurantID string `json:"restaurant_id"`
		AddressID    string `json:"address_id"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result, err := h.usecase.EstimateDelivery(c.Request.Context(), input.RestaurantID, input.AddressID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, result)
}

// Cart handlers
func (h *OrderHandler) GetCart(c *gin.Context) {
	userID, _ := c.Get("user_id")

	cart, err := h.usecase.GetCart(c.Request.Context(), userID.(string))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, cart)
}

func (h *OrderHandler) AddToCart(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input struct {
		RestaurantID string  `json:"restaurant_id" binding:"required"`
		DishID       string  `json:"dish_id" binding:"required"`
		Quantity     int     `json:"quantity" binding:"required"`
		Price        float64 `json:"price" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.AddToCart(c.Request.Context(), userID.(string), input.RestaurantID, input.DishID, input.Quantity, input.Price)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "added to cart"})
}

func (h *OrderHandler) UpdateCartItem(c *gin.Context) {
	itemID := c.Param("itemId")
	var input struct {
		Quantity int `json:"quantity" binding:"required,min=1"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdateCartItem(c.Request.Context(), itemID, input.Quantity)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "updated"})
}

func (h *OrderHandler) RemoveFromCart(c *gin.Context) {
	itemID := c.Param("itemId")

	err := h.usecase.RemoveFromCart(c.Request.Context(), itemID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (h *OrderHandler) ClearCart(c *gin.Context) {
	userID, _ := c.Get("user_id")
	cartID := c.Query("cart_id")

	err := h.usecase.ClearCart(c.Request.Context(), cartID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
