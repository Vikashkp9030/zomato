.PHONY: help build run test clean deps migrate docker-build docker-up docker-down

help:
	@echo "School Management System - Available Commands"
	@echo ""
	@echo "  make deps           - Download dependencies"
	@echo "  make build          - Build the application"
	@echo "  make run            - Run the application"
	@echo "  make test           - Run tests"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make migrate        - Run database migrations"
	@echo "  make docker-build   - Build Docker image"
	@echo "  make docker-up      - Start Docker containers"
	@echo "  make docker-down    - Stop Docker containers"
	@echo "  make fmt            - Format code"
	@echo "  make lint           - Run linter"

deps:
	@echo "Downloading dependencies..."
	go mod download
	go mod tidy

build:
	@echo "Building application..."
	go build -o bin/school-management cmd/main.go

run: build
	@echo "Running application..."
	./bin/school-management

test:
	@echo "Running tests..."
	go test -v ./...

clean:
	@echo "Cleaning build artifacts..."
	rm -rf bin/
	go clean

migrate:
	@echo "Running database migrations..."
	@read -p "Enter MySQL user: " db_user; \
	read -sp "Enter MySQL password: " db_pass; \
	read -p "Enter database name: " db_name; \
	mysql -u $$db_user -p$$db_pass $$db_name < migrations/001_create_users_table.sql; \
	mysql -u $$db_user -p$$db_pass $$db_name < migrations/002_create_students_table.sql; \
	mysql -u $$db_user -p$$db_pass $$db_name < migrations/003_create_exams_table.sql; \
	mysql -u $$db_user -p$$db_pass $$db_name < migrations/004_create_attendance_table.sql; \
	echo "Migrations completed!"

fmt:
	@echo "Formatting code..."
	go fmt ./...

lint:
	@echo "Running linter..."
	golangci-lint run ./...

docker-build:
	@echo "Building Docker image..."
	docker build -t school-management:latest .

docker-up:
	@echo "Starting Docker containers..."
	docker-compose up -d

docker-down:
	@echo "Stopping Docker containers..."
	docker-compose down

.DEFAULT_GOAL := help
