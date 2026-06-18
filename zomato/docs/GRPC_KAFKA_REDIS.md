# gRPC, Kafka, and Redis Implementation Guide

## Overview

This document explains the proper implementation of gRPC, Apache Kafka, and Redis in the Zomato food delivery platform.

---

## 1. gRPC Implementation

### 1.1 What is gRPC?

gRPC is a high-performance, open-source RPC framework developed by Google. It uses Protocol Buffers for serialization and HTTP/2 for transport.

**Benefits**:
- ✅ High performance (10-20x faster than REST)
- ✅ Strong typing with Protocol Buffers
- ✅ Bidirectional streaming
- ✅ Multiplexing over HTTP/2
- ✅ Language agnostic

### 1.2 Proto Files

Proto files define your service contracts:

**Location**: `shared/proto/`
- `user.proto` - User service definitions
- `order.proto` - Order service definitions
- `restaurant.proto` - Restaurant service definitions

**Example Proto Definition**:
```protobuf
syntax = "proto3";

package pb;

message User {
  string id = 1;
  string email = 2;
  string phone = 3;
  int64 created_at = 4;
}

service UserService {
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
}
```

### 1.3 Generate Go Code

Generate Go code from proto files:

```bash
# Install protoc compiler
brew install protobuf  # macOS
apt-get install protobuf-compiler  # Linux

# Install Go plugins
go install github.com/grpc/grpc-go/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Generate code
protoc --go_out=. --go-opt=paths=source_relative \
       --go-grpc_out=. --go-grpc_out=paths=source_relative \
       shared/proto/*.proto
```

### 1.4 gRPC Server Implementation

```go
package main

import (
	"github.com/vikashkp9030/zomato/shared/pkg/grpc"
	pb "github.com/vikashkp9030/zomato/shared/pb"
)

// Create server
server, err := grpc.NewGRPCServer(9001)
if err != nil {
	panic(err)
}

// Register service (after implementing the service interface)
pb.RegisterUserServiceServer(server.GetServer(), &UserServiceImpl{})

// Start server
go server.Start()
```

### 1.5 gRPC Client Implementation

```go
package main

import (
	"github.com/vikashkp9030/zomato/shared/pkg/grpc"
	pb "github.com/vikashkp9030/zomato/shared/pb"
)

// Create client
client, err := grpc.NewGRPCClient("localhost:9001")
if err != nil {
	panic(err)
}
defer client.Close()

// Use client
userClient := pb.NewUserServiceClient(client.GetConnection())
user, err := userClient.GetUser(ctx, &pb.GetUserRequest{UserId: "123"})
```

### 1.6 Files Provided

- `shared/pkg/grpc/grpc_server.go` - gRPC server wrapper
- `shared/pkg/grpc/grpc_client.go` - gRPC client wrapper
- `shared/proto/user.proto` - User service definitions
- `shared/proto/order.proto` - Order service definitions
- `shared/proto/restaurant.proto` - Restaurant service definitions

---

## 2. Apache Kafka Implementation

### 2.1 What is Kafka?

Apache Kafka is a distributed event streaming platform designed for high-throughput, low-latency data processing.

**Benefits**:
- ✅ High throughput (millions of messages/second)
- ✅ Fault-tolerant and durable
- ✅ Scalable distributed architecture
- ✅ Real-time data processing
- ✅ Decouples producers and consumers

### 2.2 Kafka Architecture

```
Producers → Topic (Partitions) → Consumers (Groups)
             ↓
         Brokers (Cluster)
             ↓
         ZooKeeper
```

### 2.3 Kafka Producer Implementation

**Usage**:
```go
package main

import (
	"github.com/vikashkp9030/zomato/shared/pkg/kafka"
)

// Create producer
config := kafka.ProducerConfig{
	Brokers: []string{"localhost:9092"},
	Topic:   "orders",
}
producer, err := kafka.NewProducer(config)
if err != nil {
	panic(err)
}
defer producer.Close()

// Send message
err = producer.SendMessage(ctx, "user-123", OrderCreatedEvent{
	OrderID: "order-456",
	UserID:  "user-123",
	Amount:  299.99,
})
```

### 2.4 Kafka Consumer Implementation

**Usage**:
```go
package main

import (
	"github.com/vikashkp9030/zomato/shared/pkg/kafka"
)

// Create consumer
config := kafka.ConsumerConfig{
	Brokers:    []string{"localhost:9092"},
	Topic:      "orders",
	GroupID:    "order-processing",
	StartOffset: -1, // Read from latest
}
consumer, err := kafka.NewConsumer(config)
if err != nil {
	panic(err)
}
defer consumer.Close()

// Read messages
for {
	message, err := consumer.ReadMessage(ctx)
	if err != nil {
		log.Printf("Error reading message: %v", err)
		break
	}
	
	// Process message
	ProcessOrder(message.Value)
	
	// Commit offset
	consumer.CommitMessages(ctx, message)
}
```

