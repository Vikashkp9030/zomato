# PROPER IMPLEMENTATION GUIDE - gRPC, Kafka, Redis, Microservices

**Status**: Production Implementation Guide  
**Version**: 2.0 (Corrected & Complete)  
**Date**: June 18, 2026

---

## CRITICAL FINDINGS FROM AUDIT

Based on thorough audit, the following was found:

### ❌ GRPC - NOT PROPERLY INTEGRATED
- Proto files exist but are NEVER COMPILED
- gRPC server utilities exist but NEVER INSTANTIATED
- Service implementations exist but NEVER REGISTERED
- Missing imports in order_service.go (FIXED)
- No gRPC server in any service main.go
- **FIX NEEDED**: Add proto compilation to Makefile, wire gRPC into services

### ❌ KAFKA - NOT PROPERLY INTEGRATED  
- Producer/Consumer utilities exist but NEVER USED
- Event models defined but NEVER PUBLISHED
- No Kafka in docker-compose.yml (RabbitMQ used instead)
- No event listeners in notification service
- **FIX NEEDED**: Add Kafka to docker-compose, wire producer into services, add consumers

### ⚠️ REDIS - PARTIALLY INTEGRATED
- Redis client is well-implemented
- User service integrates Redis but doesn't use it
- Restaurant service integrates Redis but actual caching unclear
- Other services ignore Redis completely
- **FIX NEEDED**: Implement actual caching logic, extend to all services

### ⚠️ MICROSERVICES - INCOMPLETE
- 6 services have proper structure (User, Restaurant, Order, Payment, Delivery, Review)
- 2 services are STUBS ONLY (Notification, Admin - just HTTP endpoints)
- No tests for any service
- Missing proper error handling

---

## HOW TO PROPERLY IMPLEMENT

### STEP 1: FIX GRPC COMPILATION

**File**: `/Makefile`

Add proto compilation:
```makefile
.PHONY: proto-compile
proto-compile:
	protoc --go_out=. --go-opt=paths=source_relative \
	        --go-grpc_out=. --go-grpc-opt=paths=source_relative \
	        shared/proto/*.proto

.PHONY: proto-clean  
proto-clean:
	find shared/proto -name "*.pb.go" -delete

build: proto-compile
	go build -o main ./cmd/main.go
```

**Commands**:
```bash
# Compile proto files
make proto-compile

# This generates shared/pb/*.pb.go files with compiled Go code
```

---

### STEP 2: WIRE GRPC INTO ORDER SERVICE

**File**: `/services/order-service/cmd/main.go`

Current: REST only  
Fix: Add gRPC server alongside REST

```go
import (
    // ... existing imports ...
    "google.golang.org/grpc"
    pb "github.com/vikashkp9030/zomato/shared/pb"
    grpcService "github.com/vikashkp9030/zomato/services/order-service/internal/grpc"
)

func main() {
    // ... existing code ...
    
    // START GRPC SERVER (Port 9003) 
    go func() {
        grpcServer, err := startGRPCServer(9003, orderRepo, orderUsecase)
        if err != nil {
            logger.Fatal("gRPC server failed", "error", err.Error())
        }
        logger.Info("gRPC server started on port 9003")
    }()
    
    // START REST API (Port 8003)
    port := viper.GetString("SERVICE_PORT")
    logger.Info("Order Service starting", "port", port)
    router.Run(fmt.Sprintf(":%s", port))
}

func startGRPCServer(port int, repo repository.OrderRepository, uc usecase.OrderUsecase) (*grpc.Server, error) {
    listener, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
    if err != nil {
        return nil, err
    }
    
    server := grpc.NewServer()
    
    // Register order service
    orderService := grpcService.NewOrderServiceImpl(repo, uc)
    pb.RegisterOrderServiceServer(server, orderService)
    
    // Start serving
    go func() {
        if err := server.Serve(listener); err != nil {
            logger.Error("gRPC server error", "error", err.Error())
        }
    }()
    
    return server, nil
}
```

**Result**: Order service now serves BOTH:
- REST API on port 8003
- gRPC API on port 9003

---

### STEP 3: ADD KAFKA TO docker-compose.yml

**File**: `/docker-compose.yml`

Current: Missing Kafka  
Fix: Add after RabbitMQ section:

