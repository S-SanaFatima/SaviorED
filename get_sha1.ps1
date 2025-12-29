# PowerShell script to get SHA-1 fingerprint
# Run this script: .\get_sha1.ps1

Write-Host "Searching for Java and keytool..." -ForegroundColor Cyan

# Try common Java installation paths
$javaPaths = @(
    "$env:JAVA_HOME\bin\keytool.exe",
    "C:\Program Files\Java\jdk-*\bin\keytool.exe",
    "C:\Program Files (x86)\Java\jdk-*\bin\keytool.exe",
    "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe",
    "C:\Program Files\Android\Android Studio\jre\bin\keytool.exe"
)

$keytoolPath = $null

# Check JAVA_HOME first
if ($env:JAVA_HOME) {
    $testPath = Join-Path $env:JAVA_HOME "bin\keytool.exe"
    if (Test-Path $testPath) {
        $keytoolPath = $testPath
        Write-Host "Found keytool in JAVA_HOME: $keytoolPath" -ForegroundColor Green
    }
}

# Search common Java locations
if (-not $keytoolPath) {
    Write-Host "Searching common Java installation paths..." -ForegroundColor Yellow
    $javaDirs = @(
        "C:\Program Files\Java",
        "C:\Program Files (x86)\Java",
        "C:\Program Files\Android\Android Studio\jbr",
        "C:\Program Files\Android\Android Studio\jre"
    )
    
    foreach ($dir in $javaDirs) {
        if (Test-Path $dir) {
            $keytool = Get-ChildItem -Path $dir -Filter "keytool.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($keytool) {
                $keytoolPath = $keytool.FullName
                Write-Host "Found keytool at: $keytoolPath" -ForegroundColor Green
                break
            }
        }
    }
}

# If still not found, try to find Java in PATH
if (-not $keytoolPath) {
    Write-Host "Checking PATH for Java..." -ForegroundColor Yellow
    try {
        $javaCmd = Get-Command java -ErrorAction Stop
        $javaDir = Split-Path (Split-Path $javaCmd.Path)
        $testKeytool = Join-Path $javaDir "bin\keytool.exe"
        if (Test-Path $testKeytool) {
            $keytoolPath = $testKeytool
            Write-Host "Found keytool via Java in PATH: $keytoolPath" -ForegroundColor Green
        }
    } catch {
        Write-Host "Java not found in PATH" -ForegroundColor Yellow
    }
}

if (-not $keytoolPath) {
    Write-Host "keytool not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install JDK or Android Studio, or add Java to your PATH." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Alternative: Use Gradle to get SHA-1:" -ForegroundColor Cyan
    Write-Host "  cd android" -ForegroundColor White
    Write-Host "  .\gradlew signingReport" -ForegroundColor White
    Write-Host ""
    exit 1
}

# Get the keystore path
$keystorePath = Join-Path $env:USERPROFILE ".android\debug.keystore"

if (-not (Test-Path $keystorePath)) {
    Write-Host "Debug keystore not found at: $keystorePath" -ForegroundColor Red
    Write-Host ""
    Write-Host "The debug keystore will be created automatically when you build your first Android app." -ForegroundColor Yellow
    Write-Host "Please build your Flutter app at least once, then run this script again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Getting SHA-1 fingerprint from debug keystore..." -ForegroundColor Cyan
Write-Host ""

# Run keytool
try {
    $output = & $keytoolPath -list -v -keystore $keystorePath -alias androiddebugkey -storepass android -keypass android 2>&1
    
    # Extract SHA1
    $sha1Line = $output | Select-String -Pattern "SHA1:"
    
    if ($sha1Line) {
        $sha1 = ($sha1Line -split "SHA1:")[1].Trim()
        Write-Host "SHA-1 Fingerprint Found!" -ForegroundColor Green
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host "  $sha1" -ForegroundColor White -BackgroundColor DarkGreen
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Copy the SHA-1 above and use it in Google Cloud Console" -ForegroundColor Yellow
        Write-Host ""
        
        # Also show MD5 and SHA256 for reference
        $md5Line = $output | Select-String -Pattern "MD5:"
        $sha256Line = $output | Select-String -Pattern "SHA256:"
        
        if ($md5Line) {
            $md5 = ($md5Line -split "MD5:")[1].Trim()
            Write-Host "MD5 (for reference): $md5" -ForegroundColor Gray
        }
        if ($sha256Line) {
            $sha256 = ($sha256Line -split "SHA256:")[1].Trim()
            Write-Host "SHA-256 (for reference): $sha256" -ForegroundColor Gray
        }
    } else {
        Write-Host "Could not extract SHA-1 from keytool output" -ForegroundColor Red
        Write-Host ""
        Write-Host "Full output:" -ForegroundColor Yellow
        $output | Write-Host
    }
} catch {
    Write-Host "Error running keytool: $_" -ForegroundColor Red
    exit 1
}

