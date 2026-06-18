package domain

import "time"

type Review struct {
	ID           string    `gorm:"primaryKey" json:"id"`
	UserID       string    `json:"user_id"`
	RestaurantID string    `json:"restaurant_id"`
	DishID       string    `json:"dish_id"`
	OrderID      string    `json:"order_id"`
	Rating       float64   `json:"rating"`
	Title        string    `json:"title"`
	Comment      string    `json:"comment"`
	Likes        int       `json:"likes"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type ReviewLike struct {
	ID       string    `gorm:"primaryKey" json:"id"`
	ReviewID string    `json:"review_id"`
	UserID   string    `json:"user_id"`
	CreatedAt time.Time `json:"created_at"`
}

func (r *Review) TableName() string {
	return "reviews"
}

func (rl *ReviewLike) TableName() string {
	return "review_likes"
}