### 2.5 Kafka Topics for Zomato

**Recommended Topics**:
- `orders.created` - Order creation events
- `orders.updated` - Order status updates
- `payments.completed` - Payment completion events
- `deliveries.assigned` - Delivery assignments
- `restaurants.registered` - New restaurant registrations
- `reviews.posted` - Customer reviews
- `notifications.user` - User notifications

### 2.6 Files Provided

- `shared/pkg/kafka/producer.go` - Kafka producer wrapper
- `shared/pkg/kafka/consumer.go` - Kafka consumer wrapper

### 2.7 Docker Compose Setup for Kafka

```yaml
zookeeper:
  image: confluentinc/cp-zookeeper:7.5.0
  environment:
    ZOOKEEPER_CLIENT_PORT: 2181

kafka:
  image: confluentinc/cp-kafka:7.5.0
  depends_on:
    - zookeeper
  ports:
    - "9092:9092"
  environment:
    KAFKA_BROKER_ID: 1
    KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
    KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:29092,PLAINTEXT_HOST://localhost:9092
    KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
    KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
    KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
```

---

## 3. Redis Implementation

### 3.1 What is Redis?

Redis is an in-memory data structure store used for caching, sessions, and real-time analytics.

**Benefits**:
- ✅ Sub-millisecond latency
- ✅ Supports multiple data structures
- ✅ Persistence options (RDB, AOF)
- ✅ Replication and clustering
- ✅ Pub/Sub messaging

### 3.2 Redis Data Structures

1. **Strings** - Simple key-value pairs
```go
rc.SetString(ctx, "user:123:name", "John", 1*time.Hour)
name, err := rc.GetString(ctx, "user:123:name")
```

2. **Hashes** - Field-value pairs within a key
```go
rc.SetHash(ctx, "user:123", map[string]interface{}{
	"name": "John",
	"email": "john@example.com",
})
hash, err := rc.GetHash(ctx, "user:123")
```

3. **Lists** - Ordered collections
```go
rc.AppendToList(ctx, "orders:user:123", "order-1", "order-2")
orders, err := rc.GetList(ctx, "orders:user:123")
```

4. **Sets** - Unordered unique collections
5. **Sorted Sets** - Sets with scores

### 3.3 Redis Cache Implementation

**Features**:
- ✅ JSON serialization for complex objects
- ✅ TTL (Time-To-Live) support
- ✅ Connection pooling
- ✅ Hash and List operations
- ✅ Atomic operations

**Usage**:
```go
package main

import (
	"github.com/vikashkp9030/zomato/shared/pkg/cache"
)

// Create Redis cache
rc := cache.MustConnect("localhost:6379")
defer rc.Close()

// Set with expiry
user := User{ID: "123", Name: "John"}
rc.Set(ctx, "user:123", user, 1*time.Hour)

// Get and deserialize
var retrievedUser User
rc.Get(ctx, "user:123", &retrievedUser)

// Set string value
rc.SetString(ctx, "session:abc", token, 24*time.Hour)

// Hash operations
rc.SetHash(ctx, "user:123:profile", map[string]interface{}{
	"email": "john@example.com",
	"phone": "1234567890",
})

// List operations
rc.AppendToList(ctx, "notifications:user:123", notification1, notification2)

// Expire a key
rc.SetExpiry(ctx, "user:123", 2*time.Hour)

// Check TTL
ttl, err := rc.TTL(ctx, "user:123")

// Delete
rc.Delete(ctx, "user:123")
```

### 3.4 Redis Caching Patterns

**Pattern 1: Cache-Aside (Lazy Loading)**
```go
// Try cache first
var user User
if err := rc.Get(ctx, "user:123", &user); err == nil {
	return user
}

// Cache miss, load from database
user = loadFromDB("123")

// Store in cache
rc.Set(ctx, "user:123", user, 1*time.Hour)
return user
```

**Pattern 2: Write-Through**
```go
// Update database and cache simultaneously
user.Name = "Updated Name"
db.Update(user)
rc.Set(ctx, "user:123", user, 1*time.Hour)
```

**Pattern 3: Cache Invalidation**
```go
// After update, invalidate cache
user.Name = "New Name"
db.Update(user)
rc.Delete(ctx, "user:123")
```

### 3.5 Files Provided

- `shared/pkg/cache/redis.go` - Enhanced Redis cache wrapper with advanced features

### 3.6 Redis Configuration in docker-compose.yml

```yaml
redis:
  image: redis:7-alpine
  ports:
    - "6379:6379"
  command: redis-server --appendonly yes
  volumes:
    - redis_data:/data
```

---

## 4. Integration Example

### 4.1 Complete Microservice Pattern

