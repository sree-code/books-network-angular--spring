# Book Social Network - Complete Setup Guide

## 🎯 Overview
This guide will help you set up and run the Book Social Network application on your macOS system.

## ✅ Prerequisites
Before starting, ensure you have the following installed:

1. **Java Development Kit (JDK) 17 or higher**
   - Check: `java -version`
   - Download from: https://adoptium.net/ or https://www.oracle.com/java/technologies/downloads/

2. **Docker Desktop**
   - Check: `docker --version`
   - Download from: https://www.docker.com/products/docker-desktop

3. **Node.js and npm** (for the Angular frontend)
   - Check: `node --version` and `npm --version`
   - Download from: https://nodejs.org/

## 🔧 Issues Fixed

### 1. Maven Command Error
**Error:** `mvn: command not found`

**Solution:** You don't need to install Maven! This project uses **Maven Wrapper** (`mvnw`), which is included in the project.

**Usage:**
```bash
# Instead of: mvn clean install
# Use: ./mvnw clean install

cd book-network
./mvnw clean install
```

### 2. JWT Authentication Casting Error
**Error:** `ClassCastException: class org.springframework.security.oauth2.jwt.Jwt cannot be cast to class com.gorasr6.book.user.User`

**Solution:** The application uses OAuth2 Resource Server with Keycloak. The `Authentication` principal is a JWT token, not a User object.

**Fixed Files:**
- `FeedbackService.java` - Changed from casting to User to using `connectedUser.getName()`
- `FeedbackMapper.java` - Updated to accept String userId instead of Integer id

## 📋 Step-by-Step Setup

### Step 1: Start Infrastructure Services

The application requires PostgreSQL, Keycloak, and a mail server. All are configured in Docker Compose.

```bash
# Navigate to project root
cd /Users/sreesumanthgorantla/Desktop/2026/book-social-network-main

# Start all services
docker-compose up -d

# Check if services are running
docker ps
```

**Expected services:**
- `postgres-sql-bsn` on port **5432**
- `keycloak-bsn` on port **9090**
- `mail-dev-bsn` on ports **1080** (web UI) and **1025** (SMTP)

### Step 2: Configure Keycloak

1. **Access Keycloak Admin Console:**
   - URL: http://localhost:9090
   - Username: `admin`
   - Password: `admin`

2. **The realm should be auto-imported** from `./keycloak/realm/book-social-network`

3. **Create a Client for the Angular App** (if not exists):
   - Realm: `book-social-network`
   - Client ID: `book-social-network-client`
   - Valid Redirect URIs: `http://localhost:4200/*`
   - Web Origins: `http://localhost:4200`

4. **Create Test Users** (if needed):
   - Go to Users → Add User
   - Set username, email, and password
   - Assign roles as needed

### Step 3: Build and Run Backend

```bash
# Navigate to backend directory
cd book-network

# Clean and build the project
./mvnw clean install

# Run the application
./mvnw spring-boot:run
```

**Backend will start on:** http://localhost:8088

**API Documentation:** http://localhost:8088/api/v1/swagger-ui/index.html

### Step 4: Setup and Run Frontend

```bash
# Navigate to frontend directory
cd book-network-ui

# Install dependencies
npm install

# Start the development server
npm start
```

**Frontend will start on:** http://localhost:4200

## 🔑 Application URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| **Frontend** | http://localhost:4200 | Register new user or use Keycloak users |
| **Backend API** | http://localhost:8088/api/v1 | JWT Token from Keycloak |
| **API Docs** | http://localhost:8088/api/v1/swagger-ui/index.html | - |
| **Keycloak** | http://localhost:9090 | admin / admin |
| **MailDev** | http://localhost:1080 | - |
| **PostgreSQL** | localhost:5432 | username / password |

## 🗄️ Database Configuration

**Database Details:**
- **Host:** localhost
- **Port:** 5432
- **Database:** book_social_network
- **Username:** username
- **Password:** password

**Connection String:**
```
jdbc:postgresql://localhost:5432/book_social_network
```

## 📧 Email Configuration

The application uses MailDev for email testing in development:
- **SMTP Port:** 1025
- **Web Interface:** http://localhost:1080

All emails (like account activation) can be viewed in the MailDev web interface.

## 🎯 Testing the Application

### 1. Register a New User
1. Go to http://localhost:4200
2. Click "Register"
3. Fill in the registration form
4. Check MailDev (http://localhost:1080) for activation email
5. Click the activation link

### 2. Login
1. Use your registered credentials
2. You'll be redirected to Keycloak login
3. After successful login, you'll be redirected back to the app

### 3. Create a Book
1. Navigate to "My Books"
2. Click "Add New Book"
3. Fill in book details
4. Upload a book cover

### 4. Share and Borrow Books
1. Mark your book as "Shareable"
2. Other users can browse and borrow your books
3. You can approve/reject return requests

## 🐛 Troubleshooting

### Docker Issues
```bash
# If services don't start
docker-compose down
docker-compose up -d --force-recreate

# Check logs
docker logs postgres-sql-bsn
docker logs keycloak-bsn
docker logs mail-dev-bsn
```

### Backend Issues
```bash
# If port 8088 is already in use
# Find and kill the process
lsof -ti:8088 | xargs kill -9

# Clean rebuild
cd book-network
./mvnw clean install -DskipTests
./mvnw spring-boot:run
```

### Frontend Issues
```bash
# Clear node modules and reinstall
cd book-network-ui
rm -rf node_modules package-lock.json
npm install
npm start
```

### Keycloak Issues
- If Keycloak doesn't start, check if port 9090 is available
- Ensure the realm file exists at `./keycloak/realm/book-social-network`
- Check Docker logs: `docker logs keycloak-bsn`

## 📝 Important Notes

1. **Maven Wrapper:** Always use `./mvnw` instead of `mvn`
2. **First Start:** Keycloak takes 1-2 minutes to fully initialize
3. **Email Testing:** All emails go to MailDev, not real email addresses
4. **Database:** Data persists in Docker volumes between restarts
5. **JWT Tokens:** The app uses OAuth2 with Keycloak, not custom JWT implementation

## 🔄 Stopping the Application

```bash
# Stop backend (Ctrl+C in the terminal running it)

# Stop frontend (Ctrl+C in the terminal running it)

# Stop Docker services
cd /Users/sreesumanthgorantla/Desktop/2026/book-social-network-main
docker-compose down

# To also remove volumes (deletes all data)
docker-compose down -v
```

## 🚀 Production Deployment

For production deployment:
1. Update `application.yml` with production database credentials
2. Configure proper Keycloak realm with valid certificates
3. Set up a real SMTP server for emails
4. Build the Angular app: `npm run build --prod`
5. Deploy the backend JAR file
6. Use a reverse proxy (nginx) for the frontend

## 📚 Additional Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Angular Documentation](https://angular.io/docs)
- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [Docker Documentation](https://docs.docker.com/)

## 💡 Tips

1. **Development Mode:** The app is configured for development with auto-reload
2. **Swagger UI:** Use the API docs to test endpoints directly
3. **Debugging:** Enable debug logs in `application-dev.yml` by setting `logging.level.com.gorasr6=DEBUG`
4. **Database Inspection:** Use tools like pgAdmin or DBeaver to inspect the database

## ✨ Summary

Your application is now ready to run! The main fixes applied:
1. ✅ Fixed JWT casting error in FeedbackService
2. ✅ Updated FeedbackMapper to work with String userId
3. ✅ Configured to use Maven Wrapper (./mvnw)
4. ✅ All compilation errors resolved

You can now start the application by following Step 1-4 above!

