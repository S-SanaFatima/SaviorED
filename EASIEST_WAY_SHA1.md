# Easiest Way to Get SHA-1 Fingerprint

Since you've already built the APK, here's the **easiest method**:

---

## ✅ Method 1: Use Android Studio (Recommended)

1. **Open Android Studio**
2. **Open your project:**
   - File → Open
   - Navigate to: `D:\DEVSYNX- Projects\SaviourED\SaviorED\Savior_ED`
3. **Wait for Gradle sync to complete**
4. **Open Gradle panel** (usually on the right side, or View → Tool Windows → Gradle)
5. **Navigate to:**
   - `Savior_ED` → `android` → `Tasks` → `android` → `signingReport`
6. **Double-click `signingReport`**
7. **Look at the bottom panel** (Run/Gradle output)
8. **Find the line:**
   ```
   SHA1: A1:B2:C3:D4:E5:F6:...
   ```
9. **Copy the SHA-1 value** (everything after "SHA1: ")

---

## ✅ Method 2: Use Flutter Command (If you have Flutter installed)

1. Open **Command Prompt** or **PowerShell**
2. Navigate to your project:
   ```cmd
   cd "D:\DEVSYNX- Projects\SaviourED\SaviorED\Savior_ED"
   ```
3. Run:
   ```cmd
   flutter build apk --debug
   ```
4. After build completes, the SHA-1 will be shown in the output, OR
5. Navigate to android folder:
   ```cmd
   cd android
   ```
6. If you have Java installed, run:
   ```cmd
   gradlew signingReport
   ```

---

## ✅ Method 3: Install Java and Run Script

1. **Download and install JDK:**
   - Go to: https://adoptium.net/
   - Download JDK 11 or 17 (LTS version)
   - Install it

2. **Set JAVA_HOME:**
   - Open System Properties → Environment Variables
   - Add new System Variable:
     - Name: `JAVA_HOME`
     - Value: `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot` (or wherever you installed it)
   - Add to PATH: `%JAVA_HOME%\bin`

3. **Restart your terminal/PowerShell**

4. **Run the script:**
   ```powershell
   cd "D:\DEVSYNX- Projects\SaviourED\SaviorED"
   cd "Savior_ED\android"
   ..\..\get_sha1_simple.ps1
   ```

---

## 🎯 Quick Answer

**If you have Android Studio installed** (which you likely do since you built the APK):
- Use **Method 1** - it's the easiest and most reliable!

**If you don't have Android Studio:**
- Install it (it includes Java), then use Method 1
- OR install JDK separately and use Method 3

---

## 📋 Once You Have SHA-1

1. Go to: https://console.cloud.google.com/
2. Navigate to: **APIs & Services** → **Credentials**
3. Click: **+ CREATE CREDENTIALS** → **OAuth client ID**
4. Select: **Android** (NOT Web application!)
5. Enter:
   - **Package name:** `com.example.savior_ed`
   - **SHA-1 certificate fingerprint:** (paste your SHA-1)
6. Click **CREATE**
7. **Uninstall and reinstall** your app
8. Try Google Sign-In again ✅


