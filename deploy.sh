#!/bin/bash

# Book Social Network - Deployment Script
# This script helps you deploy the application to production

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Book Social Network - Deployment${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${BLUE}📦 Deployment Options:${NC}"
echo -e "  1. Deploy Frontend to Vercel"
echo -e "  2. Deploy Backend to Railway"
echo -e "  3. Deploy Backend to Render"
echo -e "  4. Setup and Build Both (locally)"
echo -e "  5. Exit"
echo ""

read -p "Select an option (1-5): " option

case $option in
    1)
        echo -e "${YELLOW}📱 Deploying Frontend to Vercel...${NC}"
        echo ""

        if ! command_exists vercel; then
            echo -e "${YELLOW}Installing Vercel CLI...${NC}"
            npm install -g vercel
        fi

        cd book-network-ui

        echo -e "${YELLOW}Building Angular application...${NC}"
        npm install
        npm run build:prod

        echo -e "${GREEN}✓ Build successful${NC}"
        echo ""
        echo -e "${YELLOW}Deploying to Vercel...${NC}"
        echo -e "${BLUE}You'll be prompted to login to Vercel if not already logged in.${NC}"
        echo ""

        vercel --prod

        echo ""
        echo -e "${GREEN}✓ Frontend deployed successfully!${NC}"
        echo -e "${YELLOW}Don't forget to update environment.prod.ts with your backend URL${NC}"
        ;;

    2)
        echo -e "${YELLOW}🚂 Setting up Railway deployment...${NC}"
        echo ""

        if ! command_exists railway; then
            echo -e "${YELLOW}Installing Railway CLI...${NC}"
            npm install -g @railway/cli
        fi

        echo -e "${YELLOW}Building Spring Boot application...${NC}"
        cd book-network
        ./mvnw clean package -DskipTests

        echo -e "${GREEN}✓ Build successful${NC}"
        echo ""
        echo -e "${YELLOW}Initializing Railway project...${NC}"
        echo -e "${BLUE}You'll be prompted to login to Railway.${NC}"
        echo ""

        railway login
        railway init

        echo ""
        echo -e "${GREEN}Next steps:${NC}"
        echo -e "  1. Run: ${YELLOW}railway up${NC} to deploy"
        echo -e "  2. Add PostgreSQL: ${YELLOW}railway add${NC} and select PostgreSQL"
        echo -e "  3. Set environment variables in Railway dashboard"
        echo -e "  4. See DEPLOYMENT_GUIDE.md for complete instructions"
        ;;

    3)
        echo -e "${YELLOW}🎨 Setting up Render deployment...${NC}"
        echo ""

        echo -e "${YELLOW}Building Spring Boot application...${NC}"
        cd book-network
        ./mvnw clean package -DskipTests

        echo -e "${GREEN}✓ Build successful${NC}"
        echo ""
        echo -e "${GREEN}Manual steps for Render:${NC}"
        echo -e "  1. Go to: ${BLUE}https://render.com${NC}"
        echo -e "  2. Click 'New +' → 'Web Service'"
        echo -e "  3. Connect your GitHub repository"
        echo -e "  4. Configure:"
        echo -e "     - Name: book-social-network-backend"
        echo -e "     - Environment: Java"
        echo -e "     - Build Command: ${YELLOW}./mvnw clean package -DskipTests${NC}"
        echo -e "     - Start Command: ${YELLOW}java -jar target/book-network-0.0.1-SNAPSHOT.jar${NC}"
        echo -e "  5. Add PostgreSQL database from Render dashboard"
        echo -e "  6. Set environment variables (see DEPLOYMENT_GUIDE.md)"
        echo ""
        echo -e "See ${YELLOW}DEPLOYMENT_GUIDE.md${NC} for detailed instructions"
        ;;

    4)
        echo -e "${YELLOW}🔧 Building both frontend and backend...${NC}"
        echo ""

        # Build Backend
        echo -e "${YELLOW}Building Spring Boot backend...${NC}"
        cd "$SCRIPT_DIR/book-network"
        ./mvnw clean package -DskipTests

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Backend build successful${NC}"
        else
            echo -e "${RED}❌ Backend build failed${NC}"
            exit 1
        fi

        # Build Frontend
        echo ""
        echo -e "${YELLOW}Building Angular frontend...${NC}"
        cd "$SCRIPT_DIR/book-network-ui"

        if [ ! -d "node_modules" ]; then
            echo -e "${YELLOW}Installing dependencies...${NC}"
            npm install
        fi

        npm run build:prod

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Frontend build successful${NC}"
        else
            echo -e "${RED}❌ Frontend build failed${NC}"
            exit 1
        fi

        echo ""
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}✓ Both builds completed successfully!${NC}"
        echo -e "${GREEN}========================================${NC}"
        echo ""
        echo -e "${YELLOW}Build artifacts:${NC}"
        echo -e "  Backend JAR: ${BLUE}book-network/target/book-network-0.0.1-SNAPSHOT.jar${NC}"
        echo -e "  Frontend: ${BLUE}book-network-ui/dist/book-network-ui${NC}"
        echo ""
        echo -e "${YELLOW}Next steps:${NC}"
        echo -e "  - Deploy backend to Railway or Render"
        echo -e "  - Deploy frontend to Vercel"
        echo -e "  - See DEPLOYMENT_GUIDE.md for complete instructions"
        ;;

    5)
        echo -e "${YELLOW}Exiting...${NC}"
        exit 0
        ;;

    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment process completed!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}📚 Resources:${NC}"
echo -e "  - Deployment Guide: ${BLUE}DEPLOYMENT_GUIDE.md${NC}"
echo -e "  - Vercel Dashboard: ${BLUE}https://vercel.com/dashboard${NC}"
echo -e "  - Railway Dashboard: ${BLUE}https://railway.app/dashboard${NC}"
echo -e "  - Render Dashboard: ${BLUE}https://dashboard.render.com${NC}"
echo ""

