package repository

import (
	"context"
	"errors"

	"github.com/vikashkp9030/zomato/services/payment-service/internal/domain"
	"gorm.io/gorm"
)

type PaymentRepository struct {
	db *gorm.DB
}

func NewPaymentRepository(db *gorm.DB) *PaymentRepository {
	return &PaymentRepository{db}
}

func (r *PaymentRepository) CreatePayment(ctx context.Context, payment *domain.Payment) error {
	return r.db.WithContext(ctx).Create(payment).Error
}

func (r *PaymentRepository) GetPayment(ctx context.Context, id string) (*domain.Payment, error) {
	var payment domain.Payment
	if err := r.db.WithContext(ctx).Where("id = ?", id).First(&payment).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &payment, nil
}

func (r *PaymentRepository) GetUserPayments(ctx context.Context, userID string) ([]domain.Payment, error) {
	var payments []domain.Payment
	if err := r.db.WithContext(ctx).Where("user_id = ?", userID).Find(&payments).Error; err != nil {
		return nil, err
	}
	return payments, nil
}

func (r *PaymentRepository) UpdatePayment(ctx context.Context, payment *domain.Payment) error {
	return r.db.WithContext(ctx).Save(payment).Error
}

// Wallet methods
func (r *PaymentRepository) GetWallet(ctx context.Context, userID string) (*domain.Wallet, error) {
	var wallet domain.Wallet
	if err := r.db.WithContext(ctx).Where("user_id = ?", userID).First(&wallet).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &wallet, nil
}

func (r *PaymentRepository) CreateWallet(ctx context.Context, wallet *domain.Wallet) error {
	return r.db.WithContext(ctx).Create(wallet).Error
}

func (r *PaymentRepository) UpdateWallet(ctx context.Context, wallet *domain.Wallet) error {
	return r.db.WithContext(ctx).Save(wallet).Error
}

func (r *PaymentRepository) AddWalletTransaction(ctx context.Context, tx *domain.WalletTransaction) error {
	return r.db.WithContext(ctx).Create(tx).Error
}

// Payment Method methods
func (r *PaymentRepository) GetPaymentMethods(ctx context.Context, userID string) ([]domain.PaymentMethod, error) {
	var methods []domain.PaymentMethod
	if err := r.db.WithContext(ctx).Where("user_id = ?", userID).Find(&methods).Error; err != nil {
		return nil, err
	}
	return methods, nil
}

func (r *PaymentRepository) AddPaymentMethod(ctx context.Context, method *domain.PaymentMethod) error {
	return r.db.WithContext(ctx).Create(method).Error
}

func (r *PaymentRepository) DeletePaymentMethod(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Delete(&domain.PaymentMethod{}, "id = ?", id).Error
}

// Refund methods
func (r *PaymentRepository) CreateRefund(ctx context.Context, refund *domain.Refund) error {
	return r.db.WithContext(ctx).Create(refund).Error
}

func (r *PaymentRepository) GetRefund(ctx context.Context, paymentID string) (*domain.Refund, error) {
	var refund domain.Refund
	if err := r.db.WithContext(ctx).Where("payment_id = ?", paymentID).First(&refund).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &refund, nil
}
