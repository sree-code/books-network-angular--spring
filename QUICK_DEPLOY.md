# 🚀 Quick Deployment Guide

## Overview
This guide provides simple steps to deploy your Book Social Network application to production.

---

## ⚡ Quick Start

### Option 1: Use the Deployment Script (Recommended)
```bash
./deploy.sh
```
Select from the menu:
- **Option 1**: Deploy Frontend to Vercel
- **Option 2**: Deploy Backend to Railway
- **Option 3**: Deploy Backend to Render
- **Option 4**: Build both locally

### Option 2: Manual Deployment (follow below)

---

## 📱 Frontend Deployment (Vercel)

### Step 1: Install Vercel CLI
```bash
npm install -g vercel
```

### Step 2: Deploy
```bash
cd book-network-ui
vercel login
vercel --prod
```

### Step 3: Update Environment After Backend Deployment
1. After deploying backend, get your backend URL
2. Update `src/environments/environment.prod.ts`:
   ```typescript
   apiUrl: 'https://your-backend-url.com/api/v1'
   ```
3. Redeploy: `vercel --prod`

**Your frontend will be live at**: `https://your-app.vercel.app`

---

## 🚂 Backend Deployment (Railway - Recommended)

### Why Railway?
- ✅ Easy Spring Boot deployment
- ✅ Built-in PostgreSQL
- ✅ Free trial ($5 credit)
- ✅ Auto HTTPS

### Step 1: Install Railway CLI
```bash
npm install -g @railway/cli
```

### Step 2: Build Your App
```bash
cd book-network
./mvnw clean package -DskipTests
```

### Step 3: Deploy
```bash
railway login
railway init
railway up
```

### Step 4: Add PostgreSQL
```bash
railway add
# Select PostgreSQL
```

### Step 5: Set Environment Variables
In Railway dashboard (https://railway.app), add:
```
SPRING_PROFILES_ACTIVE=prod
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
KEYCLOAK_ISSUER_URI=https://your-keycloak.com/realms/book-social-network
```

**Your backend will be live at**: `https://your-app.railway.app`

---

## 🎨 Alternative: Backend on Render

### Step 1: Build Your App
```bash
cd book-network
./mvnw clean package -DskipTests
```

### Step 2: Deploy via Dashboard
1. Go to https://render.com
2. Click "New +" → "Web Service"
3. Connect GitHub repo
4. Configure:
   - **Name**: book-social-network-backend
   - **Environment**: Java
   - **Build Command**: `./mvnw clean package -DskipTests`
   - **Start Command**: `java -jar target/book-network-0.0.1-SNAPSHOT.jar`
5. Add PostgreSQL from dashboard
6. Set environment variables (same as Railway)

---

## 🔐 Keycloak Deployment

### Option 1: Use Keycloak Cloud (Easiest)
1. Sign up at https://www.keycloak.org/cloud
2. Create instance
3. Import realm from `keycloak/realm/book-social-network`
4. Use the provided URL

### Option 2: Deploy on Railway
See DEPLOYMENT_GUIDE.md for detailed instructions

---

## 🔗 Connect Everything

### 1. After Backend Deployment
Get your backend URL: `https://your-backend.railway.app`

### 2. Update Frontend
Edit `book-network-ui/src/environments/environment.prod.ts`:
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://your-backend.railway.app/api/v1',
  keycloakUrl: 'https://your-keycloak.com',
  keycloakRealm: 'book-social-network',
  keycloakClientId: 'book-social-network-client'
};
```

### 3. Update Keycloak
In Keycloak admin console:
- Add redirect URI: `https://your-frontend.vercel.app/*`
- Add web origin: `https://your-frontend.vercel.app`

### 4. Redeploy Frontend
```bash
cd book-network-ui
vercel --prod
```

---

## ✅ Deployment Checklist

### Backend
- [ ] Build successful locally
- [ ] Deployed to Railway/Render
- [ ] PostgreSQL database added
- [ ] Environment variables set
- [ ] Mail service configured
- [ ] API accessible via HTTPS

### Frontend
- [ ] Environment files created
- [ ] Build successful locally
- [ ] Deployed to Vercel
- [ ] Backend URL updated
- [ ] App accessible via HTTPS

### Keycloak
- [ ] Instance deployed
- [ ] Realm imported
- [ ] Client configured
- [ ] Redirect URIs updated
- [ ] Test user created

---

## 🐛 Common Issues

### Frontend can't connect to backend
- Check CORS settings in Spring Boot
- Verify API URL in environment.prod.ts
- Check browser console for errors

### Backend crashes on startup
- Check environment variables are set
- Verify database connection
- Check logs in Railway/Render dashboard

### Keycloak authentication fails
- Verify issuer-uri in application-prod.yml
- Check redirect URIs in Keycloak client
- Ensure frontend and Keycloak URLs match

---

## 📚 Resources

- **Detailed Guide**: See `DEPLOYMENT_GUIDE.md`
- **Vercel Docs**: https://vercel.com/docs
- **Railway Docs**: https://docs.railway.app
- **Render Docs**: https://render.com/docs

---

## 💰 Estimated Costs

| Service | Cost |
|---------|------|
| Vercel (Frontend) | Free |
| Railway (Backend + DB) | $5-20/month |
| Keycloak Cloud | Free tier or $25/month |
| **Total** | **$5-45/month** |

---

## 🎉 Success!

Once deployed:
- ✅ Frontend: `https://your-app.vercel.app`
- ✅ Backend: `https://your-backend.railway.app`
- ✅ API Docs: `https://your-backend.railway.app/api/v1/swagger-ui/index.html`

**Need help?** Check DEPLOYMENT_GUIDE.md for detailed troubleshooting.

