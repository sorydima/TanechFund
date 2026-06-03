import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rechain_vc_lab/core/network/dio_client.dart';
import 'package:rechain_vc_lab/core/network/network_manager.dart';
import 'package:rechain_vc_lab/core/security/biometric_auth.dart';
import 'package:rechain_vc_lab/core/services/did_service.dart';
import 'package:rechain_vc_lab/core/services/ipfs_service.dart';
import 'package:rechain_vc_lab/core/storage/cache_service.dart';
import 'package:rechain_vc_lab/core/stability/health_check_service.dart';
import 'package:rechain_vc_lab/core/stability/rate_limiter.dart';
import 'package:rechain_vc_lab/core/storage/secure_storage.dart';
import 'package:rechain_vc_lab/providers/web4_movement_provider.dart';
import 'package:rechain_vc_lab/providers/web5_creation_provider.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

/// Модуль регистрации third-party зависимостей.
@module
abstract class RegisterModule {
  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  LocalAuthentication get localAuth => LocalAuthentication();

  @singleton
  NetworkManager get networkManager => NetworkManager();

  @singleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );

  @singleton
  ISecureStorage secureStorage(FlutterSecureStorage storage) =>
      SecureStorage(storage: storage);

  @singleton
  BiometricAuthService biometricAuth(LocalAuthentication localAuth) =>
      BiometricAuthService(localAuth);

  @singleton
  Dio dio(DioClient client) => client.dio;

  @singleton
  CacheService get cacheService => CacheService();

  @singleton
  RateLimiterManager get rateLimiterManager => RateLimiterManager();

  @preResolve
  @singleton
  Future<StorageService> get storageService async => await StorageService.getInstance();

  @singleton
  HealthCheckService healthCheckService(
    NetworkManager networkManager,
    StorageService storageService,
    CacheService cacheService,
  ) =>
      HealthCheckService(networkManager, storageService, cacheService);
}

