package kafka

import (
	"context"
	"fmt"
	"log"

	"github.com/segmentio/kafka-go"
)

// Consumer represents a Kafka consumer
type Consumer struct {
	reader *kafka.Reader
	group  string
	topic  string
}

// ConsumerConfig contains Kafka consumer configuration
type ConsumerConfig struct {
	Brokers      []string
	Topic        string
	GroupID      string
	StartOffset  int64
	MinBytes     int
	MaxBytes     int
	CommitOffset bool
}

// NewConsumer creates a new Kafka consumer
func NewConsumer(config ConsumerConfig) (*Consumer, error) {
	if len(config.Brokers) == 0 {
		return nil, fmt.Errorf("brokers list cannot be empty")
	}
	if config.Topic == "" {
		return nil, fmt.Errorf("topic cannot be empty")
	}
	if config.GroupID == "" {
		return nil, fmt.Errorf("group ID cannot be empty")
	}

	if config.MinBytes == 0 {
		config.MinBytes = 10e3
	}
	if config.MaxBytes == 0 {
		config.MaxBytes = 10e6
	}

	reader := kafka.NewReader(kafka.ReaderConfig{
		Brokers:        config.Brokers,
		Topic:          config.Topic,
		GroupID:        config.GroupID,
		StartOffset:    config.StartOffset,
		MinBytes:       config.MinBytes,
		MaxBytes:       config.MaxBytes,
		CommitInterval: nil,
	})

	log.Printf("Kafka Consumer created for topic '%s' in group '%s' on brokers: %v", config.Topic, config.GroupID, config.Brokers)
	return &Consumer{
		reader: reader,
		group:  config.GroupID,
		topic:  config.Topic,
	}, nil
}

// ReadMessage reads a single message from Kafka
func (c *Consumer) ReadMessage(ctx context.Context) (kafka.Message, error) {
	message, err := c.reader.ReadMessage(ctx)
	if err != nil {
		log.Printf("Failed to read message from Kafka: %v", err)
		return kafka.Message{}, err
	}

	log.Printf("Message received from Kafka topic '%s': key=%s", c.topic, string(message.Key))
	return message, nil
}

// ReadMessages reads multiple messages from Kafka
func (c *Consumer) ReadMessages(ctx context.Context, count int) ([]kafka.Message, error) {
	messages := make([]kafka.Message, 0, count)

	for i := 0; i < count; i++ {
		message, err := c.ReadMessage(ctx)
		if err != nil {
			log.Printf("Error reading message %d: %v", i, err)
			return messages, err
		}
		messages = append(messages, message)
	}

	log.Printf("Read %d messages from Kafka topic '%s'", len(messages), c.topic)
	return messages, nil
}

// CommitMessages commits the offset for read messages
func (c *Consumer) CommitMessages(ctx context.Context, messages ...kafka.Message) error {
	if len(messages) == 0 {
		return nil
	}

	err := c.reader.CommitMessages(ctx, messages...)
	if err != nil {
		log.Printf("Failed to commit messages: %v", err)
		return err
	}

	log.Printf("Committed %d messages for topic '%s'", len(messages), c.topic)
	return nil
}

// Close closes the Kafka consumer
func (c *Consumer) Close() error {
	if c.reader != nil {
		log.Printf("Closing Kafka consumer for topic '%s'", c.topic)
		return c.reader.Close()
	}
	return nil
}

// GetTopic returns the consumer topic
func (c *Consumer) GetTopic() string {
	return c.topic
}

// GetGroup returns the consumer group
func (c *Consumer) GetGroup() string {
	return c.group
}

// MustCreateConsumer creates a consumer and panics on error
func MustCreateConsumer(config ConsumerConfig) *Consumer {
	consumer, err := NewConsumer(config)
	if err != nil {
		panic(fmt.Sprintf("Failed to create Kafka consumer: %v", err))
	}
	return consumer
}
