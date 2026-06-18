# Zomato-Style Food Delivery Platform (Go Microservices)

A production-grade food delivery platform built with Go, featuring 8+ microservices, 100+ API endpoints, PostgreSQL, Redis, RabbitMQ, and Kubernetes-ready architecture.

## 🏗️ Project Structure

```
zomato/
├── api-gateway/                 # API Gateway (REST + gRPC routing)
├── services/
│   ├── user-service/            # User management & auth
│   ├── restaurant-service/      # Restaurant & menu management
│   ├── order-service/           # Order management
│   ├── payment-service/         # Payment processing
│   ├── delivery-service/        # Delivery tracking
│   ├── review-service/          # Reviews & ratings
│   ├── notification-service/    # Email/SMS/push notifications
│   └── admin-service/           # Admin operations
├── shared/
│   ├── proto/                   # Protocol buffers for gRPC
│   ├── pkg/
│   │   ├── auth/               # JWT utilities
│   │   ├── db/                 # Database connection pool
│   │   ├── cache/              # Redis utilities
│   │   ├── logger/             # Structured logging
│   │   ├── errors/             # Custom error codes
│   │   ├── middleware/         # HTTP/gRPC middleware
│   │   └── utils/              # Common utilities
│   ├── migrations/              # Database migrations
│   ├── config/                  # Configuration files
│   └── docker/                  # Docker & compose files
├── tests/                       # Integration tests
├── docs/
│   ├── API.md                   # API documentation
│   ├── DEPLOYMENT.md            # Deployment guide
│   └── ARCHITECTURE.md          # Architecture details
├── docker-compose.yml           # Local development setup
├── Dockerfile                   # Multi-stage build
├── Makefile                     # Build automation
└── README.md                    # This file
```

## 🚀 Quick Start

### Prerequisites
- Go 1.21+
- Docker & Docker Compose
- PostgreSQL 13+
- Redis 7+
- RabbitMQ 3.12+

### Local Development

```bash
# Clone repository
git clone https://github.com/vikashkp9030/zomato.git
cd zomato

# Start all services with Docker Compose
docker-compose up -d

# Apply migrations
make migrate-all

# Run API Gateway
make run-gateway

# Run individual service (in separate terminal)
make run-user-service

# Run tests
make test

# View logs
docker-compose logs -f api-gateway
```

## 🛠️ Building & Running

### Build All Services
```bash
make build-all
```

### Run Specific Service
```bash
make run-user-service
# or
make run-restaurant-service
# or
make run-order-service
```

### Database Migrations
```bash
# Up
make migrate-up

# Down
make migrate-down

# Fresh (drop + create)
make migrate-fresh
```

## 📡 API Endpoints

### Authentication (User Service)
- `POST /api/v1/users/register` - User registration
- `POST /api/v1/users/login` - User login
- `POST /api/v1/users/refresh` - Refresh JWT token
- `POST /api/v1/users/logout` - Logout

### Users
- `GET /api/v1/users/profile` - Get user profile
- `PUT /api/v1/users/profile` - Update profile
- `DELETE /api/v1/users/profile` - Delete account
- `GET /api/v1/users/addresses` - Get addresses
- `POST /api/v1/users/addresses` - Add address

### Restaurants
- `GET /api/v1/restaurants` - List restaurants
- `POST /api/v1/restaurants` - Create restaurant (owner)
- `GET /api/v1/restaurants/{id}` - Get restaurant details
- `PUT /api/v1/restaurants/{id}` - Update restaurant
- `GET /api/v1/restaurants/{id}/menu` - Get menu

### Orders
- `POST /api/v1/orders` - Create order
- `GET /api/v1/orders` - List orders
- `GET /api/v1/orders/{id}` - Get order details
- `PUT /api/v1/orders/{id}/status` - Update order status
- `GET /api/v1/orders/{id}/track` - Track order

### Payments
- `POST /api/v1/payments/initiate` - Initiate payment
- `POST /api/v1/payments/confirm` - Confirm payment
- `GET /api/v1/payments/history` - Payment history
- `POST /api/v1/payments/refund` - Process refund

