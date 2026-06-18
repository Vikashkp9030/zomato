package usecase

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/vikashkp9030/zomato/services/user-service/internal/domain"
	"github.com/vikashkp9030/zomato/services/user-service/internal/repository"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/cache"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
	"golang.org/x/crypto/bcrypt"
)

type UserUsecase struct {
	repo       *repository.UserRepository
	jwtManager *auth.JWTManager
	cache      *cache.RedisCache
}

func NewUserUsecase(repo *repository.UserRepository, jwtManager *auth.JWTManager, cache *cache.RedisCache) *UserUsecase {
	return &UserUsecase{
		repo:       repo,
		jwtManager: jwtManager,
		cache:      cache,
	}
}

type RegisterInput struct {
	Email     string `json:"email" binding:"required,email"`
	Phone     string `json:"phone" binding:"required"`
	FirstName string `json:"first_name" binding:"required"`
	LastName  string `json:"last_name" binding:"required"`
	Password  string `json:"password" binding:"required,min=6"`
	Role      string `json:"role"`
}

type LoginInput struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type UpdateProfileInput struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Phone     string `json:"phone"`
}

func (u *UserUsecase) Register(ctx context.Context, input RegisterInput) (*domain.User, string, error) {
	// Check if user exists
	existing, err := u.repo.GetUserByEmail(ctx, input.Email)
	if err != nil {
		return nil, "", errors.NewInternalError("database error")
	}
	if existing != nil {
		return nil, "", errors.NewConflictError("email already registered")
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, "", errors.NewInternalError("password hashing failed")
	}

	if input.Role == "" {
		input.Role = "customer"
	}

	user := domain.NewUser(input.Email, input.Phone, input.FirstName, input.LastName, string(hashedPassword), input.Role)

	if err := u.repo.CreateUser(ctx, user); err != nil {
		return nil, "", errors.NewInternalError("failed to create user")
	}

	// Generate tokens
	accessToken, err := u.jwtManager.GenerateAccessToken(user.ID, user.Email, auth.Role(user.Role))
	if err != nil {
		return nil, "", errors.NewInternalError("token generation failed")
	}

	refreshToken, err := u.jwtManager.GenerateRefreshToken(user.ID)
	if err != nil {
		return nil, "", errors.NewInternalError("refresh token generation failed")
	}

	// Save refresh token to DB
	rt := &domain.RefreshToken{
		ID:        uuid.New().String(),
		UserID:    user.ID,
		Token:     refreshToken,
		ExpiresAt: time.Now().Add(7 * 24 * time.Hour),
		CreatedAt: time.Now(),
	}
	_ = u.repo.SaveRefreshToken(ctx, rt)

	return user, accessToken, nil
}

func (u *UserUsecase) Login(ctx context.Context, input LoginInput) (*domain.User, string, error) {
	user, err := u.repo.GetUserByEmail(ctx, input.Email)
	if err != nil {
		return nil, "", errors.NewInternalError("database error")
	}
	if user == nil {
		return nil, "", errors.NewUnauthorizedError("invalid email or password")
	}

	if user.Status == "suspended" {
		return nil, "", errors.NewForbiddenError("account suspended")
	}

	// Compare password
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password)); err != nil {
		return nil, "", errors.NewUnauthorizedError("invalid email or password")
	}

	// Generate access token
	accessToken, err := u.jwtManager.GenerateAccessToken(user.ID, user.Email, auth.Role(user.Role))
	if err != nil {
		return nil, "", errors.NewInternalError("token generation failed")
	}

	return user, accessToken, nil
}

func (u *UserUsecase) GetProfile(ctx context.Context, userID string) (*domain.User, error) {
	user, err := u.repo.GetUserByID(ctx, userID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	if user == nil {
		return nil, errors.NewNotFoundError("user not found")
	}
	user.Password = ""
	return user, nil
}

func (u *UserUsecase) UpdateProfile(ctx context.Context, userID string, input UpdateProfileInput) error {
	user, err := u.repo.GetUserByID(ctx, userID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if user == nil {
		return errors.NewNotFoundError("user not found")
	}

	if input.FirstName != "" {
		user.FirstName = input.FirstName
	}
	if input.LastName != "" {
		user.LastName = input.LastName
	}
	if input.Phone != "" {
		user.Phone = input.Phone
	}
	user.UpdatedAt = time.Now()

	return u.repo.UpdateUser(ctx, user)
}

func (u *UserUsecase) DeleteProfile(ctx context.Context, userID string) error {
	return u.repo.DeleteUser(ctx, userID)
}

func (u *UserUsecase) ChangePassword(ctx context.Context, userID, oldPassword, newPassword string) error {
	user, err := u.repo.GetUserByID(ctx, userID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if user == nil {
		return errors.NewNotFoundError("user not found")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(oldPassword)); err != nil {
		return errors.NewUnauthorizedError("old password is incorrect")
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return errors.NewInternalError("password hashing failed")
	}

	user.Password = string(hashedPassword)
	user.UpdatedAt = time.Now()

	return u.repo.UpdateUser(ctx, user)
}

// Address methods
func (u *UserUsecase) AddAddress(ctx context.Context, userID string, addr domain.Address) error {
	addr.ID = uuid.New().String()
	addr.UserID = userID
	addr.CreatedAt = time.Now()
	return u.repo.AddAddress(ctx, &addr)
}

func (u *UserUsecase) GetAddresses(ctx context.Context, userID string) ([]domain.Address, error) {
	return u.repo.GetAddresses(ctx, userID)
}

func (u *UserUsecase) UpdateAddress(ctx context.Context, userID, addressID string, addr domain.Address) error {
	existing, err := u.repo.GetAddressByID(ctx, addressID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if existing == nil || existing.UserID != userID {
		return errors.NewNotFoundError("address not found")
	}

	addr.ID = addressID
	addr.UserID = userID
	return u.repo.UpdateAddress(ctx, &addr)
}

func (u *UserUsecase) DeleteAddress(ctx context.Context, userID, addressID string) error {
	existing, err := u.repo.GetAddressByID(ctx, addressID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if existing == nil || existing.UserID != userID {
		return errors.NewNotFoundError("address not found")
	}

	return u.repo.DeleteAddress(ctx, addressID)
}

// Wishlist methods
func (u *UserUsecase) AddToWishlist(ctx context.Context, userID, restaurantID string) error {
	w := &domain.Wishlist{
		ID:           uuid.New().String(),
		UserID:       userID,
		RestaurantID: restaurantID,
		CreatedAt:    time.Now(),
	}
	return u.repo.AddToWishlist(ctx, w)
}

func (u *UserUsecase) GetWishlist(ctx context.Context, userID string) ([]domain.Wishlist, error) {
	return u.repo.GetWishlist(ctx, userID)
}

func (u *UserUsecase) RemoveFromWishlist(ctx context.Context, userID, wishlistID string) error {
	return u.repo.RemoveFromWishlist(ctx, wishlistID)
}
