package usecase

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/vikashkp9030/zomato/services/review-service/internal/domain"
	"github.com/vikashkp9030/zomato/services/review-service/internal/repository"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type ReviewUsecase struct {
	repo *repository.ReviewRepository
}

func NewReviewUsecase(repo *repository.ReviewRepository) *ReviewUsecase {
	return &ReviewUsecase{repo}
}

type CreateReviewInput struct {
	RestaurantID string  `json:"restaurant_id"`
	DishID       string  `json:"dish_id"`
	OrderID      string  `json:"order_id"`
	Rating       float64 `json:"rating" binding:"required,min=1,max=5"`
	Title        string  `json:"title"`
	Comment      string  `json:"comment"`
}

func (u *ReviewUsecase) CreateReview(ctx context.Context, userID string, input CreateReviewInput) (*domain.Review, error) {
	review := &domain.Review{
		ID:           uuid.New().String(),
		UserID:       userID,
		RestaurantID: input.RestaurantID,
		DishID:       input.DishID,
		OrderID:      input.OrderID,
		Rating:       input.Rating,
		Title:        input.Title,
		Comment:      input.Comment,
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}

	if err := u.repo.CreateReview(ctx, review); err != nil {
		return nil, errors.NewInternalError("failed to create review")
	}

	return review, nil
}

func (u *ReviewUsecase) GetReview(ctx context.Context, id string) (*domain.Review, error) {
	review, err := u.repo.GetReview(ctx, id)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	if review == nil {
		return nil, errors.NewNotFoundError("review not found")
	}
	return review, nil
}

func (u *ReviewUsecase) GetRestaurantReviews(ctx context.Context, restaurantID string) ([]domain.Review, error) {
	reviews, err := u.repo.GetRestaurantReviews(ctx, restaurantID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return reviews, nil
}

func (u *ReviewUsecase) GetDishReviews(ctx context.Context, dishID string) ([]domain.Review, error) {
	reviews, err := u.repo.GetDishReviews(ctx, dishID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return reviews, nil
}

func (u *ReviewUsecase) GetUserReviews(ctx context.Context, userID string) ([]domain.Review, error) {
	reviews, err := u.repo.GetUserReviews(ctx, userID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return reviews, nil
}

func (u *ReviewUsecase) UpdateReview(ctx context.Context, id string, input CreateReviewInput) error {
	review, err := u.repo.GetReview(ctx, id)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if review == nil {
		return errors.NewNotFoundError("review not found")
	}

	review.Rating = input.Rating
	review.Title = input.Title
	review.Comment = input.Comment
	review.UpdatedAt = time.Now()

	return u.repo.UpdateReview(ctx, review)
}

func (u *ReviewUsecase) DeleteReview(ctx context.Context, id string) error {
	return u.repo.DeleteReview(ctx, id)
}

func (u *ReviewUsecase) LikeReview(ctx context.Context, reviewID, userID string) error {
	like := &domain.ReviewLike{
		ID:        uuid.New().String(),
		ReviewID:  reviewID,
		UserID:    userID,
		CreatedAt: time.Now(),
	}

	if err := u.repo.AddLike(ctx, like); err != nil {
		return errors.NewInternalError("failed to like review")
	}

	// Update like count
	count, _ := u.repo.GetLikeCount(ctx, reviewID)
	review, _ := u.repo.GetReview(ctx, reviewID)
	if review != nil {
		review.Likes = int(count)
		u.repo.UpdateReview(ctx, review)
	}

	return nil
}

func (u *ReviewUsecase) UnlikeReview(ctx context.Context, reviewID, userID string) error {
	if err := u.repo.RemoveLike(ctx, reviewID, userID); err != nil {
		return errors.NewInternalError("failed to unlike review")
	}

	count, _ := u.repo.GetLikeCount(ctx, reviewID)
	review, _ := u.repo.GetReview(ctx, reviewID)
	if review != nil {
		review.Likes = int(count)
		u.repo.UpdateReview(ctx, review)
	}

	return nil
}
