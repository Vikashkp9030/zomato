#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

BASE_URL="http://localhost:8080/api/todos"

echo -e "${BLUE}=== TODO API Test Script ===${NC}\n"

# Health check
echo -e "${YELLOW}1. Health Check${NC}"
curl -s http://localhost:8080/health | jq '.'
echo ""

# Create todos
echo -e "${YELLOW}2. Creating Todos${NC}"
TODO1=$(curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Go"}')
echo "$TODO1" | jq '.'
ID1=$(echo "$TODO1" | jq '.id')
echo ""

TODO2=$(curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -d '{"title":"Build a web app"}')
echo "$TODO2" | jq '.'
ID2=$(echo "$TODO2" | jq '.id')
echo ""

# Get all todos
echo -e "${YELLOW}3. Getting All Todos${NC}"
curl -s -X GET "$BASE_URL" | jq '.'
echo ""

# Get specific todo
echo -e "${YELLOW}4. Getting Todo by ID ($ID1)${NC}"
curl -s -X GET "$BASE_URL/$ID1" | jq '.'
echo ""

# Update todo
echo -e "${YELLOW}5. Updating Todo ($ID1)${NC}"
curl -s -X PUT "$BASE_URL/$ID1" \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Go - Advanced","completed":true}' | jq '.'
echo ""

# Create another todo
echo -e "${YELLOW}6. Creating Another Todo${NC}"
TODO3=$(curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -d '{"title":"Deploy to production"}')
echo "$TODO3" | jq '.'
ID3=$(echo "$TODO3" | jq '.id')
echo ""

# Get all todos again
echo -e "${YELLOW}7. Getting All Todos (After Updates)${NC}"
curl -s -X GET "$BASE_URL" | jq '.'
echo ""

# Delete single todo
echo -e "${YELLOW}8. Deleting Todo ($ID2)${NC}"
curl -s -X DELETE "$BASE_URL/$ID2" | jq '.'
echo ""

# Final todos list
echo -e "${YELLOW}9. Final Todos List${NC}"
curl -s -X GET "$BASE_URL" | jq '.'
echo ""

echo -e "${GREEN}✅ Test completed!${NC}"
