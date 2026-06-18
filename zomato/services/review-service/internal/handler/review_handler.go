package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/vikashkp9030/zomato/services/review-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type ReviewHandler struct {
	usecase *usecase.ReviewUsecase
}

func NewReviewHandler(usecase *usecase.ReviewUsecase) *ReviewHandler {
	return &ReviewHandler{usecase}
}

func (h *ReviewHandler) CreateReview(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input usecase.CreateReviewInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	review, err := h.usecase.CreateReview(c.Request.Context(), userID.(string), input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, review)
}

func (h *ReviewHandler) GetRestaurantReviews(c *gin.Context) {
	restaurantID := c.Param("restId")

	reviews, err := h.usecase.GetRestaurantReviews(c.Request.Context(), restaurantID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, reviews)
}

func (h *ReviewHandler) GetDishReviews(c *gin.Context) {
	dishID := c.Param("dishId")

	reviews, err := h.usecase.GetDishReviews(c.Request.Context(), dishID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, reviews)
}

func (h *ReviewHandler) GetUserReviews(c *gin.Context) {
	userID, _ := c.Get("user_id")

	reviews, err := h.usecase.GetUserReviews(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, reviews)
}

func (h *ReviewHandler) UpdateReview(c *gin.Context) {
	id := c.Param("id")
	var input usecase.CreateReviewInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdateReview(c.Request.Context(), id, input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "review updated"})
}

func (h *ReviewHandler) DeleteReview(c *gin.Context) {
	id := c.Param("id")

	err := h.usecase.DeleteReview(c.Request.Context(), id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (h *ReviewHandler) LikeReview(c *gin.Context) {
	userID, _ := c.Get("user_id")
	reviewID := c.Param("id")

	err := h.usecase.LikeReview(c.Request.Context(), reviewID, userID.(string))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "review liked"})
}

func (h *ReviewHandler) UnlikeReview(c *gin.Context) {
	userID, _ := c.Get("user_id")
	reviewID := c.Param("id")

	err := h.usecase.UnlikeReview(c.Request.Context(), reviewID, userID.(string))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
