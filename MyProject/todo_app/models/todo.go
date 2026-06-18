package models

import (
	"time"

	"gorm.io/gorm"
)

// Priority levels for todos
type Priority string

const (
	PriorityLow    Priority = "low"
	PriorityMedium Priority = "medium"
	PriorityHigh   Priority = "high"
)

// Status enum for todos
type Status string

const (
	StatusTodo       Status = "todo"
	StatusInProgress Status = "in_progress"
	StatusDone       Status = "done"
	StatusArchived   Status = "archived"
)

type Todo struct {
	ID          uint            `json:"id" gorm:"primaryKey"`
	Title       string          `json:"title" gorm:"not null;index"`
	Description string          `json:"description" gorm:"type:text"`
	Completed   bool            `json:"completed" gorm:"default:false;index"`
	Priority    Priority        `json:"priority" gorm:"type:varchar(20);default:'medium'"`
	Status      Status          `json:"status" gorm:"type:varchar(20);default:'todo';index"`
	DueDate     *time.Time      `json:"due_date"`
	CategoryID  *uint           `json:"category_id"`
	Category    *Category       `json:"category,omitempty" gorm:"foreignKey:CategoryID"`
	Tags        []Tag           `json:"tags,omitempty" gorm:"many2many:todo_tags"`
	UserID      *uint           `json:"user_id"`
	User        *User           `json:"user,omitempty" gorm:"foreignKey:UserID"`
	CreatedAt   int64           `json:"created_at"`
	UpdatedAt   int64           `json:"updated_at"`
	DeletedAt   gorm.DeletedAt  `json:"-" gorm:"index"`
}

type Category struct {
	ID          uint           `json:"id" gorm:"primaryKey"`
	Name        string         `json:"name" gorm:"not null;unique;index"`
	Description string         `json:"description" gorm:"type:text"`
	Color       string         `json:"color" gorm:"default:'#3B82F6'"`
	CreatedAt   int64          `json:"created_at"`
	UpdatedAt   int64          `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `json:"-" gorm:"index"`
}

type Tag struct {
	ID        uint           `json:"id" gorm:"primaryKey"`
	Name      string         `json:"name" gorm:"not null;unique;index"`
	CreatedAt int64          `json:"created_at"`
	UpdatedAt int64          `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
}

type User struct {
	ID                    uint           `json:"id" gorm:"primaryKey"`
	Username              string         `json:"username" gorm:"not null;unique;index"`
	Email                 string         `json:"email" gorm:"not null;unique;index"`
	Password              string         `json:"-" gorm:"not null"`
	IsEmailVerified       bool           `json:"is_email_verified" gorm:"default:false"`
	LastLogin             *int64         `json:"last_login"`
	FailedLoginAttempts   int            `json:"failed_login_attempts" gorm:"default:0"`
	IsLocked              bool           `json:"is_locked" gorm:"default:false"`
	LockedUntil           *int64         `json:"locked_until"`
	PasswordResetToken    string         `json:"-" gorm:"index"`
	PasswordResetTokenExp *int64         `json:"-"`
	RefreshTokenBlacklist []string       `json:"-" gorm:"type:text"`
	CreatedAt             int64          `json:"created_at"`
	UpdatedAt             int64          `json:"updated_at"`
	DeletedAt             gorm.DeletedAt `json:"-" gorm:"index"`
}

// Request DTOs
type CreateTodoRequest struct {
	Title       string   `json:"title" binding:"required"`
	Description string   `json:"description"`
	Priority    Priority `json:"priority"`
	Status      Status   `json:"status"`
	DueDate     *time.Time `json:"due_date"`
	CategoryID  *uint    `json:"category_id"`
	TagIDs      []uint   `json:"tag_ids"`
	UserID      *uint    `json:"user_id"`
}

type UpdateTodoRequest struct {
	Title       *string  `json:"title"`
	Description *string  `json:"description"`
	Completed   *bool    `json:"completed"`
	Priority    *Priority `json:"priority"`
	Status      *Status  `json:"status"`
	DueDate     *time.Time `json:"due_date"`
	CategoryID  *uint    `json:"category_id"`
	TagIDs      []uint   `json:"tag_ids"`
	UserID      *uint    `json:"user_id"`
}

type CreateCategoryRequest struct {
	Name        string `json:"name" binding:"required"`
	Description string `json:"description"`
	Color       string `json:"color"`
}

type UpdateCategoryRequest struct {
	Name        *string `json:"name"`
	Description *string `json:"description"`
	Color       *string `json:"color"`
}

type CreateTagRequest struct {
	Name string `json:"name" binding:"required"`
}

type UpdateTagRequest struct {
	Name string `json:"name" binding:"required"`
}

type CreateUserRequest struct {
	Username string `json:"username" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

type UpdateUserRequest struct {
	Username *string `json:"username"`
	Email    *string `json:"email"`
	Password *string `json:"password"`
}

// Query filters
type TodoFilterRequest struct {
	Status     *Status  `form:"status"`
	Priority   *Priority `form:"priority"`
	Completed  *bool    `form:"completed"`
	CategoryID *uint    `form:"category_id"`
	UserID     *uint    `form:"user_id"`
	TagID      *uint    `form:"tag_id"`
	Search     *string  `form:"search"`
	SortBy     *string  `form:"sort_by"` // created_at, due_date, priority
	Order      *string  `form:"order"`   // asc, desc
	Page       *int     `form:"page"`
	Limit      *int     `form:"limit"`
}

type PaginatedResponse struct {
	Data      interface{} `json:"data"`
	Total     int64       `json:"total"`
	Page      int         `json:"page"`
	Limit     int         `json:"limit"`
	TotalPages int        `json:"total_pages"`
}

type StatsResponse struct {
	TotalTodos     int64            `json:"total_todos"`
	CompletedTodos int64            `json:"completed_todos"`
	PendingTodos   int64            `json:"pending_todos"`
	HighPriority   int64            `json:"high_priority"`
	OverdueTodos   int64            `json:"overdue_todos"`
	TodoByCategory map[string]int64 `json:"todos_by_category"`
	TodoByStatus   map[string]int64 `json:"todos_by_status"`
}

// Authentication DTOs
type SignupRequest struct {
	Username            string `json:"username" binding:"required,min=3,max=50"`
	Email               string `json:"email" binding:"required,email"`
	Password            string `json:"password" binding:"required,min=8"`
	PasswordConfirm      string `json:"password_confirm" binding:"required,min=8"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type AuthResponse struct {
	User         *User  `json:"user"`
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	ExpiresIn    int64  `json:"expires_in"`
}

type RefreshTokenRequest struct {
	RefreshToken string `json:"refresh_token" binding:"required"`
}

type ResetPasswordRequest struct {
	Email string `json:"email" binding:"required,email"`
}

type ConfirmResetPasswordRequest struct {
	Token       string `json:"token" binding:"required"`
	NewPassword string `json:"new_password" binding:"required,min=8"`
	Confirm     string `json:"confirm" binding:"required,min=8"`
}

type ChangePasswordRequest struct {
	OldPassword string `json:"old_password" binding:"required"`
	NewPassword string `json:"new_password" binding:"required,min=8"`
	Confirm     string `json:"confirm" binding:"required,min=8"`
}
