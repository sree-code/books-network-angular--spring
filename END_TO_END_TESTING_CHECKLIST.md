# 🧪 End-to-End Testing Checklist

## Before You Start
- [ ] Backend deployed on Render
- [ ] Frontend deployed on Vercel
- [ ] Database created and connected
- [ ] All environment variables set

**Backend URL**: _________________________________
**Frontend URL**: _________________________________

---

## Phase 1: Infrastructure Tests

### ✅ Backend Health
- [ ] Open: `https://your-backend.onrender.com/api/v1/swagger-ui/index.html`
- [ ] Swagger UI loads successfully
- [ ] All endpoints are visible
- [ ] No 500 errors on page load

### ✅ Frontend Loads
- [ ] Open: `https://your-frontend.vercel.app`
- [ ] Login/Register page appears
- [ ] No console errors (F12)
- [ ] No CORS errors
- [ ] Images and styles load correctly

### ✅ Database Connection
- [ ] Check Render logs: "Started BookNetworkApiApplication"
- [ ] No database connection errors
- [ ] Tables created (check with database client)

---

## Phase 2: User Registration Flow

### Test 1: User Registration
1. Navigate to Register page
2. Fill in form:
   - [ ] First Name: TestUser
   - [ ] Last Name: Demo
   - [ ] Email: test@example.com
   - [ ] Date of Birth: 01/01/2000
   - [ ] Password: Test123!@#
3. Click "Register"
4. **Expected**: Success message appears
5. **Check Backend Logs**: Look for "POST /api/v1/auth/register - 201"

**Status**: ⬜ Pass ⬜ Fail

**Notes**: _________________________________

---

### Test 2: Email Verification
1. Check email inbox (Gmail or Mailtrap)
2. **Expected**: Activation email received
3. Copy 6-digit activation code
4. Enter code on activation page
5. **Expected**: "Account activated successfully"
6. **Check Database**: Query `SELECT * FROM _user` - enabled should be `true`

**Status**: ⬜ Pass ⬜ Fail

**If email not received**:
- [ ] Check Render logs for email sending confirmation
- [ ] Verify MAIL_HOST, MAIL_USERNAME, MAIL_PASSWORD
- [ ] Check spam folder

---

### Test 3: Login (with Keycloak)
1. Navigate to Login page
2. Click "Sign In"
3. **Expected**: Redirected to Keycloak
4. Enter credentials
5. **Expected**: Redirected back to dashboard
6. **Check**: User name appears in header

**Status**: ⬜ Pass ⬜ Fail ⬜ Skipped (Keycloak not set up)

---

## Phase 3: Book Management

### Test 4: Create Book
1. Login to application
2. Navigate to "My Books"
3. Click "Add New Book"
4. Fill form:
   - [ ] Title: "Test Book Title"
   - [ ] Author: "Test Author"
   - [ ] ISBN: "978-0-123456-78-9"
   - [ ] Synopsis: "This is a test book"
   - [ ] Upload cover image (JPG/PNG)
5. Click "Save"
6. **Expected**: Book created successfully
7. **Check Backend Logs**: "POST /api/v1/books - 201"
8. **Check Database**: `SELECT * FROM book WHERE title = 'Test Book Title'`

**Status**: ⬜ Pass ⬜ Fail

**Notes**: _________________________________

---

### Test 5: View Books
1. Go to "Browse Books" or "All Books"
2. **Expected**: List of books appears
3. **Expected**: Your test book is visible
4. Click on book
5. **Expected**: Book details load
6. **Expected**: Book cover image displays

**Status**: ⬜ Pass ⬜ Fail

---

### Test 6: Update Book
1. Go to "My Books"
2. Click "Edit" on test book
3. Change title to "Updated Test Book"
4. Click "Save"
5. **Expected**: Success message
6. **Expected**: Updated title shows in list
7. **Check Database**: Title should be updated

**Status**: ⬜ Pass ⬜ Fail

---

### Test 7: Share Book
1. Go to "My Books"
2. Toggle "Shareable" switch on test book
3. **Expected**: Book marked as shareable
4. **Check**: Book appears in public listings
5. **Check Database**: `shareable = true`

**Status**: ⬜ Pass ⬜ Fail

---

