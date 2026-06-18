package events

import (
	"context"
	"encoding/json"
	"log"

	"github.com/vikashkp9030/zomato/shared/pkg/kafka"
)

// EventConsumer handles Kafka event consumption
type EventConsumer struct {
	consumer *kafka.Consumer
}

// NewEventConsumer creates a new event consumer
func NewEventConsumer(c *kafka.Consumer) *EventConsumer {
	return &EventConsumer{
		consumer: c,
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

// ListenOrderCreated listens for order created events
func (ec *EventConsumer) ListenOrderCreated(ctx context.Context, handler func(OrderCreatedEvent) error) error {
	log.Println("Starting to listen for OrderCreated events...")

	for {
		message, err := ec.consumer.ReadMessage(ctx)
		if err != nil {
			log.Printf("Error reading message: %v", err)
			return err
		}

		var event OrderCreatedEvent
		if err := json.Unmarshal(message.Value, &event); err != nil {
			log.Printf("Error unmarshaling event: %v", err)
			continue
		}

		log.Printf("Received OrderCreated event for order %s", event.OrderID)

		if err := handler(event); err != nil {
			log.Printf("Error handling OrderCreated event: %v", err)
			continue
		}

		if err := ec.consumer.CommitMessages(ctx, message); err != nil {
			log.Printf("Error committing message: %v", err)
		}
	}
}

// ListenOrderStatusChanged listens for order status change events
func (ec *EventConsumer) ListenOrderStatusChanged(ctx context.Context, handler func(OrderStatusChangedEvent) error) error {
	log.Println("Starting to listen for OrderStatusChanged events...")

	for {
		message, err := ec.consumer.ReadMessage(ctx)
		if err != nil {
			log.Printf("Error reading message: %v", err)
			return err
		}

		var event OrderStatusChangedEvent
		if err := json.Unmarshal(message.Value, &event); err != nil {
			log.Printf("Error unmarshaling event: %v", err)
			continue
		}

		log.Printf("Received OrderStatusChanged event for order %s", event.OrderID)

		if err := handler(event); err != nil {
			log.Printf("Error handling OrderStatusChanged event: %v", err)
			continue
		}

		if err := ec.consumer.CommitMessages(ctx, message); err != nil {
			log.Printf("Error committing message: %v", err)
		}
	}
}

// Close closes the event consumer
func (ec *EventConsumer) Close() error {
	return ec.consumer.Close()
}
