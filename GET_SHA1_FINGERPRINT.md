# Quick Guide: Get SHA-1 Fingerprint for Google Sign-In

## Your App's Package Name
**Package Name:** `com.example.savior_ed`

(This is from `android/app/build.gradle.kts`)

---

## Get SHA-1 Fingerprint (Windows)

### Option 1: Using Keytool (Easiest)

Open **Command Prompt** or **PowerShell** and run:

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Or in Command Prompt:
```cmd
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Look for:**
```
SHA1: A1:B2:C3:D4:E5:F6:...
```
Copy the SHA1 value (the part after "SHA1: ")

---

### Option 2: Using Gradle

1. Open terminal/command prompt
2. Navigate to Android directory:
   ```bash
   cd SaviorED/Savior_ED/android
   ```
3. Run:
   ```bash
   gradlew signingReport
   ```
   (On Windows: `.\gradlew.bat signingReport` or just `gradlew signingReport`)

4. Look for output under `Variant: debug` → find `SHA1: ...`

---

## Next Steps

1. Copy the SHA-1 fingerprint
2. Go to [Google Cloud Console](https://console.cloud.google.com/)
3. Navigate to **APIs & Services** → **Credentials**
4. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
5. Select **Android** as application type
6. Enter:
   - **Package name:** `com.example.savior_ed`
   - **SHA-1 certificate fingerprint:** (paste the SHA-1 you copied)
7. Click **CREATE**
8. **Uninstall and reinstall** your app
9. Test Google Sign-In again ✅

---

**Full detailed guide:** See `GOOGLE_SIGNIN_SETUP.md`

