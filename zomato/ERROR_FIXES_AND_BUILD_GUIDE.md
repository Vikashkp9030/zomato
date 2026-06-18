# ERROR FIXES & BUILD GUIDE

**Status**: Comprehensive Error Analysis & Solutions  
**Date**: June 18, 2026

---

## CRITICAL ERRORS FOUND & SOLUTIONS

### ERROR 1: Proto-Generated Files Missing
**Problem**: `shared/pb` package not found (import error)
**Location**: `services/order-service/internal/grpc/order_service.go:10`
**Impact**: gRPC service can't compile

**Solution**:
```bash
# Install protocol buffer compiler
brew install protobuf  # macOS
# OR
apt-get install protobuf-compiler  # Linux

# Install Go protoc plugins
go install github.com/grpc/grpc-go/cmd/protoc-gen-go-grpc@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# Compile proto files
protoc --go_out=. --go-opt=paths=source_relative \
       --go-grpc_out=. --go-grpc-opt=paths=source_relative \
       shared/proto/*.proto

# This generates:
# - shared/pb/user.pb.go
# - shared/pb/order.pb.go
# - shared/pb/restaurant.pb.go
```

---

### ERROR 2: go.sum Entry Missing for Dependencies
**Problem**: go.sum is malformed or incomplete
**Affected Modules**:
- github.com/gin-gonic/gin
- github.com/google/uuid
- github.com/golang-jwt/jwt/v5
- gorm.io/driver/postgres
- gorm.io/gorm
- github.com/segmentio/kafka-go
- google.golang.org/grpc
- github.com/redis/go-redis/v9
- golang.org/x/crypto

**Solution**:
```bash
# Full cleanup and rebuild
rm -f go.sum
go clean -cache
go clean -modcache
go mod verify  # Check go.mod integrity
go mod download  # Download all modules
go mod tidy  # Clean and update go.sum
```

---

### ERROR 3: Missing Proto Package Import
**Problem**: `pb "github.com/vikashkp9030/zomato/shared/pb"` not found
**File**: `services/order-service/internal/grpc/order_service.go`
**Cause**: Proto files not compiled yet

**Solution**: Compile proto files first (see ERROR 1)

---

### ERROR 4: Missing gRPC Status Types  
**Problem**: Undefined `status.Errorf`, `codes.InvalidArgument`
**File**: `services/order-service/internal/grpc/order_service.go`
**Line**: 173

**Fix - Add Imports**:
```go
import (
    "google.golang.org/grpc/codes"
    "google.golang.org/grpc/status"
)
```

**Fix - Define Error**:
```go
var ErrInvalidRequest = status.Errorf(codes.InvalidArgument, "invalid request")
```

---

## BUILD STEPS IN ORDER

### Step 1: Install Dependencies
```bash
# Protocol Buffer Compiler
brew install protobuf
# OR
sudo apt-get install protobuf-compiler

# Verify installation
protoc --version  # Should show version 3.x or 4.x
```

### Step 2: Install Go Protoc Plugins
```bash
go install github.com/grpc/grpc-go/cmd/protoc-gen-go-grpc@v1.3
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31

# Verify they're in PATH
which protoc-gen-go
which protoc-gen-go-grpc
```

### Step 3: Compile Proto Files
```bash
cd /Users/vikashkumarpatel/GoCourse/zomato

protoc --go_out=. --go-opt=paths=source_relative \
       --go-grpc_out=. --go-grpc-opt=paths=source_relative \
       shared/proto/user.proto \
       shared/proto/order.proto \
       shared/proto/restaurant.proto

# This creates:
# shared/pb/user.pb.go
# shared/pb/user_grpc.pb.go
# shared/pb/order.pb.go
# shared/pb/order_grpc.pb.go
# shared/pb/restaurant.pb.go
# shared/pb/restaurant_grpc.pb.go

# List generated files
ls -lh shared/pb/*.pb.go
```

### Step 4: Clean Go Module Cache
```bash
rm -f go.sum
go clean -cache
go clean -modcache
go mod verify
go mod download
go mod tidy
```

### Step 5: Build Each Service
```bash
# Test each service individually
echo "Building API Gateway..."
go build -v ./api-gateway/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi

echo "Building User Service..."
go build -v ./services/user-service/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi

echo "Building Order Service..."
go build -v ./services/order-service/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi

echo "Building Payment Service..."
go build -v ./services/payment-service/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi

echo "Building Delivery Service..."
go build -v ./services/delivery-service/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi

echo "Building Restaurant Service..."
go build -v ./services/restaurant-service/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi

echo "Building Review Service..."
go build -v ./services/review-service/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi

echo "Building Notification Service..."
go build -v ./services/notification-service/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi

echo "Building Admin Service..."
go build -v ./services/admin-service/cmd
if [ $? -ne 0 ]; then echo "FAILED"; exit 1; fi
```

