# Testing Guide - REChain VC Lab

## 🧪 Testing Strategy

This guide covers comprehensive testing strategies, best practices, and implementation for REChain VC Lab across all platforms and components.

## 📊 Testing Pyramid

### 1. Unit Tests (70%)
- **Purpose**: Test individual functions, methods, and classes
- **Scope**: Isolated components and business logic
- **Speed**: Fast execution (< 1ms per test)
- **Coverage**: High coverage of core functionality

### 2. Integration Tests (20%)
- **Purpose**: Test interactions between components
- **Scope**: Multiple components working together
- **Speed**: Medium execution (1-100ms per test)
- **Coverage**: Critical user flows and API integrations

### 3. End-to-End Tests (10%)
- **Purpose**: Test complete user journeys
- **Scope**: Full application workflows
- **Speed**: Slow execution (100ms+ per test)
- **Coverage**: Critical user scenarios

## 🔧 Unit Testing

### 1. Provider Testing

#### Testing State Management
```dart
// test/providers/web3_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/web3_provider.dart';

void main() {
  group('Web3Provider Tests', () {
    late Web3Provider provider;
    
    setUp(() {
      provider = Web3Provider();
    });
    
    test('should initialize with default values', () {
      expect(provider.isConnected, false);
      expect(provider.currentAddress, null);
      expect(provider.balance, '0');
    });
    
    test('should connect wallet successfully', () async {
      // Arrange
      const testAddress = '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6';
      
      // Act
      await provider.connectWallet(testAddress);
      
      // Assert
      expect(provider.isConnected, true);
      expect(provider.currentAddress, testAddress);
    });
    
    test('should update balance when connected', () async {
      // Arrange
      const testAddress = '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6';
      const testBalance = '1.234567890123456789';
      
      // Act
      await provider.connectWallet(testAddress);
      provider.updateBalance(testBalance);
      
      // Assert
      expect(provider.balance, testBalance);
    });
  });
}
```

#### Testing Business Logic
```dart
// test/providers/web4_movement_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/providers/web4_movement_provider.dart';

void main() {
  group('Web4MovementProvider Tests', () {
    late Web4MovementProvider provider;
    
    setUp(() {
      provider = Web4MovementProvider();
    });
    
    test('should create movement successfully', () {
      // Arrange
      const movementData = {
        'name': 'Test Movement',
        'type': 'social',
        'description': 'Test description',
      };
      
      // Act
      final result = provider.createMovement(movementData);
      
      // Assert
      expect(result, isNotNull);
      expect(result.name, 'Test Movement');
      expect(result.type, 'social');
    });
    
    test('should validate movement data', () {
      // Arrange
      const invalidData = {
        'name': '', // Empty name should be invalid
        'type': 'invalid_type',
      };
      
      // Act & Assert
      expect(() => provider.createMovement(invalidData), 
             throwsA(isA<ValidationException>()));
    });
  });
}
```

### 2. Widget Testing

#### Testing UI Components
```dart
// test/widgets/custom_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/widgets/custom_button.dart';

void main() {
  group('CustomButton Tests', () {
    testWidgets('should display button with correct text', (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Click Me';
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    
    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Click Me',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      
      // Assert
      expect(wasPressed, true);
    });
    
    testWidgets('should be disabled when onPressed is null', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled',
              onPressed: null,
            ),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      
      // Assert
      expect(find.byType(CustomButton), findsOneWidget);
      // Button should not respond to taps when disabled
    });
  });
}
```

#### Testing Screen Widgets
```dart
// test/screens/main_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/screens/main_screen.dart';
import 'package:rechain_vc_lab/providers/web3_provider.dart';

void main() {
  group('MainScreen Tests', () {
    testWidgets('should display all navigation items', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Web3Provider()),
          ],
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );
      
      // Act
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Web3 Tools'), findsOneWidget);
      expect(find.text('Web4 Movement'), findsOneWidget);
      expect(find.text('Web5 Creation'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
    
    testWidgets('should navigate to different screens', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Web3Provider()),
          ],
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );
      
      // Act
      await tester.pumpAndSettle();
      await tester.tap(find.text('Web4 Movement'));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Web4 Movement'), findsOneWidget);
      expect(find.text('Join Movement'), findsOneWidget);
    });
  });
}
```

