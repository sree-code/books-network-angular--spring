# 🐳 Render Deployment with Docker - Updated Guide (2026)

## Overview
Render now requires Docker for Java applications. This guide uses the latest Render configuration (January 2026).

---

## 📋 Prerequisites

1. ✅ **Render Account**: https://dashboard.render.com
2. ✅ **Docker** (optional, for local testing)
3. ✅ **GitHub Repository**: https://github.com/sree-code/books-network-angular--spring
4. ✅ **Gmail App Password**: For email functionality

---

## Part 1: Render Deployment (Docker-based)

### Step 1: Files Already Created ✅

I've created the following files for you:
- ✅ `book-network/Dockerfile` - Standard Docker build
- ✅ `book-network/Dockerfile.optimized` - Multi-stage build (faster, smaller)
- ✅ `book-network/.dockerignore` - Excludes unnecessary files

### Step 2: Push to GitHub

```bash
cd /Users/sreesumanthgorantla/Desktop/2026/book-social-network-main
git add .
git commit -m "Add Dockerfile for Render deployment"
git push origin main
```

---

## Step 3: Create Web Service on Render

### 3.1 Go to Render Dashboard
- Visit: https://dashboard.render.com
- Click **"New +"** → **"Web Service"**

### 3.2 Connect GitHub Repository
- Click **"Connect a repository"**
- Select: `books-network-angular--spring`
- Click **"Connect"**

### 3.3 Configure Web Service

**IMPORTANT: Use these EXACT settings for Docker deployment**

```yaml
Name:                book-social-network-api
Region:              Oregon (US West) or closest to you
Branch:              main
Root Directory:      book-network
```

**Runtime Settings:**
```yaml
Environment:         Docker
Dockerfile Path:     Dockerfile
                     (or Dockerfile.optimized for smaller image)
```

**Instance Type:**
```yaml
Free
```

**Advanced Settings (Click "Advanced"):**

Docker Command (leave empty, uses CMD from Dockerfile)
```
(Leave empty - will use CMD from Dockerfile)
```

---

## Step 4: Add PostgreSQL Database

### 4.1 Create Database
1. In Render Dashboard, click **"New +"**
2. Select **"PostgreSQL"**

### 4.2 Configure Database
```yaml
Name:                book-social-network-db
Database:            book_social_network
User:                bookuser
Region:              Same as your web service
PostgreSQL Version:  16 (latest)
Instance Type:       Free
```

3. Click **"Create Database"**
4. Wait 1-2 minutes for database to initialize

### 4.3 Get Database Connection String
1. Click on your database name
2. Scroll to **"Connections"**
3. Copy **"Internal Database URL"**
   - Format: `postgresql://user:password@host:5432/dbname`

---

## Step 5: Configure Environment Variables

### 5.1 Go to Your Web Service
- Dashboard → Your Web Service → **"Environment"** tab

### 5.2 Add Environment Variables

Click **"Add Environment Variable"** and add these ONE BY ONE:

#### Core Configuration
```bash
SPRING_PROFILES_ACTIVE=prod
PORT=8088
JAVA_TOOL_OPTIONS=-Xmx400m -Xms400m
```

#### Database Configuration
```bash
DATABASE_URL=postgresql://bookuser:password@host.oregon-postgres.render.com:5432/book_social_network
```
⚠️ Replace with YOUR actual Internal Database URL from Step 4.3

#### Email Configuration (Gmail)
```bash
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-16-char-app-password
```

**How to get Gmail App Password:**
1. Go to: https://myaccount.google.com/security
2. Enable **2-Step Verification**
3. Search: **"App passwords"**
4. Generate password for **"Mail"**
5. Copy the 16-character password (no spaces)

#### File Upload Configuration
```bash
FILE_UPLOAD_PATH=/tmp/uploads
```

#### Keycloak Configuration (Temporary)
```bash
KEYCLOAK_ISSUER_URI=http://localhost:9090/realms/book-social-network
```
⚠️ You'll update this later when Keycloak is deployed

