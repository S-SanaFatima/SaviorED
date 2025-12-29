# Connection Troubleshooting Guide

## 🔴 **Connection Refused Error - Solutions**

### **Issue:** "Connection refused" when trying to sign up/login

This error indicates the Flutter app cannot connect to your backend server.

---

## ✅ **Step 1: Verify Backend is Running**

### Test Backend Health Endpoint:
```bash
# In browser or Postman
GET https://saviored-backend-production.up.railway.app/health
```

**Expected Response:**
```json
{
  "status": "OK",
  "message": "SaviorED API is running"
}
```

### If Backend is Not Responding:
1. **Check Railway Dashboard:**
   - Go to your Railway project
   - Verify the service is running (not sleeping)
   - Check logs for errors

2. **Railway Free Tier:**
   - Services may sleep after inactivity
   - First request might take longer to wake up
   - Consider upgrading or using a keep-alive service

---

## ✅ **Step 2: Check Backend CORS Configuration**

Your backend `.env` file should have:

```env
FRONTEND_URL=*
```

Or for specific domains:
```env
FRONTEND_URL=https://your-app-domain.com,http://localhost:3000
```

**Update Backend CORS in `server.js`:**
```javascript
app.use(cors({
  origin: process.env.FRONTEND_URL || '*', // Allow all origins for mobile apps
  credentials: true,
}));
```

---

## ✅ **Step 3: Verify Backend URL in Flutter App**

**File:** `lib/core/consts/app_consts.dart`

```dart
static const String baseUrl = 'https://saviored-backend-production.up.railway.app';
```

**Make sure:**
- ✅ URL starts with `https://` (not `http://`)
- ✅ No trailing slash
- ✅ URL is correct (check Railway dashboard)

---

## ✅ **Step 4: Test Network Connectivity**

### From Your Device/Emulator:

1. **Test in Browser:**
   ```
   https://saviored-backend-production.up.railway.app/health
   ```

2. **Test with curl (if available):**
   ```bash
   curl https://saviored-backend-production.up.railway.app/health
   ```

3. **Check Internet Connection:**
   - Ensure device has internet access
   - Check firewall settings
   - Try on different network (mobile data vs WiFi)

---

## ✅ **Step 5: Check SSL Certificate**

Railway uses HTTPS with valid certificates. If you see SSL errors:

1. **For Android:**
   - Add network security config (usually not needed for Railway)
   - Check if device date/time is correct

2. **For iOS:**
   - iOS should trust Railway's certificate automatically
   - Check device date/time

---

## ✅ **Step 6: Enable Debug Logging**

Add this to see detailed error messages:

**In `api_service.dart`:**
```dart
onError: (error, handler) {
  print('API Error: ${error.type}');
  print('Error Message: ${error.message}');
  print('Response: ${error.response?.data}');
  // ... existing code
}
```

**In `auth_viewmodel.dart`:**
```dart
catch (e) {
  print('Auth Error: $e');
  print('Error Type: ${e.runtimeType}');
  // ... existing code
}
```

---

## 🔧 **Common Solutions**

### **Solution 1: Backend is Sleeping (Railway Free Tier)**
- **Fix:** Wait 30-60 seconds for first request
- **Better Fix:** Upgrade Railway plan or add keep-alive

### **Solution 2: Wrong Backend URL**
- **Fix:** Double-check URL in `app_consts.dart`
- **Verify:** Test URL in browser first

### **Solution 3: CORS Issues**
- **Fix:** Update backend CORS to allow all origins
- **For Mobile Apps:** CORS shouldn't be an issue, but check anyway

### **Solution 4: Network/Firewall**
- **Fix:** Try different network
- **Check:** Firewall blocking HTTPS connections

### **Solution 5: Backend Not Deployed**
- **Fix:** Deploy backend to Railway
- **Check:** Railway deployment logs

---

## 🧪 **Quick Test**

Run this in your Flutter app's debug console or add a test button:

```dart
// Test connection
final response = await ApiService().get('/health');
print('Backend Response: ${response.data}');
```

---

## 📱 **Mobile-Specific Issues**

### **Android:**
- Check `AndroidManifest.xml` for internet permission:
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  ```

### **iOS:**
- Check `Info.plist` for App Transport Security (usually not needed for HTTPS)

---

## 🚀 **If Still Not Working**

1. **Check Railway Logs:**
   - Go to Railway dashboard
   - View deployment logs
   - Check for errors

2. **Test Backend Directly:**
   - Use Postman or curl
   - Test all endpoints manually

3. **Check Backend Environment Variables:**
   - Verify `.env` is configured correctly
   - Check MongoDB connection
   - Verify JWT_SECRET is set

4. **Contact Support:**
   - Railway support for deployment issues
   - Check Railway status page

---

## ✅ **Expected Behavior After Fix**

Once fixed, you should see:
- ✅ Sign up works
- ✅ Login works
- ✅ No "connection refused" errors
- ✅ API calls succeed
- ✅ Data loads correctly

---

**Your backend URL:** `https://saviored-backend-production.up.railway.app`

**Test it now:** Open in browser to verify it's running!

