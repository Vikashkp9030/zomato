package repository

import (
	"context"
	"errors"

	"github.com/vikashkp9030/zomato/services/order-service/internal/domain"
	"gorm.io/gorm"
)

type OrderRepository struct {
	db *gorm.DB
}

func NewOrderRepository(db *gorm.DB) *OrderRepository {
	return &OrderRepository{db}
}

func (r *OrderRepository) CreateOrder(ctx context.Context, order *domain.Order) error {
	return r.db.WithContext(ctx).Create(order).Error
}

func (r *OrderRepository) GetOrder(ctx context.Context, id string) (*domain.Order, error) {
	var order domain.Order
	if err := r.db.WithContext(ctx).Preload("Items").Where("id = ?", id).First(&order).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &order, nil
}

func (r *OrderRepository) GetUserOrders(ctx context.Context, userID string) ([]domain.Order, error) {
	var orders []domain.Order
	if err := r.db.WithContext(ctx).Where("user_id = ?", userID).Preload("Items").Find(&orders).Error; err != nil {
		return nil, err
	}
	return orders, nil
}

func (r *OrderRepository) UpdateOrder(ctx context.Context, order *domain.Order) error {
	return r.db.WithContext(ctx).Save(order).Error
}

func (r *OrderRepository) CancelOrder(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Model(&domain.Order{}).Where("id = ?", id).Update("status", "cancelled").Error
}

// Cart methods
func (r *OrderRepository) GetCart(ctx context.Context, userID string) (*domain.Cart, error) {
	var cart domain.Cart
	if err := r.db.WithContext(ctx).Preload("Items").Where("user_id = ?", userID).First(&cart).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &cart, nil
}

func (r *OrderRepository) CreateCart(ctx context.Context, cart *domain.Cart) error {
	return r.db.WithContext(ctx).Create(cart).Error
}

func (r *OrderRepository) AddToCart(ctx context.Context, item *domain.CartItem) error {
	return r.db.WithContext(ctx).Create(item).Error
}

func (r *OrderRepository) UpdateCartItem(ctx context.Context, item *domain.CartItem) error {
	return r.db.WithContext(ctx).Save(item).Error
}

func (r *OrderRepository) RemoveFromCart(ctx context.Context, id string) error {
	return r.db.WithContext(ctx).Delete(&domain.CartItem{}, "id = ?", id).Error
}

func (r *OrderRepository) ClearCart(ctx context.Context, cartID string) error {
	return r.db.WithContext(ctx).Delete(&domain.CartItem{}, "cart_id = ?", cartID).Error
}

// Coupon methods
func (r *OrderRepository) GetCoupon(ctx context.Context, code string) (*domain.Coupon, error) {
	var coupon domain.Coupon
	if err := r.db.WithContext(ctx).Where("code = ?", code).First(&coupon).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &coupon, nil
}