### 5.3 Save Changes
- Click **"Save Changes"**
- Render will automatically start deploying

---

## Step 6: Monitor Deployment

### 6.1 Watch Build Progress
1. Go to your web service
2. Click **"Logs"** tab
3. You'll see:
   ```
   ==> Building with Dockerfile...
   ==> Downloading dependencies...
   ==> Building application...
   ==> Starting container...
   ==> Your service is live!
   ```

**Build time:** 5-10 minutes (first deploy)

### 6.2 Check for Success
Look for these log messages:
```
Started BookNetworkApiApplication in X seconds
Tomcat started on port(s): 8088
```

### 6.3 Get Your Backend URL
- At the top of your service page, you'll see:
  ```
  https://book-social-network-api.onrender.com
  ```
- **COPY THIS URL** - you'll need it!

---

## Step 7: Test Backend Deployment

### 7.1 Test Swagger UI
```
Open: https://your-service.onrender.com/api/v1/swagger-ui/index.html
```
✅ **Expected**: Swagger UI loads with all endpoints

### 7.2 Check Logs
- No ERROR messages
- Database connection successful
- Application started successfully

---

## Step 8: Update render.yaml (Optional)

For future deployments, you can use Infrastructure as Code:

```yaml
services:
  - type: web
    name: book-social-network-api
    runtime: docker
    rootDir: book-network
    dockerfilePath: Dockerfile
    envVars:
      - key: SPRING_PROFILES_ACTIVE
        value: prod
      - key: PORT
        value: 8088
      - key: JAVA_TOOL_OPTIONS
        value: -Xmx400m -Xms400m
      - key: DATABASE_URL
        fromDatabase:
          name: book-social-network-db
          property: connectionString
      - key: MAIL_HOST
        value: smtp.gmail.com
      - key: MAIL_PORT
        value: 587
      - key: FILE_UPLOAD_PATH
        value: /tmp/uploads

databases:
  - name: book-social-network-db
    databaseName: book_social_network
    user: bookuser
    plan: free
```

---

## Part 2: Deploy Frontend to Vercel

### Step 1: Update Environment Configuration

```bash
cd /Users/sreesumanthgorantla/Desktop/2026/book-social-network-main
```

Edit: `book-network-ui/src/environments/environment.prod.ts`

Replace with your actual Render URL:
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://book-social-network-api.onrender.com/api/v1',
  keycloakUrl: 'https://your-keycloak.onrender.com',
  keycloakRealm: 'book-social-network',
  keycloakClientId: 'book-social-network-client'
};
```

### Step 2: Commit and Push

```bash
git add .
git commit -m "Update production backend URL for Render"
git push origin main
```

### Step 3: Deploy to Vercel

#### Option A: Vercel Dashboard (Easier)
1. Go to: https://vercel.com/new
2. Click **"Import Git Repository"**
3. Select: `books-network-angular--spring`
4. Configure:
   ```
   Framework Preset:    Angular
   Root Directory:      book-network-ui
   Build Command:       npm run build -- --configuration=production
   Output Directory:    dist/book-network-ui
   Node Version:        18.x
   ```
5. Click **"Deploy"**

#### Option B: Vercel CLI
```bash
cd book-network-ui
npm install -g vercel
vercel login
vercel --prod
```

When prompted:
- Set up project? **Yes**
- Link to existing? **No**
- Project name: **book-social-network**
- Directory: **./book-network-ui**
- Override settings? **No**

---

## Part 3: Update CORS Configuration

Your backend needs to allow requests from Vercel.

### Option 1: Add Environment Variable
In Render dashboard, add:
```bash
ALLOWED_ORIGINS=https://your-app.vercel.app,http://localhost:4200
```

### Option 2: Update Java Code (if needed)

If you have a CORS configuration class, ensure it reads from environment:

```java
@Value("${allowed.origins:http://localhost:4200}")
private String allowedOrigins;
```

Then redeploy:
```bash
git add .
git commit -m "Update CORS configuration"
git push
```
Render will auto-deploy.

---

## Part 4: Test Local Docker Build (Optional)

Test the Dockerfile locally before deploying:

```bash
cd book-network

