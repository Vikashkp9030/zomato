package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/vikashkp9030/zomato/services/restaurant-service/internal/domain"
	"github.com/vikashkp9030/zomato/services/restaurant-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type RestaurantHandler struct {
	usecase *usecase.RestaurantUsecase
}

func NewRestaurantHandler(usecase *usecase.RestaurantUsecase) *RestaurantHandler {
	return &RestaurantHandler{usecase}
}

func (h *RestaurantHandler) CreateRestaurant(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input usecase.CreateRestaurantInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	restaurant, err := h.usecase.CreateRestaurant(c.Request.Context(), userID.(string), input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, restaurant)
}

func (h *RestaurantHandler) ListRestaurants(c *gin.Context) {
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "20"))
	offset, _ := strconv.Atoi(c.DefaultQuery("offset", "0"))

	restaurants, err := h.usecase.ListRestaurants(c.Request.Context(), limit, offset)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, restaurants)
}

func (h *RestaurantHandler) GetRestaurant(c *gin.Context) {
	id := c.Param("id")

	restaurant, err := h.usecase.GetRestaurant(c.Request.Context(), id)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, restaurant)
}

func (h *RestaurantHandler) SearchRestaurants(c *gin.Context) {
	query := c.Query("q")
	city := c.DefaultQuery("city", "")

	restaurants, err := h.usecase.SearchRestaurants(c.Request.Context(), query, city)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, restaurants)
}

func (h *RestaurantHandler) UpdateRestaurant(c *gin.Context) {
	id := c.Param("id")
	var restaurant domain.Restaurant

	if err := c.ShouldBindJSON(&restaurant); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdateRestaurant(c.Request.Context(), id, &restaurant)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, restaurant)
}

func (h *RestaurantHandler) DeleteRestaurant(c *gin.Context) {
	id := c.Param("id")

	err := h.usecase.DeleteRestaurant(c.Request.Context(), id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (h *RestaurantHandler) GetMenu(c *gin.Context) {
	id := c.Param("id")

	menu, err := h.usecase.GetMenu(c.Request.Context(), id)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, menu)
}

func (h *RestaurantHandler) AddCategory(c *gin.Context) {
	restaurantID := c.Param("id")
	var input struct {
		Name        string `json:"name" binding:"required"`
		Description string `json:"description"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.AddCategory(c.Request.Context(), restaurantID, input.Name, input.Description)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "category added"})
}

func (h *RestaurantHandler) AddDish(c *gin.Context) {
	restaurantID := c.Param("id")
	var dish domain.Dish

	if err := c.ShouldBindJSON(&dish); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.AddDish(c.Request.Context(), restaurantID, dish)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "dish added"})
}

func (h *RestaurantHandler) UpdateDish(c *gin.Context) {
	dishID := c.Param("dishId")
	var dish domain.Dish

	if err := c.ShouldBindJSON(&dish); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdateDish(c.Request.Context(), dishID, dish)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "dish updated"})
}

func (h *RestaurantHandler) DeleteDish(c *gin.Context) {
	dishID := c.Param("dishId")

	err := h.usecase.DeleteDish(c.Request.Context(), dishID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (h *RestaurantHandler) GetReviews(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"reviews": []string{}})
}

func (h *RestaurantHandler) GetRating(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"rating": 4.5})
}

func (h *RestaurantHandler) GetCuisines(c *gin.Context) {
	cuisines := []string{"Indian", "Chinese", "Continental", "Italian", "Mexican"}
	c.JSON(http.StatusOK, gin.H{"cuisines": cuisines})
}

func (h *RestaurantHandler) FollowRestaurant(c *gin.Context) {
	userID, _ := c.Get("user_id")
	restaurantID := c.Param("id")

	err := h.usecase.FollowRestaurant(c.Request.Context(), userID.(string), restaurantID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "followed"})
}

func (h *RestaurantHandler) UnfollowRestaurant(c *gin.Context) {
	userID, _ := c.Get("user_id")
	restaurantID := c.Param("id")

	err := h.usecase.UnfollowRestaurant(c.Request.Context(), userID.(string), restaurantID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (h *RestaurantHandler) GetOwnerRestaurants(c *gin.Context) {
	userID, _ := c.Get("user_id")

	restaurants, err := h.usecase.GetOwnerRestaurants(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, restaurants)
}
