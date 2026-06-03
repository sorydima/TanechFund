// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;

import '../core/network/dio_client.dart' as _i393;
import '../core/network/network_manager.dart' as _i1001;
import '../core/performance/background_sync.dart' as _i222;
import '../core/performance/memory_optimizer.dart' as _i747;
import '../core/performance/performance_monitor.dart' as _i1008;
import '../core/security/biometric_auth.dart' as _i145;
import '../core/services/did_service.dart' as _i876;
import '../core/services/ipfs_service.dart' as _i610;
import '../core/stability/health_check_service.dart' as _i109;
import '../core/stability/rate_limiter.dart' as _i919;
import '../core/storage/cache_manager.dart' as _i799;
import '../core/storage/cache_service.dart' as _i578;
import '../core/storage/secure_storage.dart' as _i637;
import '../data/repositories/auth_repository_impl.dart' as _i74;
import '../data/services/api/api_client.dart' as _i946;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../providers/app_provider_v2.dart' as _i392;
import '../providers/auth_provider_v2.dart' as _i848;
import '../providers/web4_movement_provider.dart' as _i1049;
import '../providers/web4_movement_provider_v2.dart' as _i211;
import '../providers/web5_creation_provider.dart' as _i305;
import '../providers/web5_creation_provider_v2.dart' as _i207;
import '../services/storage_service.dart' as _i306;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i305.Web5CreationProvider>(() => _i305.Web5CreationProvider());
    gh.singleton<_i747.MemoryOptimizer>(() => _i747.MemoryOptimizer());
    gh.singleton<_i1008.PerformanceMonitor>(() => _i1008.PerformanceMonitor());
    gh.singleton<_i799.CacheManager>(() => _i799.CacheManager());
    gh.singleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.singleton<_i152.LocalAuthentication>(() => registerModule.localAuth);
    gh.singleton<_i1001.NetworkManager>(() => registerModule.networkManager);
    gh.singleton<_i558.FlutterSecureStorage>(
        () => registerModule.flutterSecureStorage);
    gh.singleton<_i578.CacheService>(() => registerModule.cacheService);
    gh.singleton<_i919.RateLimiterManager>(
        () => registerModule.rateLimiterManager);
    await gh.singletonAsync<_i306.StorageService>(
      () => registerModule.storageService,
      preResolve: true,
    );
    gh.singleton<_i876.DIDService>(() => _i876.DIDService());
    gh.singleton<_i145.BiometricAuthService>(
        () => registerModule.biometricAuth(gh<_i152.LocalAuthentication>()));
    gh.singleton<_i610.IPFSService>(() => _i610.IPFSService(
          gatewayUrl: gh<String>(),
          uploadUrl: gh<String>(),
        ));
    gh.singleton<_i222.BackgroundSyncService>(
        () => _i222.BackgroundSyncService(gh<_i1001.NetworkManager>()));
    gh.factory<_i1049.Web4MovementProvider>(
        () => _i1049.Web4MovementProvider(gh<_i306.StorageService>()));
    gh.singleton<_i392.AppProviderV2>(
        () => _i392.AppProviderV2(gh<_i306.StorageService>()));
    gh.singleton<_i211.Web4MovementProviderV2>(
        () => _i211.Web4MovementProviderV2(
              gh<_i876.DIDService>(),
              gh<_i610.IPFSService>(),
              gh<_i1049.Web4MovementProvider>(),
            ));
    gh.singleton<_i637.ISecureStorage>(
        () => registerModule.secureStorage(gh<_i558.FlutterSecureStorage>()));
    gh.factory<_i800.IAuthRepository>(() => _i74.AuthRepository(
          gh<_i637.ISecureStorage>(),
          gh<_i306.StorageService>(),
        ));
    gh.singleton<_i207.Web5CreationProviderV2>(
        () => _i207.Web5CreationProviderV2(
              gh<_i876.DIDService>(),
              gh<_i610.IPFSService>(),
              gh<_i305.Web5CreationProvider>(),
            ));
    gh.singleton<_i109.HealthCheckService>(
        () => registerModule.healthCheckService(
              gh<_i1001.NetworkManager>(),
              gh<_i306.StorageService>(),
              gh<_i578.CacheService>(),
            ));
    gh.singleton<_i393.DioClient>(
        () => _i393.DioClient(gh<_i637.ISecureStorage>()));
    gh.singleton<_i848.AuthProviderV2>(() => _i848.AuthProviderV2(
          gh<_i800.IAuthRepository>(),
          gh<_i145.BiometricAuthService>(),
        ));
    gh.singleton<_i361.Dio>(() => registerModule.dio(gh<_i393.DioClient>()));
    gh.singleton<_i946.ApiClient>(() => _i946.ApiClient(
          gh<_i361.Dio>(),
          gh<_i637.ISecureStorage>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