### 3. Utility Testing

#### Testing Helper Functions
```dart
// test/utils/constants_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/utils/constants.dart';

void main() {
  group('Constants Tests', () {
    test('should have valid API endpoints', () {
      expect(Constants.apiBaseUrl, isNotEmpty);
      expect(Constants.apiBaseUrl, startsWith('https://'));
    });
    
    test('should have valid blockchain configurations', () {
      expect(Constants.supportedChains, isNotEmpty);
      expect(Constants.supportedChains, contains(1)); // Ethereum mainnet
      expect(Constants.supportedChains, contains(137)); // Polygon
    });
    
    test('should have valid app configuration', () {
      expect(Constants.appName, isNotEmpty);
      expect(Constants.appVersion, isNotEmpty);
      expect(Constants.appVersion, matches(RegExp(r'^\d+\.\d+\.\d+$')));
    });
  });
}
```

## 🔗 Integration Testing

### 1. API Integration Tests

#### Testing API Calls
```dart
// test/integration/api_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rechain_vc_lab/services/api_service.dart';

@GenerateMocks([http.Client])
void main() {
  group('API Integration Tests', () {
    late ApiService apiService;
    late MockClient mockClient;
    
    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });
    
    test('should fetch user balance successfully', () async {
      // Arrange
      const address = '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6';
      const expectedResponse = '''
      {
        "success": true,
        "data": {
          "address": "$address",
          "balance": "1.234567890123456789"
        }
      }
      ''';
      
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(expectedResponse, 200),
      );
      
      // Act
      final result = await apiService.getBalance(address);
      
      // Assert
      expect(result['success'], true);
      expect(result['data']['address'], address);
      expect(result['data']['balance'], '1.234567890123456789');
    });
    
    test('should handle API errors gracefully', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Server Error', 500),
      );
      
      // Act & Assert
      expect(() => apiService.getBalance('invalid_address'),
             throwsA(isA<ApiException>()));
    });
  });
}
```

### 2. Database Integration Tests

#### Testing Local Storage
```dart
// test/integration/storage_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

void main() {
  group('Storage Integration Tests', () {
    late StorageService storageService;
    
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = StorageService();
      await storageService.init();
    });
    
    test('should save and retrieve user preferences', () async {
      // Arrange
      const key = 'theme';
      const value = 'dark';
      
      // Act
      await storageService.setString(key, value);
      final retrievedValue = await storageService.getString(key);
      
      // Assert
      expect(retrievedValue, value);
    });
    
    test('should handle missing keys gracefully', () async {
      // Act
      final value = await storageService.getString('non_existent_key');
      
      // Assert
      expect(value, isNull);
    });
  });
}
```

### 3. Provider Integration Tests

#### Testing Provider Interactions
```dart
// test/integration/provider_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/web3_provider.dart';
import 'package:rechain_vc_lab/providers/web4_movement_provider.dart';

void main() {
  group('Provider Integration Tests', () {
    testWidgets('should sync data between providers', (WidgetTester tester) async {
      // Arrange
      final web3Provider = Web3Provider();
      final movementProvider = Web4MovementProvider();
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: web3Provider),
            ChangeNotifierProvider.value(value: movementProvider),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer2<Web3Provider, Web4MovementProvider>(
                builder: (context, web3, movement, child) {
                  return Text('Connected: ${web3.isConnected}');
                },
              ),
            ),
          ),
        ),
      );
      
      // Act
      await web3Provider.connectWallet('0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6');
      await tester.pump();
      
      // Assert
      expect(web3Provider.isConnected, true);
      expect(find.text('Connected: true'), findsOneWidget);
    });
  });
}
```

