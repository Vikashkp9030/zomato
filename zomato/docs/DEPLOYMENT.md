# Zomato Platform - Deployment Guide

## Local Development Setup

### Prerequisites
- Go 1.21+
- Docker & Docker Compose
- PostgreSQL 13+
- Redis 7+
- RabbitMQ 3.12+

### Quick Start

```bash
# 1. Clone repository
git clone https://github.com/vikashkp9030/zomato.git
cd zomato

# 2. Install dependencies
go mod download

# 3. Copy environment file
cp .env.example .env

# 4. Start services with Docker Compose
docker-compose up -d

# 5. Wait for services to initialize (30-60 seconds)
sleep 30

# 6. Run migrations (if needed)
make migrate-up

# 7. Run tests
make test

# 8. Access API Gateway
curl http://localhost:8000/health
```

### Individual Service Development

```bash
# Terminal 1: Start dependencies
docker-compose up postgres-users redis rabbitmq

# Terminal 2: Run User Service
make run-user-service

# Terminal 3: Run API Gateway
make run-gateway
```

---

## Docker Deployment

### Build Images

```bash
# Build all services
docker-compose build

# Or build specific service
docker build -t zomato-user-service:latest --build-arg SERVICE_NAME=user-service .
```

### Run with Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Remove volumes (careful!)
docker-compose down -v
```

---

## Kubernetes Deployment (Optional)

### Create Namespace

```bash
kubectl create namespace zomato
```

### Deploy Database

```bash
# StatefulSet for PostgreSQL
kubectl apply -f k8s/postgres-statefulset.yml

# ConfigMaps and Secrets
kubectl apply -f k8s/configmaps.yml
kubectl apply -f k8s/secrets.yml
```

### Deploy Services

```bash
# Deployments
kubectl apply -f k8s/deployments/

# Services
kubectl apply -f k8s/services/

# Ingress
kubectl apply -f k8s/ingress.yml
```

### Scaling

```bash
# Scale a service
kubectl scale deployment user-service --replicas=3 -n zomato

# Auto-scaling (requires metrics-server)
kubectl apply -f k8s/hpa.yml
```

### Health Checks

```bash
# Check pod status
kubectl get pods -n zomato

# Check services
kubectl get svc -n zomato

# View logs
kubectl logs -f deployment/user-service -n zomato
```

---

## Production Deployment

### Environment Configuration

```bash
# Set production environment
export ENV=production
export JWT_SECRET=<strong-random-secret>
export DB_PASSWORD=<strong-password>
export REDIS_PASSWORD=<strong-password>
```

### Database Setup

```bash
# Use managed PostgreSQL (AWS RDS, Google Cloud SQL, Azure Database)
# Update connection strings in .env

DB_HOST=prod-db.example.com
DB_USER=zomato_user
DB_PASSWORD=<strong-password>
```

### Load Balancer Setup (Nginx)

```nginx
upstream zomato_backend {
    server api-gateway:8000;
    server api-gateway:8001;
    server api-gateway:8002;
}

