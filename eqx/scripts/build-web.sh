#!/bin/bash

# 🚀 Local Build Script for Flutter Web
# Este script replica el proceso de CI/CD localmente

echo "🔍 Flutter Web Build Script"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Checking Flutter installation..."
flutter doctor

print_status "Getting Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    print_error "Failed to get dependencies"
    exit 1
fi

print_success "Dependencies downloaded successfully"

print_status "Analyzing Flutter code..."
flutter analyze

if [ $? -ne 0 ]; then
    print_warning "Code analysis found issues (continuing anyway)"
fi

print_status "Running Flutter tests..."
flutter test

if [ $? -ne 0 ]; then
    print_warning "Some tests failed (continuing anyway)"
fi

print_status "Enabling web support..."
flutter config --enable-web

print_status "Building Flutter web application..."
flutter build web \
    --release \
    --web-renderer canvaskit \
    --dart-define=FLUTTER_WEB_AUTO_DETECT=true \
    --base-href "/"

if [ $? -eq 0 ]; then
    print_success "Build completed successfully!"
    print_status "Build output available at: ./build/web/"
    print_status "To test locally, run: flutter run -d chrome"
    
    # Check if build directory exists and has content
    if [ -d "build/web" ] && [ "$(ls -A build/web)" ]; then
        print_success "Build directory contains files:"
        ls -la build/web/
    else
        print_error "Build directory is empty or doesn't exist"
        exit 1
    fi
else
    print_error "Build failed!"
    exit 1
fi

echo ""
print_success "🎉 All done! Your Flutter web app is ready for deployment."
echo ""
print_status "Next steps:"
echo "  1. Commit your changes to git"
echo "  2. Push to main branch"
echo "  3. GitHub Actions will automatically deploy to Vercel"
echo "  4. Check the Actions tab in your GitHub repository"
echo ""