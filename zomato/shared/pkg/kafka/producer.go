package kafka

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"github.com/segmentio/kafka-go"
)

// Producer represents a Kafka producer
type Producer struct {
	writer *kafka.Writer
	topic  string
}

// ProducerConfig contains Kafka producer configuration
type ProducerConfig struct {
	Brokers []string
	Topic   string
}

// NewProducer creates a new Kafka producer
func NewProducer(config ProducerConfig) (*Producer, error) {
	if len(config.Brokers) == 0 {
		return nil, fmt.Errorf("brokers list cannot be empty")
	}

	writer := &kafka.Writer{
		Addr:     kafka.TCP(config.Brokers...),
		Topic:    config.Topic,
		Balancer: &kafka.LeastBytes{},
	}

	log.Printf("Kafka Producer created for topic '%s' on brokers: %v", config.Topic, config.Brokers)
	return &Producer{
		writer: writer,
		topic:  config.Topic,
	}, nil
}

// SendMessage sends a message to Kafka
func (p *Producer) SendMessage(ctx context.Context, key string, message interface{}) error {
	data, err := json.Marshal(message)
	if err != nil {
		log.Printf("Failed to marshal message: %v", err)
		return err
	}

	err = p.writer.WriteMessages(ctx, kafka.Message{
		Key:   []byte(key),
		Value: data,
	})

	if err != nil {
		log.Printf("Failed to send message to Kafka: %v", err)
		return err
	}

	log.Printf("Message sent to Kafka topic '%s' with key '%s'", p.topic, key)
	return nil
}

// SendMessages sends multiple messages to Kafka
func (p *Producer) SendMessages(ctx context.Context, messages []kafka.Message) error {
	err := p.writer.WriteMessages(ctx, messages...)
	if err != nil {
		log.Printf("Failed to send messages to Kafka: %v", err)
		return err
	}

	log.Printf("Sent %d messages to Kafka topic '%s'", len(messages), p.topic)
	return nil
}

// Close closes the Kafka producer
func (p *Producer) Close() error {
	if p.writer != nil {
		log.Printf("Closing Kafka producer for topic '%s'", p.topic)
		return p.writer.Close()
	}
	return nil
}

// GetTopic returns the producer topic
func (p *Producer) GetTopic() string {
	return p.topic
}

// MustCreateProducer creates a producer and panics on error
func MustCreateProducer(config ProducerConfig) *Producer {
	producer, err := NewProducer(config)
	if err != nil {
		panic(fmt.Sprintf("Failed to create Kafka producer: %v", err))
	}
	return producer
}
