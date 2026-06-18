#!/bin/bash

# PostgreSQL Setup Script for TODO API
# This script helps set up PostgreSQL for the TODO API

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    TODO API - PostgreSQL Setup Script${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"

# Function to print status
print_status() {
    echo -e "${YELLOW}→${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if PostgreSQL is installed
print_status "Checking if PostgreSQL is installed..."
if ! command -v psql &> /dev/null; then
    print_error "PostgreSQL is not installed!"
    echo "Please install PostgreSQL first:"
    echo "  macOS: brew install postgresql@15"
    echo "  Linux: sudo apt-get install postgresql"
    echo "  Windows: https://www.postgresql.org/download/windows/"
    exit 1
fi
print_success "PostgreSQL found"

# Check if PostgreSQL service is running
print_status "Checking if PostgreSQL service is running..."
if ! pg_isready -q; then
    print_error "PostgreSQL service is not running!"
    echo "Please start PostgreSQL:"
    echo "  macOS: brew services start postgresql@15"
    echo "  Linux: sudo systemctl start postgresql"
    exit 1
fi
print_success "PostgreSQL service is running"

# Get database configuration from user
echo ""
print_status "Enter PostgreSQL configuration (or press Enter for defaults):"

read -p "Database Host [localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "Database Port [5432]: " DB_PORT
DB_PORT=${DB_PORT:-5432}

read -p "Database Name [todos]: " DB_NAME
DB_NAME=${DB_NAME:-todos}

read -p "Database User [todouser]: " DB_USER
DB_USER=${DB_USER:-todouser}

read -sp "Database Password [todopassword]: " DB_PASS
echo ""
DB_PASS=${DB_PASS:-todopassword}

read -p "Admin User for setup [postgres]: " ADMIN_USER
ADMIN_USER=${ADMIN_USER:-postgres}

# Summary
echo ""
print_status "Configuration Summary:"
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo "  Admin User: $ADMIN_USER"
echo ""

read -p "Continue with setup? (y/n) [y]: " CONFIRM
CONFIRM=${CONFIRM:-y}

if [ "$CONFIRM" != "y" ]; then
    print_error "Setup cancelled"
    exit 1
fi

# Create database and user
echo ""
print_status "Creating database and user..."

# Connect as admin user and create database and user
PSQL_CMD="psql -h $DB_HOST -U $ADMIN_USER"

# Check if database exists
if $PSQL_CMD -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    print_status "Database '$DB_NAME' already exists, skipping creation"
else
    $PSQL_CMD -c "CREATE DATABASE $DB_NAME;" 2>/dev/null || {
        print_error "Failed to create database. Trying without specifying host..."
        psql -U $ADMIN_USER -c "CREATE DATABASE $DB_NAME;" 2>/dev/null || true
    }
    print_success "Database '$DB_NAME' created"
fi

# Check if user exists
if $PSQL_CMD -c "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then
    print_status "User '$DB_USER' already exists, skipping creation"
else
    $PSQL_CMD -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';" 2>/dev/null || {
        print_error "Failed to create user. Trying without specifying host..."
        psql -U $ADMIN_USER -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';" 2>/dev/null || true
    }
    print_success "User '$DB_USER' created"
fi

# Grant privileges
print_status "Granting privileges..."
$PSQL_CMD -d $DB_NAME -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;" 2>/dev/null || {
    psql -U $ADMIN_USER -d $DB_NAME -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;" 2>/dev/null || true
}
$PSQL_CMD -d $DB_NAME -c "ALTER SCHEMA public OWNER TO $DB_USER;" 2>/dev/null || true

print_success "Privileges granted"

# Test connection
echo ""
print_status "Testing connection..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "SELECT version();" > /dev/null 2>&1 && \
    print_success "Connection successful!" || \
    print_error "Connection failed. Check your credentials."

# Create .env file
echo ""
print_status "Creating .env file..."
cat > .env << EOF
# PostgreSQL Configuration
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_NAME=$DB_NAME
DB_SSL=disable

# API Configuration
PORT=8080
GIN_MODE=debug
EOF
print_success ".env file created"

# Instructions for running the app
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    Setup Complete! ✓${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "To start the API, run:"
echo "  source .env && go run main.go"
echo ""
echo "Or export environment variables:"
echo "  export DB_HOST=$DB_HOST"
echo "  export DB_PORT=$DB_PORT"
echo "  export DB_USER=$DB_USER"
echo "  export DB_PASS=$DB_PASS"
echo "  export DB_NAME=$DB_NAME"
echo "  go run main.go"
echo ""
echo "API will be available at: http://localhost:8080"
echo ""
echo "Test the API:"
echo "  curl http://localhost:8080/health"
echo ""

print_success "PostgreSQL is ready for the TODO API!"
