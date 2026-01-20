# Flutter Firebase Setup and Test Script
# Run this script from the project root: SaviorED/Savior_ED

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flutter Firebase Setup & Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is available
$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue

if (-not $flutterCmd) {
    Write-Host "⚠️  Flutter not found in PATH" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Trying to find Flutter..." -ForegroundColor Cyan
    
    # Common Flutter installation paths
    $flutterPaths = @(
        "C:\flutter\bin",
        "$env:LOCALAPPDATA\flutter\bin",
        "$env:USERPROFILE\flutter\bin",
        "$env:ProgramFiles\flutter\bin",
        "$env:ProgramFiles(x86)\flutter\bin"
    )
    
    $flutterFound = $false
    foreach ($path in $flutterPaths) {
        if (Test-Path $path) {
            Write-Host "✅ Found Flutter at: $path" -ForegroundColor Green
            $env:PATH = "$path;$env:PATH"
            $flutterFound = $true
            break
        }
    }
    
    if (-not $flutterFound) {
        Write-Host ""
        Write-Host "❌ Flutter not found!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please do one of the following:" -ForegroundColor Yellow
        Write-Host "1. Install Flutter: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
        Write-Host "2. Add Flutter to PATH: Add Flutter\bin to your system PATH" -ForegroundColor White
        Write-Host "3. Use Android Studio Terminal (it has Flutter in PATH)" -ForegroundColor White
        Write-Host ""
        exit 1
    }
}

# Verify Flutter
Write-Host "✅ Flutter found!" -ForegroundColor Green
Write-Host ""
flutter --version
Write-Host ""

# Check project structure
Write-Host "Checking project setup..." -ForegroundColor Cyan

$checks = @{
    "pubspec.yaml" = Test-Path "pubspec.yaml"
    "google-services.json" = Test-Path "android\app\google-services.json"
    "android/app/build.gradle.kts" = Test-Path "android\app\build.gradle.kts"
}

$allGood = $true
foreach ($check in $checks.GetEnumerator()) {
    if ($check.Value) {
        Write-Host "  ✅ $($check.Key)" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $($check.Key) - MISSING!" -ForegroundColor Red
        $allGood = $false
    }
}

Write-Host ""

if (-not $allGood) {
    Write-Host "❌ Some files are missing. Please check the setup." -ForegroundColor Red
    exit 1
}

# Step 1: Clean
Write-Host "Step 1: Cleaning previous builds..." -ForegroundColor Cyan
flutter clean
Write-Host ""

# Step 2: Get dependencies
Write-Host "Step 2: Getting Flutter dependencies..." -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dependencies installed" -ForegroundColor Green
Write-Host ""

# Step 3: Analyze
Write-Host "Step 3: Analyzing code..." -ForegroundColor Cyan
flutter analyze
Write-Host ""

# Step 4: Build APK (Debug)
Write-Host "Step 4: Building debug APK..." -ForegroundColor Cyan
Write-Host "This may take a few minutes..." -ForegroundColor Yellow
flutter build apk --debug
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "APK Location: build\app\outputs\flutter-apk\app-debug.apk" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Install the APK on your device" -ForegroundColor White
Write-Host "2. Test Firebase Analytics in the app" -ForegroundColor White
Write-Host "3. Check Firebase Console → Analytics → DebugView (for real-time)" -ForegroundColor White
Write-Host ""

