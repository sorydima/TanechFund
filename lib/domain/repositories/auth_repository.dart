import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/models/user_model.dart';

/// Абстракция репозитория аутентификации.
/// Позволяет менять реализацию (mock, remote, local) без изменения UI.
abstract class IAuthRepository {
  /// Проверяет, аутентифицирован ли пользователь
  Future<bool> isAuthenticated();

  /// Вход по email/password
  Future<Result<UserModel, AppError>> signInWithEmail(String email, String password);

  /// Вход через Google
  Future<Result<UserModel, AppError>> signInWithGoogle();

  /// Вход через GitHub
  Future<Result<UserModel, AppError>> signInWithGitHub();

  /// Подключение Web3 кошелька
  Future<Result<UserModel, AppError>> connectWallet(String walletAddress);

  /// Выход
  Future<Result<void, AppError>> signOut();

  /// Обновление профиля
  Future<Result<UserModel, AppError>> updateProfile({
    String? name,
    String? email,
    String? avatar,
  });

  /// Сброс пароля
  Future<Result<void, AppError>> resetPassword(String email);

  /// Получение текущего пользователя
  Future<Result<UserModel, AppError>> getCurrentUser();

  /// Обновление токена
  Future<Result<void, AppError>> refreshToken();
}
