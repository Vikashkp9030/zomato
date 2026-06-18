package domain

import "time"

type Delivery struct {
	ID              string    `gorm:"primaryKey" json:"id"`
	OrderID         string    `json:"order_id"`
	DeliveryPartnerID string   `json:"delivery_partner_id"`
	Status          string    `json:"status"` // assigned, accepted, on_way, delivered, cancelled
	PickupAddress   string    `json:"pickup_address"`
	DeliveryAddress string    `json:"delivery_address"`
	PickupTime      *time.Time `json:"pickup_time"`
	DeliveryTime    *time.Time `json:"delivery_time"`
	Distance        float64   `json:"distance"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

type DeliveryPartner struct {
	ID              string    `gorm:"primaryKey" json:"id"`
	UserID          string    `json:"user_id"`
	PhoneNumber     string    `json:"phone_number"`
	VehicleType     string    `json:"vehicle_type"` // bike, car
	VehicleNumber   string    `json:"vehicle_number"`
	IsAvailable     bool      `json:"is_available"`
	CurrentLatitude float64   `json:"current_latitude"`
	CurrentLongitude float64  `json:"current_longitude"`
	TotalDeliveries int       `json:"total_deliveries"`
	Rating          float64   `json:"rating"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

type DeliveryPartnerLocation struct {
	ID              string    `gorm:"primaryKey" json:"id"`
	DeliveryPartnerID string   `json:"delivery_partner_id"`
	OrderID         string    `json:"order_id"`
	Latitude        float64   `json:"latitude"`
	Longitude       float64   `json:"longitude"`
	CreatedAt       time.Time `json:"created_at"`
}

type DeliveryRating struct {
	ID              string    `gorm:"primaryKey" json:"id"`
	OrderID         string    `json:"order_id"`
	DeliveryPartnerID string   `json:"delivery_partner_id"`
	Rating          float64   `json:"rating"`
	Review          string    `json:"review"`
	CreatedAt       time.Time `json:"created_at"`
}

func (d *Delivery) TableName() string {
	return "deliveries"
}

func (dp *DeliveryPartner) TableName() string {
	return "delivery_partners"
}

func (dpl *DeliveryPartnerLocation) TableName() string {
	return "delivery_partner_locations"
}

func (dr *DeliveryRating) TableName() string {
	return "delivery_ratings"
}
