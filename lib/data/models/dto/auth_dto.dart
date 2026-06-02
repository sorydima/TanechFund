import 'package:json_annotation/json_annotation.dart';

part 'auth_dto.g.dart';

/// DTO для запроса логина.
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  final bool? rememberMe;

  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// DTO для запроса регистрации.
@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String? phone;
  final String? referralCode;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
    this.referralCode,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// DTO для ответа с токенами.
@JsonSerializable()
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  Map<String, dynamic> toJson() => _$AuthTokensToJson(this);

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}

/// DTO для ответа с данными пользователя.
@JsonSerializable()
class UserResponse {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final String role;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  const UserResponse({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    required this.role,
    required this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

/// DTO для полного ответа авторизации.
@JsonSerializable()
class AuthResponse {
  final UserResponse user;
  final AuthTokens tokens;

  const AuthResponse({
    required this.user,
    required this.tokens,
  });

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// DTO для refresh токена.
@JsonSerializable()
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

/// DTO для сброса пароля.
@JsonSerializable()
class ResetPasswordRequest {
  final String email;

  const ResetPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

/// DTO для изменения пароля.
@JsonSerializable()
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}
