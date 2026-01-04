# 🔧 Connection Failed - Troubleshooting Guide

## Error Analysis

**Error**: `The connection attempt failed` + `java.io.EOFException`

**What this means**: Your application **cannot reach** the PostgreSQL database at all. This is a **network/connectivity issue**, not a URL format problem.

---

## 🎯 Most Likely Causes (In Order)

### 1. DATABASE_URL Not Set ⚠️ (MOST COMMON)
The environment variable is missing or incorrect in Render.

### 2. Using External URL Instead of Internal
External URLs don't work from within Render's network.

### 3. Database Not in Same Region
Database and web service must be in the same Render region.

### 4. Database Not Created Yet
The PostgreSQL instance might not be fully initialized.

---

## ✅ Solution Steps (Follow in Order)

### Step 1: Verify DATABASE_URL is Set

1. **Go to Render Dashboard** → Your Web Service → **Environment** tab

2. **Check if DATABASE_URL exists**
   - If NO → **ADD IT NOW** (see Step 2)
   - If YES → Verify it's correct (see Step 3)

---

### Step 2: Get the Correct DATABASE_URL

1. **Go to Render Dashboard** → **PostgreSQL** section

2. **Click on your database**: `book-social-network-db`

3. **Scroll to "Connections" section**

4. **Copy the "Internal Database URL"** (NOT External!)
   ```
   Format: postgresql://bookuser:xxxxx@dpg-xxxxx-a.oregon-postgres.render.com:5432/book_social_network
   ```

5. **Characteristics of Internal URL**:
   - ✅ Starts with `postgresql://`
   - ✅ Hostname ends with `.render.com` (NOT `.render-external.com`)
   - ✅ Usually shorter than External URL
   - ✅ Does NOT have `?sslmode=require` at the end (app adds this automatically)

---

### Step 3: Set DATABASE_URL in Web Service

1. **Go back to your Web Service** → **Environment** tab

2. **If DATABASE_URL doesn't exist**:
   - Click **"Add Environment Variable"**
   - Key: `DATABASE_URL`
   - Value: *paste the Internal Database URL*
   - Click **"Save Changes"**

3. **If DATABASE_URL already exists**:
   - Click **"Edit"** (pencil icon)
   - **REPLACE** with the correct Internal Database URL
   - Click **"Save Changes"**

4. **Render will automatically redeploy** (wait 5-10 minutes)

---

### Step 4: Verify Region Match

Both services MUST be in the same region:

1. **Check Database Region**:
   - Dashboard → PostgreSQL → `book-social-network-db`
   - Look for region (e.g., "Oregon (US West)")

2. **Check Web Service Region**:
   - Dashboard → Web Service → `book-social-network-api`
   - Look for region

3. **If Different Regions**:
   - You need to recreate one of them in the same region
   - Or create a new database in the web service's region

---

### Step 5: Check Database Status

1. **Go to your PostgreSQL database** in Render Dashboard

2. **Check Status**:
   - Should show **"Available"** (green)
   - If "Creating" → Wait until ready
   - If "Failed" → Delete and recreate

3. **Test Connection** (Optional):
   - Click "Connect" → "External Connection"
   - Try connecting with a PostgreSQL client (pgAdmin, DBeaver)
   - If this fails, the database itself has issues

---

### Step 6: Check Logs for Diagnostic Info

After redeployment with the new code:

1. **Go to your Web Service** → **Logs** tab

2. **Look for these log messages**:
   ```
   === DATABASE CONFIGURATION ===
   DATABASE_URL is SET
   Converted DATABASE_URL:
     Host: dpg-xxxxx-a.oregon-postgres.render.com
     Port: 5432
     Database: /book_social_network
     Username: bookuser
     JDBC URL: jdbc:postgresql://[...]
   Creating HikariDataSource with connection pool
   ```

3. **If you see**:
   - `DATABASE_URL is NOT SET` → Go back to Step 3
   - `Invalid DATABASE_URL format` → Wrong URL format
   - `The connection attempt failed` → Network/region issue

---

## 📋 Correct Environment Variables

Make sure ALL of these are set in Render → Environment:

```bash
# CRITICAL - Must be set correctly
DATABASE_URL=postgresql://bookuser:xxxxx@dpg-xxxxx.oregon-postgres.render.com:5432/book_social_network

# Application settings
SPRING_PROFILES_ACTIVE=prod
PORT=8088
JAVA_TOOL_OPTIONS=-Xmx400m -Xms400m

# Email (can be set later)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

# File upload
FILE_UPLOAD_PATH=/tmp/uploads

# Keycloak (temporary)
KEYCLOAK_ISSUER_URI=http://localhost:9090/realms/book-social-network
```

---

## 🔍 How to Verify It's Fixed

After redeployment, look for these in logs:

✅ **Success Indicators**:
```
=== DATABASE CONFIGURATION ===
DATABASE_URL is SET
Converted DATABASE_URL:
  Host: dpg-xxxxx-a.oregon-postgres.render.com
  [...]
HikariPool-1 - Starting...
HikariPool-1 - Start completed
Started BookNetworkApiApplication in X seconds
```

