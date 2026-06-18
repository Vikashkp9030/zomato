package usecase

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/vikashkp9030/zomato/services/restaurant-service/internal/domain"
	"github.com/vikashkp9030/zomato/services/restaurant-service/internal/repository"
	"github.com/vikashkp9030/zomato/shared/pkg/cache"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type RestaurantUsecase struct {
	repo  *repository.RestaurantRepository
	cache *cache.RedisCache
}

func NewRestaurantUsecase(repo *repository.RestaurantRepository, cache *cache.RedisCache) *RestaurantUsecase {
	return &RestaurantUsecase{
		repo:  repo,
		cache: cache,
	}
}

type CreateRestaurantInput struct {
	Name          string   `json:"name" binding:"required"`
	Description   string   `json:"description"`
	Address       string   `json:"address" binding:"required"`
	City          string   `json:"city" binding:"required"`
	Latitude      float64  `json:"latitude"`
	Longitude     float64  `json:"longitude"`
	PhoneNumber   string   `json:"phone_number"`
	Email         string   `json:"email"`
	CuisineTypes  []string `json:"cuisine_types"`
}

func (u *RestaurantUsecase) CreateRestaurant(ctx context.Context, ownerID string, input CreateRestaurantInput) (*domain.Restaurant, error) {
	restaurant := &domain.Restaurant{
		ID:          uuid.New().String(),
		OwnerID:     ownerID,
		Name:        input.Name,
		Description: input.Description,
		Address:     input.Address,
		City:        input.City,
		Latitude:    input.Latitude,
		Longitude:   input.Longitude,
		PhoneNumber: input.PhoneNumber,
		Email:       input.Email,
		Status:      "pending",
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
	}

	if err := u.repo.CreateRestaurant(ctx, restaurant); err != nil {
		return nil, errors.NewInternalError("failed to create restaurant")
	}

	return restaurant, nil
}

func (u *RestaurantUsecase) GetRestaurant(ctx context.Context, id string) (*domain.Restaurant, error) {
	restaurant, err := u.repo.GetRestaurant(ctx, id)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	if restaurant == nil {
		return nil, errors.NewNotFoundError("restaurant not found")
	}
	return restaurant, nil
}

func (u *RestaurantUsecase) ListRestaurants(ctx context.Context, limit, offset int) ([]domain.Restaurant, error) {
	restaurants, err := u.repo.GetAllRestaurants(ctx, limit, offset)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return restaurants, nil
}

func (u *RestaurantUsecase) SearchRestaurants(ctx context.Context, query, city string) ([]domain.Restaurant, error) {
	restaurants, err := u.repo.SearchRestaurants(ctx, query, city)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return restaurants, nil
}

func (u *RestaurantUsecase) UpdateRestaurant(ctx context.Context, id string, restaurant *domain.Restaurant) error {
	existing, err := u.repo.GetRestaurant(ctx, id)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if existing == nil {
		return errors.NewNotFoundError("restaurant not found")
	}

	restaurant.ID = id
	restaurant.UpdatedAt = time.Now()
	return u.repo.UpdateRestaurant(ctx, restaurant)
}

func (u *RestaurantUsecase) DeleteRestaurant(ctx context.Context, id string) error {
	return u.repo.DeleteRestaurant(ctx, id)
}

func (u *RestaurantUsecase) GetOwnerRestaurants(ctx context.Context, ownerID string) ([]domain.Restaurant, error) {
	restaurants, err := u.repo.GetOwnerRestaurants(ctx, ownerID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return restaurants, nil
}

// Menu operations
func (u *RestaurantUsecase) AddCategory(ctx context.Context, restaurantID string, name, description string) error {
	category := &domain.Category{
		ID:           uuid.New().String(),
		RestaurantID: restaurantID,
		Name:         name,
		Description:  description,
		CreatedAt:    time.Now(),
	}
	return u.repo.AddCategory(ctx, category)
}

func (u *RestaurantUsecase) GetMenu(ctx context.Context, restaurantID string) (interface{}, error) {
	categories, err := u.repo.GetCategories(ctx, restaurantID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}

	type Menu struct {
		Categories []domain.Category `json:"categories"`
		Dishes     []domain.Dish     `json:"dishes"`
	}

	dishes, _ := u.repo.GetDishes(ctx, restaurantID)
	return Menu{Categories: categories, Dishes: dishes}, nil
}

func (u *RestaurantUsecase) AddDish(ctx context.Context, restaurantID string, dish domain.Dish) error {
	dish.ID = uuid.New().String()
	dish.RestaurantID = restaurantID
	dish.CreatedAt = time.Now()
	return u.repo.AddDish(ctx, &dish)
}

func (u *RestaurantUsecase) UpdateDish(ctx context.Context, id string, dish domain.Dish) error {
	existing, err := u.repo.GetDish(ctx, id)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if existing == nil {
		return errors.NewNotFoundError("dish not found")
	}

	dish.ID = id
	return u.repo.UpdateDish(ctx, &dish)
}

func (u *RestaurantUsecase) DeleteDish(ctx context.Context, id string) error {
	return u.repo.DeleteDish(ctx, id)
}

// Follow/Unfollow
func (u *RestaurantUsecase) FollowRestaurant(ctx context.Context, userID, restaurantID string) error {
	follow := &domain.Follow{
		ID:           uuid.New().String(),
		UserID:       userID,
		RestaurantID: restaurantID,
		CreatedAt:    time.Now(),
	}
	return u.repo.AddFollow(ctx, follow)
}

func (u *RestaurantUsecase) UnfollowRestaurant(ctx context.Context, userID, restaurantID string) error {
	return u.repo.RemoveFollow(ctx, userID, restaurantID)
}
