#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}   School Management App - Ready to Run${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Check devices
echo -e "${YELLOW}Checking available devices...${NC}"
flutter devices

echo ""
echo -e "${YELLOW}Starting Flutter app...${NC}"
echo ""

cd /Users/vikashkumarpatel/GoCourse/school_management_frontend

# Run flutter
flutter run

