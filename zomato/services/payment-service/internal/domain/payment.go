package domain

import "time"

type Payment struct {
	ID            string    `gorm:"primaryKey" json:"id"`
	OrderID       string    `json:"order_id"`
	UserID        string    `json:"user_id"`
	Amount        float64   `json:"amount"`
	Currency      string    `json:"currency"`
	Method        string    `json:"method"` // credit_card, debit_card, upi, wallet
	Status        string    `json:"status"` // pending, completed, failed, refunded
	TransactionID string    `json:"transaction_id"`
	FailureReason string    `json:"failure_reason"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

type PaymentMethod struct {
	ID       string    `gorm:"primaryKey" json:"id"`
	UserID   string    `json:"user_id"`
	Type     string    `json:"type"` // card, upi
	IsDefault bool     `json:"is_default"`
	Details  string    `json:"details"` // encrypted
	CreatedAt time.Time `json:"created_at"`
}

type Wallet struct {
	ID       string    `gorm:"primaryKey" json:"id"`
	UserID   string    `gorm:"uniqueIndex" json:"user_id"`
	Balance  float64   `json:"balance"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type WalletTransaction struct {
	ID        string    `gorm:"primaryKey" json:"id"`
	WalletID  string    `json:"wallet_id"`
	UserID    string    `json:"user_id"`
	Amount    float64   `json:"amount"`
	Type      string    `json:"type"` // credit, debit
	Reason    string    `json:"reason"`
	CreatedAt time.Time `json:"created_at"`
}

type Refund struct {
	ID        string    `gorm:"primaryKey" json:"id"`
	PaymentID string    `json:"payment_id"`
	Amount    float64   `json:"amount"`
	Status    string    `json:"status"` // pending, completed, failed
	CreatedAt time.Time `json:"created_at"`
}

func (p *Payment) TableName() string {
	return "payments"
}

func (pm *PaymentMethod) TableName() string {
	return "payment_methods"
}

func (w *Wallet) TableName() string {
	return "wallets"
}

func (wt *WalletTransaction) TableName() string {
	return "wallet_transactions"
}

func (r *Refund) TableName() string {
	return "refunds"
}
