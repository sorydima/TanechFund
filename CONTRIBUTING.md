# Contributing to REChain®️ VC Lab

Thank you for your interest in contributing to REChain®️ VC Lab! This document provides guidelines and information for contributors.

## 🎯 How to Contribute

### Types of Contributions

We welcome several types of contributions:

- 🐛 **Bug Reports**: Help us identify and fix issues
- ✨ **Feature Requests**: Suggest new features or improvements
- 💻 **Code Contributions**: Submit code changes and improvements
- 📖 **Documentation**: Improve our documentation and guides
- 🎨 **Design**: Help with UI/UX improvements
- 🧪 **Testing**: Help us test the application

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.35.2 or higher
- Dart SDK 3.9.0 or higher
- Git
- Android Studio / VS Code
- Basic understanding of Flutter/Dart

### Development Setup

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/rechain-vc-lab.git
   cd rechain-vc-lab
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/rechain-vc-lab.git
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 📋 Development Guidelines

### Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use proper indentation (2 spaces)

### Architecture Guidelines

- Follow the existing provider pattern for state management
- Keep UI and business logic separated
- Use proper error handling
- Implement proper loading states
- Follow the existing folder structure

### Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

#### Examples:
```bash
feat(web4): add movement trajectory creation
fix(web3): resolve wallet connection issue
docs: update README with installation steps
style: format code according to dart guidelines
```

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Clear description** of the issue
2. **Steps to reproduce** the problem
3. **Expected behavior** vs actual behavior
4. **Screenshots** if applicable
5. **Environment details**:
   - Flutter version
   - Dart version
   - Platform (Android/iOS/Web)
   - Device/OS version

### Bug Report Template

```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
 - Flutter version: [e.g. 3.35.2]
 - Dart version: [e.g. 3.9.0]
 - Platform: [e.g. Android, iOS, Web]
 - OS version: [e.g. Android 14, iOS 17]

**Additional context**
Add any other context about the problem here.
```

## ✨ Feature Requests

When requesting features, please include:

1. **Clear description** of the feature
2. **Use case** and motivation
3. **Proposed solution** (if you have one)
4. **Alternatives considered**
5. **Additional context**

### Feature Request Template

```markdown
**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
```

## 💻 Code Contributions

### Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, well-documented code
   - Add tests if applicable
   - Update documentation if needed

3. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit your changes**
   ```bash
   git commit -m "feat: add your feature description"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Use the PR template
   - Link any related issues
   - Request reviews from maintainers

### Pull Request Template

```markdown
## Description
Brief description of the changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] I have tested these changes locally
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Writing Tests

- Write unit tests for business logic
- Write widget tests for UI components
- Aim for good test coverage
- Use descriptive test names
- Follow the AAA pattern (Arrange, Act, Assert)

## 📖 Documentation

### Documentation Guidelines

- Keep documentation up-to-date
- Use clear and concise language
- Include code examples where helpful
- Follow the existing documentation style
- Update README.md for significant changes

### Documentation Types

- **API Documentation**: Document public APIs
- **User Guides**: Help users understand features
- **Developer Guides**: Help contributors understand the codebase
- **Architecture Documentation**: Explain system design

## 🎨 Design Contributions

### UI/UX Guidelines

- Follow Material Design 3 principles
- Maintain consistency with existing design
- Consider accessibility requirements
- Test on different screen sizes
- Use the existing color scheme and theming

### Design Process

1. **Propose design changes** in an issue
2. **Create mockups** or wireframes
3. **Get feedback** from maintainers
4. **Implement changes** following the design
5. **Test thoroughly** on different devices

## 🔍 Code Review Process

### For Contributors

- Address all review comments
- Make requested changes
- Respond to feedback constructively
- Keep PRs focused and small
- Update documentation as needed

### For Reviewers

- Be constructive and helpful
- Focus on code quality and functionality
- Check for security issues
- Verify tests are adequate
- Ensure documentation is updated

## 🏷️ Issue Labels

We use the following labels to categorize issues:

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements or additions to documentation
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention is needed
- `priority: high`: High priority issue
- `priority: medium`: Medium priority issue
- `priority: low`: Low priority issue
- `web3`: Related to Web3 functionality
- `web4`: Related to Web4 movement features
- `web5`: Related to Web5 creation features
- `ui/ux`: User interface or user experience
- `performance`: Performance related
- `security`: Security related

## 📞 Getting Help

### Communication Channels

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For general questions and discussions
- **Pull Request Comments**: For code review discussions

### Getting Help

- Search existing issues and discussions first
- Provide clear and detailed information
- Be patient and respectful
- Follow the community guidelines

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

### Expected Behavior

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## 🎉 Recognition

Contributors will be recognized in:

- **README.md**: Listed as contributors
- **Release Notes**: Mentioned in relevant releases
- **GitHub**: Shown in the contributors section

## 📝 License

By contributing to REChain®️ VC Lab, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to REChain®️ VC Lab! 🚀
