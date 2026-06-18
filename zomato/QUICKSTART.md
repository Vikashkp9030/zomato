# Zomato Platform - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### 1. Prerequisites Check

```bash
# Check Go version (1.21+)
go version

# Check Docker
docker --version
docker-compose --version
```

### 2. Clone & Setup

```bash
git clone https://github.com/vikashkp9030/zomato.git
cd zomato

# Copy environment
cp .env.example .env

# Download dependencies
go mod download
```

### 3. Start All Services

```bash
# Single command to start everything
docker-compose up -d

# Wait for services to be ready (30-60 seconds)
echo "Waiting for services to initialize..."
sleep 30

# Verify all services are running
docker-compose ps
```

### 4. Test the API

```bash
# Check Gateway Health
curl http://localhost:8000/health

# Response should show:
# {"status":"ok","service":"api-gateway","timestamp":"..."}

# Check all services health
curl http://localhost:8000/health/services
```

### 5. Try Your First API Call

```bash
# Register a new user
curl -X POST http://localhost:8000/api/v1/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "phone": "9876543210",
    "first_name": "John",
    "last_name": "Doe",
    "password": "password123"
  }'

# Save the token from response for next requests
TOKEN="<jwt_token_from_response>"
```

---

## 📋 Common Commands

```bash
# View all services
make help

# Start all services
make run-all

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild and restart
docker-compose down && docker-compose up --build -d

# Access specific service logs
docker-compose logs -f user-service
docker-compose logs -f api-gateway

# Run tests
make test

# Format code
make fmt

# Run linter
make lint
```

---

## 🌐 Service Endpoints

| Service | Port | Health Check |
|---------|------|---|
| API Gateway | 8000 | http://localhost:8000/health |
| User Service | 8001 | http://localhost:8001/health |
| Restaurant Service | 8002 | http://localhost:8002/health |
| Order Service | 8003 | http://localhost:8003/health |
| Payment Service | 8004 | http://localhost:8004/health |
| Delivery Service | 8005 | http://localhost:8005/health |
| Review Service | 8006 | http://localhost:8006/health |
| Notification Service | 8007 | http://localhost:8007/health |
| Admin Service | 8008 | http://localhost:8008/health |

---

## 🧪 Quick API Tests

### Test 1: User Registration
```bash
curl -X POST http://localhost:8000/api/v1/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "customer@test.com",
    "phone": "9876543210",
    "first_name": "John",
    "last_name": "Customer",
    "password": "Test123!",
    "role": "customer"
  }'
```

### Test 2: User Login
```bash
curl -X POST http://localhost:8000/api/v1/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "customer@test.com",
    "password": "Test123!"
  }'
```

### Test 3: Create Restaurant (Owner)
```bash
TOKEN="<token_from_login>"

curl -X POST http://localhost:8000/api/v1/restaurants \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Pizza Palace",
    "description": "Authentic Italian pizzeria",
    "address": "123 Main Street",
    "city": "New York",
    "latitude": 40.7128,
    "longitude": -74.0060,
    "phone_number": "5551234567",
    "email": "pizza@example.com"
  }'
```

### Test 4: List Restaurants
```bash
curl http://localhost:8000/api/v1/restaurants?limit=10&offset=0
```

### Test 5: Create Order
```bash
TOKEN="<customer_token>"

curl -X POST http://localhost:8000/api/v1/orders \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "restaurant_id": "<restaurant_id>",
    "delivery_address_id": "<address_id>",
    "items": [
      {
        "dish_id": "<dish_id>",
        "quantity": 2,
        "price": 250.00
      }
    ],
    "payment_method": "card"
  }'
```

---

## 🗄️ Database Access

### Connect to PostgreSQL

```bash
# User Service DB
psql -h localhost -p 5432 -U zomato -d users_db

# Restaurant Service DB
psql -h localhost -p 5433 -U zomato -d restaurants_db

# All other databases follow same pattern on different ports
```

### Common Queries

```sql
-- Check users
SELECT id, email, role FROM users LIMIT 10;

-- Check orders
SELECT id, user_id, status, total_amount FROM orders LIMIT 10;

-- Check restaurants
SELECT id, name, city, average_rating FROM restaurants LIMIT 10;
```

---

## 🐛 Troubleshooting

### Services Not Starting?

```bash
# Check Docker daemon
docker ps

# Check logs
docker-compose logs api-gateway

# Verify ports are free
lsof -i :8000

# Full restart
docker-compose down -v
docker-compose up -d
```

### Can't Connect to Database?

```bash
# Check PostgreSQL container
docker ps | grep postgres

# Check logs
docker-compose logs postgres-users

# Verify credentials
grep DB_ .env

# Test connection
docker-compose exec postgres-users psql -U zomato -d users_db -c "SELECT 1"
```

### API Gateway Not Responding?

```bash
# Check if running
docker-compose ps | grep api-gateway

# View logs
docker-compose logs -f api-gateway

# Try direct service endpoint (skip gateway)
curl http://localhost:8001/api/v1/users/profile
```

### High Memory/CPU Usage?

```bash
# Monitor containers
docker stats

# Reduce service replicas
docker-compose down
# Edit docker-compose.yml to reduce replicas
docker-compose up -d
```

---

## 📚 Documentation

- **API Reference**: [docs/API.md](docs/API.md)
- **Deployment Guide**: [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)
- **Architecture**: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- **Full README**: [README.md](README.md)

---

## 🔑 Important Notes

1. **Credentials in Docker**: Default credentials are for development only
2. **JWT Secret**: Change `JWT_SECRET` in .env before production
3. **Database**: Each service has its own PostgreSQL instance
4. **Redis**: Shared instance for caching across all services
5. **RabbitMQ**: Message queue for async operations

---

## ⏭️ Next Steps

1. ✅ Services running locally
2. 📖 Read [API Documentation](docs/API.md)
3. 🧪 Run test suite: `make test`
4. 🚀 Deploy to Docker: `docker-compose up -d`
5. ☁️ (Optional) Deploy to Kubernetes
6. 📊 Setup monitoring and alerts

---

## 💬 Get Help

```bash
# View all commands
make help

# Run tests
make test

# Check service status
docker-compose ps

# View service logs
docker-compose logs -f <service_name>
```

---

## 🎯 Development Workflow

```bash
# 1. Start services
docker-compose up -d

# 2. Make code changes (services auto-reload in development)

# 3. Run tests
make test

# 4. Check code quality
make lint fmt

# 5. Commit changes
git add .
git commit -m "feat: add new feature"

# 6. Push to GitHub
git push origin main
```

---

**Ready to build the next big food delivery platform? Let's go! 🍕🍔🍱**
