package repository

import (
	"context"
	"errors"

	"github.com/vikashkp9030/zomato/services/delivery-service/internal/domain"
	"gorm.io/gorm"
)

type DeliveryRepository struct {
	db *gorm.DB
}

func NewDeliveryRepository(db *gorm.DB) *DeliveryRepository {
	return &DeliveryRepository{db}
}

func (r *DeliveryRepository) CreateDelivery(ctx context.Context, delivery *domain.Delivery) error {
	return r.db.WithContext(ctx).Create(delivery).Error
}

func (r *DeliveryRepository) GetDelivery(ctx context.Context, orderID string) (*domain.Delivery, error) {
	var delivery domain.Delivery
	if err := r.db.WithContext(ctx).Where("order_id = ?", orderID).First(&delivery).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &delivery, nil
}

func (r *DeliveryRepository) UpdateDelivery(ctx context.Context, delivery *domain.Delivery) error {
	return r.db.WithContext(ctx).Save(delivery).Error
}

func (r *DeliveryRepository) GetPartnerDeliveries(ctx context.Context, partnerID string) ([]domain.Delivery, error) {
	var deliveries []domain.Delivery
	if err := r.db.WithContext(ctx).Where("delivery_partner_id = ?", partnerID).Find(&deliveries).Error; err != nil {
		return nil, err
	}
	return deliveries, nil
}

// Partner methods
func (r *DeliveryRepository) GetDeliveryPartner(ctx context.Context, id string) (*domain.DeliveryPartner, error) {
	var partner domain.DeliveryPartner
	if err := r.db.WithContext(ctx).Where("id = ?", id).First(&partner).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &partner, nil
}

func (r *DeliveryRepository) GetAvailablePartners(ctx context.Context) ([]domain.DeliveryPartner, error) {
	var partners []domain.DeliveryPartner
	if err := r.db.WithContext(ctx).Where("is_available = ?", true).Find(&partners).Error; err != nil {
		return nil, err
	}
	return partners, nil
}

func (r *DeliveryRepository) UpdatePartner(ctx context.Context, partner *domain.DeliveryPartner) error {
	return r.db.WithContext(ctx).Save(partner).Error
}

// Location tracking
func (r *DeliveryRepository) CreateLocation(ctx context.Context, location *domain.DeliveryPartnerLocation) error {
	return r.db.WithContext(ctx).Create(location).Error
}

func (r *DeliveryRepository) GetLatestLocation(ctx context.Context, partnerID, orderID string) (*domain.DeliveryPartnerLocation, error) {
	var location domain.DeliveryPartnerLocation
	if err := r.db.WithContext(ctx).
		Where("delivery_partner_id = ? AND order_id = ?", partnerID, orderID).
		Order("created_at DESC").
		First(&location).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &location, nil
}

// Rating
func (r *DeliveryRepository) CreateRating(ctx context.Context, rating *domain.DeliveryRating) error {
	return r.db.WithContext(ctx).Create(rating).Error
}

func (r *DeliveryRepository) GetPartnerRating(ctx context.Context, partnerID string) (float64, error) {
	var avg float64
	if err := r.db.WithContext(ctx).Model(&domain.DeliveryRating{}).
		Where("delivery_partner_id = ?", partnerID).
		Select("AVG(rating)").
		Scan(&avg).Error; err != nil {
		return 0, err
	}
	return avg, nil
}
