package repository

import (
	"context"
	"errors"

	"github.com/vikashkp9030/zomato/services/user-service/internal/domain"
	"gorm.io/gorm"
)

type UserRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{db}
}

func (r *UserRepository) CreateUser(ctx context.Context, user *domain.User) error {
	return r.db.WithContext(ctx).Create(user).Error
}

func (r *UserRepository) GetUserByEmail(ctx context.Context, email string) (*domain.User, error) {
	var user domain.User
	if err := r.db.WithContext(ctx).Where("email = ?", email).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) GetUserByID(ctx context.Context, id string) (*domain.User, error) {
	var user domain.User
	if err := r.db.WithContext(ctx).Where("id = ?", id).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) UpdateUser(ctx context.Context, user *domain.User) error {
	return r.db.WithContext(ctx).Save(user).Error
}

func (r *UserRepository) DeleteUser(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Delete(&domain.User{}, "id = ?", id).Error
}

// Address methods
func (r *UserRepository) AddAddress(ctx context.Context, address *domain.Address) error {
	return r.db.WithContext(ctx).Create(address).Error
}

func (r *UserRepository) GetAddresses(ctx context.Context, userID string) ([]domain.Address, error) {
	var addresses []domain.Address
	if err := r.db.WithContext(ctx).Where("user_id = ?", userID).Find(&addresses).Error; err != nil {
		return nil, err
	}
	return addresses, nil
}

func (r *UserRepository) GetAddressByID(ctx context.Context, id string) (*domain.Address, error) {
	var address domain.Address
	if err := r.db.WithContext(ctx).Where("id = ?", id).First(&address).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &address, nil
}

func (r *UserRepository) UpdateAddress(ctx context.Context, address *domain.Address) error {
	return r.db.WithContext(ctx).Save(address).Error
}

func (r *UserRepository) DeleteAddress(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Delete(&domain.Address{}, "id = ?", id).Error
}

// Wishlist methods
func (r *UserRepository) AddToWishlist(ctx context.Context, wishlist *domain.Wishlist) error {
	return r.db.WithContext(ctx).Create(wishlist).Error
}

func (r *UserRepository) GetWishlist(ctx context.Context, userID string) ([]domain.Wishlist, error) {
	var wishlists []domain.Wishlist
	if err := r.db.WithContext(ctx).Where("user_id = ?", userID).Find(&wishlists).Error; err != nil {
		return nil, err
	}
	return wishlists, nil
}

func (r *UserRepository) RemoveFromWishlist(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Delete(&domain.Wishlist{}, "id = ?", id).Error
}

// Refresh Token methods
func (r *UserRepository) SaveRefreshToken(ctx context.Context, token *domain.RefreshToken) error {
	return r.db.WithContext(ctx).Create(token).Error
}

func (r *UserRepository) GetRefreshToken(ctx context.Context, tokenString string) (*domain.RefreshToken, error) {
	var token domain.RefreshToken
	if err := r.db.WithContext(ctx).Where("token = ?", tokenString).First(&token).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &token, nil
}

func (r *UserRepository) DeleteRefreshToken(ctx context.Context, tokenString string) error {
	return r.db.WithContext(ctx).Delete(&domain.RefreshToken{}, "token = ?", tokenString).Error
}
