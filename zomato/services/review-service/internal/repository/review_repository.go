package repository

import (
	"context"
	"errors"

	"github.com/vikashkp9030/zomato/services/review-service/internal/domain"
	"gorm.io/gorm"
)

type ReviewRepository struct {
	db *gorm.DB
}

func NewReviewRepository(db *gorm.DB) *ReviewRepository {
	return &ReviewRepository{db}
}

func (r *ReviewRepository) CreateReview(ctx context.Context, review *domain.Review) error {
	return r.db.WithContext(ctx).Create(review).Error
}

func (r *ReviewRepository) GetReview(ctx context.Context, id string) (*domain.Review, error) {
	var review domain.Review
	if err := r.db.WithContext(ctx).Where("id = ?", id).First(&review).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &review, nil
}

func (r *ReviewRepository) GetRestaurantReviews(ctx context.Context, restaurantID string) ([]domain.Review, error) {
	var reviews []domain.Review
	if err := r.db.WithContext(ctx).Where("restaurant_id = ?", restaurantID).Find(&reviews).Error; err != nil {
		return nil, err
	}
	return reviews, nil
}

func (r *ReviewRepository) GetDishReviews(ctx context.Context, dishID string) ([]domain.Review, error) {
	var reviews []domain.Review
	if err := r.db.WithContext(ctx).Where("dish_id = ?", dishID).Find(&reviews).Error; err != nil {
		return nil, err
	}
	return reviews, nil
}

func (r *ReviewRepository) GetUserReviews(ctx context.Context, userID string) ([]domain.Review, error) {
	var reviews []domain.Review
	if err := r.db.WithContext(ctx).Where("user_id = ?", userID).Find(&reviews).Error; err != nil {
		return nil, err
	}
	return reviews, nil
}

func (r *ReviewRepository) UpdateReview(ctx context.Context, review *domain.Review) error {
	return r.db.WithContext(ctx).Save(review).Error
}

func (r *ReviewRepository) DeleteReview(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Delete(&domain.Review{}, "id = ?", id).Error
}

func (r *ReviewRepository) AddLike(ctx context.Context, like *domain.ReviewLike) error {
	return r.db.WithContext(ctx).Create(like).Error
}

func (r *ReviewRepository) RemoveLike(ctx context.Context, reviewID, userID string) error {
	return r.db.WithContext(ctx).Delete(&domain.ReviewLike{}, "review_id = ? AND user_id = ?", reviewID, userID).Error
}

func (r *ReviewRepository) GetLikeCount(ctx context.Context, reviewID string) (int64, error) {
	var count int64
	if err := r.db.WithContext(ctx).Model(&domain.ReviewLike{}).Where("review_id = ?", reviewID).Count(&count).Error; err != nil {
		return 0, err
	}
	return count, nil
}