### Deliveries
- `POST /api/v1/deliveries/assign` - Assign delivery partner
- `PUT /api/v1/deliveries/partner/location` - Update partner location
- `GET /api/v1/deliveries/track/{orderId}` - Track delivery

### Reviews
- `POST /api/v1/reviews` - Create review
- `GET /api/v1/reviews/restaurant/{restId}` - Get restaurant reviews
- `PUT /api/v1/reviews/{id}` - Update review
- `DELETE /api/v1/reviews/{id}` - Delete review

### Admin
- `GET /api/v1/admin/users` - Manage users
- `GET /api/v1/admin/restaurants/pending` - Pending restaurants
- `PUT /api/v1/admin/restaurants/{id}/approve` - Approve restaurant
- `GET /api/v1/admin/analytics/orders` - Order analytics

## 🔐 Authentication

All endpoints (except login/register/health) require JWT token in the `Authorization` header:
```
Authorization: Bearer <jwt_token>
```

JWT includes:
- `sub` (subject) - user ID
- `role` - user role (customer, owner, delivery, admin)
- `exp` - expiration time
- `iat` - issued at

## 🗄️ Database

PostgreSQL schemas:
- `users_db` - User service
- `restaurants_db` - Restaurant service
- `orders_db` - Order service
- `payments_db` - Payment service
- `deliveries_db` - Delivery service
- `reviews_db` - Review service
- `notifications_db` - Notification service
- `admin_db` - Admin service

Run migrations:
```bash
make migrate-all
```

## 💾 Cache

Redis is used for:
- Session storage
- Restaurant metadata cache
- User preference cache
- Rate limiting

## 📨 Message Queue

RabbitMQ for async processing:
- Order events
- Payment notifications
- Delivery updates
- Email/SMS queue

## 📊 Monitoring

### Prometheus Metrics
```
GET /metrics
```

### Health Checks
```
GET /health              # API Gateway health
GET /health/:service     # Individual service health
```

### Logging
Structured logging with correlation IDs for distributed tracing.

### Tracing
Jaeger integration for distributed tracing.

## 🧪 Testing

```bash
# Run all tests
make test

# Run specific service tests
make test-user-service
make test-order-service

# Run with coverage
make test-coverage
```

## 🐳 Docker

### Build Docker images
```bash
docker build -t zomato-api-gateway:latest -f docker/Dockerfile.gateway .
docker build -t zomato-user-service:latest -f docker/Dockerfile.user .
```

### Run with Docker Compose
```bash
docker-compose up -d
docker-compose logs -f
```

## ☸️ Kubernetes Deployment (Optional)

```bash
# Apply manifests
kubectl apply -f k8s/

# Check deployments
kubectl get deployments
kubectl get services
kubectl get pods

# View logs
kubectl logs -f deployment/api-gateway
```

## 📖 Documentation

- [API Reference](docs/API.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Development Guide](docs/DEVELOPMENT.md)

## 🔄 Inter-Service Communication

### gRPC (Synchronous)
Services communicate via gRPC for real-time operations:
- Order → Payment (payment processing)
- Order → Delivery (assign partner)
- Order → Notification (send updates)

### RabbitMQ (Asynchronous)
For decoupled, event-driven operations:
- Order events
- Payment confirmations
- Delivery updates
- Notifications

## 🛡️ Security

- **JWT**: HMAC-SHA256 with refresh tokens
- **TLS**: gRPC with SSL/TLS
- **Rate Limiting**: Token bucket per user/IP
- **Input Validation**: All endpoints validate input
- **SQL Injection Protection**: Parameterized queries
- **CORS**: Configured for frontend

## ⚡ Performance

- **Response Time**: < 200ms (p95)
- **Load Testing**: k6/Gatling ready
- **Caching**: Redis for hot data
- **Connection Pooling**: pgx for PostgreSQL
- **Horizontal Scaling**: Stateless services

## 🤝 Contributing

1. Create feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -m "feat: your feature"`
3. Push to remote: `git push origin feature/your-feature`
4. Create pull request

## 📝 License

MIT License

## 👤 Author

Vikash Kumar Patel

## 📞 Support

For issues and questions, please create an issue in the repository.