### Step 6: Full Project Build
```bash
go build ./...

# Should show: (no output = success)
echo "Build successful!"
echo $?  # Should print 0
```

---

## COMPLETE BASH SCRIPT TO FIX ALL ERRORS

```bash
#!/bin/bash
set -e

echo "=========================================="
echo "Zomato Project Build & Error Fix"
echo "=========================================="

# Step 1: Check Go version
echo "✓ Checking Go version..."
go version

# Step 2: Install protoc if not exists
echo "✓ Installing protoc compiler..."
if ! command -v protoc &> /dev/null; then
    echo "  Installing Protocol Buffer compiler..."
    brew install protobuf  # macOS
    # OR: sudo apt-get install protobuf-compiler  # Linux
fi

# Step 3: Install Go protoc plugins
echo "✓ Installing Go protoc plugins..."
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3

# Step 4: Compile proto files
echo "✓ Compiling proto files..."
cd /Users/vikashkumarpatel/GoCourse/zomato

if [ ! -d "shared/pb" ]; then
    mkdir -p shared/pb
fi

protoc --go_out=. --go-opt=paths=source_relative \
       --go-grpc_out=. --go-grpc-opt=paths=source_relative \
       shared/proto/user.proto \
       shared/proto/order.proto \
       shared/proto/restaurant.proto

if [ -f "shared/pb/user.pb.go" ]; then
    echo "  ✓ Proto files compiled successfully"
else
    echo "  ✗ Proto compilation failed"
    exit 1
fi

# Step 5: Clean Go module cache
echo "✓ Cleaning Go module cache..."
rm -f go.sum
go clean -cache
go clean -modcache
go mod verify
go mod download
go mod tidy

# Step 6: Build all services
echo "✓ Building services..."
go build ./...

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✓ SUCCESS: All services built successfully!"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "✗ ERROR: Build failed"
    echo "=========================================="
    exit 1
fi
```

---

## FILES TO CREATE AFTER PROTO COMPILATION

After running protoc, these files will be auto-generated (DO NOT EDIT):

```
shared/pb/
├── user.pb.go           (Proto message types)
├── user_grpc.pb.go      (gRPC service stubs)
├── order.pb.go          (Proto message types)
├── order_grpc.pb.go     (gRPC service stubs)
├── restaurant.pb.go     (Proto message types)
└── restaurant_grpc.pb.go (gRPC service stubs)
```

**DO NOT** manually edit these files. If they need changes, modify the `.proto` files and recompile.

---

## VERIFICATION CHECKLIST

- [ ] Protocol Buffer compiler installed (`protoc --version`)
- [ ] Go protoc plugins installed
- [ ] Proto files compiled (`ls shared/pb/*.pb.go`)
- [ ] go.sum has entries for all dependencies
- [ ] API Gateway builds: `go build ./api-gateway/cmd`
- [ ] User Service builds: `go build ./services/user-service/cmd`
- [ ] Order Service builds: `go build ./services/order-service/cmd`
- [ ] Payment Service builds: `go build ./services/payment-service/cmd`
- [ ] Delivery Service builds: `go build ./services/delivery-service/cmd`
- [ ] Restaurant Service builds: `go build ./services/restaurant-service/cmd`
- [ ] Review Service builds: `go build ./services/review-service/cmd`
- [ ] Notification Service builds: `go build ./services/notification-service/cmd`
- [ ] Admin Service builds: `go build ./services/admin-service/cmd`
- [ ] Full project builds: `go build ./...`

---

## TROUBLESHOOTING

### If build still fails:
```bash
# Hard reset of all go caches
rm -rf ~/go/pkg/mod/*
rm -f go.sum
rm -rf shared/pb/*.pb.go
go mod download
go mod tidy
# Recompile protos
protoc --go_out=. --go-opt=paths=source_relative \
       --go-grpc_out=. --go-grpc-opt=paths=source_relative \
       shared/proto/*.proto
# Try building again
go build ./...
```

### If protoc not found:
```bash
# macOS
brew install protobuf

# Linux (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install protobuf-compiler

# Linux (RHEL/CentOS)
sudo yum install protobuf-compiler

# Verify
protoc --version
```

### If go protoc plugins not found:
```bash
# Install them
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3

# Verify they're in PATH
which protoc-gen-go
which protoc-gen-go-grpc

# If not in PATH, add to .bashrc or .zshrc
export PATH="$PATH:$(go env GOPATH)/bin"
```

---

## EXPECTED BUILD OUTPUT

After all fixes, you should see:
```
$ go build ./...
$  # No output means success!

$ echo $?
0  # Exit code 0 means success
```

---

**Status**: Complete error fix guide provided  
**Next**: Follow the steps above to build successfully  
**Timeline**: 5-10 minutes to complete all steps