## 🎯 End-to-End Testing

### 1. User Journey Tests

#### Testing Complete Workflows
```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rechain_vc_lab/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('End-to-End Tests', () {
    testWidgets('complete user onboarding flow', (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();
      
      // Verify welcome screen
      expect(find.text('Welcome to REChain VC Lab'), findsOneWidget);
      
      // Tap get started button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      
      // Verify main screen
      expect(find.text('Web3 Tools'), findsOneWidget);
      expect(find.text('Web4 Movement'), findsOneWidget);
      expect(find.text('Web5 Creation'), findsOneWidget);
      
      // Navigate to Web4 Movement
      await tester.tap(find.text('Web4 Movement'));
      await tester.pumpAndSettle();
      
      // Verify Web4 screen
      expect(find.text('Join Movement'), findsOneWidget);
      expect(find.text('Create Movement'), findsOneWidget);
      
      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Verify back to main screen
      expect(find.text('Web3 Tools'), findsOneWidget);
    });
    
    testWidgets('wallet connection flow', (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to Web3 Tools
      await tester.tap(find.text('Web3 Tools'));
      await tester.pumpAndSettle();
      
      // Tap connect wallet
      await tester.tap(find.text('Connect Wallet'));
      await tester.pumpAndSettle();
      
      // Verify wallet connection dialog
      expect(find.text('Connect Your Wallet'), findsOneWidget);
      
      // Select wallet type
      await tester.tap(find.text('MetaMask'));
      await tester.pumpAndSettle();
      
      // Verify connection success
      expect(find.text('Wallet Connected'), findsOneWidget);
    });
  });
}
```

### 2. Platform-Specific Tests

#### Testing Android Features
```dart
// integration_test/android_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Android Specific Tests', () {
    testWidgets('should handle Android back button', (WidgetTester tester) async {
      // Test Android back button behavior
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/navigation',
        null,
        (data) {},
      );
      
      // Verify back button handling
      expect(find.byType(Scaffold), findsOneWidget);
    });
    
    testWidgets('should handle Android permissions', (WidgetTester tester) async {
      // Test permission handling
      // This would require platform-specific testing setup
    });
  });
}
```

#### Testing iOS Features
```dart
// integration_test/ios_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('iOS Specific Tests', () {
    testWidgets('should handle iOS gestures', (WidgetTester tester) async {
      // Test iOS-specific gestures
      await tester.drag(find.byType(Scaffold), Offset(0, -100));
      await tester.pumpAndSettle();
      
      // Verify gesture handling
    });
    
    testWidgets('should handle iOS safe area', (WidgetTester tester) async {
      // Test safe area handling
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
```

## 🚀 Performance Testing

### 1. Load Testing

#### Testing with Large Data Sets
```dart
// test/performance/load_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/providers/web4_movement_provider.dart';

void main() {
  group('Load Tests', () {
    test('should handle large movement lists', () {
      // Arrange
      final provider = Web4MovementProvider();
      final largeDataSet = List.generate(10000, (i) => {
        'name': 'Movement $i',
        'type': 'social',
        'description': 'Description for movement $i',
      });
      
      // Act
      final stopwatch = Stopwatch()..start();
      for (final data in largeDataSet) {
        provider.createMovement(data);
      }
      stopwatch.stop();
      
      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Should complete in under 5 seconds
      expect(provider.movements.length, equals(10000));
    });
    
    test('should handle concurrent API calls', () async {
      // Arrange
      final futures = <Future>[];
      
      // Act
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        futures.add(apiService.getData('endpoint_$i'));
      }
      await Future.wait(futures);
      stopwatch.stop();
      
      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(10000)); // Should complete in under 10 seconds
    });
  });
}
```

### 2. Memory Testing

