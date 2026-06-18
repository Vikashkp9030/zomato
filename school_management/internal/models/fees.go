package models

import "time"

type Fee struct {
	ID              int       `json:"id"`
	StudentID       int       `json:"student_id"`
	Amount          float64   `json:"amount"`
	DueDate         time.Time `json:"due_date"`
	PaidDate        *time.Time `json:"paid_date"`
	Status          string    `json:"status"` // pending, paid, overdue
	Description     string    `json:"description"`
	TransactionID   string    `json:"transaction_id"`
	PaymentMethod   string    `json:"payment_method"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

type FeeResponse struct {
	ID            int       `json:"id"`
	StudentName   string    `json:"student_name"`
	Amount        float64   `json:"amount"`
	DueDate       time.Time `json:"due_date"`
	PaidDate      *time.Time `json:"paid_date"`
	Status        string    `json:"status"`
	Description   string    `json:"description"`
	PaymentMethod string    `json:"payment_method"`
}

type StudentFeesSummary struct {
	StudentID    int     `json:"student_id"`
	StudentName  string  `json:"student_name"`
	TotalFees    float64 `json:"total_fees"`
	AmountPaid   float64 `json:"amount_paid"`
	AmountPending float64 `json:"amount_pending"`
	Status       string  `json:"status"`
}

type FeeReceipt struct {
	ID            int       `json:"id"`
	StudentName   string    `json:"student_name"`
	Amount        float64   `json:"amount"`
	PaidDate      time.Time `json:"paid_date"`
	TransactionID string    `json:"transaction_id"`
	PaymentMethod string    `json:"payment_method"`
}