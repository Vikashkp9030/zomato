package domain

import "time"

type Restaurant struct {
	ID           string    `gorm:"primaryKey" json:"id"`
	OwnerID      string    `json:"owner_id"`
	Name         string    `json:"name"`
	Description  string    `json:"description"`
	Address      string    `json:"address"`
	City         string    `json:"city"`
	Latitude     float64   `json:"latitude"`
	Longitude    float64   `json:"longitude"`
	PhoneNumber  string    `json:"phone_number"`
	Email        string    `json:"email"`
	CuisineTypes string    `json:"cuisine_types"` // JSON array
	AverageRating float64  `json:"average_rating"`
	TotalReviews int       `json:"total_reviews"`
	IsOpen       bool      `json:"is_open"`
	Status       string    `json:"status"` // active, inactive, pending, rejected
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type Category struct {
	ID           string    `gorm:"primaryKey" json:"id"`
	RestaurantID string    `json:"restaurant_id"`
	Name         string    `json:"name"`
	Description  string    `json:"description"`
	CreatedAt    time.Time `json:"created_at"`
}

type Dish struct {
	ID           string    `gorm:"primaryKey" json:"id"`
	RestaurantID string    `json:"restaurant_id"`
	CategoryID   string    `json:"category_id"`
	Name         string    `json:"name"`
	Description  string    `json:"description"`
	Price        float64   `json:"price"`
	IsVeg        bool      `json:"is_veg"`
	IsAvailable  bool      `json:"is_available"`
	PrepTime     int       `json:"prep_time"` // minutes
	CreatedAt    time.Time `json:"created_at"`
}

type Follow struct {
	ID           string    `gorm:"primaryKey" json:"id"`
	UserID       string    `json:"user_id"`
	RestaurantID string    `json:"restaurant_id"`
	CreatedAt    time.Time `json:"created_at"`
}

func (r *Restaurant) TableName() string {
	return "restaurants"
}

func (c *Category) TableName() string {
	return "categories"
}

func (d *Dish) TableName() string {
	return "dishes"
}

func (f *Follow) TableName() string {
	return "follows"
}
