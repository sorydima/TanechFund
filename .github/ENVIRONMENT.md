# Environment Configuration

This document describes the environment variables, secrets, and configuration files used throughout the REChain VC project. Proper configuration of these variables is essential for development, testing, staging, and production environments.

## 📋 Environment Variables Overview

### Required Variables

| Variable Name | Description | Default Value | Required |
|---------------|-------------|---------------|----------|
| `FLUTTER_ENV` | Environment mode (dev, staging, prod) | `dev` | No |
| `APP_NAME` | Application name | `REChain VC` | No |
| `APP_VERSION` | Application version | `1.0.0` | No |
| `API_BASE_URL` | Base URL for API endpoints | `https://api.rechain.vc` | Yes |
| `WEBSOCKET_URL` | WebSocket server URL | `wss://ws.rechain.vc` | Yes |
| `BLOCKCHAIN_RPC_URL` | Ethereum/Blockchain RPC endpoint | `https://mainnet.infura.io/v3/` | Yes |
| `FLUTTER_WEB_CANVASKIT_URL` | CanvasKit WASM URL for web builds | `https://unpkg.com/canvaskit-wasm` | No |

### Development Environment
```bash
# .env.development
FLUTTER_ENV=dev
API_BASE_URL=https://dev-api.rechain.vc
WEBSOCKET_URL=wss://dev-ws.rechain.vc
BLOCKCHAIN_RPC_URL=https://sepolia.infura.io/v3/YOUR_PROJECT_ID
LOG_LEVEL=debug
MOCK_API=true
ENABLE_ANALYTICS=false
```

### Staging Environment
```bash
# .env.staging
FLUTTER_ENV=staging
API_BASE_URL=https://staging-api.rechain.vc
WEBSOCKET_URL=wss://staging-ws.rechain.vc
BLOCKCHAIN_RPC_URL=https://sepolia.infura.io/v3/YOUR_PROJECT_ID
LOG_LEVEL=info
MOCK_API=false
ENABLE_ANALYTICS=true
```

### Production Environment
```bash
# .env.production
FLUTTER_ENV=prod
API_BASE_URL=https://api.rechain.vc
WEBSOCKET_URL=wss://ws.rechain.vc
BLOCKCHAIN_RPC_URL=https://mainnet.infura.io/v3/YOUR_PROJECT_ID
LOG_LEVEL=warn
MOCK_API=false
ENABLE_ANALYTICS=true
CRASH_REPORTING=true
```

## 🔐 GitHub Secrets Configuration

### Repository Secrets
Configure these secrets in your GitHub repository settings:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `API_KEY` | API authentication key | `sk_live_...` |
| `WEBSOCKET_TOKEN` | WebSocket authentication token | `ws_token_...` |
| `INFURA_PROJECT_ID` | Infura project ID for blockchain | `1234567890abcdef` |
| `SENTRY_DSN` | Sentry error tracking DSN | `https://...@sentry.io/...` |
| `FIREBASE_CONFIG` | Firebase configuration JSON | `{"apiKey": "...", ...}` |
| `GOOGLE_SERVICE_ACCOUNT` | Google service account for deployments | Base64 encoded JSON |
| `APPLE_TEAM_ID` | Apple Developer Team ID | `ABC123DEF4` |
| `APPLE_KEY_ID` | Apple signing key ID | `2X9R4HXF34` |
| `APPLE_ISSUER_ID` | Apple issuer ID | `69a6de7f-...` |
| `ANDROID_KEYSTORE_BASE64` | Android keystore file (base64) | Base64 encoded keystore |
| `ANDROID_KEYSTORE_PASSWORD` | Android keystore password | `keystore_password` |
| `ANDROID_KEY_ALIAS` | Android key alias | `upload` |
| `ANDROID_KEY_PASSWORD` | Android key password | `key_password` |

