#!/bin/bash

# REChain VC Lab - Codemagic-style Build Script
# This script mimics the Codemagic CI/CD build process locally

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Build configuration
FLUTTER_BUILD_MODE="release"
FLUTTER_WEB_RENDERER="auto"
BUILD_ID=$(date +%Y%m%d_%H%M%S)

echo -e "${BLUE}🚀 REChain VC Lab - Codemagic-style Build${NC}"
echo -e "${BLUE}Build ID: ${BUILD_ID}${NC}"
echo -e "${BLUE}Build Mode: ${FLUTTER_BUILD_MODE}${NC}"
echo -e "${BLUE}Web Renderer: ${FLUTTER_WEB_RENDERER}${NC}"
echo ""

# Function to print step
print_step() {
    echo -e "${YELLOW}📋 $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Flutter is installed
print_step "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

flutter --version
print_success "Flutter is available"

# Check Flutter doctor
print_step "Running Flutter doctor..."
flutter doctor
print_success "Flutter doctor completed"

# Set up local.properties for Android
print_step "Setting up local.properties..."
if [ -d "android" ]; then
    echo "flutter.sdk=$(which flutter | xargs dirname | xargs dirname)" > android/local.properties
    print_success "local.properties created"
else
    echo "No android directory found, skipping local.properties"
fi

# Get Flutter packages
print_step "Getting Flutter packages..."
flutter packages pub get
print_success "Flutter packages retrieved"

# Run Flutter analyze
print_step "Running Flutter analyze..."
flutter analyze
print_success "Flutter analyze completed"

# Run Flutter tests
print_step "Running Flutter tests..."
flutter test
print_success "Flutter tests completed"

# Build Web App
print_step "Building Flutter web app..."
if [ -f "web/index-codemagic.html" ]; then
    cp web/index-codemagic.html web/index.html
    echo "Using Codemagic-style index.html"
fi

flutter build web \
    --release \
    --no-tree-shake-icons \
    --dart-define=FLUTTER_WEB_RENDERER=${FLUTTER_WEB_RENDERER} \
    --base-href="/" \
    --web-renderer=auto

print_success "Web app built successfully"

# Build Android App Bundle (if Android is available)
if [ -d "android" ] && command -v java &> /dev/null; then
    print_step "Building Android App Bundle..."
    flutter build appbundle --release
    print_success "Android App Bundle built successfully"
    
    print_step "Building Android APK..."
    flutter build apk --release
    print_success "Android APK built successfully"
else
    echo "Skipping Android build (Android directory or Java not available)"
fi

# Build iOS App (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]] && [ -d "ios" ]; then
    print_step "Building iOS app..."
    flutter build ios --release --no-codesign
    print_success "iOS app built successfully"
else
    echo "Skipping iOS build (not on macOS or iOS directory not available)"
fi

# Build macOS App (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_step "Building macOS app..."
    flutter build macos --release
    print_success "macOS app built successfully"
else
    echo "Skipping macOS build (not on macOS)"
fi

# Build Windows App (if on Windows)
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    print_step "Building Windows app..."
    flutter build windows --release
    print_success "Windows app built successfully"
else
    echo "Skipping Windows build (not on Windows)"
fi

# Build Linux App (if on Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    print_step "Building Linux app..."
    flutter build linux --release
    print_success "Linux app built successfully"
else
    echo "Skipping Linux build (not on Linux)"
fi

# Prepare deployment files
print_step "Preparing deployment files..."

# Copy additional files for web deployment
if [ -f "web/.htaccess" ]; then
    cp web/.htaccess build/web/ 2>/dev/null || echo "No .htaccess file found"
fi

if [ -f "web/manifest.json" ]; then
    cp web/manifest.json build/web/ 2>/dev/null || echo "No manifest.json file found"
fi

# Create build info
cat > build/web/build-info.txt << EOF
Build Date: $(date)
Build ID: ${BUILD_ID}
Flutter Version: $(flutter --version | head -n 1)
Build Mode: ${FLUTTER_BUILD_MODE}
Web Renderer: ${FLUTTER_WEB_RENDERER}
Platform: $(uname -s)
Architecture: $(uname -m)
EOF

# Show build sizes
print_step "Build sizes:"
if [ -d "build/web" ]; then
    echo "Web build size: $(du -sh build/web/ | cut -f1)"
fi

if [ -d "build/app/outputs/bundle/release" ]; then
    echo "Android AAB size: $(du -sh build/app/outputs/bundle/release/*.aab | cut -f1)"
fi

if [ -d "build/app/outputs/flutter-apk" ]; then
    echo "Android APK size: $(du -sh build/app/outputs/flutter-apk/*.apk | cut -f1)"
fi

# Create archives
print_step "Creating build archives..."
cd build

if [ -d "web" ]; then
    tar -czf ../web-build-${BUILD_ID}.tar.gz web/
    echo "Web archive: web-build-${BUILD_ID}.tar.gz"
fi

if [ -d "app" ]; then
    tar -czf ../android-build-${BUILD_ID}.tar.gz app/
    echo "Android archive: android-build-${BUILD_ID}.tar.gz"
fi

cd ..

print_success "Build archives created"

# Final summary
echo ""
echo -e "${GREEN}🎉 Build completed successfully!${NC}"
echo -e "${GREEN}Build ID: ${BUILD_ID}${NC}"
echo ""
echo -e "${BLUE}📁 Build artifacts:${NC}"
echo "  - build/web/ (Web application)"
if [ -d "build/app/outputs/bundle/release" ]; then
    echo "  - build/app/outputs/bundle/release/*.aab (Android App Bundle)"
fi
if [ -d "build/app/outputs/flutter-apk" ]; then
    echo "  - build/app/outputs/flutter-apk/*.apk (Android APK)"
fi
if [ -d "build/ios" ]; then
    echo "  - build/ios/ (iOS application)"
fi
if [ -d "build/macos" ]; then
    echo "  - build/macos/ (macOS application)"
fi
if [ -d "build/windows" ]; then
    echo "  - build/windows/ (Windows application)"
fi
if [ -d "build/linux" ]; then
    echo "  - build/linux/ (Linux application)"
fi
echo ""
echo -e "${BLUE}📦 Archives:${NC}"
ls -la *-build-${BUILD_ID}.tar.gz 2>/dev/null || echo "No archives created"
echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo "  1. Test the web build locally: cd build/web && python -m http.server 8000"
echo "  2. Deploy to your hosting provider"
echo "  3. Upload Android AAB to Google Play Console"
echo "  4. Upload iOS IPA to App Store Connect"
echo ""
echo -e "${GREEN}✅ Codemagic-style build completed!${NC}"
