package repository

import (
	"context"
	"errors"

	"github.com/vikashkp9030/zomato/services/restaurant-service/internal/domain"
	"gorm.io/gorm"
)

type RestaurantRepository struct {
	db *gorm.DB
}

func NewRestaurantRepository(db *gorm.DB) *RestaurantRepository {
	return &RestaurantRepository{db}
}

func (r *RestaurantRepository) CreateRestaurant(ctx context.Context, restaurant *domain.Restaurant) error {
	return r.db.WithContext(ctx).Create(restaurant).Error
}

func (r *RestaurantRepository) GetRestaurant(ctx context.Context, id string) (*domain.Restaurant, error) {
	var restaurant domain.Restaurant
	if err := r.db.WithContext(ctx).Where("id = ?", id).First(&restaurant).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &restaurant, nil
}

func (r *RestaurantRepository) GetAllRestaurants(ctx context.Context, limit, offset int) ([]domain.Restaurant, error) {
	var restaurants []domain.Restaurant
	if err := r.db.WithContext(ctx).Where("status = ?", "active").Limit(limit).Offset(offset).Find(&restaurants).Error; err != nil {
		return nil, err
	}
	return restaurants, nil
}

func (r *RestaurantRepository) SearchRestaurants(ctx context.Context, query string, city string) ([]domain.Restaurant, error) {
	var restaurants []domain.Restaurant
	err := r.db.WithContext(ctx).
		Where("status = ? AND (name ILIKE ? OR city ILIKE ?)", "active", "%"+query+"%", "%"+city+"%").
		Find(&restaurants).Error
	return restaurants, err
}

func (r *RestaurantRepository) UpdateRestaurant(ctx context.Context, restaurant *domain.Restaurant) error {
	return r.db.WithContext(ctx).Save(restaurant).Error
}

func (r *RestaurantRepository) DeleteRestaurant(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Delete(&domain.Restaurant{}, "id = ?", id).Error
}

func (r *RestaurantRepository) GetOwnerRestaurants(ctx context.Context, ownerID string) ([]domain.Restaurant, error) {
	var restaurants []domain.Restaurant
	if err := r.db.WithContext(ctx).Where("owner_id = ?", ownerID).Find(&restaurants).Error; err != nil {
		return nil, err
	}
	return restaurants, nil
}

// Category methods
func (r *RestaurantRepository) AddCategory(ctx context.Context, category *domain.Category) error {
	return r.db.WithContext(ctx).Create(category).Error
}

func (r *RestaurantRepository) GetCategories(ctx context.Context, restaurantID string) ([]domain.Category, error) {
	var categories []domain.Category
	if err := r.db.WithContext(ctx).Where("restaurant_id = ?", restaurantID).Find(&categories).Error; err != nil {
		return nil, err
	}
	return categories, nil
}

// Dish methods
func (r *RestaurantRepository) AddDish(ctx context.Context, dish *domain.Dish) error {
	return r.db.WithContext(ctx).Create(dish).Error
}

func (r *RestaurantRepository) GetDishes(ctx context.Context, restaurantID string) ([]domain.Dish, error) {
	var dishes []domain.Dish
	if err := r.db.WithContext(ctx).Where("restaurant_id = ?", restaurantID).Find(&dishes).Error; err != nil {
		return nil, err
	}
	return dishes, nil
}

func (r *RestaurantRepository) GetDish(ctx context.Context, id string) (*domain.Dish, error) {
	var dish domain.Dish
	if err := r.db.WithContext(ctx).Where("id = ?", id).First(&dish).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &dish, nil
}

func (r *RestaurantRepository) UpdateDish(ctx context.Context, dish *domain.Dish) error {
	return r.db.WithContext(ctx).Save(dish).Error
}

func (r *RestaurantRepository) DeleteDish(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Delete(&domain.Dish{}, "id = ?", id).Error
}

// Follow methods
func (r *RestaurantRepository) AddFollow(ctx context.Context, follow *domain.Follow) error {
	return r.db.WithContext(ctx).Create(follow).Error
}

func (r *RestaurantRepository) RemoveFollow(ctx context.Context, userID, restaurantID string) error {
	return r.db.WithContext(ctx).Delete(&domain.Follow{}, "user_id = ? AND restaurant_id = ?", userID, restaurantID).Error
}

func (r *RestaurantRepository) IsFollowing(ctx context.Context, userID, restaurantID string) (bool, error) {
	var count int64
	err := r.db.WithContext(ctx).Model(&domain.Follow{}).Where("user_id = ? AND restaurant_id = ?", userID, restaurantID).Count(&count).Error
	return count > 0, err
}
