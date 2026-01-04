# Book Social Network - Production Deployment Guide

## 🚀 Deployment Architecture

### Recommended Setup
- **Frontend (Angular)**: Vercel ✅
- **Backend (Spring Boot)**: Railway/Render (NOT Vercel)
- **Database**: Neon, Railway, or Supabase (PostgreSQL)
- **Keycloak**: Separate server or Keycloak Cloud

---

## 🎯 Why Not Deploy Spring Boot on Vercel?

**Vercel Limitations:**
- Serverless functions have **10-second execution limit**
- Limited to **Node.js, Go, Python, Ruby** runtimes
- No persistent file storage
- Not optimized for Java/Spring Boot applications

**Better Alternatives for Spring Boot:**
1. **Railway** (Easiest, $5/month)
2. **Render** (Free tier available)
3. **AWS Elastic Beanstalk**
4. **Heroku**
5. **DigitalOcean App Platform**

---

## Part 1: Frontend Deployment (Vercel)

### Step 1: Prepare Angular App for Production

#### 1.1 Create Environment Configuration

Create `src/environments` directory and add environment files:

```bash
cd book-network-ui
mkdir -p src/environments
```

**src/environments/environment.ts** (Development)
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8088/api/v1',
  keycloakUrl: 'http://localhost:9090',
  keycloakRealm: 'book-social-network',
  keycloakClientId: 'book-social-network-client'
};
```

**src/environments/environment.prod.ts** (Production)
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://your-backend.railway.app/api/v1', // Update after backend deployment
  keycloakUrl: 'https://your-keycloak-instance.com',
  keycloakRealm: 'book-social-network',
  keycloakClientId: 'book-social-network-client'
};
```

#### 1.2 Update API Configuration to Use Environment

Update `src/app/services/api-configuration.ts` to use environment variables.

#### 1.3 Update Angular Build Configuration

Update `angular.json` to include environment replacements.

### Step 2: Create Vercel Configuration

Create `vercel.json` in the `book-network-ui` directory:

```json
{
  "version": 2,
  "name": "book-social-network-ui",
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "dist/book-network-ui"
      }
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ]
}
```

### Step 3: Update package.json

Add Vercel build script to `book-network-ui/package.json`:

```json
"scripts": {
  "vercel-build": "ng build --configuration production"
}
```

### Step 4: Deploy to Vercel

#### Option A: Using Vercel CLI (Recommended)

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Navigate to frontend directory
cd book-network-ui

# Deploy
vercel

# For production deployment
vercel --prod
```

#### Option B: Using Vercel Dashboard

1. Go to [vercel.com](https://vercel.com)
2. Click "Import Project"
3. Connect your GitHub repository
4. Select the repository: `books-network-angular--spring`
5. Framework Preset: **Angular**
6. Root Directory: `book-network-ui`
7. Build Command: `npm run vercel-build`
8. Output Directory: `dist/book-network-ui`
9. Click "Deploy"

---

## Part 2: Backend Deployment (Railway - Recommended)

### Why Railway?
- ✅ Easy Spring Boot deployment
- ✅ Built-in PostgreSQL database
- ✅ Environment variable management
- ✅ Automatic HTTPS
- ✅ Free trial, then $5/month

### Step 1: Prepare Spring Boot for Production

#### 1.1 Create Production Application Properties

Create `book-network/src/main/resources/application-prod.yml`:

```yaml
spring:
  datasource:
    url: ${DATABASE_URL}
    username: ${DATABASE_USERNAME}
    password: ${DATABASE_PASSWORD}
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: false
    properties:
      hibernate:
        format_sql: false
    database: postgresql
    database-platform: org.hibernate.dialect.PostgreSQLDialect
  mail:
    host: ${MAIL_HOST}
    port: ${MAIL_PORT:587}
    username: ${MAIL_USERNAME}
    password: ${MAIL_PASSWORD}
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enabled: true
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: ${KEYCLOAK_ISSUER_URI}

application:
  file:
    uploads:
      photos-output-path: ${FILE_UPLOAD_PATH:/tmp/uploads}

server:
  port: ${PORT:8088}
```

#### 1.2 Update application.yml

Update the active profile:

```yaml
spring:
  profiles:
    active: ${SPRING_PROFILES_ACTIVE:dev}
```

### Step 2: Deploy to Railway

#### Option A: Using Railway CLI

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
cd book-network
railway init

# Link to Railway project
railway link

# Deploy
railway up
```

#### Option B: Using Railway Dashboard (Easier)