#### Testing Memory Usage
```dart
// test/performance/memory_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'dart:developer' as developer;

void main() {
  group('Memory Tests', () {
    test('should not leak memory with repeated operations', () {
      // Arrange
      final provider = Web4MovementProvider();
      final initialMemory = _getMemoryUsage();
      
      // Act - Perform many operations
      for (int i = 0; i < 1000; i++) {
        provider.createMovement({
          'name': 'Movement $i',
          'type': 'social',
          'description': 'Description $i',
        });
        
        if (i % 100 == 0) {
          provider.clearMovements();
        }
      }
      
      // Force garbage collection
      developer.Timeline.startSync('gc');
      developer.Timeline.finishSync();
      
      final finalMemory = _getMemoryUsage();
      final memoryIncrease = finalMemory - initialMemory;
      
      // Assert
      expect(memoryIncrease, lessThan(10 * 1024 * 1024)); // Should not increase by more than 10MB
    });
  });
}

int _getMemoryUsage() {
  // This would need platform-specific implementation
  return 0;
}
```

## 🔧 Test Configuration

### 1. Test Setup

#### Test Configuration File
```dart
// test/test_config.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestConfig {
  static Future<void> setup() async {
    // Initialize mock services
    SharedPreferences.setMockInitialValues({});
    
    // Configure test environment
    TestWidgetsFlutterBinding.ensureInitialized();
  }
  
  static void tearDown() {
    // Clean up after tests
  }
}
```

#### Test Helper Functions
```dart
// test/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/web3_provider.dart';

Widget createTestApp(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Web3Provider()),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

Future<void> pumpAndSettle(WidgetTester tester) async {
  await tester.pump();
  await tester.pumpAndSettle();
}
```

### 2. Mock Services

#### API Service Mock
```dart
// test/mocks/api_service_mock.dart
import 'package:mockito/mockito.dart';
import 'package:rechain_vc_lab/services/api_service.dart';

class MockApiService extends Mock implements ApiService {
  @override
  Future<Map<String, dynamic>> getBalance(String address) async {
    return {
      'success': true,
      'data': {
        'address': address,
        'balance': '1.234567890123456789',
      },
    };
  }
  
  @override
  Future<Map<String, dynamic>> createMovement(Map<String, dynamic> data) async {
    return {
      'success': true,
      'data': {
        'id': 'mov_123456789',
        'name': data['name'],
        'type': data['type'],
        'description': data['description'],
      },
    };
  }
}
```

## 📊 Test Coverage

### 1. Coverage Configuration

#### Coverage Setup
```yaml
# coverage.yaml
coverage:
  exclude:
    - test/**
    - lib/main.dart
    - lib/generated/**
    - lib/l10n/**
```

#### Coverage Commands
```bash
# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# View coverage report
open coverage/html/index.html
```

### 2. Coverage Goals

#### Target Coverage
- **Overall Coverage**: > 80%
- **Unit Tests**: > 90%
- **Integration Tests**: > 70%
- **Critical Paths**: > 95%

#### Coverage Monitoring
```dart
// test/coverage/coverage_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Coverage Tests', () {
    test('should have adequate test coverage', () {
      // This would integrate with coverage tools
      // to verify coverage thresholds are met
    });
  });
}
```

## 🎯 Testing Best Practices

### 1. Test Organization
- **Group related tests** using `group()`
- **Use descriptive test names** that explain what is being tested
- **Follow AAA pattern**: Arrange, Act, Assert
- **Keep tests independent** and isolated
- **Use meaningful assertions** with clear error messages

### 2. Test Data
- **Use test fixtures** for consistent test data
- **Create test builders** for complex objects
- **Use factories** for object creation
- **Mock external dependencies** appropriately
- **Clean up test data** after each test

### 3. Test Maintenance
- **Update tests** when requirements change
- **Refactor tests** to improve readability
- **Remove obsolete tests** that are no longer relevant
- **Monitor test performance** and optimize slow tests
- **Review test coverage** regularly

---

**Testing is not just about finding bugs, it's about building confidence! 🧪**

*Last updated: 2024-09-04*
*Version: 1.0.0*
*Testing Guide Version: 1.0.0*
