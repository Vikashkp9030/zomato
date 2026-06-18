package events

import (
	"context"
	"encoding/json"
	"log"

	"github.com/vikashkp9030/zomato/shared/pkg/kafka"
)

// EventProducer handles Kafka event publishing
type EventProducer struct {
	producer *kafka.Producer
}

// NewEventProducer creates a new event producer
func NewEventProducer(p *kafka.Producer) *EventProducer {
	return &EventProducer{
		producer: p,
	}
}

// OrderCreatedEvent represents an order creation event
type OrderCreatedEvent struct {
	OrderID      string  `json:"order_id"`
	UserID       string  `json:"user_id"`
	RestaurantID string  `json:"restaurant_id"`
	TotalAmount  float64 `json:"total_amount"`
	CreatedAt    int64   `json:"created_at"`
}

// OrderStatusChangedEvent represents an order status change event
type OrderStatusChangedEvent struct {
	OrderID   string `json:"order_id"`
	OldStatus string `json:"old_status"`
	NewStatus string `json:"new_status"`
	UpdatedAt int64  `json:"updated_at"`
}

// PublishOrderCreated publishes an order created event
func (ep *EventProducer) PublishOrderCreated(ctx context.Context, event OrderCreatedEvent) error {
	log.Printf("Publishing OrderCreated event for order %s", event.OrderID)

	err := ep.producer.SendMessage(ctx, event.OrderID, event)
	if err != nil {
		log.Printf("Error publishing OrderCreated event: %v", err)
		return err
	}

	log.Printf("OrderCreated event published successfully for order %s", event.OrderID)
	return nil
}

// PublishOrderStatusChanged publishes an order status change event
func (ep *EventProducer) PublishOrderStatusChanged(ctx context.Context, event OrderStatusChangedEvent) error {
	log.Printf("Publishing OrderStatusChanged event for order %s", event.OrderID)

	err := ep.producer.SendMessage(ctx, event.OrderID, event)
	if err != nil {
		log.Printf("Error publishing OrderStatusChanged event: %v", err)
		return err
	}

	log.Printf("OrderStatusChanged event published successfully for order %s", event.OrderID)
	return nil
}

// Close closes the event producer
func (ep *EventProducer) Close() error {
	return ep.producer.Close()
}
