package handler

import (
	"encoding/json"
	"net/http"

	"school-management/config"
	"school-management/internal/middleware"
	"school-management/internal/models"
	"school-management/internal/repository"
	"school-management/internal/utils"
)

type AuthHandler struct {
	userRepo *repository.UserRepository
	cfg      *config.AppConfig
}

func NewAuthHandler(userRepo *repository.UserRepository, cfg *config.AppConfig) *AuthHandler {
	return &AuthHandler{
		userRepo: userRepo,
		cfg:      cfg,
	}
}

func (h *AuthHandler) Register(w http.ResponseWriter, r *http.Request) {
	var req models.RegisterRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	exists, err := h.userRepo.EmailExists(req.Email)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Database error", err.Error())
		return
	}

	if exists {
		utils.ErrorResponse(w, http.StatusConflict, "Email already registered", "")
		return
	}

	hashedPassword, err := utils.HashPassword(req.Password)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Password hashing failed", err.Error())
		return
	}

	user := &models.User{
		Email:     req.Email,
		Password:  hashedPassword,
		FirstName: req.FirstName,
		LastName:  req.LastName,
		Role:      req.Role,
		Status:    "Active",
	}

	if err := h.userRepo.Create(user); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to create user", err.Error())
		return
	}

	user.Password = ""
	utils.SuccessResponse(w, http.StatusCreated, "User registered successfully", user)
}

func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	var req models.LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	user, err := h.userRepo.GetByEmail(req.Email)
	if err != nil {
		utils.ErrorResponse(w, http.StatusUnauthorized, "Invalid credentials", "")
		return
	}

	if !utils.CheckPasswordHash(req.Password, user.Password) {
		utils.ErrorResponse(w, http.StatusUnauthorized, "Invalid credentials", "")
		return
	}

	accessToken, err := utils.GenerateAccessToken(user.ID, user.Email, user.Role, h.cfg)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Token generation failed", err.Error())
		return
	}

	refreshToken, err := utils.GenerateRefreshToken(user.ID, h.cfg)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Token generation failed", err.Error())
		return
	}

	user.Password = ""
	response := models.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         user,
	}

	utils.SuccessResponse(w, http.StatusOK, "Login successful", response)
}

func (h *AuthHandler) RefreshToken(w http.ResponseWriter, r *http.Request) {
	var req models.RefreshTokenRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	claims, err := utils.ValidateToken(req.RefreshToken, h.cfg)
	if err != nil {
		utils.ErrorResponse(w, http.StatusUnauthorized, "Invalid refresh token", err.Error())
		return
	}

	user, err := h.userRepo.GetByID(claims.UserID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusUnauthorized, "User not found", "")
		return
	}

	accessToken, err := utils.GenerateAccessToken(user.ID, user.Email, user.Role, h.cfg)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Token generation failed", err.Error())
		return
	}

	user.Password = ""
	response := models.AuthResponse{
		AccessToken: accessToken,
		User:        user,
	}

	utils.SuccessResponse(w, http.StatusOK, "Token refreshed successfully", response)
}

func (h *AuthHandler) ChangePassword(w http.ResponseWriter, r *http.Request) {
	claims := middleware.GetUserFromContext(r)
	if claims == nil {
		utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", "")
		return
	}

	var req models.ChangePasswordRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
		return
	}

	user, err := h.userRepo.GetByID(claims.UserID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "User not found", "")
		return
	}

	if !utils.CheckPasswordHash(req.OldPassword, user.Password) {
		utils.ErrorResponse(w, http.StatusUnauthorized, "Old password is incorrect", "")
		return
	}

	hashedPassword, err := utils.HashPassword(req.NewPassword)
	if err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Password hashing failed", err.Error())
		return
	}

	if err := h.userRepo.UpdatePassword(user.ID, hashedPassword); err != nil {
		utils.ErrorResponse(w, http.StatusInternalServerError, "Failed to update password", err.Error())
		return
	}

	utils.SuccessResponse(w, http.StatusOK, "Password changed successfully", nil)
}

func (h *AuthHandler) GetProfile(w http.ResponseWriter, r *http.Request) {
	claims := middleware.GetUserFromContext(r)
	if claims == nil {
		utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", "")
		return
	}

	user, err := h.userRepo.GetByID(claims.UserID)
	if err != nil {
		utils.ErrorResponse(w, http.StatusNotFound, "User not found", "")
		return
	}

	user.Password = ""
	utils.SuccessResponse(w, http.StatusOK, "Profile retrieved successfully", user)
}
