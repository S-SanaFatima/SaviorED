# Manual Instructions: Get SHA-1 Fingerprint

Since `keytool` is not in your PATH, here are alternative methods:


## Method 1: Using Android Studio (Easiest)

1. Open **Android Studio**
2. Open your project: `SaviorED/Savior_ED`
3. In the **Gradle** panel (right side), expand:
   - `Savior_ED` → `android` → `Tasks` → `android` → `signingReport`
4. Double-click **signingReport**
5. Look at the **Run** output at the bottom
6. Find the line that says `SHA1: ...` under `Variant: debug`
7. Copy the SHA-1 value

---

## Method 2: Using Flutter Command

1. Open **Command Prompt** or **PowerShell**
2. Navigate to your project:
   ```cmd
   cd "D:\DEVSYNX- Projects\SaviourED\SaviorED\Savior_ED"
   ```
3. Run:
   ```cmd
   flutter build apk --debug
   ```
4. Then navigate to Android folder:
   ```cmd
   cd android
   ```
5. Run:
   ```cmd
      cd android
   gradlew signingReport
   ```
6. Look for `SHA1: ...` in the output

---

## Method 3: Find Java/Keytool Manually

1. **If you have Android Studio installed:**
   - Look for keytool at:
     - `C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe`
     - `C:\Program Files\Android\Android Studio\jre\bin\keytool.exe`

2. **If you have JDK installed:**
   - Look for keytool at:
     - `C:\Program Files\Java\jdk-*\bin\keytool.exe`
     - `C:\Program Files (x86)\Java\jdk-*\bin\keytool.exe`

3. **Once you find keytool, run:**
   ```cmd
   "FULL_PATH_TO_KEYTOOL" -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
   ```

4. **Look for the line:**
   ```
   SHA1: A1:B2:C3:D4:E5:F6:...
   ```

---

## Method 4: Use the PowerShell Script (After Installing Java)

1. Install **JDK** or **Android Studio** (which includes Java)
2. Add Java to your PATH, OR
3. Set JAVA_HOME environment variable
4. Run the script:
   ```powershell
   .\get_sha1.ps1
   ```

---

## Quick Check: Do You Have the Debug Keystore?

The debug keystore is created automatically when you build your first Android app.

**Check if it exists:**
```cmd
dir "%USERPROFILE%\.android\debug.keystore"
```

**If it doesn't exist:**
1. Build your Flutter app at least once:
   ```cmd
   flutter build apk --debug
   ```
2. Then try getting SHA-1 again

---

## What to Do With SHA-1

Once you have the SHA-1 fingerprint:

1. Go to: https://console.cloud.google.com/
2. Navigate to: **APIs & Services** → **Credentials**
3. Click: **+ CREATE CREDENTIALS** → **OAuth client ID**
4. Select: **Android**
5. Enter:
   - **Package name:** `com.example.savior_ed`
   - **SHA-1 certificate fingerprint:** (paste your SHA-1)
6. Click **CREATE**

---

## Need Help?

If you're still having trouble:
- Make sure you've built your Flutter app at least once
- Install Android Studio (it includes Java/keytool)
- Or install JDK separately and add it to PATH