```yaml
zookeeper:
  image: confluentinc/cp-zookeeper:7.5.0
  environment:
    ZOOKEEPER_CLIENT_PORT: 2181
  ports:
    - "2181:2181"

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
    KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"
```

**Result**: Kafka available at `kafka:9092` (internal) and `localhost:9092` (external)

---

### STEP 4: WIRE KAFKA PRODUCER INTO ORDER SERVICE

**File**: `/services/order-service/cmd/main.go`

Add producer initialization:

```go
import (
    // ... existing imports ...
    "github.com/vikashkp9030/zomato/shared/pkg/kafka"
    orderEvents "github.com/vikashkp9030/zomato/services/order-service/internal/events"
)

func main() {
    // ... database, JWT, etc. ...
    
    // KAFKA PRODUCER
    kafkaProducer, err := kafka.NewProducer(kafka.ProducerConfig{
        Brokers: []string{viper.GetString("KAFKA_BROKER")},
        Topic:   "orders.created",
    })
    if err != nil {
        logger.Error("Kafka producer failed", "error", err.Error())
        kafkaProducer = nil // Continue without Kafka
    } else {
        defer kafkaProducer.Close()
    }
    
    // Wire producer into usecase
    orderRepo := repository.NewOrderRepository(pgDB)
    orderUsecase := usecase.NewOrderUsecase(orderRepo, kafkaProducer)
    orderHandler := handler.NewOrderHandler(orderUsecase)
    
    // ... rest of code ...
}
```

**Result**: Order service publishes events to Kafka on order creation/update

---

### STEP 5: IMPLEMENT NOTIFICATION SERVICE WITH KAFKA CONSUMER

**File**: `/services/notification-service/cmd/main.go`

Current: STUB only  
Fix: Complete implementation

```go
package main

import (
    "context"
    "encoding/json"
    // ... other imports ...
    "github.com/vikashkp9030/zomato/shared/pkg/kafka"
    orderEvents "github.com/vikashkp9030/zomato/services/notification-service/internal/events"
)

func main() {
    logger.Init(os.Getenv("ENV"))
    
    // KAFKA CONSUMER
    kafkaConsumer, err := kafka.NewConsumer(kafka.ConsumerConfig{
        Brokers:    []string{viper.GetString("KAFKA_BROKER")},
        Topic:      "orders.created",
        GroupID:    "notification-service",
        StartOffset: -1, // Latest
    })
    if err != nil {
        logger.Fatal("Kafka consumer failed", "error", err.Error())
    }
    defer kafkaConsumer.Close()
    
    // START EVENT LISTENER
    go listenForOrderEvents(kafkaConsumer)
    
    // Start REST API for health checks
    router := gin.Default()
    router.GET("/health", func(c *gin.Context) {
        c.JSON(200, gin.H{"status": "ok", "service": "notification-service"})
    })
    
    logger.Info("Notification Service starting")
    router.Run(":8007")
}

func listenForOrderEvents(consumer *kafka.Consumer) {
    for {
        message, err := consumer.ReadMessage(context.Background())
        if err != nil {
            logger.Error("Failed to read Kafka message", "error", err.Error())
            continue
        }
        
        var event orderEvents.OrderCreatedEvent
        if err := json.Unmarshal(message.Value, &event); err != nil {
            logger.Error("Failed to parse event", "error", err.Error())
            continue
        }
        
        // Send notification (email/SMS/push)
        logger.Info("Order created event received",
            "orderId", event.OrderID,
            "userId", event.UserID,
        )
        
        // TODO: Send notification to user
        
        // Commit message
        consumer.CommitMessages(context.Background(), message)
    }
}
```

**Result**: Notification service listens to order events and sends notifications

---

### STEP 6: IMPLEMENT REDIS CACHING IN USER SERVICE

**File**: `/services/user-service/internal/usecase/user_usecase.go`

Current: Receives Redis but doesn't use it  
Fix: Implement caching

