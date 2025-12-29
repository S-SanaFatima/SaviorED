
# Google Sign-In Setup Guide for Android

## Error: "Access blocked: This app's request is invalid"

This error occurs because the Android app's SHA-1 certificate fingerprint is not registered in Google Cloud Console.

---

## 🔧 **Solution: Configure Google OAuth for Android**

### Step 1: Get Your App's SHA-1 Fingerprint

#### Option A: Using Gradle (Recommended)

1. Open terminal/command prompt
2. Navigate to your Flutter project's Android directory:
   ```bash
   cd SaviorED/Savior_ED/android
   ```

3. For **debug keystore** (for testing):
   ```bash
   ./gradlew signingReport
   ```
   
   On Windows:
   ```bash
   gradlew signingReport
   ```

4. Look for the output under `Variant: debug` → `SHA1: ...`
   - Copy the SHA-1 fingerprint (it looks like: `A1:B2:C3:D4:E5:F6:...`)

#### Option B: Using Keytool (Direct Method)

For debug keystore:
```bash
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

For release keystore (if you have one):
```bash
keytool -list -v -keystore "path/to/your/keystore.jks" -alias your-key-alias
```

Copy the **SHA1** fingerprint from the output.

---

### Step 2: Get Your App's Package Name

Check your `android/app/build.gradle` or `build.gradle.kts` file:
- Look for `applicationId` or `namespace`
- It should be something like `com.example.savior_ed` or `com.yourcompany.saviored`

Or check `AndroidManifest.xml`:
- Look for `package="..."`

---

### Step 3: Create OAuth Client ID in Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)

2. Select your project (or create a new one)

3. Navigate to **APIs & Services** → **Credentials**

4. Click **+ CREATE CREDENTIALS** → **OAuth client ID**

5. If prompted, configure the OAuth consent screen:
   - User Type: **External** (for public users) or **Internal** (for organization only)
   - Fill in required fields:
     - App name: `SaviorED` (or your app name)
     - User support email: Your email
     - Developer contact: Your email
   - Click **SAVE AND CONTINUE**
   - Scopes: Click **SAVE AND CONTINUE** (default scopes are fine)
   - Test users: Add your email if testing with external users, then **SAVE AND CONTINUE**
   - Summary: Click **BACK TO DASHBOARD**

6. Create **OAuth client ID**:
   - Application type: Select **Android**
   - Name: `SaviorED Android` (or any name)
   - Package name: Enter your package name (from Step 2)
     - Example: `com.example.savior_ed`
   - SHA-1 certificate fingerprint: Paste the SHA-1 fingerprint (from Step 1)
   - Click **CREATE**

7. **IMPORTANT**: You should also create a **Web application** OAuth client:
   - Application type: **Web application**
   - Name: `SaviorED Web`
   - Authorized JavaScript origins: (optional for mobile, but recommended)
   - Authorized redirect URIs: (optional for mobile)
   - Click **CREATE**
   - Copy the **Client ID** - you may want to use this as `serverClientId` in the app

---

### Step 4: Verify Configuration

1. Go back to **Credentials** page
2. You should now see:
   - ✅ An **Android** OAuth client (with your package name and SHA-1)
   - ✅ A **Web application** OAuth client (optional, but recommended)

---

### Step 5: Test the Sign-In

1. **Uninstall and reinstall** your app (important - Google caches the OAuth configuration)
2. Run the app
3. Try Google Sign-In again
4. It should work now! ✅

---

## 🔍 **Troubleshooting**

### Still Getting the Error?

1. **Wait a few minutes** after adding SHA-1 in Google Cloud Console (changes can take 5-10 minutes to propagate)

2. **Uninstall and reinstall** the app completely

3. **Double-check**:
   - Package name matches exactly (case-sensitive)
   - SHA-1 fingerprint is correct (no spaces, correct format)
   - You're testing with the correct keystore (debug vs release)

4. **Check Google Cloud Console logs**:
   - Go to **APIs & Services** → **Dashboard**
   - Look for any error messages

5. **For Release Builds**: Make sure to add the **release keystore SHA-1** as well:
   - Get SHA-1 from your release keystore
   - Add another Android OAuth client with the release SHA-1

---

## 📝 **Additional Notes**

### Using serverClientId (Optional but Recommended)

If you want to use the web client ID for backend token verification, you can update the code:

```dart
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com', // From Step 3
);
```

However, this is **optional** - the app should work without it if the Android OAuth client is properly configured.

---

## ✅ **Quick Checklist**

- [ ] Got SHA-1 fingerprint from debug keystore
- [ ] Got package name from build.gradle
- [ ] Created Android OAuth client in Google Cloud Console
- [ ] Added SHA-1 fingerprint to Android OAuth client
- [ ] Added package name to Android OAuth client
- [ ] (Optional) Created Web OAuth client for backend
- [ ] Uninstalled and reinstalled the app
- [ ] Tested Google Sign-In

---

## 🆘 **Still Having Issues?**

If you're still encountering problems:

1. Check the exact error message in the app logs
2. Verify the OAuth consent screen is published (or you're using a test user)
3. Ensure you're using the correct Google account that has access to the OAuth client
4. Try clearing Google Play Services cache on your device
5. Check if your app's package name matches what's registered in Google Cloud Console