# Build Docker image
docker build -t book-network:latest .

# Run container
docker run -p 8088:8088 \
  -e SPRING_PROFILES_ACTIVE=dev \
  -e DATABASE_URL=jdbc:postgresql://localhost:5432/book_social_network \
  -e DATABASE_USERNAME=username \
  -e DATABASE_PASSWORD=password \
  book-network:latest

# Test
curl http://localhost:8088/api/v1/swagger-ui/index.html
```

---

## Part 5: Troubleshooting

### Issue 1: Docker Build Fails

**Error**: `failed to build`

**Check Logs For:**
- Maven dependency download issues
- Compilation errors
- Missing files

**Solution:**
```bash
# Test build locally first
cd book-network
docker build -t test .

# Check for errors
# Fix any issues in pom.xml or source code
```

---

### Issue 2: Container Exits Immediately

**Error**: `Container exited with code 1`

**Check:**
1. Environment variables are set correctly
2. DATABASE_URL format is correct
3. Port binding uses $PORT variable

**Solution:** Check Render logs for Java exceptions

---

### Issue 3: Database Connection Failed

**Error**: `Unable to connect to database`

**Check:**
1. DATABASE_URL format: `postgresql://user:pass@host:5432/dbname`
2. Database is in same region as web service
3. Use **Internal Database URL** (not External)

**Solution:**
```bash
# Verify in Render logs
Looking for: "HikariPool-1 - Start completed"
```

---

### Issue 4: Out of Memory

**Error**: `OutOfMemoryError`

**Solution:** Adjust memory in environment variables:
```bash
JAVA_TOOL_OPTIONS=-Xmx350m -Xms350m
```

For free tier, max is ~450MB total.

---

### Issue 5: Port Binding Error

**Error**: `Port 8088 already in use`

**Solution:** Ensure CMD in Dockerfile uses $PORT:
```dockerfile
CMD ["java", "-Dserver.port=${PORT:-8088}", ...]
```

---

## Part 6: Render Configuration Summary

### Web Service Settings (Docker)
```yaml
Name:                book-social-network-api
Environment:         Docker
Dockerfile Path:     Dockerfile
Root Directory:      book-network
Branch:              main
Region:              Oregon (US West)
Instance Type:       Free (or $7/month)
Auto-Deploy:         Yes
```

### Environment Variables (Complete List)
```bash
# Application
SPRING_PROFILES_ACTIVE=prod
PORT=8088
JAVA_TOOL_OPTIONS=-Xmx400m -Xms400m

# Database
DATABASE_URL=postgresql://user:pass@host.oregon-postgres.render.com:5432/book_social_network

# Email
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=abcdefghijklmnop

# File Upload
FILE_UPLOAD_PATH=/tmp/uploads

# CORS (optional)
ALLOWED_ORIGINS=https://your-app.vercel.app

# Keycloak
KEYCLOAK_ISSUER_URI=http://localhost:9090/realms/book-social-network
```

### Database Settings
```yaml
Name:                book-social-network-db
PostgreSQL Version:  16
Database Name:       book_social_network
User:                bookuser
Region:              Same as web service
Instance Type:       Free
```

---

## Part 7: Deployment Checklist

### Pre-Deployment
- [x] Dockerfile created
- [x] .dockerignore created
- [x] Code pushed to GitHub
- [ ] Render account created
- [ ] Gmail App Password ready

### Deployment
- [ ] Web Service created on Render
- [ ] PostgreSQL database created
- [ ] Database connected to web service
- [ ] All environment variables set
- [ ] First deployment successful
- [ ] Backend URL noted: _______________

### Testing
- [ ] Swagger UI accessible
- [ ] No errors in Render logs
- [ ] Database tables created
- [ ] Can register user
- [ ] Email sending works

### Frontend
- [ ] Environment.prod.ts updated with backend URL
- [ ] Code pushed to GitHub
- [ ] Deployed to Vercel
- [ ] Frontend URL noted: _______________
- [ ] No CORS errors

