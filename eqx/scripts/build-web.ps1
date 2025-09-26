# 🚀 Local Build Script for Flutter Web (PowerShell)
# Este script replica el proceso de CI/CD localmente

Write-Host "🔍 Flutter Web Build Script" -ForegroundColor Blue
Write-Host "==========================" -ForegroundColor Blue

function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if Flutter is installed
try {
    flutter --version | Out-Null
    Write-Success "Flutter is installed"
} catch {
    Write-Error "Flutter is not installed or not in PATH"
    exit 1
}

Write-Status "Checking Flutter installation..."
flutter doctor

Write-Status "Getting Flutter dependencies..."
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to get dependencies"
    exit 1
}

Write-Success "Dependencies downloaded successfully"

Write-Status "Analyzing Flutter code..."
flutter analyze

if ($LASTEXITCODE -ne 0) {
    Write-Warning "Code analysis found issues (continuing anyway)"
}

Write-Status "Running Flutter tests..."
flutter test

if ($LASTEXITCODE -ne 0) {
    Write-Warning "Some tests failed (continuing anyway)"
}

Write-Status "Enabling web support..."
flutter config --enable-web

Write-Status "Building Flutter web application..."
flutter build web --release --web-renderer canvaskit --dart-define=FLUTTER_WEB_AUTO_DETECT=true --base-href "/"

if ($LASTEXITCODE -eq 0) {
    Write-Success "Build completed successfully!"
    Write-Status "Build output available at: .\build\web\"
    Write-Status "To test locally, run: flutter run -d chrome"
    
    # Check if build directory exists and has content
    if (Test-Path "build\web" -PathType Container) {
        $files = Get-ChildItem "build\web"
        if ($files.Count -gt 0) {
            Write-Success "Build directory contains files:"
            Get-ChildItem "build\web" | Format-Table Name, Length, LastWriteTime
        } else {
            Write-Error "Build directory is empty"
            exit 1
        }
    } else {
        Write-Error "Build directory doesn't exist"
        exit 1
    }
} else {
    Write-Error "Build failed!"
    exit 1
}

Write-Host ""
Write-Success "🎉 All done! Your Flutter web app is ready for deployment."
Write-Host ""
Write-Status "Next steps:"
Write-Host "  1. Commit your changes to git"
Write-Host "  2. Push to main branch"
Write-Host "  3. GitHub Actions will automatically deploy to Vercel"
Write-Host "  4. Check the Actions tab in your GitHub repository"
Write-Host ""