#!/bin/bash

echo "🔍 Verifying School Management Setup..."
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check 1: Backend directory exists
echo -e "${YELLOW}1. Checking Backend Directory...${NC}"
if [ -d "/Users/vikashkumarpatel/GoCourse/school_management" ]; then
    echo -e "${GREEN}✅ Backend directory found${NC}"
else
    echo -e "${RED}❌ Backend directory NOT found${NC}"
    exit 1
fi
echo ""

# Check 2: Frontend directory exists
echo -e "${YELLOW}2. Checking Frontend Directory...${NC}"
if [ -d "/Users/vikashkumarpatel/GoCourse/school_management_frontend" ]; then
    echo -e "${GREEN}✅ Frontend directory found${NC}"
else
    echo -e "${RED}❌ Frontend directory NOT found${NC}"
    exit 1
fi
echo ""

# Check 3: Backend CORS middleware updated
echo -e "${YELLOW}3. Checking Backend CORS Configuration...${NC}"
if grep -q "allowOrigin := origin" /Users/vikashkumarpatel/GoCourse/school_management/internal/middleware/cors.go; then
    echo -e "${GREEN}✅ CORS middleware properly configured${NC}"
else
    echo -e "${RED}❌ CORS middleware needs update${NC}"
fi
echo ""

# Check 4: Frontend .env exists
echo -e "${YELLOW}4. Checking Frontend .env File...${NC}"
if [ -f "/Users/vikashkumarpatel/GoCourse/school_management_frontend/.env" ]; then
    echo -e "${GREEN}✅ Frontend .env file found${NC}"
    echo "   Content:"
    grep "BASE_URL" /Users/vikashkumarpatel/GoCourse/school_management_frontend/.env | sed 's/^/   /'
else
    echo -e "${RED}❌ Frontend .env file NOT found${NC}"
fi
echo ""

# Check 5: Test backend connectivity
echo -e "${YELLOW}5. Testing Backend Connectivity...${NC}"
if nc -z localhost 8080 2>/dev/null; then
    echo -e "${GREEN}✅ Backend is running on port 8080${NC}"

    # Test login endpoint
    echo -e "${YELLOW}   Testing login endpoint...${NC}"
    RESPONSE=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
      -H "Content-Type: application/json" \
      -d '{"email":"vikash798561@gmail.com","password":"Vikash@123"}')

    if echo "$RESPONSE" | grep -q "success"; then
        echo -e "${GREEN}   ✅ Login endpoint returns success${NC}"
        if echo "$RESPONSE" | grep -q "access_token"; then
            echo -e "${GREEN}   ✅ access_token present in response${NC}"
        fi
        if echo "$RESPONSE" | grep -q "refresh_token"; then
            echo -e "${GREEN}   ✅ refresh_token present in response${NC}"
        fi
    else
        echo -e "${RED}   ❌ Login endpoint error${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Backend is NOT running on port 8080${NC}"
    echo "   Start it with: cd /Users/vikashkumarpatel/GoCourse/school_management && go run ./cmd/main.go"
fi
echo ""

# Check 6: Test CORS headers
echo -e "${YELLOW}6. Testing CORS Headers (Preflight)...${NC}"
CORS_RESPONSE=$(curl -s -i -X OPTIONS http://localhost:8080/api/v1/auth/login \
  -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: POST" 2>&1)

if echo "$CORS_RESPONSE" | grep -q "Access-Control-Allow-Origin"; then
    echo -e "${GREEN}✅ CORS headers present${NC}"
    echo "$CORS_RESPONSE" | grep "Access-Control" | sed 's/^/   /'
else
    echo -e "${RED}❌ CORS headers missing${NC}"
fi
echo ""

# Check 7: Verify Interceptors in Frontend
echo -e "${YELLOW}7. Checking Frontend Interceptors...${NC}"
if [ -f "/Users/vikashkumarpatel/GoCourse/school_management_frontend/lib/core/network/interceptors/auth_interceptor.dart" ]; then
    echo -e "${GREEN}✅ Auth interceptor found${NC}"
fi
if [ -f "/Users/vikashkumarpatel/GoCourse/school_management_frontend/lib/core/network/interceptors/logging_interceptor.dart" ]; then
    echo -e "${GREEN}✅ Logging interceptor found${NC}"
fi
if [ -f "/Users/vikashkumarpatel/GoCourse/school_management_frontend/lib/core/network/interceptors/error_interceptor.dart" ]; then
    echo -e "${GREEN}✅ Error interceptor found${NC}"
fi
echo ""

echo -e "${GREEN}✅ Verification Complete!${NC}"
echo ""
echo "📋 Next Steps:"
echo "1. Start Backend:   cd /Users/vikashkumarpatel/GoCourse/school_management && go run ./cmd/main.go"
echo "2. Start Frontend:  cd /Users/vikashkumarpatel/GoCourse/school_management_frontend && flutter run -d chrome"
echo "3. Check Console:   Open DevTools (F12) and watch the logs"
echo "4. Check Network:   Go to Network tab and verify requests"
echo ""