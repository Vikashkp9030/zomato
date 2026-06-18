package usecase

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/vikashkp9030/zomato/services/order-service/internal/domain"
	"github.com/vikashkp9030/zomato/services/order-service/internal/repository"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type OrderUsecase struct {
	repo *repository.OrderRepository
}

func NewOrderUsecase(repo *repository.OrderRepository) *OrderUsecase {
	return &OrderUsecase{repo}
}

type CreateOrderInput struct {
	RestaurantID string      `json:"restaurant_id" binding:"required"`
	DeliveryAddressID string `json:"delivery_address_id" binding:"required"`
	Items        []struct {
		DishID   string  `json:"dish_id"`
		Quantity int     `json:"quantity"`
		Price    float64 `json:"price"`
	} `json:"items"`
	PaymentMethod string  `json:"payment_method"`
	CouponCode    string  `json:"coupon_code"`
	Notes         string  `json:"notes"`
}

func (u *OrderUsecase) CreateOrder(ctx context.Context, userID string, input CreateOrderInput) (*domain.Order, error) {
	order := &domain.Order{
		ID:               uuid.New().String(),
		UserID:           userID,
		RestaurantID:     input.RestaurantID,
		DeliveryAddressID: input.DeliveryAddressID,
		Status:           "placed",
		PaymentStatus:    "pending",
		PaymentMethod:    input.PaymentMethod,
		Notes:            input.Notes,
		CreatedAt:        time.Now(),
		UpdatedAt:        time.Now(),
	}

	var totalAmount float64
	for _, item := range input.Items {
		orderItem := domain.OrderItem{
			ID:        uuid.New().String(),
			OrderID:   order.ID,
			DishID:    item.DishID,
			Quantity:  item.Quantity,
			Price:     item.Price,
			CreatedAt: time.Now(),
		}
		order.Items = append(order.Items, orderItem)
		totalAmount += item.Price * float64(item.Quantity)
	}

	order.TotalAmount = totalAmount
	order.TaxAmount = totalAmount * 0.05
	order.DeliveryFee = 30
	order.EstimatedTime = 45

	if err := u.repo.CreateOrder(ctx, order); err != nil {
		return nil, errors.NewInternalError("failed to create order")
	}

	return order, nil
}

func (u *OrderUsecase) GetOrder(ctx context.Context, id string) (*domain.Order, error) {
	order, err := u.repo.GetOrder(ctx, id)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	if order == nil {
		return nil, errors.NewNotFoundError("order not found")
	}
	return order, nil
}

func (u *OrderUsecase) ListOrders(ctx context.Context, userID string) ([]domain.Order, error) {
	orders, err := u.repo.GetUserOrders(ctx, userID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return orders, nil
}

func (u *OrderUsecase) UpdateOrderStatus(ctx context.Context, id, status string) error {
	order, err := u.repo.GetOrder(ctx, id)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if order == nil {
		return errors.NewNotFoundError("order not found")
	}

	order.Status = status
	order.UpdatedAt = time.Now()
	return u.repo.UpdateOrder(ctx, order)
}

func (u *OrderUsecase) CancelOrder(ctx context.Context, id string) error {
	order, err := u.repo.GetOrder(ctx, id)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if order == nil {
		return errors.NewNotFoundError("order not found")
	}

	if order.Status != "placed" && order.Status != "confirmed" {
		return errors.NewValidationError("cannot cancel order in current status")
	}

	return u.repo.CancelOrder(ctx, id)
}

// Cart operations
func (u *OrderUsecase) GetCart(ctx context.Context, userID string) (*domain.Cart, error) {
	cart, err := u.repo.GetCart(ctx, userID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return cart, nil
}

func (u *OrderUsecase) AddToCart(ctx context.Context, userID, restaurantID, dishID string, quantity int, price float64) error {
	cart, _ := u.repo.GetCart(ctx, userID)
	if cart == nil {
		cart = &domain.Cart{
			ID:           uuid.New().String(),
			UserID:       userID,
			RestaurantID: restaurantID,
			CreatedAt:    time.Now(),
		}
		u.repo.CreateCart(ctx, cart)
	}

	item := &domain.CartItem{
		ID:        uuid.New().String(),
		CartID:    cart.ID,
		DishID:    dishID,
		Quantity:  quantity,
		Price:     price,
		CreatedAt: time.Now(),
	}

	return u.repo.AddToCart(ctx, item)
}

func (u *OrderUsecase) UpdateCartItem(ctx context.Context, itemID string, quantity int) error {
	return u.repo.UpdateCartItem(ctx, &domain.CartItem{ID: itemID, Quantity: quantity})
}

func (u *OrderUsecase) RemoveFromCart(ctx context.Context, itemID string) error {
	return u.repo.RemoveFromCart(ctx, itemID)
}

func (u *OrderUsecase) ClearCart(ctx context.Context, cartID string) error {
	return u.repo.ClearCart(ctx, cartID)
}

func (u *OrderUsecase) EstimateDelivery(ctx context.Context, restaurantID, addressID string) (map[string]interface{}, error) {
	return map[string]interface{}{
		"estimated_time": 45,
		"distance_km":    5.2,
	}, nil
}
