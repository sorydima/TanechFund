import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/core/storage/secure_storage.dart';
import 'package:rechain_vc_lab/domain/repositories/auth_repository.dart';
import 'package:rechain_vc_lab/models/user_model.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

/// Реализация AuthRepository с secure storage для токенов
/// и обычным storage для пользовательских данных.
@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final ISecureStorage _secureStorage;
  final StorageService _storage;

  static const _authTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userDataKey = 'user_data';
  static const _isAuthenticatedKey = 'is_authenticated';

  AuthRepository(this._secureStorage, this._storage);

  @override
  Future<bool> isAuthenticated() async {
    final tokenResult = await _secureStorage.read(_authTokenKey);
    return tokenResult.isSuccess && tokenResult.value != null;
  }

  @override
  Future<Result<UserModel, AppError>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      // TODO: Заменить на реальный API вызов
      await Future.delayed(const Duration(seconds: 1));

      if (email == 'demo@rechain.com' && password == 'password') {
        const user = UserModel(
          id: 'user_001',
          name: 'Демо Пользователь',
          email: 'demo@rechain.com',
          role: 'user',
          permissions: ['read', 'write', 'participate'],
        );
        await _saveAuthState(user, 'demo_token', 'demo_refresh');
        return const Success(user);
      }

      return Failure(AuthError('Неверный email или пароль', code: 'invalid_credentials'));
    } catch (e, st) {
      AppLogger.error('AuthRepository: signInWithEmail failed', e, st);
      return Failure(AuthError('Ошибка входа', stackTrace: st));
    }
  }

  @override
  Future<Result<UserModel, AppError>> signInWithGoogle() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      const user = UserModel(
        id: 'google_user_001',
        name: 'Google Пользователь',
        email: 'google@example.com',
        avatar: 'https://via.placeholder.com/150',
        role: 'user',
        permissions: ['read', 'write', 'participate'],
      );
      await _saveAuthState(user, 'google_token', 'google_refresh');
      return const Success(user);
    } catch (e, st) {
      AppLogger.error('AuthRepository: signInWithGoogle failed', e, st);
      return Failure(AuthError('Ошибка входа через Google', stackTrace: st));
    }
  }

  @override
  Future<Result<UserModel, AppError>> signInWithGitHub() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      const user = UserModel(
        id: 'github_user_001',
        name: 'GitHub Разработчик',
        email: 'github@example.com',
        avatar: 'https://via.placeholder.com/150',
        role: 'developer',
        permissions: ['read', 'write', 'participate', 'create_projects'],
      );
      await _saveAuthState(user, 'github_token', 'github_refresh');
      return const Success(user);
    } catch (e, st) {
      AppLogger.error('AuthRepository: signInWithGitHub failed', e, st);
      return Failure(AuthError('Ошибка входа через GitHub', stackTrace: st));
    }
  }

  @override
  Future<Result<UserModel, AppError>> connectWallet(String walletAddress) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (walletAddress.length >= 42) {
        const user = UserModel(
          id: 'wallet_user_001',
          name: 'Web3 Пользователь',
          email: 'wallet@web3.com',
          role: 'web3_user',
          permissions: ['read', 'write', 'participate', 'blockchain_operations'],
        );
        await _saveAuthState(user, 'wallet_token', 'wallet_refresh');
        return const Success(user);
      }

      return Failure(AuthError('Неверный адрес кошелька', code: 'invalid_wallet'));
    } catch (e, st) {
      AppLogger.error('AuthRepository: connectWallet failed', e, st);
      return Failure(AuthError('Ошибка подключения кошелька', stackTrace: st));
    }
  }

  @override
  Future<Result<void, AppError>> signOut() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      await _clearAuthState();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('AuthRepository: signOut failed', e, st);
      return Failure(AuthError('Ошибка выхода', stackTrace: st));
    }
  }

  @override
  Future<Result<UserModel, AppError>> updateProfile({
    String? name,
    String? email,
    String? avatar,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final currentUserResult = await getCurrentUser();
      if (currentUserResult.isFailure) {
        return Failure(currentUserResult.error ?? AuthError('Неизвестная ошибка'));
      }

      final updatedUser = currentUserResult.value!.copyWith(
        name: name,
        email: email,
        avatar: avatar,
      );

      await _storage.set<String>(_userDataKey, jsonEncode(updatedUser.toJson()));
      return Success(updatedUser);
    } catch (e, st) {
      AppLogger.error('AuthRepository: updateProfile failed', e, st);
      return Failure(AuthError('Ошибка обновления профиля', stackTrace: st));
    }
  }

  @override
  Future<Result<void, AppError>> resetPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Интеграция с API сброса пароля
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('AuthRepository: resetPassword failed', e, st);
      return Failure(AuthError('Ошибка сброса пароля', stackTrace: st));
    }
  }

  @override
  Future<Result<UserModel, AppError>> getCurrentUser() async {
    try {
      final userJsonResult = _storage.get<String>(_userDataKey, '');
      if (userJsonResult.isFailure || userJsonResult.value!.isEmpty) {
        return Failure(AuthError('Пользователь не найден', code: 'user_not_found'));
      }

      final user = UserModel.fromJson(
        jsonDecode(userJsonResult.value!) as Map<String, dynamic>,
      );
      return Success(user);
    } catch (e, st) {
      AppLogger.error('AuthRepository: getCurrentUser failed', e, st);
      return Failure(AuthError('Ошибка получения пользователя', stackTrace: st));
    }
  }

  @override
  Future<Result<void, AppError>> refreshToken() async {
    try {
      final refreshResult = await _secureStorage.read(_refreshTokenKey);
      if (refreshResult.isFailure || refreshResult.value == null) {
        return Failure(AuthError('Refresh token не найден', code: 'no_refresh_token'));
      }

      // TODO: Заменить на реальный API вызов обновления токена
      await Future.delayed(const Duration(milliseconds: 500));
      await _secureStorage.write(_authTokenKey, 'new_token');
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('AuthRepository: refreshToken failed', e, st);
      return Failure(AuthError('Ошибка обновления токена', stackTrace: st));
    }
  }

  // Private helpers

  Future<void> _saveAuthState(
    UserModel user,
    String token,
    String refreshToken,
  ) async {
    await Future.wait([
      _secureStorage.write(_authTokenKey, token),
      _secureStorage.write(_refreshTokenKey, refreshToken),
      _storage.set<String>(_userDataKey, jsonEncode(user.toJson())),
      _storage.set<bool>(_isAuthenticatedKey, true),
    ]);
  }

  Future<void> _clearAuthState() async {
    await Future.wait([
      _secureStorage.delete(_authTokenKey),
      _secureStorage.delete(_refreshTokenKey),
      _storage.remove(_userDataKey),
      _storage.set<bool>(_isAuthenticatedKey, false),
    ]);
  }
}
