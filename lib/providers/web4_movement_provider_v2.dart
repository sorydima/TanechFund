import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/base/base_provider.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/services/did_models.dart';
import 'package:rechain_vc_lab/core/services/did_service.dart';
import 'package:rechain_vc_lab/core/services/ipfs_service.dart';
import 'package:rechain_vc_lab/providers/web4_movement_provider.dart';

/// Расширенный Web4 Movement Provider V2 с поддержкой DID и IPFS
@singleton
class Web4MovementProviderV2 extends BaseProvider {
  final DIDService _didService;
  final IPFSService _ipfsService;
  final Web4MovementProvider _legacyProvider;

  // Текущая децентрализованная идентичность пользователя
  DID? _currentDid;
  
  // IPFS CID для хранения траекторий
  String? _trajectoriesIpfsCid;
  String? _identitiesIpfsCid;

  DID? get currentDid => _currentDid;
  bool get hasIdentity => _currentDid != null;

  Web4MovementProviderV2(
    this._didService,
    this._ipfsService,
    this._legacyProvider,
  ) {
    initialize();
  }

  @override
  void initialize() {
    execute(() async {
      // Загрузка сохранённых DID
      await _didService.loadStoredDids();
      
      // Пытаемся восстановить текущую идентичность
      final storedDid = await _didService.getDid('current_did');
      if (storedDid.isSuccess && storedDid.value != null) {
        _currentDid = storedDid.value;
        AppLogger.info('Restored DID: ${_currentDid!.id}');
      } else {
        // Создаём новую DID при первом запуске
        await _createDecentralizedIdentity();
      }
      
      return Result.success(null);
    }, errorPrefix: 'Ошибка инициализации Web4 V2');
  }

  /// Создание децентрализованной идентичности
  Future<Result<dynamic, Exception>> _createDecentralizedIdentity() async {
    return await execute(() async {
      final didResult = await _didService.createDidKey();
      
      if (didResult.isSuccess) {
        _currentDid = didResult.value;
        
        // Сохраняем как текущую идентичность
        final storedResult = await _didService.createDid(
          domain: 'rechain.vc',
          userId: 'current_did',
          metadata: {
            'linkedDid': _currentDid!.id,
            'createdAt': DateTime.now().toIso8601String(),
          },
        );

        AppLogger.info('Created decentralized identity: ${_currentDid!.id}');
      } else {
        AppLogger.error('Failed to create DID', didResult.error);
      }
      
      return Result.success(null);
    }, errorPrefix: 'Ошибка создания DID');
  }