### Organization Secrets (if applicable)
- `ORG_DEPLOY_KEY` - Organization deployment key
- `ORG_FIREBASE_TOKEN` - Firebase deployment token
- `ORG_SLACK_WEBHOOK` - Slack notification webhook

## 🏗️ Platform-Specific Configuration

### Android Configuration
**File:** `android/app/build.gradle.kts`

```kotlin
android {
    defaultConfig {
        applicationId = "com.rechain.vc"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
        
        // Environment-specific configuration
        buildConfigField("String", "API_BASE_URL", "\"${project.findProperty("API_BASE_URL") ?: "https://dev-api.rechain.vc"}\"")
        buildConfigField("String", "WEBSOCKET_URL", "\"${project.findProperty("WEBSOCKET_URL") ?: "wss://dev-ws.rechain.vc"}\"")
        buildConfigField("boolean", "MOCK_API", "${project.findProperty("MOCK_API") ?: "true"}")
    }
}
```

**Signing Configuration:** `android/key.properties`
```properties
storeFile=../android_key.jks
storePassword=your_keystore_password
keyAlias=upload
keyPassword=your_key_password
```

### iOS Configuration
**File:** `ios/Runner/Info.plist`

```xml
<dict>
    <!-- Environment Configuration -->
    <key>API_BASE_URL</key>
    <string>$(API_BASE_URL)</string>
    <key>WEBSOCKET_URL</key>
    <string>$(WEBSOCKET_URL)</string>
    <key>MOCK_API</key>
    <true/>
    
    <!-- Capabilities -->
    <key>NSCameraUsageDescription</key>
    <string>Camera access for QR code scanning</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Location access for blockchain verification</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Photo library access for document verification</string>
</dict>
```

**Build Configuration:** `ios/Runner.xcconfig`
```xcconfig
// Environment Variables
API_BASE_URL = https://dev-api.rechain.vc
WEBSOCKET_URL = wss://dev-ws.rechain.vc
BLOCKCHAIN_RPC_URL = https://sepolia.infura.io/v3/YOUR_PROJECT_ID

// Signing
DEVELOPMENT_TEAM = ABC123DEF4
PROVISIONING_PROFILE_SPECIFIER = "REChain VC Development"
CODE_SIGN_STYLE = Automatic
```

### Web Configuration
**File:** `web/index.html`

```html
<script>
  // Environment configuration
  window.env = {
    API_BASE_URL: '${API_BASE_URL || 'https://dev-api.rechain.vc'}',
    WEBSOCKET_URL: '${WEBSOCKET_URL || 'wss://dev-ws.rechain.vc'}',
    BLOCKCHAIN_RPC_URL: '${BLOCKCHAIN_RPC_URL || 'https://sepolia.infura.io/v3/'}',
    MOCK_API: ${MOCK_API || 'true'},
    SENTRY_DSN: '${SENTRY_DSN || ''}',
    GA_TRACKING_ID: '${GA_TRACKING_ID || ''}'
  };
</script>
```

**Service Worker Configuration:** `web/sw.js`
```javascript
// Environment-aware service worker
const CACHE_NAME = 'rechain-vc-v1.0.0';
const API_BASE_URL = window.env?.API_BASE_URL || 'https://dev-api.rechain.vc';

// Cache configuration based on environment
const cacheConfig = {
  dev: {
    cacheFirst: ['/'],
    networkFirst: ['api/*', 'ws/*']
  },
  staging: {
    cacheFirst: ['/', '/assets/*'],
    networkFirst: ['api/*', 'ws/*']
  },
  prod: {
    cacheFirst: ['/', '/assets/*', '/lib/*'],
    networkFirst: ['api/*', 'ws/*']
  }
};
```

