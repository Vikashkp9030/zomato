#!/bin/bash

# School Management App - Frontend + Backend Runner
# This script runs both the Flutter frontend and Go backend simultaneously

set -e

BACKEND_DIR="/Users/vikashkumarpatel/GoCourse/school_management"
FRONTEND_DIR="/Users/vikashkumarpatel/GoCourse/school_management_frontend"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}   School Management App - Frontend & Backend Launcher${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Function to print section headers
print_section() {
    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
}

# Check if directories exist
print_section "1️⃣  Checking directories..."
if [ ! -d "$BACKEND_DIR" ]; then
    echo -e "${RED}❌ Backend directory not found: $BACKEND_DIR${NC}"
    exit 1
fi
if [ ! -d "$FRONTEND_DIR" ]; then
    echo -e "${RED}❌ Frontend directory not found: $FRONTEND_DIR${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Both directories found${NC}"
echo ""

# Check if Go is installed
print_section "2️⃣  Checking prerequisites..."
if ! command -v go &> /dev/null; then
    echo -e "${RED}❌ Go is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Go is installed: $(go version)${NC}"

if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter is installed: $(flutter --version | head -1)${NC}"
echo ""

# Start backend in background
print_section "3️⃣  Starting Backend Server..."
cd "$BACKEND_DIR"

# Check if go.mod exists
if [ ! -f "go.mod" ]; then
    echo -e "${RED}❌ go.mod not found in backend directory${NC}"
    exit 1
fi

# Download dependencies
echo "📦 Downloading Go dependencies..."
go mod download 2>&1 | tail -3 || true
go mod tidy 2>&1 | tail -3 || true

# Build and run backend
echo "🔨 Building backend..."
go build -o server ./cmd/main.go 2>&1 || {
    echo -e "${RED}❌ Backend build failed${NC}"
    exit 1
}

echo -e "${GREEN}✓ Backend built successfully${NC}"
echo "🚀 Starting backend server..."
./server &
BACKEND_PID=$!
echo -e "${GREEN}✓ Backend started with PID: $BACKEND_PID${NC}"
sleep 2
echo ""

# Start frontend
print_section "4️⃣  Starting Frontend..."
cd "$FRONTEND_DIR"

echo "📦 Getting Flutter dependencies..."
flutter pub get > /dev/null 2>&1 || true

echo -e "${GREEN}✓ Frontend dependencies ready${NC}"
echo "🚀 Starting Flutter app..."
echo ""

# Launch Flutter in debug mode
flutter run

# Cleanup function
cleanup() {
    echo ""
    echo -e "${YELLOW}Shutting down...${NC}"
    kill $BACKEND_PID 2>/dev/null || true
    echo -e "${GREEN}✓ All services stopped${NC}"
}

# Set trap to cleanup on exit
trap cleanup EXIT

wait
