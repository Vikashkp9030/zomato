package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/vikashkp9030/zomato/services/user-service/internal/domain"
	"github.com/vikashkp9030/zomato/services/user-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type UserHandler struct {
	usecase    *usecase.UserUsecase
	jwtManager *auth.JWTManager
}

func NewUserHandler(usecase *usecase.UserUsecase, jwtManager *auth.JWTManager) *UserHandler {
	return &UserHandler{
		usecase:    usecase,
		jwtManager: jwtManager,
	}
}

func (h *UserHandler) Register(c *gin.Context) {
	var input usecase.RegisterInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, token, err := h.usecase.Register(c.Request.Context(), input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"user":  user,
		"token": token,
	})
}

func (h *UserHandler) Login(c *gin.Context) {
	var input usecase.LoginInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, token, err := h.usecase.Login(c.Request.Context(), input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"user":  user,
		"token": token,
	})
}

func (h *UserHandler) Refresh(c *gin.Context) {
	var input struct {
		RefreshToken string `json:"refresh_token" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID, err := h.jwtManager.VerifyRefreshToken(input.RefreshToken)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid refresh token"})
		return
	}

	user, err := h.usecase.GetProfile(c.Request.Context(), userID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	token, err := h.jwtManager.GenerateAccessToken(user.ID, user.Email, auth.Role(user.Role))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "token generation failed"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}

func (h *UserHandler) VerifyEmail(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "email verification not implemented"})
}

func (h *UserHandler) GetProfile(c *gin.Context) {
	userID, _ := c.Get("user_id")

	user, err := h.usecase.GetProfile(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, user)
}

func (h *UserHandler) UpdateProfile(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input usecase.UpdateProfileInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdateProfile(c.Request.Context(), userID.(string), input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	user, _ := h.usecase.GetProfile(c.Request.Context(), userID.(string))
	c.JSON(http.StatusOK, user)
}

func (h *UserHandler) DeleteProfile(c *gin.Context) {
	userID, _ := c.Get("user_id")

	err := h.usecase.DeleteProfile(c.Request.Context(), userID.(string))
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (h *UserHandler) ChangePassword(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input struct {
		OldPassword string `json:"old_password" binding:"required"`
		NewPassword string `json:"new_password" binding:"required,min=6"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.ChangePassword(c.Request.Context(), userID.(string), input.OldPassword, input.NewPassword)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "password updated"})
}

func (h *UserHandler) Logout(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "logged out successfully"})
}

// Address Handlers
func (h *UserHandler) GetAddresses(c *gin.Context) {
	userID, _ := c.Get("user_id")

	addresses, err := h.usecase.GetAddresses(c.Request.Context(), userID.(string))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, addresses)
}

func (h *UserHandler) AddAddress(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input domain.Address

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.AddAddress(c.Request.Context(), userID.(string), input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "address added"})
}

func (h *UserHandler) UpdateAddress(c *gin.Context) {
	userID, _ := c.Get("user_id")
	addressID := c.Param("id")
	var input domain.Address

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.UpdateAddress(c.Request.Context(), userID.(string), addressID, input)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "address updated"})
}

func (h *UserHandler) DeleteAddress(c *gin.Context) {
	userID, _ := c.Get("user_id")
	addressID := c.Param("id")

	err := h.usecase.DeleteAddress(c.Request.Context(), userID.(string), addressID)
	if err != nil {
		if ce, ok := errors.IsCustomError(err); ok {
			c.JSON(ce.GetStatusCode(), gin.H{"error": ce.Message})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// Wishlist Handlers
func (h *UserHandler) GetWishlist(c *gin.Context) {
	userID, _ := c.Get("user_id")

	wishlist, err := h.usecase.GetWishlist(c.Request.Context(), userID.(string))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusOK, wishlist)
}

func (h *UserHandler) AddToWishlist(c *gin.Context) {
	userID, _ := c.Get("user_id")
	var input struct {
		RestaurantID string `json:"restaurant_id" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := h.usecase.AddToWishlist(c.Request.Context(), userID.(string), input.RestaurantID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "added to wishlist"})
}

func (h *UserHandler) RemoveFromWishlist(c *gin.Context) {
	userID, _ := c.Get("user_id")
	wishlistID := c.Param("id")

	err := h.usecase.RemoveFromWishlist(c.Request.Context(), userID.(string), wishlistID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
