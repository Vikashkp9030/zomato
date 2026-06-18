package usecase

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/vikashkp9030/zomato/services/payment-service/internal/domain"
	"github.com/vikashkp9030/zomato/services/payment-service/internal/repository"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type PaymentUsecase struct {
	repo *repository.PaymentRepository
}

func NewPaymentUsecase(repo *repository.PaymentRepository) *PaymentUsecase {
	return &PaymentUsecase{repo}
}

type InitiatePaymentInput struct {
	OrderID string  `json:"order_id" binding:"required"`
	Amount  float64 `json:"amount" binding:"required"`
	Method  string  `json:"method" binding:"required"`
}

func (u *PaymentUsecase) InitiatePayment(ctx context.Context, userID string, input InitiatePaymentInput) (*domain.Payment, error) {
	payment := &domain.Payment{
		ID:        uuid.New().String(),
		OrderID:   input.OrderID,
		UserID:    userID,
		Amount:    input.Amount,
		Currency:  "INR",
		Method:    input.Method,
		Status:    "pending",
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}

	if err := u.repo.CreatePayment(ctx, payment); err != nil {
		return nil, errors.NewInternalError("failed to create payment")
	}

	return payment, nil
}

func (u *PaymentUsecase) ConfirmPayment(ctx context.Context, paymentID string) error {
	payment, err := u.repo.GetPayment(ctx, paymentID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if payment == nil {
		return errors.NewNotFoundError("payment not found")
	}

	// Simulate payment processing
	payment.Status = "completed"
	payment.TransactionID = uuid.New().String()
	payment.UpdatedAt = time.Now()

	return u.repo.UpdatePayment(ctx, payment)
}

func (u *PaymentUsecase) GetPayment(ctx context.Context, paymentID string) (*domain.Payment, error) {
	payment, err := u.repo.GetPayment(ctx, paymentID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	if payment == nil {
		return nil, errors.NewNotFoundError("payment not found")
	}
	return payment, nil
}

func (u *PaymentUsecase) GetPaymentHistory(ctx context.Context, userID string) ([]domain.Payment, error) {
	payments, err := u.repo.GetUserPayments(ctx, userID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return payments, nil
}

func (u *PaymentUsecase) RefundPayment(ctx context.Context, paymentID string, amount float64) error {
	payment, err := u.repo.GetPayment(ctx, paymentID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if payment == nil {
		return errors.NewNotFoundError("payment not found")
	}

	refund := &domain.Refund{
		ID:        uuid.New().String(),
		PaymentID: paymentID,
		Amount:    amount,
		Status:    "pending",
		CreatedAt: time.Now(),
	}

	if err := u.repo.CreateRefund(ctx, refund); err != nil {
		return errors.NewInternalError("failed to create refund")
	}

	payment.Status = "refunded"
	payment.UpdatedAt = time.Now()
	return u.repo.UpdatePayment(ctx, payment)
}

// Wallet operations
func (u *PaymentUsecase) GetWalletBalance(ctx context.Context, userID string) (float64, error) {
	wallet, err := u.repo.GetWallet(ctx, userID)
	if err != nil {
		return 0, errors.NewInternalError("database error")
	}
	if wallet == nil {
		return 0, nil
	}
	return wallet.Balance, nil
}

func (u *PaymentUsecase) AddToWallet(ctx context.Context, userID string, amount float64) error {
	wallet, _ := u.repo.GetWallet(ctx, userID)
	if wallet == nil {
		wallet = &domain.Wallet{
			ID:        uuid.New().String(),
			UserID:    userID,
			Balance:   amount,
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		}
		return u.repo.CreateWallet(ctx, wallet)
	}

	wallet.Balance += amount
	wallet.UpdatedAt = time.Now()

	tx := &domain.WalletTransaction{
		ID:       uuid.New().String(),
		WalletID: wallet.ID,
		UserID:   userID,
		Amount:   amount,
		Type:     "credit",
		Reason:   "add_funds",
		CreatedAt: time.Now(),
	}

	if err := u.repo.AddWalletTransaction(ctx, tx); err != nil {
		return err
	}

	return u.repo.UpdateWallet(ctx, wallet)
}

func (u *PaymentUsecase) WithdrawFromWallet(ctx context.Context, userID string, amount float64) error {
	wallet, err := u.repo.GetWallet(ctx, userID)
	if err != nil || wallet == nil {
		return errors.NewNotFoundError("wallet not found")
	}

	if wallet.Balance < amount {
		return errors.NewValidationError("insufficient balance")
	}

	wallet.Balance -= amount
	wallet.UpdatedAt = time.Now()

	tx := &domain.WalletTransaction{
		ID:       uuid.New().String(),
		WalletID: wallet.ID,
		UserID:   userID,
		Amount:   amount,
		Type:     "debit",
		Reason:   "withdraw",
		CreatedAt: time.Now(),
	}

	if err := u.repo.AddWalletTransaction(ctx, tx); err != nil {
		return err
	}

	return u.repo.UpdateWallet(ctx, wallet)
}

// Payment Methods
func (u *PaymentUsecase) GetPaymentMethods(ctx context.Context, userID string) ([]domain.PaymentMethod, error) {
	methods, err := u.repo.GetPaymentMethods(ctx, userID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return methods, nil
}

func (u *PaymentUsecase) AddPaymentMethod(ctx context.Context, userID, methodType, details string) error {
	method := &domain.PaymentMethod{
		ID:        uuid.New().String(),
		UserID:    userID,
		Type:      methodType,
		Details:   details,
		CreatedAt: time.Now(),
	}
	return u.repo.AddPaymentMethod(ctx, method)
}

func (u *PaymentUsecase) DeletePaymentMethod(ctx context.Context, id string) error {
	return u.repo.DeletePaymentMethod(ctx, id)
}
