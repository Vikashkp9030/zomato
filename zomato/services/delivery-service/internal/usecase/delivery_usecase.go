package usecase

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/vikashkp9030/zomato/services/delivery-service/internal/domain"
	"github.com/vikashkp9030/zomato/services/delivery-service/internal/repository"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

type DeliveryUsecase struct {
	repo *repository.DeliveryRepository
}

func NewDeliveryUsecase(repo *repository.DeliveryRepository) *DeliveryUsecase {
	return &DeliveryUsecase{repo}
}

type AssignDeliveryInput struct {
	OrderID         string `json:"order_id" binding:"required"`
	PickupAddress   string `json:"pickup_address" binding:"required"`
	DeliveryAddress string `json:"delivery_address" binding:"required"`
}

func (u *DeliveryUsecase) AssignDelivery(ctx context.Context, input AssignDeliveryInput) (*domain.Delivery, error) {
	// Get available partners
	partners, err := u.repo.GetAvailablePartners(ctx)
	if err != nil || len(partners) == 0 {
		return nil, errors.NewServiceUnavailableError("no delivery partners available")
	}

	// Assign to first available (can be optimized with geo-distance)
	partner := partners[0]

	delivery := &domain.Delivery{
		ID:               uuid.New().String(),
		OrderID:          input.OrderID,
		DeliveryPartnerID: partner.ID,
		Status:           "assigned",
		PickupAddress:    input.PickupAddress,
		DeliveryAddress:  input.DeliveryAddress,
		Distance:         5.2,
		CreatedAt:        time.Now(),
		UpdatedAt:        time.Now(),
	}

	if err := u.repo.CreateDelivery(ctx, delivery); err != nil {
		return nil, errors.NewInternalError("failed to assign delivery")
	}

	return delivery, nil
}

func (u *DeliveryUsecase) GetDelivery(ctx context.Context, orderID string) (*domain.Delivery, error) {
	delivery, err := u.repo.GetDelivery(ctx, orderID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	if delivery == nil {
		return nil, errors.NewNotFoundError("delivery not found")
	}
	return delivery, nil
}

func (u *DeliveryUsecase) UpdatePartnerLocation(ctx context.Context, partnerID, orderID string, lat, lon float64) error {
	location := &domain.DeliveryPartnerLocation{
		ID:                uuid.New().String(),
		DeliveryPartnerID: partnerID,
		OrderID:           orderID,
		Latitude:          lat,
		Longitude:         lon,
		CreatedAt:         time.Now(),
	}

	return u.repo.CreateLocation(ctx, location)
}

func (u *DeliveryUsecase) UpdatePartnerStatus(ctx context.Context, partnerID, status string) error {
	partner, err := u.repo.GetDeliveryPartner(ctx, partnerID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if partner == nil {
		return errors.NewNotFoundError("partner not found")
	}

	partner.IsAvailable = status == "available"
	partner.UpdatedAt = time.Now()

	return u.repo.UpdatePartner(ctx, partner)
}

func (u *DeliveryUsecase) GetPartnerEarnings(ctx context.Context, partnerID string) (map[string]interface{}, error) {
	deliveries, err := u.repo.GetPartnerDeliveries(ctx, partnerID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}

	var earnings float64
	for _, d := range deliveries {
		if d.Status == "delivered" {
			earnings += 50 // Fixed fee per delivery
		}
	}

	return map[string]interface{}{
		"total_earnings":   earnings,
		"total_deliveries": len(deliveries),
	}, nil
}

func (u *DeliveryUsecase) GetPartnerOrders(ctx context.Context, partnerID string) ([]domain.Delivery, error) {
	deliveries, err := u.repo.GetPartnerDeliveries(ctx, partnerID)
	if err != nil {
		return nil, errors.NewInternalError("database error")
	}
	return deliveries, nil
}

func (u *DeliveryUsecase) AcceptOrder(ctx context.Context, partnerID, orderID string) error {
	delivery, err := u.repo.GetDelivery(ctx, orderID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if delivery == nil {
		return errors.NewNotFoundError("delivery not found")
	}

	delivery.Status = "accepted"
	delivery.UpdatedAt = time.Now()

	return u.repo.UpdateDelivery(ctx, delivery)
}

func (u *DeliveryUsecase) RejectOrder(ctx context.Context, partnerID, orderID string) error {
	delivery, err := u.repo.GetDelivery(ctx, orderID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if delivery == nil {
		return errors.NewNotFoundError("delivery not found")
	}

	delivery.Status = "cancelled"
	delivery.UpdatedAt = time.Now()

	return u.repo.UpdateDelivery(ctx, delivery)
}

func (u *DeliveryUsecase) CompleteOrder(ctx context.Context, partnerID, orderID string) error {
	delivery, err := u.repo.GetDelivery(ctx, orderID)
	if err != nil {
		return errors.NewInternalError("database error")
	}
	if delivery == nil {
		return errors.NewNotFoundError("delivery not found")
	}

	now := time.Now()
	delivery.Status = "delivered"
	delivery.DeliveryTime = &now
	delivery.UpdatedAt = time.Now()

	return u.repo.UpdateDelivery(ctx, delivery)
}