1. Go to [railway.app](https://railway.app)
2. Sign up / Login with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Choose your repository: `books-network-angular--spring`
6. Configure:
   - **Root Directory**: `book-network`
   - **Build Command**: `./mvnw clean package -DskipTests`
   - **Start Command**: `java -jar target/book-network-0.0.1-SNAPSHOT.jar`

### Step 3: Add PostgreSQL Database

1. In Railway project, click "New"
2. Select "Database" → "PostgreSQL"
3. Railway will automatically create DATABASE_URL

### Step 4: Configure Environment Variables

In Railway dashboard, add these environment variables:

```
SPRING_PROFILES_ACTIVE=prod
DATABASE_URL=(automatically set by Railway)
DATABASE_USERNAME=(automatically set by Railway)
DATABASE_PASSWORD=(automatically set by Railway)

# Mail Configuration (use a service like SendGrid, Mailgun, or Gmail)
MAIL_HOST=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USERNAME=your-sendgrid-username
MAIL_PASSWORD=your-sendgrid-password

# Keycloak Configuration
KEYCLOAK_ISSUER_URI=https://your-keycloak-instance.com/realms/book-social-network

# File Upload Path
FILE_UPLOAD_PATH=/app/uploads
```

### Step 5: Update CORS Configuration

Update your Spring Boot CORS configuration to allow your Vercel frontend URL.

---

## Part 3: Database Deployment

### Option 1: Railway PostgreSQL (Recommended)
- Automatically configured when you add PostgreSQL in Railway
- Comes with Railway deployment

### Option 2: Neon (Free Tier)
1. Go to [neon.tech](https://neon.tech)
2. Create a new project
3. Copy connection string
4. Use as DATABASE_URL in Railway

### Option 3: Supabase
1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Get connection string
4. Use in Railway environment variables

---

## Part 4: Keycloak Deployment

### Option 1: Keycloak Cloud (Easiest)
1. Sign up at [www.keycloak.org/cloud](https://www.keycloak.org/cloud)
2. Create instance
3. Import your realm configuration
4. Use the provided URL

### Option 2: Deploy on Railway
1. Create new Railway service
2. Use Keycloak Docker image
3. Configure with PostgreSQL
4. Set up persistent volumes

### Option 3: Use Auth0 (Alternative)
Consider using Auth0 instead of Keycloak for easier setup:
- [auth0.com](https://auth0.com)
- Has better free tier
- Easier configuration

---

## Part 5: Connect Everything

### Step 1: Get Backend URL
After Railway deployment, you'll get a URL like:
```
https://your-app.railway.app
```

### Step 2: Update Frontend Environment
Update `book-network-ui/src/environments/environment.prod.ts`:

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://your-app.railway.app/api/v1',
  keycloakUrl: 'https://your-keycloak.com',
  keycloakRealm: 'book-social-network',
  keycloakClientId: 'book-social-network-client'
};
```

### Step 3: Update Keycloak Configuration
1. Login to Keycloak admin console
2. Go to your realm settings
3. Update Valid Redirect URIs:
   - Add: `https://your-vercel-app.vercel.app/*`
4. Update Web Origins:
   - Add: `https://your-vercel-app.vercel.app`

### Step 4: Update Backend CORS
In your Spring Boot application, update CORS to allow Vercel domain.

### Step 5: Redeploy Frontend
```bash
cd book-network-ui
vercel --prod
```

---

## 📋 Deployment Checklist

### Backend
- [ ] Create production application properties
- [ ] Deploy to Railway
- [ ] Add PostgreSQL database
- [ ] Configure environment variables
- [ ] Set up mail service
- [ ] Configure Keycloak
- [ ] Update CORS settings
- [ ] Test API endpoints

### Frontend
- [ ] Create environment files
- [ ] Update API configuration
- [ ] Create vercel.json
- [ ] Update package.json scripts
- [ ] Deploy to Vercel
- [ ] Configure environment variables in Vercel
- [ ] Update Keycloak redirect URIs
- [ ] Test application

### Database
- [ ] Set up PostgreSQL
- [ ] Run migrations
- [ ] Verify connections

### Keycloak
- [ ] Deploy Keycloak instance
- [ ] Import realm configuration
- [ ] Create test users
- [ ] Update client settings
- [ ] Configure redirect URIs

---

## 🔒 Security Considerations

1. **Environment Variables**: Never commit sensitive data
2. **CORS**: Only allow specific origins
3. **HTTPS**: Ensure all services use HTTPS
4. **API Keys**: Rotate regularly
5. **Database**: Use connection pooling
6. **File Uploads**: Implement size limits and validation

---

## 💰 Cost Estimate

| Service | Free Tier | Paid |
|---------|-----------|------|
| Vercel (Frontend) | ✅ Free for personal | $20/month |
| Railway (Backend) | $5 trial credit | $5-20/month |
| PostgreSQL (Railway) | Included | - |
| Keycloak Cloud | Free tier available | $25-50/month |
| Total | ~$5/month | $30-90/month |

---

## 🐛 Troubleshooting

### Frontend Issues
- **404 on refresh**: Check vercel.json routes configuration
- **API not connecting**: Verify environment.prod.ts has correct backend URL
- **CORS errors**: Update backend CORS configuration

### Backend Issues
- **Database connection failed**: Check DATABASE_URL format
- **Port binding error**: Ensure PORT environment variable is set
- **File upload fails**: Check FILE_UPLOAD_PATH and permissions

### Keycloak Issues
- **Redirect URI mismatch**: Update client settings in Keycloak
- **Token validation failed**: Check issuer-uri in application-prod.yml
- **CORS errors**: Enable CORS in Keycloak admin console

---

## 📚 Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Railway Documentation](https://docs.railway.app)
- [Spring Boot Deployment Guide](https://spring.io/guides/gs/spring-boot-docker/)
- [Keycloak Documentation](https://www.keycloak.org/documentation)

---

## 🎉 Next Steps

1. Follow this guide step by step
2. Deploy backend to Railway first
3. Then deploy frontend to Vercel
4. Configure Keycloak
5. Test the complete application
6. Monitor logs and performance

Good luck with your deployment! 🚀

