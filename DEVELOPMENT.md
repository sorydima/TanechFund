# Development Guide - REChain VC Lab

## 🚀 Getting Started

### Prerequisites
- **Flutter**: 3.35.2 or higher
- **Dart**: 3.9.0 or higher
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Git**: Latest version
- **Platform-specific tools**:
  - **Android**: Android SDK 36+, Android Studio
  - **iOS**: Xcode 15+, macOS 12+
  - **Windows**: Visual Studio 2022, Windows 10 SDK
  - **macOS**: Xcode 15+, macOS 12+
  - **Linux**: GTK 3.0+, CMake 3.10+
  - **Web**: Chrome, Firefox, Safari, Edge

### Installation
```bash
# Clone the repository
git clone https://github.com/your-username/TanechFund.git
cd TanechFund

# Install dependencies
flutter pub get

# Run the application
flutter run
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Application entry point
├── providers/               # State management providers
│   ├── web3_provider.dart   # Web3 blockchain integration
│   ├── web4_movement_provider.dart  # Web4 Movement concepts
│   ├── web5_creation_provider.dart  # Web5 Creation concepts
│   └── ...
├── screens/                 # UI screens
│   ├── main_screen.dart     # Main navigation screen
│   ├── web4_movement_screen.dart  # Web4 Movement UI
│   ├── web5_creation_screen.dart  # Web5 Creation UI
│   └── ...
├── widgets/                 # Reusable UI components
│   ├── custom_button.dart
│   ├── custom_card.dart
│   └── ...
└── utils/                   # Utility functions
    └── constants.dart
```

## 🔧 Development Workflow

### 1. Setting Up Development Environment
```bash
# Check Flutter installation
flutter doctor

# Verify all platforms are supported
flutter doctor -v

# Install dependencies
flutter pub get

# Run tests
flutter test
```

### 2. Running the Application
```bash
# Run on connected device
flutter run

# Run on specific platform
flutter run -d windows
flutter run -d android
flutter run -d ios
flutter run -d web

# Run with hot reload
flutter run --hot

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

### 3. Building for Production
```bash
# Build for Android
flutter build apk --release
flutter build appbundle --release

# Build for iOS
flutter build ios --release

# Build for Windows
flutter build windows --release

# Build for macOS
flutter build macos --release

# Build for Linux
flutter build linux --release

# Build for Web
flutter build web --release
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Test Structure
```
test/
├── unit/                   # Unit tests
│   ├── providers/         # Provider tests
│   ├── utils/             # Utility tests
│   └── widgets/           # Widget tests
├── integration/           # Integration tests
│   └── app_test.dart
└── test_driver/           # Test driver
    └── app.dart
```

## 📱 Platform-Specific Development

### Android Development
```bash
# Check Android setup
flutter doctor --android-licenses

# Run on Android emulator
flutter run -d android

# Build Android APK
flutter build apk --release

# Build Android App Bundle
flutter build appbundle --release
```

### iOS Development
```bash
# Check iOS setup
flutter doctor --ios-licenses

# Run on iOS simulator
flutter run -d ios

# Build iOS app
flutter build ios --release
```

### Windows Development
```bash
# Check Windows setup
flutter doctor --windows-licenses

# Run on Windows
flutter run -d windows

# Build Windows app
flutter build windows --release
```

### Web Development
```bash
# Run web app locally
flutter run -d web-server --web-port 8080

# Build web app
flutter build web --release

# Serve web app
cd build/web
python -m http.server 8000
```

## 🔍 Debugging

### Flutter DevTools
```bash
# Launch DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Connect to running app
flutter run --debug
# Then open DevTools in browser
```

### Debugging Tips
1. **Use `print()` statements** for quick debugging
2. **Use `debugPrint()`** for better performance
3. **Use `assert()`** for development-time checks
4. **Use `flutter logs`** to view device logs
5. **Use breakpoints** in your IDE

### Common Debugging Commands
```bash
# View device logs
flutter logs

# Restart app
flutter run --hot

# Clean build
flutter clean
flutter pub get

# Check for issues
flutter analyze
flutter doctor
```

## 🚀 Performance Optimization

### Build Optimization
```bash
# Build with optimizations
flutter build web --release --no-tree-shake-icons
flutter build apk --release --split-per-abi
flutter build appbundle --release
```

### Code Optimization
1. **Use `const` constructors** where possible
2. **Avoid unnecessary rebuilds** with `const` widgets
3. **Use `ListView.builder`** for large lists
4. **Optimize images** and assets
5. **Use `flutter analyze`** to find issues

### Memory Optimization
1. **Dispose controllers** properly
2. **Use `AutomaticKeepAliveClientMixin`** for expensive widgets
3. **Implement `didUpdateWidget`** for state management
4. **Use `RepaintBoundary`** for complex widgets

## 📦 Dependencies

### Adding Dependencies
```bash
# Add dependency
flutter pub add package_name

# Add dev dependency
flutter pub add --dev package_name

# Add dependency with specific version
flutter pub add package_name:^1.0.0
```

### Managing Dependencies
```bash
# Update dependencies
flutter pub upgrade

# Check outdated dependencies
flutter pub outdated

# Get dependencies
flutter pub get

# Clean dependencies
flutter pub deps
```

## 🔧 Configuration

### Environment Variables
Create `.env` file in project root:
```env
# API Configuration
API_BASE_URL=https://api.rechain.network
API_KEY=your_api_key

# Blockchain Configuration
RPC_URL=https://mainnet.infura.io/v3/your_project_id
CHAIN_ID=1

# Feature Flags
ENABLE_WEB4=true
ENABLE_WEB5=true
ENABLE_ANALYTICS=false
```

### Build Configuration
Update `pubspec.yaml`:
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.35.0"

dependencies:
  flutter:
    sdk: flutter
  # ... other dependencies
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Flutter Doctor Issues
```bash
# Fix Android licenses
flutter doctor --android-licenses

# Fix iOS licenses
flutter doctor --ios-licenses

# Fix Windows licenses
flutter doctor --windows-licenses
```

#### 2. Build Issues
```bash
# Clean build
flutter clean
flutter pub get
flutter run

# Reset Flutter
flutter channel stable
flutter upgrade
flutter doctor
```

#### 3. Platform-Specific Issues
- **Android**: Check Android SDK, build tools, and licenses
- **iOS**: Check Xcode, iOS SDK, and certificates
- **Windows**: Check Visual Studio and Windows SDK
- **Web**: Check browser compatibility and CSP settings

### Getting Help
1. **Check Flutter documentation**: https://flutter.dev/docs
2. **Search existing issues**: https://github.com/your-username/TanechFund/issues
3. **Create new issue**: Use issue templates
4. **Join discussions**: Use GitHub Discussions
5. **Contact maintainers**: Check CONTRIBUTING.md

## 📚 Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [Web3 Dart Package](https://pub.dev/packages/web3dart)

### Tools
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Android Studio](https://developer.android.com/studio)
- [Xcode](https://developer.apple.com/xcode/)

### Community
- [Flutter Community](https://flutter.dev/community)
- [Dart Community](https://dart.dev/community)
- [GitHub Discussions](https://github.com/your-username/TanechFund/discussions)

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

**Happy Coding! 🚀**

*Last updated: $(date)*
*Version: 1.0.0*
