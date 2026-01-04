# 📋 Deployment Checklist

Use this checklist to track your deployment progress.

---

## Pre-Deployment
- [x] Project compiles successfully locally
- [x] All code committed to GitHub
- [x] Environment files created
- [x] Deployment configuration files created
- [x] Documentation reviewed

---

## Backend Deployment (Railway/Render)

### Setup
- [ ] Railway/Render account created
- [ ] Railway CLI installed (if using Railway)
- [ ] Project built successfully: `./mvnw clean package -DskipTests`

### Deployment
- [ ] Backend deployed to Railway/Render
- [ ] PostgreSQL database added
- [ ] Database connected successfully
- [ ] Backend URL noted: `____________________________`

### Environment Variables Set
- [ ] `SPRING_PROFILES_ACTIVE=prod`
- [ ] `DATABASE_URL` (auto-set by platform)
- [ ] `MAIL_HOST`
- [ ] `MAIL_PORT`
- [ ] `MAIL_USERNAME`
- [ ] `MAIL_PASSWORD`
- [ ] `KEYCLOAK_ISSUER_URI`
- [ ] `FILE_UPLOAD_PATH`

### Verification
- [ ] Backend accessible via browser
- [ ] Swagger UI loads: `https://your-backend-url/api/v1/swagger-ui/index.html`
- [ ] No startup errors in logs
- [ ] Database tables created

---

## Frontend Deployment (Vercel)

### Setup
- [ ] Vercel account created
- [ ] Vercel CLI installed: `npm install -g vercel`
- [ ] Vercel logged in: `vercel login`

### Configuration
- [ ] Updated `src/environments/environment.prod.ts` with backend URL
- [ ] Changes committed and pushed to GitHub
- [ ] Project builds locally: `npm run build:prod`

### Deployment
- [ ] Frontend deployed: `vercel --prod`
- [ ] Frontend URL noted: `____________________________`
- [ ] Application loads in browser
- [ ] No console errors

---

## Keycloak Setup

### Deployment
- [ ] Keycloak instance deployed (Keycloak Cloud or Railway)
- [ ] Keycloak URL noted: `____________________________`
- [ ] Admin console accessible
- [ ] Keycloak admin credentials saved securely

### Configuration
- [ ] Realm imported/created: `book-social-network`
- [ ] Client created: `book-social-network-client`
- [ ] Valid Redirect URIs added:
  - [ ] `https://your-vercel-app.vercel.app/*`
  - [ ] `http://localhost:4200/*` (for local testing)
- [ ] Web Origins added:
  - [ ] `https://your-vercel-app.vercel.app`
  - [ ] `http://localhost:4200` (for local testing)
- [ ] Test user created

---

## Integration & Testing

### Backend-Frontend Connection
- [ ] CORS configured in Spring Boot for Vercel URL
- [ ] API calls from frontend work
- [ ] No CORS errors in browser console

### Keycloak Integration
- [ ] Backend issuer-uri matches Keycloak URL
- [ ] Frontend keycloakUrl matches Keycloak URL
- [ ] Authentication flow works

### Feature Testing
- [ ] User registration works
- [ ] Activation email received
- [ ] Email activation link works
- [ ] User login via Keycloak works
- [ ] Token validation works
- [ ] Logout works
- [ ] Protected routes require authentication

### Book Management
- [ ] Create book works
- [ ] Upload book cover works
- [ ] View book list works
- [ ] Update book works
- [ ] Archive book works
- [ ] Share book works
- [ ] Delete book works

### Book Borrowing
- [ ] Borrow book works
- [ ] Return book works
- [ ] Approve return works
- [ ] View borrowed books works
- [ ] View lending history works

---

## Post-Deployment

### Monitoring
- [ ] Railway/Render dashboard checked
- [ ] Logs reviewed for errors
- [ ] Response times acceptable
- [ ] Resource usage monitored

### Documentation
- [ ] Team notified of new URLs
- [ ] Production URLs documented
- [ ] Credentials stored securely
- [ ] Environment variables documented

### Optimization
- [ ] Consider custom domain for frontend
- [ ] Consider custom domain for backend
- [ ] Set up SSL (auto with Vercel/Railway)
- [ ] Consider CDN for static assets
- [ ] Consider cloud storage for uploads (S3/Cloudinary)

---

## Optional Enhancements

### CI/CD
- [ ] GitHub Actions configured
- [ ] Auto-deploy on push to main
- [ ] Automated tests run before deploy

### Monitoring & Analytics
- [ ] Error tracking setup (Sentry)
- [ ] Analytics setup (Google Analytics)
- [ ] Uptime monitoring (UptimeRobot)
- [ ] Performance monitoring

### Security
- [ ] Security headers configured
- [ ] Rate limiting enabled
- [ ] API key rotation scheduled
- [ ] Database backups configured
- [ ] Disaster recovery plan documented

---

## URLs & Credentials Reference

Fill this in as you complete deployment:

### Production URLs
```
Frontend:    https://_____________________________.vercel.app
Backend:     https://_____________________________.railway.app
API Docs:    https://_____________________________.railway.app/api/v1/swagger-ui/index.html
Keycloak:    https://_____________________________
```

### Platform Dashboards
```
Vercel:      https://vercel.com/dashboard
Railway:     https://railway.app/dashboard
Render:      https://dashboard.render.com
Keycloak:    https://your-keycloak-instance.com/admin
```

### Git Repository
```
GitHub:      https://github.com/sree-code/books-network-angular--spring
```

---

## Notes & Issues

Use this space to track any issues or notes during deployment:

```
Issue:
Solution:

Issue:
Solution:

Issue:
Solution:
```

---

## Sign-Off

- [ ] Deployment completed successfully
- [ ] All features tested and working
- [ ] Documentation updated
- [ ] Team notified

**Deployed by:** _________________
**Date:** _________________
**Production Release Version:** _________________

---

## Quick Commands Reference

```bash
# Build backend
cd book-network && ./mvnw clean package -DskipTests

# Build frontend
cd book-network-ui && npm run build:prod

# Deploy to Vercel
vercel --prod

# Deploy to Railway
railway up

# Check logs (Railway)
railway logs

# Check git status
git status

# Push to GitHub
git add . && git commit -m "message" && git push
```

---

**Good luck with your deployment!** 🚀

