package domain

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID        string    `gorm:"primaryKey" json:"id"`
	Email     string    `gorm:"uniqueIndex" json:"email"`
	Phone     string    `gorm:"uniqueIndex" json:"phone"`
	FirstName string    `json:"first_name"`
	LastName  string    `json:"last_name"`
	Password  string    `json:"-"`
	Role      string    `json:"role"` // customer, owner, delivery, admin
	Status    string    `json:"status"` // active, inactive, suspended
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Address struct {
	ID        string    `gorm:"primaryKey" json:"id"`
	UserID    string    `json:"user_id"`
	Type      string    `json:"type"` // home, work, other
	Address   string    `json:"address"`
	City      string    `json:"city"`
	State     string    `json:"state"`
	ZipCode   string    `json:"zip_code"`
	Latitude  float64   `json:"latitude"`
	Longitude float64   `json:"longitude"`
	IsDefault bool      `json:"is_default"`
	CreatedAt time.Time `json:"created_at"`
}

type Wishlist struct {
	ID           string    `gorm:"primaryKey" json:"id"`
	UserID       string    `json:"user_id"`
	RestaurantID string    `json:"restaurant_id"`
	CreatedAt    time.Time `json:"created_at"`
}

type RefreshToken struct {
	ID        string    `gorm:"primaryKey"`
	UserID    string    `gorm:"index"`
	Token     string    `gorm:"uniqueIndex"`
	ExpiresAt time.Time
	CreatedAt time.Time
}

func NewUser(email, phone, firstName, lastName, password, role string) *User {
	return &User{
		ID:        uuid.New().String(),
		Email:     email,
		Phone:     phone,
		FirstName: firstName,
		LastName:  lastName,
		Password:  password,
		Role:      role,
		Status:    "active",
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}
}

func (u *User) TableName() string {
	return "users"
}

func (a *Address) TableName() string {
	return "addresses"
}

func (w *Wishlist) TableName() string {
	return "wishlists"
}

func (rt *RefreshToken) TableName() string {
	return "refresh_tokens"
}