### Test 8: Archive Book
1. Go to "My Books"
2. Click "Archive" on test book
3. **Expected**: Book moved to archived
4. **Expected**: Book not visible in public listings
5. **Check Database**: `archived = true`

**Status**: ⬜ Pass ⬜ Fail

---

## Phase 4: Book Borrowing

### Test 9: Borrow a Book
**Requires 2 users**:
1. User A creates and shares a book
2. User B browses books
3. User B clicks "Borrow" on User A's book
4. **Expected**: Book marked as borrowed
5. **Expected**: Appears in User B's "Borrowed Books"
6. **Check Database**: Entry in `book_transaction_history`

**Status**: ⬜ Pass ⬜ Fail ⬜ Skipped

---

### Test 10: Return a Book
1. User B goes to "Borrowed Books"
2. Click "Return" on borrowed book
3. **Expected**: Return request sent
4. User A receives notification
5. User A approves return
6. **Expected**: Book returned successfully
7. **Check Database**: Transaction completed

**Status**: ⬜ Pass ⬜ Fail ⬜ Skipped

---

## Phase 5: Feedback System

### Test 11: Give Feedback
1. After borrowing a book
2. Navigate to book details
3. Click "Add Feedback"
4. Rate: 4.5 stars
5. Comment: "Great book!"
6. Submit
7. **Expected**: Feedback saved
8. **Expected**: Feedback appears on book page
9. **Check Database**: Entry in `feedback` table

**Status**: ⬜ Pass ⬜ Fail ⬜ Skipped

---

## Phase 6: File Upload

### Test 12: Book Cover Upload
1. Create/Edit book
2. Click "Upload Cover"
3. Select image (JPG, < 5MB)
4. **Expected**: Upload progress shows
5. **Expected**: Image preview appears
6. Save book
7. **Expected**: Cover displays on book list
8. **Check Backend Logs**: "File saved to: /tmp/uploads/..."

**Status**: ⬜ Pass ⬜ Fail

**Known Issue**: Files in /tmp are ephemeral on free tier
**Solution**: Use Cloudinary or S3 for production

---

## Phase 7: Performance Tests

### Test 13: Page Load Times
Measure with browser DevTools (Network tab):

- [ ] Frontend homepage: _____ ms (Target: < 2s)
- [ ] Backend Swagger UI: _____ ms (Target: < 3s)
- [ ] Book list page: _____ ms (Target: < 2s)
- [ ] Book details page: _____ ms (Target: < 1.5s)

**Notes**: First request after sleep may take 30-60s on free tier

---

### Test 14: API Response Times
Test individual endpoints via Swagger:

- [ ] GET /api/v1/books: _____ ms (Target: < 1s)
- [ ] POST /api/v1/books: _____ ms (Target: < 2s)
- [ ] GET /api/v1/feedbacks: _____ ms (Target: < 1s)

**Status**: ⬜ Acceptable ⬜ Needs Optimization

---

## Phase 8: Error Handling

### Test 15: Invalid Registration
1. Try registering with:
   - [ ] Empty email → Error message shown
   - [ ] Invalid email format → Error message shown
   - [ ] Short password → Error message shown
   - [ ] Duplicate email → Error message shown
2. **Expected**: Proper error messages, no crashes

**Status**: ⬜ Pass ⬜ Fail

---

### Test 16: Unauthorized Access
1. Logout
2. Try accessing protected routes directly:
   - [ ] /books/my-books → Redirected to login
   - [ ] /books/create → Redirected to login
3. **Expected**: No unauthorized access

**Status**: ⬜ Pass ⬜ Fail

---

### Test 17: Invalid File Upload
1. Try uploading:
   - [ ] File > 50MB → Error message
   - [ ] PDF file as book cover → Error or rejection
   - [ ] No file selected → Proper validation
2. **Expected**: Proper error handling

**Status**: ⬜ Pass ⬜ Fail

---

## Phase 9: Database Verification

### Test 18: Data Persistence
1. Create a book
2. Logout
3. Clear browser cache
4. Login again
5. **Expected**: Book still exists
6. **Check Database**: Record persists

**Status**: ⬜ Pass ⬜ Fail

---

### Test 19: Database Tables
Connect to PostgreSQL and verify tables exist:

