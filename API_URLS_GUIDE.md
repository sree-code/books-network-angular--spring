# 🌐 API URLs and Testing Guide

## 🎯 Understanding the 404 Error

**Why you got 404:**
The root URL `https://book-social-network-api-wkiu.onrender.com/` had no endpoint mapped!

Your API is configured with a **base path**: `/api/v1/`

This means all endpoints are under `/api/v1/`, not at the root `/`.

---

## ✅ CORRECT URLs for Your API

### **Primary URLs (What You Should Use)**

#### 1. Swagger UI (API Documentation)
```
https://book-social-network-api-wkiu.onrender.com/api/v1/swagger-ui/index.html
```
**Use this to:**
- View all available endpoints
- Test API calls directly
- See request/response formats

#### 2. API Status Check
```
https://book-social-network-api-wkiu.onrender.com/api/v1/status
```
**Returns:**
```json
{
  "status": "UP",
  "message": "Book Social Network API is running",
  "timestamp": "2026-01-04T...",
  "apiVersion": "v1"
}
```

#### 3. Health Check
```
https://book-social-network-api-wkiu.onrender.com/api/v1/status/health
```
**Returns:**
```json
{
  "status": "UP",
  "application": "Book Social Network API"
}
```

#### 4. Simple Ping
```
https://book-social-network-api-wkiu.onrender.com/api/v1/status/ping
```
**Returns:** `pong`

---

### **NEW: Root URL Support**

After deploying the fix:

#### Root URL (Auto-redirects to Swagger)
```
https://book-social-network-api-wkiu.onrender.com/
```
**Now redirects to:** Swagger UI (no more 404!)

#### API Information
```
https://book-social-network-api-wkiu.onrender.com/info
```
**Returns:** Complete API information and available endpoints

#### Root Health Check
```
https://book-social-network-api-wkiu.onrender.com/health
```
**Returns:** Health status

---

## 📋 API Endpoint Structure

Your API follows this structure:

```
Base URL: https://book-social-network-api-wkiu.onrender.com
    │
    ├── / (root)
    │   ├── GET  /              → Redirects to Swagger UI ✅ (NEW!)
    │   ├── GET  /health        → Health check ✅ (NEW!)
    │   └── GET  /info          → API info ✅ (NEW!)
    │
    └── /api/v1/ (API base path)
        ├── /status
        │   ├── GET  /api/v1/status         → API status ✅ (NEW!)
        │   ├── GET  /api/v1/status/health  → Health ✅ (NEW!)
        │   └── GET  /api/v1/status/ping    → Ping ✅ (NEW!)
        │
        ├── /auth
        │   ├── POST /api/v1/auth/register
        │   ├── POST /api/v1/auth/authenticate
        │   └── GET  /api/v1/auth/activate-account
        │
        ├── /books
        │   ├── GET    /api/v1/books
        │   ├── POST   /api/v1/books
        │   ├── GET    /api/v1/books/{id}
        │   └── ...
        │
        ├── /feedbacks
        │   ├── GET    /api/v1/feedbacks
        │   ├── POST   /api/v1/feedbacks
        │   └── ...
        │
        └── /swagger-ui
            └── GET  /api/v1/swagger-ui/index.html
```

---

## 🧪 Testing Your API

### Method 1: Browser (Easiest)

#### Test 1: Swagger UI
**Open in browser:**
```
https://book-social-network-api-wkiu.onrender.com/api/v1/swagger-ui/index.html
```
✅ **If this loads** → API is working!

#### Test 2: Status Endpoint
**Open in browser:**
```
https://book-social-network-api-wkiu.onrender.com/api/v1/status
```
✅ **Should show:** `{"status":"UP",...}`

#### Test 3: Root URL (After Fix)
**Open in browser:**
```
https://book-social-network-api-wkiu.onrender.com/
```
✅ **Should redirect to:** Swagger UI

---

### Method 2: cURL (Command Line)

```bash
# Test status
curl https://book-social-network-api-wkiu.onrender.com/api/v1/status

# Test ping
curl https://book-social-network-api-wkiu.onrender.com/api/v1/status/ping

# Test health
curl https://book-social-network-api-wkiu.onrender.com/api/v1/status/health

# Test root (after fix)
curl -I https://book-social-network-api-wkiu.onrender.com/
```

---

### Method 3: Postman/Insomnia

