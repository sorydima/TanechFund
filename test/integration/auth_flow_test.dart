import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/domain/repositories/auth_repository.dart';
import 'package:rechain_vc_lab/models/user_model.dart';
import 'package:rechain_vc_lab/providers/auth_provider_v2.dart';
import 'package:rechain_vc_lab/core/security/biometric_auth.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockBiometricAuth extends Mock implements BiometricAuthService {}

void main() {
  group('AuthProviderV2 Integration Tests', () {
    late MockAuthRepository mockRepo;
    late MockBiometricAuth mockBiometric;
    late AuthProviderV2 authProvider;

    setUp(() {
      mockRepo = MockAuthRepository();
      mockBiometric = MockBiometricAuth();
      authProvider = AuthProviderV2(mockRepo, mockBiometric);
    });

    tearDown(() {
      authProvider.dispose();
    });

    group('Sign In Flow', () {
      test('successful email sign in updates state', () async {
        const user = UserModel(
          id: 'user_001',
          name: 'Test User',
          email: 'test@example.com',
          role: 'user',
          permissions: ['read', 'write'],
        );

        when(mockRepo.signInWithEmail('test@example.com', 'password'))
            .thenAnswer((_) async => const Success(user));

        final result = await authProvider.signInWithEmail(
          'test@example.com',
          'password',
        );

        expect(result.isSuccess, true);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.userName, 'Test User');
        expect(authProvider.hasPermission('read'), true);
        expect(authProvider.error, isNull);
      });

      test('failed sign in sets error state', () async {
        when(mockRepo.signInWithEmail('wrong@email.com', 'wrong'))
            .thenAnswer((_) async => Failure(
                  AuthError('Неверные credentials', code: 'invalid_credentials'),
                ));

        final result = await authProvider.signInWithEmail(
          'wrong@email.com',
          'wrong',
        );

        expect(result.isFailure, true);
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.error, isNotNull);
        expect(authProvider.hasError, true);
      });

      test('sign out clears all state', () async {
        const user = UserModel(
          id: 'user_001',
          name: 'Test User',
          email: 'test@example.com',
          role: 'user',
          permissions: ['read'],
        );

        when(mockRepo.signInWithEmail('test@example.com', 'password'))
            .thenAnswer((_) async => const Success(user));
        when(mockRepo.signOut())
            .thenAnswer((_) async => const Success(null));

        await authProvider.signInWithEmail('test@example.com', 'password');
        expect(authProvider.isAuthenticated, true);

        await authProvider.signOut();
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.user.isEmpty, true);
        expect(authProvider.userId, isNull);
      });
    });

    group('Permission Flow', () {
      test('hasPermission checks correctly', () async {
        const user = UserModel(
          id: 'dev_001',
          name: 'Developer',
          email: 'dev@example.com',
          role: 'developer',
          permissions: ['read', 'write', 'create_projects'],
        );

        when(mockRepo.signInWithGitHub())
            .thenAnswer((_) async => const Success(user));

        await authProvider.signInWithGitHub();

        expect(authProvider.hasPermission('read'), true);
        expect(authProvider.hasPermission('create_projects'), true);
        expect(authProvider.hasPermission('admin'), false);
        expect(authProvider.hasAllPermissions(['read', 'write']), true);
        expect(authProvider.hasAllPermissions(['read', 'admin']), false);
        expect(authProvider.hasAnyPermission(['admin', 'write']), true);
      });
    });

    group('Profile Update Flow', () {
      test('update profile refreshes user data', () async {
        const initialUser = UserModel(
          id: 'user_001',
          name: 'Old Name',
          email: 'old@example.com',
          role: 'user',
          permissions: ['read'],
        );

        const updatedUser = UserModel(
          id: 'user_001',
          name: 'New Name',
          email: 'new@example.com',
          role: 'user',
          permissions: ['read'],
        );

        when(mockRepo.signInWithEmail('test@example.com', 'password'))
            .thenAnswer((_) async => const Success(initialUser));
        when(mockRepo.updateProfile(name: 'New Name', email: 'new@example.com'))
            .thenAnswer((_) async => const Success(updatedUser));

        await authProvider.signInWithEmail('test@example.com', 'password');
        expect(authProvider.userName, 'Old Name');

        await authProvider.updateProfile(
          name: 'New Name',
          email: 'new@example.com',
        );

        expect(authProvider.userName, 'New Name');
        expect(authProvider.userEmail, 'new@example.com');
      });
    });

    group('Loading State', () {
      test('sets loading during async operations', () async {
        when(mockRepo.signInWithEmail('test@example.com', 'password')).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return const Success(UserModel(
            id: 'user_001',
            name: 'Test',
            email: 'test@example.com',
            role: 'user',
            permissions: [],
          ));
        });

        final future = authProvider.signInWithEmail('test@example.com', 'password');
        await Future.delayed(const Duration(milliseconds: 50));

        expect(authProvider.isLoading, true);

        await future;
        expect(authProvider.isLoading, false);
      });
    });

    group('Error Recovery', () {
      test('clears error on successful operation', () async {
        when(mockRepo.signInWithEmail('wrong', 'wrong'))
            .thenAnswer((_) async => Failure(
                  AuthError('Ошибка', code: 'test'),
                ));

        when(mockRepo.signInWithEmail('test@example.com', 'password'))
            .thenAnswer((_) async => const Success(UserModel(
                  id: 'user_001',
                  name: 'Test',
                  email: 'test@example.com',
                  role: 'user',
                  permissions: [],
                )));

        await authProvider.signInWithEmail('wrong', 'wrong');
        expect(authProvider.error, isNotNull);

        await authProvider.signInWithEmail('test@example.com', 'password');
        expect(authProvider.error, isNull);
      });
    });
  });
}
