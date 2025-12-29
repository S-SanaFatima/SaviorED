# Simple script to get SHA-1 fingerprint
# Run from: SaviorED/Savior_ED/android

Write-Host "Getting SHA-1 fingerprint..." -ForegroundColor Cyan
Write-Host ""

# Clear JAVA_HOME if it's invalid
if ($env:JAVA_HOME -like "*jdk-*") {
    $env:JAVA_HOME = $null
    Write-Host "Cleared invalid JAVA_HOME" -ForegroundColor Yellow
}

# Try to find Java
$javaFound = $false

# Check Android Studio
$androidStudioPaths = @(
    "C:\Program Files\Android\Android Studio\jbr",
    "C:\Program Files\Android\Android Studio\jre"
)

foreach ($path in $androidStudioPaths) {
    if (Test-Path $path) {
        $env:JAVA_HOME = $path
        Write-Host "Using Java from Android Studio: $env:JAVA_HOME" -ForegroundColor Green
        $javaFound = $true
        break
    }
}

# Check Program Files\Java
if (-not $javaFound) {
    $javaDirs = Get-ChildItem "C:\Program Files\Java" -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer }
    foreach ($dir in $javaDirs) {
        if (Test-Path (Join-Path $dir.FullName "bin\java.exe")) {
            $env:JAVA_HOME = $dir.FullName
            Write-Host "Using Java from: $env:JAVA_HOME" -ForegroundColor Green
            $javaFound = $true
            break
        }
    }
}

# Check PATH
if (-not $javaFound) {
    try {
        $javaCmd = Get-Command java -ErrorAction Stop
        $javaDir = Split-Path (Split-Path $javaCmd.Path)
        if (Test-Path (Join-Path $javaDir "bin\java.exe")) {
            $env:JAVA_HOME = $javaDir
            Write-Host "Using Java from PATH: $env:JAVA_HOME" -ForegroundColor Green
            $javaFound = $true
        }
    } catch {
        # Java not in PATH
    }
}

if (-not $javaFound) {
    Write-Host "ERROR: Java not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Java JDK or Android Studio." -ForegroundColor Yellow
    Write-Host "Or manually set JAVA_HOME to your Java installation directory." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Running Gradle signing report..." -ForegroundColor Cyan
Write-Host ""

# Run gradlew
$output = .\gradlew.bat signingReport 2>&1

# Extract SHA1
$sha1Lines = $output | Select-String -Pattern "SHA1:"

if ($sha1Lines) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "SHA-1 FINGERPRINT FOUND:" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    
    foreach ($line in $sha1Lines) {
        $sha1 = ($line -split "SHA1:")[1].Trim()
        Write-Host "  $sha1" -ForegroundColor White -BackgroundColor DarkGreen
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Copy the SHA-1 above and use it in Google Cloud Console" -ForegroundColor Yellow
    Write-Host "Package name: com.example.savior_ed" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "SHA-1 not found in output. Showing full output:" -ForegroundColor Yellow
    Write-Host ""
    $output | Write-Host
}


