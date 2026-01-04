#!/bin/bash

# Render Deployment - Quick Commands Reference
# Use this as a quick reference while deploying

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Render Deployment - Quick Reference${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

echo -e "${BLUE}📋 STEP 1: Build Backend Locally${NC}"
echo -e "${YELLOW}Command:${NC}"
echo "cd /Users/sreesumanthgorantla/Desktop/2026/book-social-network-main/book-network"
echo "./mvnw clean package -DskipTests"
echo ""

echo -e "${BLUE}📋 STEP 2: Render Web Service Configuration${NC}"
echo -e "${YELLOW}Copy these settings to Render:${NC}"
echo ""
echo "Name:           book-social-network-api"
echo "Branch:         main"
echo "Root Directory: book-network"
echo "Runtime:        Java"
echo ""
echo "Build Command:"
echo "./mvnw clean package -DskipTests"
echo ""
echo "Start Command:"
echo "java -Dserver.port=\$PORT -Dspring.profiles.active=prod -jar target/book-network-0.0.1-SNAPSHOT.jar"
echo ""

echo -e "${BLUE}📋 STEP 3: Environment Variables for Render${NC}"
echo -e "${YELLOW}Add these in Render Dashboard:${NC}"
echo ""
echo "SPRING_PROFILES_ACTIVE=prod"
echo "PORT=8088"
echo "JAVA_TOOL_OPTIONS=-Xmx400m -Xms400m"
echo ""
echo "# Database (after creating PostgreSQL):"
echo "DATABASE_URL=<your-internal-database-url>"
echo ""
echo "# Email (Gmail):"
echo "MAIL_HOST=smtp.gmail.com"
echo "MAIL_PORT=587"
echo "MAIL_USERNAME=your-email@gmail.com"
echo "MAIL_PASSWORD=<your-gmail-app-password>"
echo ""
echo "# File Upload:"
echo "FILE_UPLOAD_PATH=/tmp/uploads"
echo ""
echo "# Keycloak (update later):"
echo "KEYCLOAK_ISSUER_URI=http://localhost:9090/realms/book-social-network"
echo ""

echo -e "${BLUE}📋 STEP 4: PostgreSQL Configuration${NC}"
echo -e "${YELLOW}Create database with these settings:${NC}"
echo ""
echo "Name:           book-social-network-db"
echo "Database:       book_social_network"
echo "PostgreSQL:     16"
echo "Region:         Same as web service"
echo ""

echo -e "${BLUE}📋 STEP 5: Update Frontend${NC}"
echo -e "${YELLOW}After backend is deployed, update:${NC}"
echo "File: book-network-ui/src/environments/environment.prod.ts"
echo ""
echo "apiUrl: 'https://YOUR-SERVICE.onrender.com/api/v1'"
echo ""

echo -e "${BLUE}📋 STEP 6: Test URLs${NC}"
echo -e "${YELLOW}After deployment, test these:${NC}"
echo ""
echo "Backend:        https://YOUR-SERVICE.onrender.com"
echo "Swagger:        https://YOUR-SERVICE.onrender.com/api/v1/swagger-ui/index.html"
echo "Health Check:   https://YOUR-SERVICE.onrender.com/actuator/health (if available)"
echo ""

echo -e "${BLUE}📋 STEP 7: Common Issues${NC}"
echo -e "${YELLOW}If deployment fails:${NC}"
echo ""
echo "1. Check Render logs for errors"
echo "2. Verify all environment variables are set"
echo "3. Ensure database is in same region"
echo "4. Check Start Command uses \$PORT"
echo "5. Verify JAVA_TOOL_OPTIONS for memory limits"
echo ""

echo -e "${BLUE}📋 Quick Links${NC}"
echo -e "${YELLOW}Useful URLs:${NC}"
echo ""
echo "Render Dashboard:   https://dashboard.render.com"
echo "GitHub Repo:        https://github.com/sree-code/books-network-angular--spring"
echo "Deployment Guide:   RENDER_DEPLOYMENT_COMPLETE_GUIDE.md"
echo "Testing Checklist:  END_TO_END_TESTING_CHECKLIST.md"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Ready to deploy! Follow the guide:${NC}"
echo -e "${YELLOW}RENDER_DEPLOYMENT_COMPLETE_GUIDE.md${NC}"
echo -e "${GREEN}========================================${NC}"

