#!/bin/bash

# Book Social Network - Quick Start Script
# This script helps you start the application quickly

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Book Social Network - Quick Start${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command_exists java; then
    echo -e "${RED}❌ Java is not installed. Please install JDK 17 or higher.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Java found: $(java -version 2>&1 | head -n 1)${NC}"

if ! command_exists docker; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker Desktop.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker found${NC}"

if ! command_exists node; then
    echo -e "${YELLOW}⚠ Node.js is not installed. You'll need it for the frontend.${NC}"
else
    echo -e "${GREEN}✓ Node.js found: $(node --version)${NC}"
fi

echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker Desktop.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker is running${NC}"

echo ""
echo -e "${YELLOW}Starting infrastructure services...${NC}"

# Start Docker services
docker-compose up -d

echo -e "${GREEN}✓ Docker services started${NC}"
echo ""
echo -e "${YELLOW}Waiting for services to be ready (30 seconds)...${NC}"
sleep 30

# Check if services are running
if docker ps | grep -q postgres-sql-bsn; then
    echo -e "${GREEN}✓ PostgreSQL is running${NC}"
else
    echo -e "${RED}❌ PostgreSQL failed to start${NC}"
fi

if docker ps | grep -q keycloak-bsn; then
    echo -e "${GREEN}✓ Keycloak is running${NC}"
else
    echo -e "${RED}❌ Keycloak failed to start${NC}"
fi

if docker ps | grep -q mail-dev-bsn; then
    echo -e "${GREEN}✓ MailDev is running${NC}"
else
    echo -e "${RED}❌ MailDev failed to start${NC}"
fi

echo ""
echo -e "${YELLOW}Building backend application...${NC}"
cd book-network
./mvnw clean install -DskipTests

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend build successful${NC}"
else
    echo -e "${RED}❌ Backend build failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Available Services:${NC}"
echo -e "  🌐 Keycloak Admin:  ${GREEN}http://localhost:9090${NC} (admin/admin)"
echo -e "  📧 MailDev:         ${GREEN}http://localhost:1080${NC}"
echo -e "  📚 Backend API:     ${GREEN}http://localhost:8088/api/v1${NC}"
echo -e "  📖 API Docs:        ${GREEN}http://localhost:8088/api/v1/swagger-ui/index.html${NC}"
echo -e "  💻 Frontend:        ${GREEN}http://localhost:4200${NC}"
echo ""
echo -e "${YELLOW}To start the backend:${NC}"
echo -e "  cd book-network"
echo -e "  ./mvnw spring-boot:run"
echo ""
echo -e "${YELLOW}To start the frontend:${NC}"
echo -e "  cd book-network-ui"
echo -e "  npm install  ${GREEN}(first time only)${NC}"
echo -e "  npm start"
echo ""
echo -e "${YELLOW}To view Docker logs:${NC}"
echo -e "  docker logs postgres-sql-bsn"
echo -e "  docker logs keycloak-bsn"
echo -e "  docker logs mail-dev-bsn"
echo ""
echo -e "${YELLOW}To stop all services:${NC}"
echo -e "  docker-compose down"
echo ""
echo -e "${GREEN}For detailed instructions, see SETUP_GUIDE.md${NC}"
echo ""

