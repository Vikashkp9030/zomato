package domain

import "time"

type Order struct {
	ID               string       `gorm:"primaryKey" json:"id"`
	UserID           string       `json:"user_id"`
	RestaurantID     string       `json:"restaurant_id"`
	DeliveryAddressID string      `json:"delivery_address_id"`
	TotalAmount      float64      `json:"total_amount"`
	TaxAmount        float64      `json:"tax_amount"`
	DeliveryFee      float64      `json:"delivery_fee"`
	Status           string       `json:"status"` // placed, confirmed, preparing, on_way, delivered, cancelled
	PaymentStatus    string       `json:"payment_status"` // pending, completed, failed
	PaymentMethod    string       `json:"payment_method"`
	EstimatedTime    int          `json:"estimated_time"` // minutes
	Notes            string       `json:"notes"`
	CreatedAt        time.Time    `json:"created_at"`
	UpdatedAt        time.Time    `json:"updated_at"`
	Items            []OrderItem  `gorm:"foreignKey:OrderID" json:"items"`
}

type OrderItem struct {
	ID         string    `gorm:"primaryKey" json:"id"`
	OrderID    string    `json:"order_id"`
	DishID     string    `json:"dish_id"`
	Quantity   int       `json:"quantity"`
	Price      float64   `json:"price"`
	Notes      string    `json:"notes"`
	CreatedAt  time.Time `json:"created_at"`
}

type Cart struct {
	ID           string     `gorm:"primaryKey" json:"id"`
	UserID       string     `json:"user_id"`
	RestaurantID string     `json:"restaurant_id"`
	Items        []CartItem `gorm:"foreignKey:CartID" json:"items"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

type CartItem struct {
	ID          string    `gorm:"primaryKey" json:"id"`
	CartID      string    `json:"cart_id"`
	DishID      string    `json:"dish_id"`
	Quantity    int       `json:"quantity"`
	Price       float64   `json:"price"`
	Notes       string    `json:"notes"`
	CreatedAt   time.Time `json:"created_at"`
}

type Coupon struct {
	ID       string    `gorm:"primaryKey" json:"id"`
	Code     string    `gorm:"uniqueIndex" json:"code"`
	Discount float64   `json:"discount"` // percentage or fixed
	Type     string    `json:"type"` // percentage, fixed
	MinOrder float64   `json:"min_order"`
	MaxUses  int       `json:"max_uses"`
	Uses     int       `json:"uses"`
	ExpiresAt time.Time `json:"expires_at"`
}

func (o *Order) TableName() string {
	return "orders"
}

func (oi *OrderItem) TableName() string {
	return "order_items"
}

func (c *Cart) TableName() string {
	return "carts"
}

func (ci *CartItem) TableName() string {
	return "cart_items"
}

func (c *Coupon) TableName() string {
	return "coupons"
}
