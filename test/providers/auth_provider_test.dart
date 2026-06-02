import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthProvider', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    tearDown(() {
      authProvider.dispose();
    });

    group('Initial state', () {
      test('should have isLoading false after initialization', () {
        // Note: AuthProvider loads state async, so we check after a brief delay
        expect(authProvider.isLoading, false);
      });

      test('should have error null initially', () {
        expect(authProvider.error, isNull);
      });
    });

    group('signInWithEmail', () {
      test('should succeed with valid credentials', () async {
        final result = await authProvider.signInWithEmail(
          'demo@rechain.com',
          'password',
        );

        expect(result.isSuccess, true);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.userId, 'user_001');
        expect(authProvider.userName, 'Демо Пользователь');
      });

      test('should fail with invalid credentials', () async {
        final result = await authProvider.signInWithEmail(
          'wrong@email.com',
          'wrongpass',
        );

        expect(result.isFailure, true);
        expect(result.error, isA<AuthError>());
        expect(authProvider.isAuthenticated, false);
      });

      test('should fail with empty email', () async {
        final result = await authProvider.signInWithEmail(
          '',
          'password',
        );

        expect(result.isFailure, true);
      });

      test('should set loading state during sign in', () async {
        Future.delayed(const Duration(milliseconds: 100), () {
          expect(authProvider.isLoading, true);
        });

        await authProvider.signInWithEmail(
          'demo@rechain.com',
          'password',
        );

        expect(authProvider.isLoading, false);
      });
    });

    group('signInWithGoogle', () {
      test('should succeed and set user data', () async {
        final result = await authProvider.signInWithGoogle();

        expect(result.isSuccess, true);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.userId, 'google_user_001');
        expect(authProvider.user.email, 'google@example.com');
      });

      test('should set correct role for Google user', () async {
        await authProvider.signInWithGoogle();
        expect(authProvider.user.role, 'user');
      });
    });

    group('signInWithGitHub', () {
      test('should succeed and set user data', () async {
        final result = await authProvider.signInWithGitHub();

        expect(result.isSuccess, true);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.userId, 'github_user_001');
        expect(authProvider.user.email, 'github@example.com');
      });

      test('should set developer role for GitHub user', () async {
        await authProvider.signInWithGitHub();
        expect(authProvider.user.role, 'developer');
      });

      test('should have create_projects permission for GitHub user', () async {
        await authProvider.signInWithGitHub();
        expect(authProvider.hasPermission('create_projects'), true);
      });
    });

    group('connectWallet', () {
      test('should succeed with valid wallet address', () async {
        final validWallet = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';
        final result = await authProvider.connectWallet(validWallet);

        expect(result.isSuccess, true);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.userId, 'wallet_user_001');
      });

      test('should fail with short wallet address', () async {
        final invalidWallet = '0x123';
        final result = await authProvider.connectWallet(invalidWallet);

        expect(result.isFailure, true);
        expect(result.error, isA<AuthError>());
      });

      test('should set web3_user role for wallet connection', () async {
        await authProvider.connectWallet('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1');
        expect(authProvider.user.role, 'web3_user');
      });

      test('should have blockchain_operations permission', () async {
        await authProvider.connectWallet('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1');
        expect(authProvider.hasPermission('blockchain_operations'), true);
      });
    });

    group('signOut', () {
      test('should clear authentication state', () async {
        await authProvider.signInWithEmail('demo@rechain.com', 'password');
        expect(authProvider.isAuthenticated, true);

        await authProvider.signOut();

        expect(authProvider.isAuthenticated, false);
        expect(authProvider.user.isEmpty, true);
        expect(authProvider.userId, isNull);
      });
    });

    group('Permission checks', () {
      test('hasPermission should return true for existing permission', () async {
        await authProvider.signInWithGitHub();
        expect(authProvider.hasPermission('read'), true);
        expect(authProvider.hasPermission('write'), true);
      });

      test('hasPermission should return false for non-existing permission', () async {
        await authProvider.signInWithEmail('demo@rechain.com', 'password');
        expect(authProvider.hasPermission('admin'), false);
      });

      test('hasAnyPermission should return true if any permission exists', () async {
        await authProvider.signInWithGitHub();
        expect(authProvider.hasAnyPermission(['admin', 'read', 'superuser']), true);
      });

      test('hasAllPermissions should return true only if all permissions exist', () async {
        await authProvider.signInWithGitHub();
        expect(authProvider.hasAllPermissions(['read', 'write']), true);
        expect(authProvider.hasAllPermissions(['read', 'admin']), false);
      });
    });

    group('updateProfile', () {
      test('should update user name', () async {
        await authProvider.signInWithEmail('demo@rechain.com', 'password');
        final result = await authProvider.updateProfile(name: 'New Name');

        expect(result.isSuccess, true);
        expect(authProvider.userName, 'New Name');
      });

      test('should update user email', () async {
        await authProvider.signInWithEmail('demo@rechain.com', 'password');
        final result = await authProvider.updateProfile(email: 'new@example.com');

        expect(result.isSuccess, true);
        expect(authProvider.userEmail, 'new@example.com');
      });

      test('should update user avatar', () async {
        await authProvider.signInWithEmail('demo@rechain.com', 'password');
        final result = await authProvider.updateProfile(
          avatar: 'https://new-avatar.com/pic.jpg',
        );

        expect(result.isSuccess, true);
        expect(authProvider.userAvatar, 'https://new-avatar.com/pic.jpg');
      });

      test('should update multiple fields at once', () async {
        await authProvider.signInWithEmail('demo@rechain.com', 'password');
        final result = await authProvider.updateProfile(
          name: 'Updated User',
          email: 'updated@example.com',
        );

        expect(result.isSuccess, true);
        expect(authProvider.userName, 'Updated User');
        expect(authProvider.userEmail, 'updated@example.com');
      });
    });

    group('resetPassword', () {
      test('should succeed with valid email', () async {
        final result = await authProvider.resetPassword('test@example.com');
        expect(result.isSuccess, true);
      });

      test('should not change authentication state', () async {
        await authProvider.signInWithEmail('demo@rechain.com', 'password');
        final wasAuthenticated = authProvider.isAuthenticated;

        await authProvider.resetPassword('demo@rechain.com');

        expect(authProvider.isAuthenticated, wasAuthenticated);
      });
    });

    group('Error handling', () {
      test('should clear error after successful operation', () async {
        await authProvider.signInWithEmail('wrong@email.com', 'wrong');
        expect(authProvider.error, isNotNull);

        await authProvider.signInWithEmail('demo@rechain.com', 'password');
        expect(authProvider.error, isNull);
      });

      test('should preserve error message for invalid credentials', () async {
        await authProvider.signInWithEmail('wrong@email.com', 'wrong');
        expect(authProvider.error, isNotNull);
        expect(authProvider.error!.isNotEmpty, true);
      });
    });
  });
}