```sql
-- Check tables
\dt

-- Verify user table
SELECT count(*) FROM _user;

-- Verify book table  
SELECT count(*) FROM book;

-- Verify relationships
SELECT * FROM book WHERE owner_id IS NOT NULL;
```

**Expected Tables**:
- [ ] _user
- [ ] book
- [ ] role
- [ ] token
- [ ] feedback
- [ ] book_transaction_history

**Status**: ⬜ All Present ⬜ Missing Tables

---

## Phase 10: Security Tests

### Test 20: CORS Security
1. Open browser console
2. Navigate through app
3. **Expected**: No CORS errors
4. **Check**: Only Vercel URL is allowed

**Status**: ⬜ Pass ⬜ Fail

---

### Test 21: Password Security
1. Register a user
2. Check database:
   ```sql
   SELECT password FROM _user WHERE email = 'test@example.com';
   ```
3. **Expected**: Password is hashed (bcrypt)
4. **Expected**: Cannot see plain text password

**Status**: ⬜ Pass ⬜ Fail

---

### Test 22: Token Security
1. Login and get JWT token
2. Copy token from browser storage
3. Try using expired/invalid token
4. **Expected**: 401 Unauthorized
5. **Expected**: Proper token validation

**Status**: ⬜ Pass ⬜ Fail ⬜ Skipped

---

## Phase 11: Monitoring

### Test 23: Check Render Logs
1. Go to Render Dashboard → Logs
2. Look for:
   - [ ] No ERROR level logs (or minimal)
   - [ ] Successful requests logged
   - [ ] Database queries logged (if enabled)
   - [ ] Email sending confirmations

**Status**: ⬜ Clean ⬜ Has Errors

**Errors Found**: _________________________________

---

### Test 24: Resource Usage
1. Render Dashboard → Metrics
2. Check:
   - [ ] CPU usage: _____ % (Free tier: < 50% avg)
   - [ ] Memory usage: _____ MB (Free tier: < 450MB)
   - [ ] Request count: _____

**Status**: ⬜ Within Limits ⬜ Exceeding

---

## Phase 12: Multi-User Testing

### Test 25: Concurrent Users
1. Open app in 2 different browsers
2. Login as User A in Browser 1
3. Login as User B in Browser 2
4. User A creates a book
5. User B should see the book (if shared)
6. Test simultaneous actions

**Status**: ⬜ Pass ⬜ Fail ⬜ Skipped

---

## Phase 13: Mobile Responsiveness

### Test 26: Mobile View
1. Open browser DevTools
2. Switch to mobile view (iPhone/Android)
3. Test:
   - [ ] Login page renders correctly
   - [ ] Book list scrolls properly
   - [ ] Images scale correctly
   - [ ] Forms are usable
   - [ ] Buttons are clickable

**Status**: ⬜ Pass ⬜ Needs Work

---

## Phase 14: Email Testing

### Test 27: Email Formatting
1. Register a new user
2. Check activation email:
   - [ ] Subject line is appropriate
   - [ ] Email body is formatted
   - [ ] Activation code is visible
   - [ ] No broken HTML
   - [ ] Links work (if any)

**Status**: ⬜ Pass ⬜ Fail

---

## Summary

### Overall Results

**Total Tests**: 27
**Passed**: _____ 
**Failed**: _____
**Skipped**: _____

### Critical Issues Found
1. _________________________________
2. _________________________________
3. _________________________________

### Minor Issues Found
1. _________________________________
2. _________________________________
3. _________________________________

### Performance Notes
_________________________________
_________________________________

### Recommended Actions
- [ ] Fix critical issues before launch
- [ ] Document known limitations
- [ ] Set up monitoring
- [ ] Create backup strategy
- [ ] Plan for scaling

---

## Sign-Off

- [ ] All critical features working
- [ ] Performance acceptable
- [ ] Security measures in place
- [ ] Documentation updated
- [ ] Ready for production use

**Tested By**: _________________
**Date**: _________________
**Environment**: Production
**Backend**: https://_________________
**Frontend**: https://_________________

---

## Notes for Future Testing

_________________________________
_________________________________
_________________________________

---

**Testing Complete!** Use this checklist every time you deploy or make major changes. 🎉