### Desktop Configuration (Windows/macOS/Linux)
**Windows:** `windows/config/app_config.h`
```cpp
#pragma once

// Environment configuration
namespace AppConfig {
    const char* API_BASE_URL = "https://dev-api.rechain.vc";
    const char* WEBSOCKET_URL = "wss://dev-ws.rechain.vc";
    const char* BLOCKCHAIN_RPC_URL = "https://sepolia.infura.io/v3/YOUR_PROJECT_ID";
    bool MOCK_API = true;
    bool ENABLE_CRASH_REPORTING = false;
}
```

**macOS:** `macos/Runner/Configs/AppInfo.xcconfig`
```xcconfig
API_BASE_URL = https://dev-api.rechain.vc
WEBSOCKET_URL = wss://dev-ws.rechain.vc
BLOCKCHAIN_RPC_URL = https://sepolia.infura.io/v3/YOUR_PROJECT_ID
MOCK_API = YES
ENABLE_ANALYTICS = NO
```

## 🔧 CI/CD Environment Variables

### GitHub Actions Secrets
These variables are available in workflows via `${{ secrets.VARIABLE_NAME }}`:

```yaml
# Example workflow usage
- name: Deploy to Production
  env:
    API_BASE_URL: ${{ secrets.API_BASE_URL }}
    WEBSOCKET_TOKEN: ${{ secrets.WEBSOCKET_TOKEN }}
    INFURA_PROJECT_ID: ${{ secrets.INFURA_PROJECT_ID }}
    SENTRY_DSN: ${{ secrets.SENTRY_DSN }}
  run: |
    flutter build --release
    # Deployment commands
```

### Workflow-Specific Variables
**CI Workflow (.github/workflows/ci.yml):**
```yaml
env:
  FLUTTER_VERSION: '3.13.0'
  DART_CHANNEL: 'stable'
  COVERAGE_THRESHOLD: '80'
  TIMEOUT_MINUTES: '10'
```

**Release Workflow (.github/workflows/release.yml):**
```yaml
env:
  TAG_PREFIX: 'v'
  CHANGELOG_GENERATOR: 'conventional-changelog'
  RELEASE_DRAFT: 'false'
  AUTO_PUBLISH: 'true'
```

## 🛡️ Security Best Practices

### Secret Management
1. **Never commit secrets** to version control
2. **Use GitHub Secrets** for CI/CD variables
3. **Rotate secrets regularly** (every 90 days)
4. **Use environment-specific secrets** when possible
5. **Enable secret scanning** in GitHub settings

### Environment Separation
- **Development:** Local `.env` files (gitignored)
- **CI/CD:** GitHub Secrets
- **Production:** Managed service configuration
- **Staging:** Separate secrets from production

### Access Control
- **Repository Secrets:** Available to all workflows
- **Environment Secrets:** Scoped to specific environments
- **Organization Secrets:** Shared across repositories
- **Limited Access:** Use `secrets: inherit` only when necessary

## 📱 Flutter-Specific Configuration

### pubspec.yaml Environment Support
```yaml
# Add environment_config package
dependencies:
  flutter:
    sdk: flutter
  environment_config: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

### Environment Config Usage
**lib/config/environment_config.dart:**
```dart
import 'package:environment_config/environment_config.dart';

class AppConfig {
  static final String apiBaseUrl = ConfigValue('API_BASE_URL').string();
  static final String websocketUrl = ConfigValue('WEBSOCKET_URL').string();
  static final bool mockApi = ConfigValue('MOCK_API').bool();
  static final String blockchainRpcUrl = ConfigValue('BLOCKCHAIN_RPC_URL').string();
  
  static Future<void> initialize() async {
    await Config.init(
      dotenvPath: '.env.${ConfigValue('FLUTTER_ENV').stringOr('dev')}',
    );
  }
}
```

### Build Configuration
**For different environments:**
```bash
# Development build
flutter build apk --dart-define=FLUTTER_ENV=dev --dart-define=API_BASE_URL=https://dev-api.rechain.vc

# Production build
flutter build apk --release --dart-define=FLUTTER_ENV=prod --dart-define=API_BASE_URL=https://api.rechain.vc

