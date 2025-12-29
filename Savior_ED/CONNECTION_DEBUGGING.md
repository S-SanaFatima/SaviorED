# Connection Timeout Debugging Guide

## 🔧 **Changes Made to Fix Connection Issues**

### 1. **Increased Timeout Duration**
- Changed from 30 seconds to **60 seconds**
- Railway services may have cold starts that take time
- File: `lib/core/consts/app_consts.dart`

### 2. **Added Comprehensive Logging**
- Request logging: Shows URL, method, and data being sent
- Response logging: Shows status code and response data
- Error logging: Detailed error information
- File: `lib/core/services/api_service.dart`

### 3. **Improved Error Messages**
- More detailed error messages for users
- Specific guidance for different error types
- Shows backend URL in error messages
- File: `lib/core/features/authentication/viewmodels/auth_viewmodel.dart`

### 4. **Added LogInterceptor**
- Dio's built-in logging interceptor
- Shows full request/response details in console
- Helps debug network issues

---

## 🐛 **How to Debug Connection Issues**

### **Step 1: Check Console Logs**

When you try to sign up, check the Flutter console/logs. You should see:

```
🚀 API Request: POST https://saviored-backend-production.up.railway.app/api/auth/register
📦 Request Data: {email: ..., password: ..., name: ...}
🔗 Full URL: https://saviored-backend-production.up.railway.app/api/auth/register
```

**If you DON'T see these logs:**
- The request is not being sent
- Check if the button click is working
- Check if the form validation is passing

**If you DO see these logs but no response:**
- Network issue
- Backend is not responding
- Timeout is occurring

### **Step 2: Check Error Type**

Look for error logs like:
```
❌ API Error: DioExceptionType.connectionTimeout
❌ DioException during registration:
   Type: DioExceptionType.connectionError
   Message: ...
```

**Common Error Types:**
- `connectionTimeout` - Server took too long to respond
- `connectionError` - Cannot reach the server
- `receiveTimeout` - Server responded but took too long
- `sendTimeout` - Request took too long to send

### **Step 3: Test Backend Directly**

Test your backend URL in a browser or Postman:
```
GET https://saviored-backend-production.up.railway.app/health
```

**Expected Response:**
```json
{
  "status": "OK",
  "message": "SaviorED API is running"
}
```

### **Step 4: Check Railway Dashboard**

1. Go to Railway dashboard
2. Check if service is running (not sleeping)
3. Check deployment logs for errors
4. Verify environment variables are set
5. Check if MongoDB connection is working

---

## 🔍 **Common Issues and Solutions**

### **Issue 1: Request Not Being Sent**

**Symptoms:**
- No logs in console
- Loading indicator shows but nothing happens

**Solutions:**
- Check internet connection on device
- Check if form validation is passing
- Check if button is properly connected

### **Issue 2: Connection Timeout**

**Symptoms:**
- Logs show request being sent
- Error: "Connection timeout"
- No response from server

**Solutions:**
1. **Railway Cold Start:**
   - First request after inactivity may take 30-60 seconds
   - Wait and try again
   - Consider upgrading Railway plan

2. **Slow Network:**
   - Try on different network (WiFi vs Mobile data)
   - Check network speed

3. **Backend Overloaded:**
   - Check Railway metrics
   - Check backend logs for errors

### **Issue 3: Connection Refused**

**Symptoms:**
- Error: "Connection refused"
- Cannot reach server

**Solutions:**
1. **Backend Not Running:**
   - Check Railway dashboard
   - Restart the service if needed

2. **Wrong URL:**
   - Verify URL in `app_consts.dart`
   - Test URL in browser

3. **Network/Firewall:**
   - Check device firewall settings
   - Try different network

### **Issue 4: SSL/Certificate Issues**

**Symptoms:**
- SSL handshake errors
- Certificate validation errors

**Solutions:**
- Railway uses valid SSL certificates
- Check device date/time is correct
- For Android, may need network security config (usually not needed)

---

## 📱 **Testing Steps**

1. **Enable Logging:**
   - Run app in debug mode
   - Watch console for logs

2. **Try Sign Up:**
   - Fill in form
   - Click sign up
   - Watch console logs

3. **Check Logs:**
   - Look for request logs
   - Look for response/error logs
   - Note the error type

4. **Test Backend:**
   - Open backend URL in browser
   - Test `/health` endpoint
   - Verify it's responding

5. **Check Network:**
   - Try different network
   - Check internet connectivity
   - Test on emulator vs physical device

---

## 🚀 **Next Steps**

1. **Run the app** and try to sign up
2. **Check console logs** for detailed information
3. **Share the logs** if issue persists
4. **Test backend URL** in browser to verify it's accessible

---

## 📋 **What to Share if Issue Persists**

If the issue continues, please share:

1. **Console Logs:**
   - Copy all logs from when you click sign up
   - Look for lines starting with 🚀, ✅, or ❌

2. **Error Message:**
   - The exact error message shown to user
   - The error type from logs

3. **Backend Status:**
   - Can you access `/health` endpoint in browser?
   - What does Railway dashboard show?

4. **Network Info:**
   - Are you on WiFi or mobile data?
   - Can you access other websites?

---

**The app now has detailed logging. Try signing up again and check the console logs!**

