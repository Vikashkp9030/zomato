package handlers

import (
	"crypto/rand"
	"encoding/base64"
	"net/http"
	"strings"
	"time"
	"todo_app/database"
	"todo_app/models"
	"todo_app/utils"

	"github.com/gin-gonic/gin"
)

const (
	AccessTokenDuration  = 15 * time.Minute
	RefreshTokenDuration = 7 * 24 * time.Hour
	MaxFailedAttempts    = 5
	LockoutDuration      = 15 * time.Minute
)

func Signup(c *gin.Context) {
	var req models.SignupRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.Password != req.PasswordConfirm {
		c.JSON(http.StatusBadRequest, gin.H{"error": "passwords do not match"})
		return
	}

	var existingUser models.User
	if err := database.DB.Where("email = ? OR username = ?", req.Email, req.Username).First(&existingUser).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "user already exists"})
		return
	}

	hashedPassword, err := utils.HashPassword(req.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to hash password"})
		return
	}

	now := time.Now().Unix()
	user := models.User{
		Username:        req.Username,
		Email:           req.Email,
		Password:        hashedPassword,
		IsEmailVerified: false,
		CreatedAt:       now,
		UpdatedAt:       now,
	}

	if err := database.DB.Create(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create user"})
		return
	}

	accessToken, err := utils.GenerateAccessToken(user.ID, user.Username, user.Email, AccessTokenDuration)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate token"})
		return
	}

	refreshToken, err := utils.GenerateRefreshToken(user.ID, RefreshTokenDuration)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate refresh token"})
		return
	}

	// Clear sensitive fields
	user.Password = ""

	c.JSON(http.StatusCreated, models.AuthResponse{
		User:         &user,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		ExpiresIn:    int64(AccessTokenDuration.Seconds()),
	})
}

func Login(c *gin.Context) {
	var req models.LoginRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var user models.User
	if err := database.DB.Where("email = ?", req.Email).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid credentials"})
		return
	}

	if user.IsLocked {
		if user.LockedUntil != nil && time.Now().Unix() < *user.LockedUntil {
			c.JSON(http.StatusForbidden, gin.H{"error": "account is temporarily locked"})
			return
		}
		user.IsLocked = false
		user.FailedLoginAttempts = 0
		database.DB.Model(&user).Updates(map[string]interface{}{
			"is_locked":             false,
			"failed_login_attempts": 0,
		})
	}

	if err := utils.ComparePassword(user.Password, req.Password); err != nil {
		user.FailedLoginAttempts++
		updates := map[string]interface{}{"failed_login_attempts": user.FailedLoginAttempts}

		if user.FailedLoginAttempts >= MaxFailedAttempts {
			user.IsLocked = true
			lockUntil := time.Now().Add(LockoutDuration).Unix()
			user.LockedUntil = &lockUntil
			updates["is_locked"] = true
			updates["locked_until"] = lockUntil
		}

		database.DB.Model(&user).Updates(updates)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid credentials"})
		return
	}

	now := time.Now().Unix()
	database.DB.Model(&user).Updates(map[string]interface{}{
		"failed_login_attempts": 0,
		"last_login":            now,
	})

	accessToken, err := utils.GenerateAccessToken(user.ID, user.Username, user.Email, AccessTokenDuration)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate token"})
		return
	}

	refreshToken, err := utils.GenerateRefreshToken(user.ID, RefreshTokenDuration)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate refresh token"})
		return
	}

	user.Password = ""

	c.JSON(http.StatusOK, models.AuthResponse{
		User:         &user,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		ExpiresIn:    int64(AccessTokenDuration.Seconds()),
	})
}

func RefreshAccessToken(c *gin.Context) {
	var req models.RefreshTokenRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, err := utils.ValidateToken(req.RefreshToken)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid refresh token"})
		return
	}

	var user models.User
	if err := database.DB.First(&user, claims.UserID).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "user not found"})
		return
	}

	if user.RefreshTokenBlacklist != nil {
		for _, token := range user.RefreshTokenBlacklist {
			if token == req.RefreshToken {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "token has been revoked"})
				return
			}
		}
	}

	accessToken, err := utils.GenerateAccessToken(user.ID, user.Username, user.Email, AccessTokenDuration)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate token"})
		return
	}

	user.Password = ""

	c.JSON(http.StatusOK, models.AuthResponse{
		User:        &user,
		AccessToken: accessToken,
		ExpiresIn:   int64(AccessTokenDuration.Seconds()),
	})
}

func RequestPasswordReset(c *gin.Context) {
	var req models.ResetPasswordRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var user models.User
	if err := database.DB.Where("email = ?", req.Email).First(&user).Error; err != nil {
		c.JSON(http.StatusOK, gin.H{"message": "if email exists, reset link has been sent"})
		return
	}

	resetToken := generateSecureToken()
	resetTokenExp := time.Now().Add(1 * time.Hour).Unix()

	if err := database.DB.Model(&user).Updates(map[string]interface{}{
		"password_reset_token":     resetToken,
		"password_reset_token_exp": resetTokenExp,
	}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate reset token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "if email exists, reset link has been sent",
		"token":   resetToken,
	})
}

func ConfirmPasswordReset(c *gin.Context) {
	var req models.ConfirmResetPasswordRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.NewPassword != req.Confirm {
		c.JSON(http.StatusBadRequest, gin.H{"error": "passwords do not match"})
		return
	}

	var user models.User
	if err := database.DB.Where("password_reset_token = ?", req.Token).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired reset token"})
		return
	}

	if user.PasswordResetTokenExp == nil || time.Now().Unix() > *user.PasswordResetTokenExp {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "reset token has expired"})
		return
	}

	hashedPassword, err := utils.HashPassword(req.NewPassword)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to hash password"})
		return
	}

	if err := database.DB.Model(&user).Updates(map[string]interface{}{
		"password":                    hashedPassword,
		"password_reset_token":        "",
		"password_reset_token_exp":    nil,
		"failed_login_attempts":       0,
		"is_locked":                   false,
		"locked_until":                nil,
		"refresh_token_blacklist":     nil,
	}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to reset password"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "password has been reset successfully"})
}

func ChangePassword(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req models.ChangePasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.NewPassword != req.Confirm {
		c.JSON(http.StatusBadRequest, gin.H{"error": "passwords do not match"})
		return
	}

	if req.OldPassword == req.NewPassword {
		c.JSON(http.StatusBadRequest, gin.H{"error": "new password must be different from old password"})
		return
	}

	var user models.User
	if err := database.DB.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	if err := utils.ComparePassword(user.Password, req.OldPassword); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid password"})
		return
	}

	hashedPassword, err := utils.HashPassword(req.NewPassword)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to hash password"})
		return
	}

	if err := database.DB.Model(&user).Updates(map[string]interface{}{
		"password":                    hashedPassword,
		"refresh_token_blacklist":     nil,
		"failed_login_attempts":       0,
		"updated_at":                  time.Now().Unix(),
	}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to change password"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "password changed successfully"})
}

func Logout(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var user models.User
	if err := database.DB.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	authHeader := c.GetHeader("Authorization")
	if authHeader != "" {
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		var blacklist []string
		if user.RefreshTokenBlacklist != nil {
			blacklist = user.RefreshTokenBlacklist
		}
		blacklist = append(blacklist, tokenString)

		if err := database.DB.Model(&user).Update("refresh_token_blacklist", blacklist).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to logout"})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{"message": "logged out successfully"})
}

func generateSecureToken() string {
	bytes := make([]byte, 32)
	if _, err := rand.Read(bytes); err != nil {
		return ""
	}
	return base64.URLEncoding.EncodeToString(bytes)
}