# Web build with environment
flutter build web --dart-define=FLUTTER_ENV=prod --dart-define=API_BASE_URL=https://api.rechain.vc
```

## 🌐 External Service Configuration

### Firebase Configuration
**firebase_options.json (gitignored):**
```json
{
  "apiKey": "AIzaSy...",
  "authDomain": "rechain-vc.firebaseapp.com",
  "projectId": "rechain-vc",
  "storageBucket": "rechain-vc.appspot.com",
  "messagingSenderId": "123456789",
  "appId": "1:123456789:web:abcdef123456"
}
```

### Sentry Configuration
**sentry.properties (gitignored):**
```properties
defaults.url=https://sentry.io/
defaults.org=your-org
defaults.project=your-project
auth.token=your_auth_token
```

### Google Analytics
**GA tracking configured via dart-define:**
```bash
flutter run --dart-define=GA_TRACKING_ID=GA_MEASUREMENT_ID
```

## 🧪 Testing Environment Variables

### Unit Tests
```dart
// test/config_test.dart
void main() {
  group('Environment Configuration', () {
    setUpAll(() async {
      await AppConfig.initialize();
    });
    
    test('API base URL is correct', () {
      expect(AppConfig.apiBaseUrl, equals('https://dev-api.rechain.vc'));
    });
    
    test('Mock API is enabled in dev', () {
      expect(AppConfig.mockApi, isTrue);
    });
  });
}
```

### Integration Tests
**integration_test/app_test.dart:**
```dart
// Use test environment variables
flutter test integration_test/ --dart-define=TESTING=true --dart-define=API_BASE_URL=https://test-api.rechain.vc
```

## 🚨 Troubleshooting

### Common Issues

1. **Missing Environment Variables**
   ```
   Error: Environment variable 'API_BASE_URL' not found
   Solution: Check .env file or GitHub secrets configuration
   ```

2. **Platform-Specific Build Failures**
   ```
   Android: Check ANDROID_KEYSTORE_* secrets
   iOS: Verify DEVELOPMENT_TEAM and provisioning profile
   Web: Ensure FLUTTER_WEB_CANVASKIT_URL is accessible
   ```

3. **CI/CD Failures**
   ```
   Check GitHub Actions logs for missing secrets
   Verify workflow permissions and access tokens
   Ensure environment-specific configurations match
   ```

### Debugging Commands
```bash
# Print all environment variables
flutter run --dart-define=DEBUG_ENV=true

# Validate configuration
dart run bin/validate_config.dart

# Check secret availability in CI
echo "API_BASE_URL is set: ${API_BASE_URL:+set}"
```

## 📚 Related Documentation

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Development setup and contribution guidelines
- **[WORKFLOW.md](WORKFLOW.md)** - CI/CD pipeline overview and configuration
- **[SECURITY.md](SECURITY.md)** - Security policies and vulnerability reporting
- **[.github/workflows/ci.yml](.github/workflows/ci.yml)** - Main CI workflow with environment usage
- **[pubspec.yaml](pubspec.yaml)** - Dependencies including environment_config package

## 🔄 Updating Environment Configuration

### Adding New Variables
1. **Update .env files** with new variables
2. **Add to GitHub Secrets** for CI/CD
3. **Update platform configurations** (build.gradle, Info.plist, etc.)
4. **Modify AppConfig class** to use new variables
5. **Update documentation** in this file
6. **Test all environments** after changes

### Rotating Secrets
1. **Generate new secret values**
2. **Update all environment files** (.env, GitHub secrets)
3. **Update external services** (Firebase, Infura, etc.)
4. **Test deployments** in staging environment
5. **Deploy to production** during maintenance window
6. **Remove old secrets** after verification

---

*Last updated: September 2024*

For questions about environment configuration, see [CONTRIBUTING.md](CONTRIBUTING.md) or create an issue using the [documentation template](.github/ISSUE_TEMPLATE/documentation.md).