.PHONY: help build run-all run-gateway run-user-service run-restaurant-service run-order-service run-payment-service run-delivery-service run-review-service run-notification-service run-admin-service test clean docker-build docker-run docker-stop

SERVICES := api-gateway user-service restaurant-service order-service payment-service delivery-service review-service notification-service admin-service

help:
	@echo "Zomato Platform - Makefile Commands"
	@echo "===================================="
	@echo "make build-all              - Build all services"
	@echo "make run-all                - Run all services with Docker Compose"
	@echo "make run-gateway            - Run API Gateway"
	@echo "make run-user-service       - Run User Service"
	@echo "make run-restaurant-service - Run Restaurant Service"
	@echo "make run-order-service      - Run Order Service"
	@echo "make run-payment-service    - Run Payment Service"
	@echo "make run-delivery-service   - Run Delivery Service"
	@echo "make run-review-service     - Run Review Service"
	@echo "make run-notification-service - Run Notification Service"
	@echo "make run-admin-service      - Run Admin Service"
	@echo "make test                   - Run tests"
	@echo "make docker-build           - Build Docker images"
	@echo "make docker-run             - Run with Docker Compose"
	@echo "make docker-stop            - Stop Docker Compose"
	@echo "make migrate-up             - Run database migrations"
	@echo "make migrate-down           - Rollback migrations"
	@echo "make clean                  - Clean build artifacts"

build-all:
	@for service in $(SERVICES); do \
		echo "Building $$service..."; \
		go build -o bin/$$service ./services/$$service/cmd/main.go; \
	done

run-gateway:
	@echo "Running API Gateway on port 8000..."
	go run api-gateway/cmd/main.go

run-user-service:
	@echo "Running User Service on port 8001..."
	go run services/user-service/cmd/main.go

run-restaurant-service:
	@echo "Running Restaurant Service on port 8002..."
	go run services/restaurant-service/cmd/main.go

run-order-service:
	@echo "Running Order Service on port 8003..."
	go run services/order-service/cmd/main.go

run-payment-service:
	@echo "Running Payment Service on port 8004..."
	go run services/payment-service/cmd/main.go

run-delivery-service:
	@echo "Running Delivery Service on port 8005..."
	go run services/delivery-service/cmd/main.go

run-review-service:
	@echo "Running Review Service on port 8006..."
	go run services/review-service/cmd/main.go

run-notification-service:
	@echo "Running Notification Service on port 8007..."
	go run services/notification-service/cmd/main.go

run-admin-service:
	@echo "Running Admin Service on port 8008..."
	go run services/admin-service/cmd/main.go

run-all:
	@echo "Starting all services with Docker Compose..."
	docker-compose up -d
	@echo "All services started!"
	@echo ""
	@echo "API Gateway: http://localhost:8000"
	@echo "Services running on ports 8001-8008"
	@echo ""
	@echo "View logs: docker-compose logs -f"
	@echo "Stop services: docker-compose down"

docker-build:
	@echo "Building Docker images..."
	@for service in $(SERVICES); do \
		echo "Building $$service Docker image..."; \
		docker build -t zomato-$$service:latest --build-arg SERVICE_NAME=$$service .; \
	done

docker-run:
	docker-compose up -d

docker-stop:
	docker-compose down

docker-logs:
	docker-compose logs -f

test:
	@echo "Running tests..."
	go test -v ./...

test-coverage:
	@echo "Running tests with coverage..."
	go test -v -cover ./...

test-user-service:
	go test -v ./services/user-service/...

test-order-service:
	go test -v ./services/order-service/...

migrate-up:
	@echo "Running migrations..."
	# Add migration commands here

migrate-down:
	@echo "Rolling back migrations..."
	# Add rollback commands here

migrate-fresh:
	@echo "Dropping and recreating databases..."
	# Add fresh migration commands here

lint:
	@echo "Running linter..."
	golangci-lint run ./...

fmt:
	@echo "Formatting code..."
	go fmt ./...

clean:
	@echo "Cleaning build artifacts..."
	rm -rf bin/
	go clean

dependencies:
	@echo "Downloading dependencies..."
	go mod download
	go mod tidy

docs:
	@echo "Building API documentation..."
	# Add swagger generation here

db-reset:
	@echo "Resetting databases..."
	docker-compose down -v
	docker-compose up -d

logs:
	docker-compose logs -f

status:
	@echo "Service Status:"
	@docker-compose ps

shell:
	@echo "Opening shell in api-gateway..."
	docker-compose exec api-gateway sh