---

## Part 8: Useful Commands

### Check Render Logs
```bash
# Via Dashboard: Logs tab
# Via CLI:
render logs -s book-social-network-api
```

### Redeploy After Code Changes
```bash
git add .
git commit -m "Your changes"
git push origin main
# Render auto-deploys
```

### Manual Deploy (if auto-deploy is off)
```bash
# Via Dashboard: Click "Manual Deploy" → "Deploy latest commit"
```

### Check Docker Image Size
```bash
# Locally
docker images | grep book-network

# Use Dockerfile.optimized for smaller images
```

---

## Part 9: Performance Optimization

### Use Multi-Stage Build
Rename `Dockerfile.optimized` to `Dockerfile` for:
- ✅ Smaller image size (100MB vs 300MB)
- ✅ Faster deployments
- ✅ Better caching

```bash
cd book-network
mv Dockerfile Dockerfile.backup
mv Dockerfile.optimized Dockerfile
git add Dockerfile
git commit -m "Use optimized Dockerfile"
git push
```

### Enable Health Checks
Dockerfile already includes health check. Verify in Render:
- Dashboard → Service → Health → Should show "Healthy"

---

## Part 10: Cost & Limits

### Render Free Tier
- ✅ 750 hours/month web service
- ✅ 90 days free PostgreSQL (then $7/month)
- ⚠️ Sleeps after 15 min inactivity
- ⚠️ First request after sleep: 30-60 seconds
- ⚠️ 512 MB RAM limit

### Upgrade Benefits ($7/month)
- ✅ Always-on (no sleep)
- ✅ Faster cold starts
- ✅ Better performance
- ✅ More reliable

### When to Upgrade
- If users complain about slow first load
- If you need 24/7 uptime
- If you're getting production traffic

---

## Part 11: Next Steps

### Immediate
1. ✅ Push Dockerfile to GitHub
2. ✅ Create Render Web Service
3. ✅ Add PostgreSQL database
4. ✅ Set environment variables
5. ✅ Wait for deployment
6. ✅ Test backend
7. ✅ Deploy frontend
8. ✅ Test end-to-end

### Soon
- Set up monitoring
- Configure custom domain
- Set up Keycloak
- Add logging/analytics
- Configure backups

### Optional
- Use Dockerfile.optimized
- Set up CI/CD pipeline
- Add automated tests
- Configure CDN
- Set up error tracking

---

## Summary

### Key Changes for 2026 Render Deployment
1. ✅ **Docker Required**: Java is no longer a direct runtime
2. ✅ **Dockerfile Created**: Standard and optimized versions
3. ✅ **Environment**: Select "Docker" not "Java"
4. ✅ **Configuration**: Use render.yaml for infrastructure as code

### Your Files
```
book-network/
├── Dockerfile              ✅ Standard Docker build
├── Dockerfile.optimized    ✅ Multi-stage optimized
├── .dockerignore          ✅ Excludes unnecessary files
├── pom.xml                ✅ Maven configuration
└── src/                   ✅ Source code
```

### Deployment Flow
```
1. Push code with Dockerfile to GitHub
2. Create Web Service (Docker) on Render
3. Add PostgreSQL database
4. Set environment variables
5. Render builds Docker image
6. Render deploys container
7. Test backend API
8. Deploy frontend to Vercel
9. Test complete application
```

---

## 🎉 You're Ready!

**Files created:**
- ✅ `book-network/Dockerfile`
- ✅ `book-network/Dockerfile.optimized`
- ✅ `book-network/.dockerignore`

**Next action:**
```bash
# Commit and push
cd /Users/sreesumanthgorantla/Desktop/2026/book-social-network-main
git add .
git commit -m "Add Docker configuration for Render deployment"
git push origin main

# Then follow this guide to deploy on Render!
```

**Deployment URL:**
- Go to: https://dashboard.render.com
- Follow Step 3 above

Good luck! 🚀