      return Result.success(null);
    }, errorPrefix: 'Ошибка создания DID');
  }

  /// Загрузка траекторий из IPFS
  Future<Result<void, Exception>> loadTrajectoriesFromIpfs() async {
    return await execute(() async {
      if (_trajectoriesIpfsCid == null) {
        return Result.failure(Exception('No IPFS CID for trajectories'));
      }

      final result = await _ipfsService.getWeb4Trajectory(_trajectoriesIpfsCid!);
      
      if (result.isSuccess) {
        // Обновляем legacy provider с данными из IPFS
        // TODO: Интегрировать с MovementTrajectory моделями
        AppLogger.info('Trajectories loaded from IPFS');
        return Result.success(null);
      } else {
        AppLogger.error('Failed to load trajectories from IPFS', result.error);
        return result;
      }
    }, errorPrefix: 'Ошибка загрузки траекторий');
  }

  /// Сохранение траекторий в IPFS
  Future<Result<String, Exception>> saveTrajectoriesToIpfs(List<dynamic> trajectories) async {
    return await execute(() async {
      final result = await _ipfsService.uploadWeb4Trajectory({
        'trajectories': trajectories,
        'updatedAt': DateTime.now().toIso8601String(),
        'did': _currentDid?.id,
      });

      if (result.isSuccess) {
        _trajectoriesIpfsCid = result.value;
        AppLogger.info('Trajectories saved to IPFS: ${result.value}');
      }

      return result;
    }, errorPrefix: 'Ошибка сохранения траекторий');
  }

  /// Получение верифицируемых креденшиалов для идентичности
  Future<Result<List<dynamic>, Exception>> getCredentials() async {
    if (_currentDid == null) {
      return Result.failure(Exception('No identity available'));
    }

    return await execute(() async {
      final result = await _didService.getCredentialsForSubject(_currentDid!.id);
      
      if (result.isSuccess) {
        AppLogger.info('Retrieved ${result.value!.length} credentials');
      }

      return result;
    }, errorPrefix: 'Ошибка получения креденшиалов');
  }

  /// Издание креденшиала за выполненную траекторию
  Future<Result<dynamic, Exception>> issueTrajectoryCredential(String trajectoryId, Map<String, dynamic> claims) async {
    if (_currentDid == null) {
      return Result.failure(Exception('No identity available'));
    }

    return await execute(() async {
      final result = await _didService.issueCredential(
        issuerDid: 'did:web:rechain.vc:platform', // DID платформы
        subjectDid: _currentDid!.id,
        claims: {
          'trajectoryId': trajectoryId,
          'type': 'trajectory_completion',
          ...claims,
        },
        validity: const Duration(days: 365), // Действителен 1 год
      );

      if (result.isSuccess) {
        AppLogger.info('Trajectory credential issued: ${result.value!.id}');
      }

      return result;
    }, errorPrefix: 'Ошибка издания креденшиала');
  }

  /// Проверка креденшиала
  Future<Result<bool, Exception>> verifyCredential(dynamic credential) async {
    return await execute(() async {
      final result = await _didService.verifyCredential(credential);
      return result;
    }, errorPrefix: 'Ошибка проверки креденшиала');
  }

  /// Синхронизация данных с IPFS
  Future<Result<dynamic, Exception>> syncWithIpfs() async {
    return await execute(() async {
      try {
        // Загрузка с IPFS
        if (_trajectoriesIpfsCid != null) {
          await loadTrajectoriesFromIpfs();
        }

        // Сохранение в IPFS (демо - не реализовано полностью)
        // TODO: Реализовать полную синхронизацию

        AppLogger.info('Sync with IPFS completed');
        return Result.success(null);
      } catch (e) {
        AppLogger.error('Sync with IPFS failed', e);
        return Result.failure(e);
      }
    }, errorPrefix: 'Ошибка синхронизации');
  }

  /// Экспорт идентичности для восстановления
  Future<String> exportIdentity() async {
    if (_currentDid == null) {
      throw Exception('No identity to export');
    }

    return json.encode({
      'did': _currentDid!.toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    });
  }

  /// Импортирование идентичности из резервной копии
  Future<Result<dynamic, Exception>> importIdentity(String exportedData) async {
    return await execute(() async {
      try {
        final data = json.decode(exportedData);
        
        if (data['did'] == null) {
          return Result.failure(Exception('Invalid identity data'));
        }

        _currentDid = DID.fromJson(data['did']);
        
        // Сохраняем в DID service
        final storedResult = await _didService.createDid(
          domain: 'rechain.vc',
          userId: 'current_did',
          metadata: {
            'imported': true,
            'importedAt': DateTime.now().toIso8601String(),
          },
        );

        AppLogger.info('Identity imported: ${_currentDid!.id}');
        return Result.success(null);
      } catch (e) {
        AppLogger.error('Failed to import identity', e);
        return Result.failure(e);
      }
    }, errorPrefix: 'Ошибка импорта идентичности');
  }

        // Сохранение в IPFS (демо - не реализовано полностью)
        // TODO: Реализовать полную синхронизацию

        AppLogger.info('Sync with IPFS completed');
        return Result.success(null);
      } catch (e) {
        AppLogger.error('Sync with IPFS failed', e);
        return Result.failure(e);
      }
    }, errorPrefix: 'Ошибка синхронизации');
  }

  /// Создание децентрализованного графа связей
  Map<String, dynamic> buildIdentityGraph() {
    return {
      'did': _currentDid?.id,
      'timestamp': DateTime.now().toIso8601String(),
      'network': {
        'type': 'web4_movement',
        'version': '1.0.0',
      },
      'metadata': {
        'platform': 'rechain_vc_lab',
        'decentralized': true,
      },
    };
  }

  /// Экспорт идентичности для восстановления
  Future<String> exportIdentity() async {
    if (_currentDid == null) {
      throw Exception('No identity to export');
    }

    return json.encode({
      'did': _currentDid!.toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    });
  }

  /// Импортирование идентичности из резервной копии
  Future<Result<void, Exception>> importIdentity(String exportedData) async {
    return await execute(() async {
      try {
        final data = json.decode(exportedData);
        
        if (data['did'] == null) {
          return Result.failure(Exception('Invalid identity data'));
        }

        _currentDid = DID.fromJson(data['did']);
        
        // Сохраняем в DID service
        final storedResult = await _didService.createDid(
          domain: 'rechain.vc',
          userId: 'current_did',
          metadata: {
            'imported': true,
            'importedAt': DateTime.now().toIso8601String(),
          },
        );

        AppLogger.info('Identity imported: ${_currentDid!.id}');
        return Result.success(null);
      } catch (e) {
        AppLogger.error('Failed to import identity', e);
        return Result.failure(e);
      }
    }, errorPrefix: 'Ошибка импорта идентичности');
  }

  @override
  void dispose() {
    AppLogger.debug('Web4MovementProviderV2 disposed');
    super.dispose();
  }
}