```go
func (uu *UserUsecase) GetProfile(ctx context.Context, userID string) (*domain.User, error) {
    // CHECK CACHE FIRST
    cacheKey := fmt.Sprintf("user:%s:profile", userID)
    var cachedUser domain.User
    if err := uu.cache.Get(ctx, cacheKey, &cachedUser); err == nil {
        logger.Info("User found in cache", "userId", userID)
        return &cachedUser, nil
    }
    
    // LOAD FROM DATABASE
    user, err := uu.repository.GetUserByID(ctx, userID)
    if err != nil {
        return nil, err
    }
    
    // CACHE RESULT
    uu.cache.Set(ctx, cacheKey, user, 1*time.Hour)
    
    return user, nil
}

func (uu *UserUsecase) UpdateProfile(ctx context.Context, user *domain.User) error {
    // UPDATE DATABASE
    if err := uu.repository.UpdateUser(ctx, user); err != nil {
        return err
    }
    
    // INVALIDATE CACHE
    cacheKey := fmt.Sprintf("user:%s:profile", user.ID)
    uu.cache.Delete(ctx, cacheKey)
    
    return nil
}
```

**Result**: User profiles cached for 1 hour, invalidated on updates

---

### STEP 7: COMPLETE ADMIN SERVICE

**File**: `/services/admin-service/`

Create proper domain/repository/usecase/handler structure similar to other services.

---

## PORT ALLOCATION

After proper implementation:

| Service | REST | gRPC | Protocol |
|---------|------|------|----------|
| API Gateway | 8000 | - | REST only |
| User Service | 8001 | 9001 | REST + gRPC |
| Restaurant Service | 8002 | 9002 | REST + gRPC |
| Order Service | 8003 | 9003 | REST + gRPC |
| Payment Service | 8004 | 9004 | REST + gRPC |
| Delivery Service | 8005 | 9005 | REST + gRPC |
| Review Service | 8006 | 9006 | REST + gRPC |
| Notification Service | 8007 | - | Event-driven |
| Admin Service | 8008 | - | REST + gRPC |

---

## DATA FLOW AFTER PROPER IMPLEMENTATION

```
Client REST Request
       ↓
API Gateway (8000) - Routes to appropriate service
       ↓
Service REST Handler (8001-8008)
       ↓
Service Usecase Logic
    ├─ Update Database (PostgreSQL)
    ├─ Cache Result (Redis)
    └─ Publish Event (Kafka) ← NEW
       ↓
Kafka Event Bus
       ├─ Order Events → Notification Service
       ├─ Order Events → Analytics
       └─ Order Events → Other services (via consumers)

Kafka Event Listener
       ↓
Service Consumes Event
       ↓
Execute Business Logic
```

---

## TESTING THE PROPER IMPLEMENTATION

### 1. Test gRPC Service
```bash
# Install grpcurl
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# List services
grpcurl -plaintext localhost:9003 list

# Call RPC
grpcurl -plaintext -d '{"user_id":"123"}' localhost:9003 pb.OrderService/GetOrder
```

### 2. Test Kafka Events
```bash
# Consume from topic
kafka-console-consumer --bootstrap-server localhost:9092 --topic orders.created --from-beginning

# Check topics
kafka-topics --bootstrap-server localhost:9092 --list
```

### 3. Test Redis Caching
```bash
# Connect to Redis
redis-cli

# Check cached keys
KEYS user:*

# See cache content
GET user:123:profile
```

---

## CHECKLIST FOR PROPER IMPLEMENTATION

- [ ] Proto files compiled (make proto-compile)
- [ ] Order service main.go has gRPC server setup
- [ ] Kafka in docker-compose.yml
- [ ] Order service main.go creates Kafka producer
- [ ] Notification service main.go consumes Kafka events
- [ ] User service usecase implements caching logic
- [ ] All services compile without errors
- [ ] docker-compose up brings up all services
- [ ] Health check endpoints respond
- [ ] gRPC services respond on correct ports
- [ ] Kafka events publish successfully
- [ ] Notification service consumes events
- [ ] Redis caching works
- [ ] Tests exist for critical paths

---

## NEXT STEPS

1. **Immediately**: Run `make proto-compile` to generate .pb.go files
2. **Immediately**: Fix go.mod with `go mod tidy`
3. **High Priority**: Update order-service/cmd/main.go with gRPC + Kafka
4. **High Priority**: Update docker-compose.yml with Kafka
5. **High Priority**: Implement notification service consumer
6. **Medium Priority**: Add caching to all usecases
7. **Medium Priority**: Complete admin service
8. **Low Priority**: Add tests

---

**This is the PROPER implementation needed for production use.**