```go
package main

import (
	"context"
	"github.com/vikashkp9030/zomato/shared/pkg/cache"
	"github.com/vikashkp9030/zomato/shared/pkg/grpc"
	"github.com/vikashkp9030/zomato/shared/pkg/kafka"
	pb "github.com/vikashkp9030/zomato/shared/pb"
)

type UserService struct {
	db    database.DB
	cache cache.RedisCache
	producer kafka.Producer
}

// gRPC Handler
func (u *UserService) GetUser(ctx context.Context, req *pb.GetUserRequest) (*pb.GetUserResponse, error) {
	// Check cache first
	var user User
	if err := u.cache.Get(ctx, "user:"+req.UserId, &user); err == nil {
		return &pb.GetUserResponse{User: &pb.User{...}}, nil
	}
	
	// Load from database
	user = u.db.GetUser(req.UserId)
	
	// Cache result
	u.cache.Set(ctx, "user:"+req.UserId, user, 1*time.Hour)
	
	// Publish event
	u.producer.SendMessage(ctx, user.ID, UserAccessedEvent{...})
	
	return &pb.GetUserResponse{...}, nil
}
```

### 4.2 Event-Driven Architecture

```
REST API → User Service (gRPC)
              ↓
         Process & Validate
              ↓
         Kafka (orders.created)
              ↓
    ┌─────────┼─────────┐
    ↓         ↓         ↓
 Payment  Delivery  Notification
 Service  Service   Service
    ↓         ↓         ↓
   Redis (Caching & State)
```

---

## 5. Performance Considerations

### 5.1 gRPC Performance

- **Latency**: ~1-5ms per RPC call
- **Throughput**: 10,000+ requests/second per service
- **Best For**: Inter-service communication, streaming

### 5.2 Kafka Performance

- **Throughput**: 100,000+ messages/second per broker
- **Latency**: 50-100ms (configurable)
- **Best For**: Event distribution, decoupled services

### 5.3 Redis Performance

- **Operations**: 100,000+ per second
- **Latency**: <1ms (in-memory)
- **Best For**: Caching, sessions, real-time data

---

## 6. Monitoring & Debugging

### 6.1 gRPC Debugging

```bash
# Enable verbose logging
export GRPC_GO_LOG_VERBOSITY_LEVEL=99
export GRPC_GO_LOG_SEVERITY_LEVEL=info

# Use grpcurl for testing
grpcurl -plaintext localhost:9001 list
grpcurl -plaintext -d '{"user_id":"123"}' localhost:9001 pb.UserService/GetUser
```

### 6.2 Kafka Debugging

```bash
# List topics
kafka-topics --bootstrap-server localhost:9092 --list

# Consume messages
kafka-console-consumer --bootstrap-server localhost:9092 --topic orders.created --from-beginning

# Describe topic
kafka-topics --bootstrap-server localhost:9092 --describe --topic orders.created
```

### 6.3 Redis Debugging

```bash
# Connect to Redis CLI
redis-cli

# View all keys
KEYS *

# Get key details
GET user:123
HGETALL user:123:profile
LRANGE orders:user:123 0 -1

# Monitor
MONITOR
```

---

## 7. Best Practices

### 7.1 gRPC Best Practices

✅ Use meaningful service names  
✅ Implement proper error handling  
✅ Use message versioning  
✅ Implement timeouts  
✅ Use proper authentication (mTLS)  
✅ Monitor service latency  

### 7.2 Kafka Best Practices

✅ Use meaningful topic names  
✅ Implement idempotent consumers  
✅ Handle poison messages  
✅ Monitor consumer lag  
✅ Use partitioning for scalability  
✅ Implement proper error handling  

### 7.3 Redis Best Practices

✅ Set appropriate TTLs  
✅ Use key namespacing (user:123:name)  
✅ Monitor memory usage  
✅ Use pipelining for multiple operations  
✅ Implement proper connection pooling  
✅ Handle cache misses gracefully  
✅ Implement cache invalidation strategies  

---

## 8. Troubleshooting

### gRPC Issues

| Problem | Solution |
|---------|----------|
| Connection refused | Check service is running on correct port |
| Deadline exceeded | Increase timeout or optimize service |
| Unavailable error | Check service availability |

### Kafka Issues

| Problem | Solution |
|---------|----------|
| Broker not available | Check Kafka is running |
| Offset out of range | Implement proper offset management |
| Consumer lag high | Increase partitions or consumer replicas |

### Redis Issues

| Problem | Solution |
|---------|----------|
| Connection timeout | Check Redis is running and accessible |
| Memory limit exceeded | Implement TTL and eviction policies |
| Slow operation | Use pipeline or lua scripts |

---

## Summary

The Zomato platform now has proper implementations of:

✅ **gRPC** - High-performance service-to-service communication  
✅ **Kafka** - Event streaming and message queuing  
✅ **Redis** - Caching, sessions, and real-time data  

These technologies work together to create a scalable, responsive, and resilient food delivery platform.

---

**Generated**: June 18, 2026  
**Status**: ✅ Complete Implementation  
**Ready for**: Production Use
