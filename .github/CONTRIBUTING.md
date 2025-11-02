# Contributing to REChain VC Project

Thank you for considering contributing to our Flutter-based cross-platform application! We welcome contributions that improve the codebase, documentation, or user experience.

## Development Setup

### Prerequisites
- Flutter SDK (stable channel, version 3.10+)
- Dart (included with Flutter)
- Platform-specific tools:
  - Android: Android Studio, Android SDK
  - iOS: Xcode (macOS only)
  - Web: Chrome/Chromium
  - Desktop: CMake, Ninja (Linux)

### Getting Started
1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/rechain-vc.git`
3. Create a feature branch: `git checkout -b feature/your-feature`
4. Install dependencies: `flutter pub get`
5. Run the app: `flutter run`

## Coding Standards

### Flutter/Dart Guidelines
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Use `dart format` for code formatting
- Write unit tests for new features
- Keep functions under 50 lines when possible

### Platform-Specific Code
- Android changes in `/android/` directory
- iOS changes in `/ios/` directory  
- Web-specific code in `/web/`
- Desktop in respective platform directories

### Commit Messages
Use conventional commit format:
- `feat: add new feature`
- `fix: resolve bug`
- `docs: update documentation`
- `chore: miscellaneous changes`

## Testing

### Unit Tests
Run unit tests: `flutter test`
Ensure 80%+ code coverage

### Integration Tests
Run integration tests: `flutter test integration_test/`

### Platform Tests
Test on all target platforms:
- Android: `flutter run -d android`
- iOS: `flutter run -d ios`
- Web: `flutter run -d chrome`
- Desktop: `flutter run -d windows` (or macos/linux)

## Pull Request Guidelines

1. Ensure CI passes (linting, testing, building all platforms)
2. Reference related issues: `Fixes #123`
3. Keep PRs focused on single concern
4. Update documentation if needed

### Required Checks
- [ ] Code formatted with `dart format`
- [ ] All tests pass
- [ ] No linting errors
- [ ] Builds successfully on all platforms
- [ ] CHANGELOG.md updated (if applicable)

## Code Owners
See [.github/CODEOWNERS](CODEOWNERS) for directory-specific reviewers

## Reporting Issues
Use the [Bug Report template](ISSUE_TEMPLATE/bug_report.md) for bugs
Use the [Feature Request template](ISSUE_TEMPLATE/feature_request.md) for new features

## Security Issues
Report security vulnerabilities privately via [SECURITY.md](SECURITY.md)

## License
By contributing, you agree that your contributions will be licensed under the project's LICENSE file.