❌ **Still Failing**:
```
DATABASE_URL is NOT SET
OR
The connection attempt failed
```

---

## 🐛 Common Mistakes

### Mistake 1: Using External URL
```bash
# ❌ WRONG (External URL - won't work)
DATABASE_URL=postgresql://bookuser:xxx@dpg-xxx.oregon-postgres.render-external.com:5432/db

# ✅ CORRECT (Internal URL)
DATABASE_URL=postgresql://bookuser:xxx@dpg-xxx-a.oregon-postgres.render.com:5432/db
```

### Mistake 2: Converting to JDBC Format
```bash
# ❌ WRONG (Don't convert manually)
DATABASE_URL=jdbc:postgresql://dpg-xxx.oregon-postgres.render.com:5432/db

# ✅ CORRECT (Let the app convert)
DATABASE_URL=postgresql://dpg-xxx.oregon-postgres.render.com:5432/db
```

### Mistake 3: Adding SSL Parameter
```bash
# ❌ WRONG (Don't add sslmode manually)
DATABASE_URL=postgresql://bookuser:xxx@host:5432/db?sslmode=require

# ✅ CORRECT (App adds SSL automatically)
DATABASE_URL=postgresql://bookuser:xxx@host:5432/db
```

---

## 🔧 Alternative: Separate Variables

If you can't get DATABASE_URL working, use separate variables:

1. **Remove DATABASE_URL** (or leave it)

2. **Add these instead**:
```bash
DATABASE_USERNAME=bookuser
DATABASE_PASSWORD=<your-password>
DATABASE_HOST=dpg-xxxxx-a.oregon-postgres.render.com
DATABASE_PORT=5432
DATABASE_NAME=book_social_network
```

3. **Update application-prod.yml**:
```yaml
spring:
  datasource:
    url: jdbc:postgresql://${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_NAME}?sslmode=require
    username: ${DATABASE_USERNAME}
    password: ${DATABASE_PASSWORD}
```

---

## 📞 Step-by-Step Checklist

Complete these in order:

- [ ] **Step 1**: Go to PostgreSQL database in Render
- [ ] **Step 2**: Copy **Internal Database URL**
- [ ] **Step 3**: Go to Web Service → Environment
- [ ] **Step 4**: Set/Update DATABASE_URL
- [ ] **Step 5**: Verify regions match
- [ ] **Step 6**: Save changes (triggers redeploy)
- [ ] **Step 7**: Wait 5-10 minutes
- [ ] **Step 8**: Check logs for success messages
- [ ] **Step 9**: Test Swagger UI

---

## 🎯 Quick Diagnostic

**Run this mental checklist**:

1. ✅ DATABASE_URL is set in Render? 
   - NO → **Set it now!**
   - YES → Continue

2. ✅ It's the Internal URL (not External)?
   - NO → **Get Internal URL from database**
   - YES → Continue

3. ✅ Web service and database in same region?
   - NO → **Recreate in same region**
   - YES → Continue

4. ✅ Database status is "Available"?
   - NO → **Wait or recreate database**
   - YES → Should work!

---

## 🚀 Expected Timeline

After fixing DATABASE_URL:

```
0:00 - Save environment variable in Render
0:01 - Render triggers auto-deploy
0:02 - Docker build starts
5:00 - Docker build completes
5:30 - Container starts, connects to database
6:00 - Application starts successfully ✅
```

Total: **~6 minutes**

---

## ✅ Success Confirmation

You'll know it worked when you see:

1. **In Logs**:
   ```
   HikariPool-1 - Start completed
   Started BookNetworkApiApplication
   ```

2. **Swagger UI loads**:
   ```
   https://your-service.onrender.com/api/v1/swagger-ui/index.html
   ```

3. **No error messages** in logs

---

## 💡 Pro Tips

1. **Always use Internal URL** for database connections within Render
2. **Check regions first** - most common oversight
3. **Wait for database** to be fully "Available" before deploying app
4. **Don't modify the URL** - paste exactly as Render provides
5. **Check logs immediately** after deploy for diagnostic info

---

## 📚 Related Documentation

- `RENDER_DOCKER_DEPLOYMENT_2026.md` - Complete deployment guide
- `END_TO_END_TESTING_CHECKLIST.md` - Testing after deployment

---

## 🎊 Summary

**Most Likely Fix**: 
1. Get **Internal Database URL** from PostgreSQL database
2. Set it as **DATABASE_URL** in Web Service environment
3. Wait for redeploy
4. Check logs for success

**If that doesn't work**:
1. Verify regions match
2. Verify database is "Available"
3. Try separate DATABASE_* variables

---

**Your next action**: Go to Render Dashboard → PostgreSQL → Copy Internal Database URL → Web Service → Environment → Set DATABASE_URL → Save

This will trigger an automatic redeploy with the correct configuration! 🚀