server {
    listen 80;
    server_name api.zomato.example.com;
    
    # SSL redirect
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.zomato.example.com;
    
    ssl_certificate /etc/ssl/certs/cert.pem;
    ssl_certificate_key /etc/ssl/private/key.pem;
    
    # Security headers
    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    
    location / {
        proxy_pass http://zomato_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

### Monitoring & Logging

```yaml
# Prometheus config
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'zomato-services'
    static_configs:
      - targets: 
          - 'user-service:8001'
          - 'restaurant-service:8002'
          - 'order-service:8003'
```

```bash
# ELK Stack
docker run -d -p 5601:5601 docker.elastic.co/kibana/kibana:7.14.0
docker run -d -p 9200:9200 docker.elastic.co/elasticsearch/elasticsearch:7.14.0
```

### CI/CD Pipeline (GitHub Actions)

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Build images
        run: docker-compose build
      
      - name: Run tests
        run: make test
      
      - name: Push to registry
        run: |
          docker login -u ${{ secrets.DOCKER_USER }} -p ${{ secrets.DOCKER_PASS }}
          docker push zomato-api-gateway:latest
          docker push zomato-user-service:latest
          # ... push other services
      
      - name: Deploy to K8s
        run: |
          kubectl set image deployment/user-service \
            user-service=zomato-user-service:latest \
            -n zomato
```

### Backup & Recovery

```bash
# Database backup
pg_dump -h localhost -U zomato users_db > backup.sql

# Database restore
psql -h localhost -U zomato users_db < backup.sql

# Automated backups
*/2 * * * * pg_dump -h localhost -U zomato users_db | gzip > /backups/$(date +\%Y\%m\%d_\%H\%M\%S).sql.gz
```

---

## Performance Tuning

### Database Optimization

```sql
-- Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_restaurants_city ON restaurants(city);

-- Connection pooling (pgx)
max_connections=100
max_idle_time=5m
```

### Caching Strategy

```go
// Redis cache strategy
- Session data: 24 hours
- Restaurant menus: 1 hour
- User preferences: 12 hours
- Search results: 5 minutes
```

### Rate Limiting

```
- Per user: 100 requests/minute
- Per IP: 20 requests/minute
- Burst: 150 requests/second
```

---

## Monitoring Checklist

- [ ] API Gateway health: `/health`
- [ ] Service health: `/health/services`
- [ ] Database connectivity
- [ ] Redis connectivity
- [ ] RabbitMQ connectivity
- [ ] Prometheus metrics
- [ ] Log aggregation
- [ ] Distributed tracing
- [ ] Error tracking (Sentry)
- [ ] Alert thresholds

---

## Security Checklist

- [ ] JWT secrets rotated
- [ ] HTTPS/TLS enabled
- [ ] Database passwords changed
- [ ] Rate limiting enabled
- [ ] CORS properly configured
- [ ] Input validation
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] CSRF tokens
- [ ] Regular security audits

---

## Disaster Recovery

### RTO/RPO Targets
- RTO: 1 hour
- RPO: 15 minutes

### Backup Strategy
- Daily full backups
- Hourly incremental backups
- Off-site backup replication
- Recovery testing quarterly

### Failover Plan
- Multi-region deployment
- Database replication
- Service redundancy
- Automated failover

---

## Scaling Guidelines

### Vertical Scaling
- Increase server resources (CPU, RAM, storage)
- Database connection pool expansion

### Horizontal Scaling
- Service replication
- Load balancer configuration
- Database partitioning
- Cache distribution

### Monitoring Metrics for Scaling
- CPU usage > 70%
- Memory usage > 80%
- Response time > 200ms
- Request queue depth > 100

---

## Troubleshooting

### Service Won't Start
```bash
# Check logs
docker-compose logs api-gateway

# Check port conflicts
lsof -i :8000

# Restart service
docker-compose restart api-gateway
```

### Database Connection Issues
```bash
# Test connection
psql -h localhost -U zomato -d users_db

# Check credentials in .env
grep DB_ .env

# Restart database
docker-compose restart postgres-users
```

### High Memory Usage
```bash
# Check memory allocation
docker stats

# Check for leaks
go tool pprof http://localhost:8001/debug/pprof/heap

# Adjust service limits
docker-compose.yml: mem_limit: 512M
```

---

## Cost Optimization

1. Use managed services (RDS, ElastiCache, Pub/Sub)
2. Enable auto-scaling for non-peak hours
3. Use spot instances for non-critical services
4. Optimize database queries
5. Cache aggressively
6. Compress API responses

---

## Support & Escalation

- Critical: Page on-call engineer
- High: Ticket with 1-hour SLA
- Medium: Ticket with 4-hour SLA
- Low: Ticket with 24-hour SLA

On-call rotation: weekly rotation of 3 engineers
