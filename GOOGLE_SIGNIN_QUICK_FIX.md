# Quick Fix: Google Sign-In "redirect_uri_mismatch" Error

## 🔴 The Problem

You're seeing: **"Error 400: redirect_uri_mismatch"**

This happens because:
1. Native Google Sign-In is failing (SHA-1 not configured)
2. App falls back to web OAuth flow
3. Web OAuth requires redirect URIs that aren't configured

## ✅ The Solution

**You need to configure Android OAuth client in Google Cloud Console** (NOT web OAuth).

---

## 🚀 Quick Steps (5 minutes)

### Step 1: Get SHA-1 Fingerprint

Open **Command Prompt** or **PowerShell** and run:

```cmd
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Copy the SHA1 value** (looks like: `A1:B2:C3:D4:E5:F6:...`)

---

### Step 2: Configure Google Cloud Console

1. Go to: https://console.cloud.google.com/
2. Select your project (or create one)
3. Navigate to: **APIs & Services** → **Credentials**
4. Click: **+ CREATE CREDENTIALS** → **OAuth client ID**

5. **If prompted**, configure OAuth consent screen:
   - User Type: **External**
   - App name: `SaviorED`
   - User support email: (your email)
   - Developer contact: (your email)
   - Click **SAVE AND CONTINUE** through all steps

6. **Create Android OAuth Client:**
   - Application type: **Android** ⚠️ (NOT Web application!)
   - Name: `SaviorED Android`
   - Package name: `com.example.savior_ed`
   - SHA-1 certificate fingerprint: (paste the SHA-1 you copied)
   - Click **CREATE**

---

### Step 3: Test

1. **Uninstall** your app completely
2. **Reinstall** the app
3. Try Google Sign-In again ✅

---

## ⚠️ Important Notes

- **DO NOT** create a Web application OAuth client for this
- **DO** create an Android OAuth client
- The package name must match exactly: `com.example.savior_ed`
- SHA-1 must be from your debug keystore (for testing)
- Changes may take 5-10 minutes to propagate

---

## 🔍 Still Not Working?

1. **Wait 5-10 minutes** after adding SHA-1
2. **Uninstall and reinstall** the app
3. **Check** that you created an **Android** OAuth client (not Web)
4. **Verify** package name matches: `com.example.savior_ed`
5. **Double-check** SHA-1 fingerprint is correct

---

## 📚 Full Documentation

See `GOOGLE_SIGNIN_SETUP.md` for detailed instructions.

