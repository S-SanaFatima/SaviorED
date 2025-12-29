# Backend Connection Configuration

## ✅ **Live Backend URL Configured**

Your Flutter app is now connected to the live production backend!

### **Backend URL:**
```
https://saviored-backend-production.up.railway.app
```

### **Configuration File:**
- **File:** `lib/core/consts/app_consts.dart`
- **Updated:** Base URL changed from `http://localhost:5000` to production URL

---

## 📋 **All Endpoints Connected**

All API endpoints are automatically using the live backend URL:

### **Authentication Endpoints** ✅
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user
- `POST /api/auth/logout` - Logout

### **User Endpoints** ✅
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `GET /api/users/:id` - Get user by ID

### **Focus Session Endpoints** ✅
- `POST /api/focus-sessions` - Create focus session
- `GET /api/focus-sessions` - Get user's sessions
- `GET /api/focus-sessions/:id` - Get session by ID
- `PUT /api/focus-sessions/:id/update` - Update session
- `PUT /api/focus-sessions/:id/complete` - Complete session

### **Castle Endpoints** ✅
- `GET /api/castles/my-castle` - Get user's castle
- `PUT /api/castles/level-up` - Level up castle
- `GET /api/castles/:userId` - Get castle by user ID

### **Leaderboard Endpoints** ✅
- `GET /api/leaderboard/global` - Global leaderboard
- `GET /api/leaderboard/school` - School leaderboard

### **Treasure Chest Endpoints** ✅
- `GET /api/treasure-chests/my-chest` - Get user's chest
- `PUT /api/treasure-chests/update-progress` - Update progress
- `PUT /api/treasure-chests/claim` - Claim rewards

---

## 🔧 **How It Works**

1. **Base URL Configuration:**
   - All API calls use `AppConsts.baseUrl` as the base
   - Relative paths (e.g., `/api/auth/login`) are appended automatically

2. **API Service:**
   - `ApiService` singleton handles all HTTP requests
   - Automatically adds JWT token to Authorization header
   - Handles errors globally

3. **ViewModels:**
   - All viewmodels use `ApiService` for API calls
   - Automatic token management
   - Error handling included

---

## ⚠️ **Backend CORS Configuration**

Make sure your backend `.env` file has the correct `FRONTEND_URL`:

```env
FRONTEND_URL=https://your-flutter-app-domain.com
```

Or if testing locally:
```env
FRONTEND_URL=http://localhost:3000
```

**Note:** Railway backend should allow requests from your Flutter app domain.

---

## 🧪 **Testing the Connection**

### 1. Test Health Endpoint
```bash
curl https://saviored-backend-production.up.railway.app/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "SaviorED API is running"
}
```

### 2. Test from Flutter App
- Open the app
- Try to register/login
- Check if API calls are successful
- Monitor network requests in debug console

---

## 📱 **Current Configuration**

```dart
// lib/core/consts/app_consts.dart
static const String baseUrl = 'https://saviored-backend-production.up.railway.app';
```

All API calls will use this URL automatically:
- ✅ Authentication
- ✅ User management
- ✅ Focus sessions
- ✅ Castle system
- ✅ Leaderboard
- ✅ Treasure chests

---

## 🚀 **Ready to Use!**

Your Flutter app is now fully connected to the live production backend. All endpoints will automatically use the Railway backend URL.

**No additional configuration needed!** 🎉

