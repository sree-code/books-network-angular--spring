# 🚀 Complete End-to-End Deployment Guide - Render

## 📋 Overview
This guide will walk you through deploying your Book Social Network application to production using:
- **Backend**: Render (Spring Boot + PostgreSQL)
- **Frontend**: Vercel (Angular)
- **Authentication**: Keycloak (we'll use a public instance for testing)

**Estimated Time**: 30-45 minutes

---

## Part 1: Deploy Backend to Render (20 minutes)

### Step 1: Build Your Backend Locally (Test First)
```bash
cd /Users/sreesumanthgorantla/Desktop/2026/book-social-network-main/book-network
./mvnw clean package -DskipTests
```

✅ **Expected Result**: `BUILD SUCCESS` and a JAR file created in `target/` directory

---

### Step 2: Create Web Service on Render

1. **Go to Render Dashboard**
   - Visit: https://dashboard.render.com
   - Login with your account

2. **Create New Web Service**
   - Click **"New +"** button (top right)
   - Select **"Web Service"**

3. **Connect GitHub Repository**
   - Click **"Connect account"** if not connected
   - Find and select: `books-network-angular--spring`
   - Click **"Connect"**

4. **Configure Web Service** (IMPORTANT - Copy these exactly)

   **Basic Settings:**
   ```
   Name:                book-social-network-api
   Region:              Oregon (US West) or closest to you
   Branch:              main
   Root Directory:      book-network
   Runtime:             Java
   Build Command:       ./mvnw clean package -DskipTests
   Start Command:       java -Dserver.port=$PORT -Dspring.profiles.active=prod -jar target/book-network-0.0.1-SNAPSHOT.jar
   ```

   **Instance Type:**
   ```
   Free (512 MB RAM, 0.1 CPU)
   ```
   ⚠️ Note: Free tier sleeps after 15 min of inactivity. Upgrade to $7/month for always-on.

5. **Click "Advanced"** (expand advanced settings)

   **Add Environment Variables** (click "Add Environment Variable" for each):
   ```
   SPRING_PROFILES_ACTIVE=prod
   PORT=8088
   JAVA_TOOL_OPTIONS=-Xmx400m -Xms400m
   ```

6. **Click "Create Web Service"**
   - Render will start building your application
   - This takes 5-10 minutes for first deployment

---

### Step 3: Add PostgreSQL Database

1. **While backend is building, create database**
   - In Render Dashboard, click **"New +"**
   - Select **"PostgreSQL"**

2. **Configure Database**
   ```
   Name:           book-social-network-db
   Database:       book_social_network
   User:           bookuser
   Region:         Same as your web service
   PostgreSQL Version: 16 (latest)
   Instance Type:  Free
   ```

3. **Click "Create Database"**
   - Database will be ready in 1-2 minutes

4. **Copy Database Connection Details**
   - On database page, scroll down to **"Connections"**
   - Copy these values (click the copy icon):
     - **Internal Database URL** (starts with `postgresql://`)
     - **JDBC URL** (starts with `jdbc:postgresql://`)

---

### Step 4: Connect Database to Backend

1. **Go back to your Web Service** (book-social-network-api)
   - Click on your service name in the dashboard
   - Go to **"Environment"** tab
   - Click **"Add Environment Variable"**

2. **Add Database Environment Variables**
   
   Click "Add Environment Variable" and add these one by one:

   ```bash
   # Database Configuration
   DATABASE_URL=<paste your Internal Database URL>
   
   # Or use individual components (JDBC format)
   DATABASE_URL=jdbc:postgresql://dpg-xxxxx.oregon-postgres.render.com/book_social_network
   DATABASE_USERNAME=bookuser
   DATABASE_PASSWORD=<your-database-password>
   ```

3. **Add Email Configuration** (for sending activation emails)
   
   **Option A: Using Gmail** (Recommended for testing)
   ```bash
   MAIL_HOST=smtp.gmail.com
   MAIL_PORT=587
   MAIL_USERNAME=your-email@gmail.com
   MAIL_PASSWORD=your-app-password
   ```
   
   ⚠️ **How to get Gmail App Password:**
   - Go to https://myaccount.google.com/security
   - Enable 2-Step Verification
   - Go to "App passwords"
   - Generate password for "Mail"
   - Copy the 16-character password

   **Option B: Using Mailtrap** (For testing without sending real emails)
   ```bash
   MAIL_HOST=smtp.mailtrap.io
   MAIL_PORT=2525
   MAIL_USERNAME=<mailtrap-username>
   MAIL_PASSWORD=<mailtrap-password>
   ```
   Sign up at https://mailtrap.io for free testing account

4. **Add File Upload Configuration**
   ```bash
   FILE_UPLOAD_PATH=/tmp/uploads
   ```

5. **Add Keycloak Configuration** (We'll use a test setup)
   ```bash
   KEYCLOAK_ISSUER_URI=http://localhost:9090/realms/book-social-network
   ```
   
   ⚠️ **Note**: For now, we'll keep localhost. We'll update this after setting up Keycloak or use a workaround.

6. **Click "Save Changes"**
   - Render will automatically redeploy your service

---

### Step 5: Wait for Deployment to Complete

1. **Monitor Build Logs**
   - Go to **"Logs"** tab in your web service
   - Watch for:
     ```
     BUILD SUCCESS
     Started BookNetworkApiApplication in X seconds
     ```

2. **Check Deployment Status**
   - Green checkmark = Deployed successfully
   - Red X = Failed (check logs for errors)

3. **Get Your Backend URL**
   - At the top of your service page, you'll see:
   ```
   https://book-social-network-api.onrender.com
   ```
   - **COPY THIS URL** - you'll need it!

---

### Step 6: Test Backend API

1. **Test Health/Swagger**
   ```
   Open: https://book-social-network-api.onrender.com/api/v1/swagger-ui/index.html
   ```
   
   ✅ **Expected**: Swagger UI should load

2. **Test Simple Endpoint**
   ```
   Open: https://book-social-network-api.onrender.com/api/v1/actuator/health
   ```
   
   ⚠️ If 404, that's okay - not all apps have actuator

3. **Check Logs for Errors**
   - Go to Logs tab
   - Look for any exceptions or errors
   - Database connection should be successful

---

## Part 2: Setup Keycloak (15 minutes)

### Option A: Use Keycloak Cloud (Easiest)

⚠️ **For production, you need a real Keycloak instance**

**Quick Solution for Testing:**

1. **Deploy Keycloak on Render** (Same as backend)
   - New + → Web Service
   - **Docker Image**: `quay.io/keycloak/keycloak:24.0.2`
   ```
   Name:           book-keycloak
   Region:         Same as backend
   Docker Command: start-dev
   Environment Variables:
     KEYCLOAK_ADMIN=admin
     KEYCLOAK_ADMIN_PASSWORD=admin
   ```

2. **Add Keycloak Database**
   - Create another PostgreSQL database for Keycloak
   - Link it to Keycloak service

**OR Use Alternative for Quick Testing:**

### Option B: Disable Keycloak Temporarily (Quick Testing)

For initial testing without Keycloak:

1. Update backend to use basic auth instead of Keycloak
2. Or use public Keycloak test instance

⚠️ **Recommended**: Set up Keycloak properly before production use

---

## Part 3: Deploy Frontend to Vercel (10 minutes)

### Step 1: Update Production Environment

1. **Edit environment.prod.ts**
   ```typescript
   export const environment = {
     production: true,
     apiUrl: 'https://book-social-network-api.onrender.com/api/v1',
     keycloakUrl: 'https://your-keycloak.onrender.com', // Update when Keycloak is ready
     keycloakRealm: 'book-social-network',
     keycloakClientId: 'book-social-network-client'
   };
   ```

2. **Commit and Push**
   ```bash
   cd /Users/sreesumanthgorantla/Desktop/2026/book-social-network-main
   git add .
   git commit -m "Update production backend URL"
   git push origin main
   ```

---

### Step 2: Deploy to Vercel (Dashboard Method)

1. **Go to Vercel Dashboard**
   - Visit: https://vercel.com/new
   - Login with your account

2. **Import Git Repository**
   - Click **"Import Git Repository"**
   - Select: `books-network-angular--spring`
   - Click **"Import"**

3. **Configure Project**
   ```
   Framework Preset:    Angular
   Root Directory:      book-network-ui
   Build Command:       npm run build -- --configuration=production
   Output Directory:    dist/book-network-ui
   Install Command:     npm install
   ```

4. **Environment Variables** (Optional for frontend)
   - Usually not needed, using environment files

5. **Click "Deploy"**
   - Wait 2-5 minutes for build
   - ✅ You'll get a URL like: `https://book-social-network.vercel.app`

---

### Step 3: Update Backend CORS

Your backend needs to allow requests from Vercel URL.

**If you have a CORS configuration class**, update it:

1. Go to Render Dashboard → Your Backend Service
2. Add Environment Variable:
   ```bash
   ALLOWED_ORIGINS=https://book-social-network.vercel.app,http://localhost:4200
   ```

3. Save and redeploy

---

## Part 4: Complete End-to-End Testing (15 minutes)

### Test 1: Frontend Loads ✅

1. **Open Vercel URL**: `https://your-app.vercel.app`
2. **Check Browser Console** (F12)
   - Should have no CORS errors
   - Should have no 404 errors

**Expected**: Login/Register page loads

---

### Test 2: Backend API Accessible ✅

1. **Test Swagger UI**:
   ```
   https://book-social-network-api.onrender.com/api/v1/swagger-ui/index.html
   ```
   
2. **Check Available Endpoints**:
   - Authentication endpoints
   - Books endpoints
   - Feedback endpoints

**Expected**: All endpoints listed

---

### Test 3: User Registration Flow ✅

1. **Go to Frontend**: Register page
2. **Fill Registration Form**:
   ```
   First Name:  Test
   Last Name:   User
   Email:       test@example.com
   Password:    Test123!@#
   ```
3. **Click Register**

**Expected Behavior:**
- ✅ Success message appears
- ✅ Check email (Gmail/Mailtrap) for activation code
- ✅ If no email, check Render logs for errors

**Check Backend Logs** (Render Dashboard → Logs):
```
Should see: POST /api/v1/auth/register - 201 Created
Should see: Email sent to: test@example.com
```

---

### Test 4: Email Activation ✅

1. **Check Email**:
   - Gmail inbox
   - Or Mailtrap inbox (https://mailtrap.io/inboxes)

2. **Copy Activation Code** (6 digits)

3. **Enter Code** on activation page

**Expected**:
- ✅ Account activated successfully
- ✅ Redirected to login page

---

### Test 5: Login Flow ✅

⚠️ **This requires Keycloak to be set up**

If Keycloak is working:
1. Click **Login**
2. Redirected to Keycloak
3. Enter credentials
4. Redirected back to app
5. Dashboard loads

**Workaround without Keycloak:**
- Backend needs modification to use JWT without Keycloak
- Or complete Keycloak setup first

---

### Test 6: Database Verification ✅

1. **Go to Render Dashboard**
2. **Open PostgreSQL Database**
3. **Click "Connect" → "External Connection"**
4. **Use DBeaver or pgAdmin**:
   ```
   Host:     dpg-xxxxx.oregon-postgres.render.com
   Port:     5432
   Database: book_social_network
   Username: bookuser
   Password: <your-password>
   ```

5. **Check Tables Created**:
   - Users table
   - Books table
   - Roles table
   - Tokens table

6. **Verify User Registration**:
   ```sql
   SELECT * FROM _user;
   ```
   Should see your test user

---

### Test 7: Book Management (After Login) ✅

1. **Create a Book**:
   - Title, Author, ISBN
   - Upload cover image

2. **Check Backend Logs**:
   ```
   POST /api/v1/books - 201 Created
   File uploaded to: /tmp/uploads/...
   ```

3. **Verify in Database**:
   ```sql
   SELECT * FROM book;
   ```

4. **List Books**:
   - Should show your created book

---

### Test 8: Performance & Monitoring ✅

1. **Check Response Times**:
   - Backend: < 2 seconds (first request may be slower on free tier)
   - Frontend: < 1 second

2. **Monitor Render Metrics**:
   - Dashboard → Your Service → Metrics
   - CPU usage
   - Memory usage
   - Request count

3. **Free Tier Limitations**:
   - ⚠️ Service sleeps after 15 min inactivity
   - First request after sleep: 30-60 seconds
   - Upgrade to $7/month for always-on

---

## Part 5: Troubleshooting Common Issues

### Issue 1: CORS Errors in Browser Console ❌

**Error**: `Access to XMLHttpRequest blocked by CORS policy`

**Solution**:
```bash
# Add to Render Environment Variables
ALLOWED_ORIGINS=https://your-vercel-app.vercel.app
```

Then redeploy backend.

---

### Issue 2: Database Connection Failed ❌

**Error**: `Unable to connect to PostgreSQL`

**Solution**:
1. Check DATABASE_URL is correct
2. Verify database is running (Render dashboard)
3. Check database region matches backend region
4. Use Internal Database URL (not External)

---

### Issue 3: Backend Not Starting ❌

**Error**: `Application failed to start`

**Check Logs**:
```bash
# Common issues:
- Port binding error (use $PORT)
- Missing environment variables
- Database connection timeout
```

**Solution**:
1. Check all environment variables are set
2. Verify Start Command uses $PORT
3. Check Java heap memory (add -Xmx400m)

---

### Issue 4: File Upload Fails ❌

**Error**: `Cannot write to /tmp/uploads`

**Solution**:
```bash
# Files in /tmp are ephemeral on Render
# For production, use cloud storage:

# Option 1: AWS S3
# Option 2: Cloudinary
# Option 3: Render Disk (paid plans)
```

---

### Issue 5: Emails Not Sending ❌

**Check Backend Logs**:
```
Should see: "Email sent successfully"
Or: "Error sending email: ..."
```

**Solution**:
1. Verify MAIL_HOST, MAIL_PORT
2. Check Gmail App Password is correct
3. Try Mailtrap for testing
4. Check firewall isn't blocking SMTP

---

### Issue 6: Keycloak Not Working ❌

**Error**: `Token validation failed`

**Quick Fix**:
```bash
# For testing without Keycloak:
# Modify backend to use simple JWT or basic auth
# OR complete Keycloak setup properly
```

---

## Part 6: Production Checklist

### Before Going Live ✅

- [ ] Backend deployed and accessible
- [ ] Database connected and tables created
- [ ] Email service working
- [ ] Frontend deployed and loading
- [ ] CORS configured correctly
- [ ] Environment variables secure
- [ ] Keycloak configured (or auth working)
- [ ] Test user can register
- [ ] Test user can activate account
- [ ] Test user can login
- [ ] Test user can create book
- [ ] File uploads working (or cloud storage configured)
- [ ] Performance acceptable
- [ ] Error monitoring set up
- [ ] Backup strategy planned

---

## Part 7: Post-Deployment

### Monitor Your Application

1. **Render Dashboard**:
   - Check metrics daily
   - Monitor error logs
   - Watch resource usage

2. **Set Up Alerts**:
   - Email notifications for errors
   - Slack integration
   - Uptime monitoring

3. **Regular Maintenance**:
   - Database backups
   - Security updates
   - Performance optimization

---

## Quick Reference - All Your URLs

Fill these in as you deploy:

```bash
# Backend
Render Dashboard:     https://dashboard.render.com
Backend URL:          https://book-social-network-api.onrender.com
API Docs:             https://book-social-network-api.onrender.com/api/v1/swagger-ui/index.html
Database:             dpg-xxxxx.oregon-postgres.render.com

# Frontend  
Vercel Dashboard:     https://vercel.com/dashboard
Frontend URL:         https://book-social-network.vercel.app

# Keycloak
Keycloak URL:         https://your-keycloak.onrender.com
Admin Console:        https://your-keycloak.onrender.com/admin

# Repository
GitHub:               https://github.com/sree-code/books-network-angular--spring
```

---

## Cost Summary

| Service | Free Tier | Paid |
|---------|-----------|------|
| Render Backend | ✅ 750 hours/month | $7/month (always-on) |
| Render PostgreSQL | ✅ 90 days free | $7/month |
| Vercel Frontend | ✅ Unlimited | $20/month |
| Email (Mailtrap) | ✅ 500 emails/month | Free |
| **Total** | **FREE for testing** | **$14-27/month** |

---

## Next Steps

1. ✅ **Complete this guide step by step**
2. 📸 **Take screenshots** of successful deployments
3. 📝 **Document your URLs** in the checklist
4. 🧪 **Test all features** thoroughly
5. 🚀 **Share your deployed app** with others!

---

## Need Help?

- Check Render logs first
- Verify all environment variables
- Test backend independently via Swagger
- Check browser console for frontend errors
- Review this guide's troubleshooting section

---

**You're ready to deploy!** Follow this guide step by step, and you'll have a fully functional production application. 🚀

Good luck! 🎉