**Import these endpoints:**

```
GET  https://book-social-network-api-wkiu.onrender.com/api/v1/status
GET  https://book-social-network-api-wkiu.onrender.com/api/v1/status/health
GET  https://book-social-network-api-wkiu.onrender.com/api/v1/status/ping
```

---

## 🔧 What I Just Fixed

### Problem:
- ❌ `https://book-social-network-api-wkiu.onrender.com/` → 404 Error
- ❌ No root endpoint defined
- ❌ Confusing for users

### Solution (After Deployment):
- ✅ Root URL now redirects to Swagger UI
- ✅ Added `/health` endpoint at root
- ✅ Added `/info` endpoint with API details
- ✅ Added `/api/v1/status` endpoints for monitoring
- ✅ No more 404 on root URL!

---

## 📊 Quick Verification Checklist

After the code redeploys, test these in order:

- [ ] **Step 1:** Open `https://book-social-network-api-wkiu.onrender.com/api/v1/swagger-ui/index.html`
  - Expected: Swagger UI loads with all endpoints

- [ ] **Step 2:** Open `https://book-social-network-api-wkiu.onrender.com/api/v1/status`
  - Expected: JSON response with `"status": "UP"`

- [ ] **Step 3:** Open `https://book-social-network-api-wkiu.onrender.com/`
  - Expected: Redirects to Swagger UI (no 404!)

- [ ] **Step 4:** Test in frontend
  - Update frontend API URL to: `https://book-social-network-api-wkiu.onrender.com/api/v1`

---

## 🎯 For Frontend Configuration

Update your frontend environment file:

```typescript
// book-network-ui/src/environments/environment.prod.ts
export const environment = {
  production: true,
  apiUrl: 'https://book-social-network-api-wkiu.onrender.com/api/v1',
  // ... other config
};
```

**Important:** Include `/api/v1` in the base URL!

---

## ⏱️ Timeline for Fix

```
NOW     → Code with root endpoints created ✅
+1 min  → Commit and push to GitHub
+2 min  → Render detects changes
+3 min  → Build starts
+10 min → Deployment completes
+11 min → Root URL now works! ✅
```

**Test in 10-15 minutes!**

---

## 🐛 Current Status vs After Fix

### CURRENT (Before Fix):
```
❌ https://book-social-network-api-wkiu.onrender.com/
   → 404 Not Found

✅ https://book-social-network-api-wkiu.onrender.com/api/v1/swagger-ui/index.html
   → Works! (This is your actual API)
```

### AFTER FIX (After Deployment):
```
✅ https://book-social-network-api-wkiu.onrender.com/
   → Redirects to Swagger UI!

✅ https://book-social-network-api-wkiu.onrender.com/health
   → Health check works!

✅ https://book-social-network-api-wkiu.onrender.com/api/v1/status
   → Status endpoint works!

✅ https://book-social-network-api-wkiu.onrender.com/api/v1/swagger-ui/index.html
   → Still works!
```

---

## 💡 Key Takeaways

1. **Your API is at `/api/v1/`** - not at root `/`
2. **Swagger UI** is your best friend for testing: `/api/v1/swagger-ui/index.html`
3. **Root URL 404** is normal if no endpoint is mapped there
4. **After fix**, root URL will redirect to Swagger
5. **Frontend** must use `/api/v1` as base path

---

## 📚 Useful Commands

```bash
# Check if API is running
curl https://book-social-network-api-wkiu.onrender.com/api/v1/status

# Check database connectivity (implicitly)
curl https://book-social-network-api-wkiu.onrender.com/api/v1/status/health

# Quick ping test
curl https://book-social-network-api-wkiu.onrender.com/api/v1/status/ping
```

---

## ✅ Summary

**Your API is WORKING!** The 404 was because:
- You accessed the root `/` which had no endpoint
- Your API is actually at `/api/v1/`
- Swagger UI is at `/api/v1/swagger-ui/index.html`

**After deploying the fix:**
- Root `/` will redirect to Swagger
- Health checks available
- No more confusion!

---

## 🚀 Test RIGHT NOW (Before Fix)

**This should work RIGHT NOW:**
```
https://book-social-network-api-wkiu.onrender.com/api/v1/swagger-ui/index.html
```

**Open this in your browser to confirm your API is actually working!**

---

**Your API is deployed and working - you were just looking at the wrong URL!** 🎉

