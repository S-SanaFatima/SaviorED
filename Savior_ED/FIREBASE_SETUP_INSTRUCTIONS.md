# Firebase Analytics Setup Instructions

## ✅ What's Already Done

1. ✅ Firebase dependencies added to `pubspec.yaml`
2. ✅ Firebase Analytics service created
3. ✅ Firebase initialized in `main.dart`
4. ✅ Android Gradle files updated
5. ✅ Analytics tracking added to:
   - User login/signup
   - Focus session start/complete
   - Treasure chest opened
   - User ID tracking

## 📋 What You Need to Do

### Step 1: Create Firebase Project

1. Go to: https://console.firebase.google.com/
2. Click **"Add project"** or select existing project
3. Enter project name: `SaviorED` (or your preferred name)
4. Follow the setup wizard

### Step 2: Add Android App to Firebase

1. In Firebase Console, click **"Add app"** → Select **Android**
2. Enter:
   - **Package name:** `com.example.savior_ed`
   - **App nickname:** `Savior ED` (optional)
   - **Debug signing certificate SHA-1:** (paste from your `sha_keys.txt`)
3. Click **"Register app"**

### Step 3: Download `google-services.json`

1. After registering, download `google-services.json`
2. Place it in: `SaviorED/Savior_ED/android/app/google-services.json`
3. **Important:** This file must be in `android/app/` folder!

### Step 4: Install Dependencies

Run:
```bash
flutter pub get
```

### Step 5: Build and Test

```bash
flutter clean
flutter build apk --debug
```

## 📊 Analytics Events Being Tracked

- **login** - When user logs in (method: email/google)
- **sign_up** - When user registers (method: email)
- **focus_session_start** - When focus timer starts
- **focus_session_complete** - When focus session ends (with duration, coins, XP)
- **treasure_chest_opened** - When user claims treasure chest rewards

## 🔍 View Analytics

1. Go to Firebase Console
2. Navigate to **Analytics** → **Events**
3. Wait 24-48 hours for data to appear (or use DebugView for real-time)

## 🐛 Debug Mode (Optional)

To see events in real-time:

1. Enable debug mode:
   ```bash
   adb shell setprop debug.firebase.analytics.app com.example.savior_ed
   ```
2. View events in Firebase Console → Analytics → DebugView

## ⚠️ Important Notes

- **google-services.json** is required for Firebase to work
- Analytics data may take 24-48 hours to appear in reports
- Use DebugView for immediate testing
- Make sure SHA-1 fingerprint matches in both Firebase and Google Cloud Console

---

**That's it!** Once you add `google-services.json`, Firebase Analytics will start tracking automatically.

