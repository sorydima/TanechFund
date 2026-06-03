import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/services/did_models.dart';

/// Сервис управления децентрализованными идентичностями
@singleton
class DIDService {
  final FlutterSecureStorage _secureStorage;
  final Map<String, DID> _didRegistry = {};
  final Map<String, VerifiableCredential> _credentials = {};

  DIDService() : _secureStorage = const FlutterSecureStorage();

  /// Создание новой децентрализованной идентичности
  Future<Result<DID, Exception>> createDid({
    required String domain,
    required String userId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final did = DID(
        id: DID.generateDid(domain, userId),
        didDocument: _createDidDocument(userId),
        metadata: metadata ?? {},
        createdAt: DateTime.now(),
      );

      _didRegistry[did.id] = did;
      
      // Сохранение в secure storage
      await _secureStorage.write(
        key: 'did_${did.id}',
        value: json.encode(did.toJson()),
      );

      AppLogger.info('DID created: ${did.id}');
      return Result.success(did);
    } catch (e) {
      AppLogger.error('Failed to create DID', e);
      return Result.failure(e);
    }
  }

  /// Создание DID в формате did:key
  Future<Result<DID, Exception>> createDidKey() async {
    try {
      final did = DID(
        id: DID.generateDidKey(),
        didDocument: _createDidDocument('key'),
        metadata: {'type': 'did:key'},
        createdAt: DateTime.now(),
      );

      _didRegistry[did.id] = did;
      
      await _secureStorage.write(
        key: 'did_${did.id}',
        value: json.encode(did.toJson()),
      );

      AppLogger.info('DID (key) created: ${did.id}');
      return Result.success(did);
    } catch (e) {
      AppLogger.error('Failed to create DID key', e);
      return Result.failure(e);
    }
  }

  /// Получение DID по ID
  Future<Result<DID?, Exception>> getDid(String didId) async {
    try {
      if (_didRegistry.containsKey(didId)) {
        return Result.success(_didRegistry[didId]);
      }

      // Загрузка из secure storage
      final stored = await _secureStorage.read(key: 'did_$didId');
      if (stored != null) {
        final did = DID.fromJson(json.decode(stored));
        _didRegistry[didId] = did;
        return Result.success(did);
      }

      return Result.success(null);
    } catch (e) {
      AppLogger.error('Failed to get DID', e);
      return Result.failure(e);
    }
  }

  /// Издание верифицируемого креденшиала
  Future<Result<VerifiableCredential, Exception>> issueCredential({
    required String issuerDid,
    required String subjectDid,
    required Map<String, dynamic> claims,
    Duration? validity,
  }) async {
    try {
      final credential = VerifiableCredential(
        id: 'vc:${DID.uuid()}',
        issuer: issuerDid,
        subject: subjectDid,
        claims: claims,
        issuedAt: DateTime.now(),
        expiresAt: validity != null ? DateTime.now().add(validity) : null,
      );

      // В реальной реализации здесь будет подпись с использованием приватного ключа
      // Для демо используем заглушку
      final dummyPrivateKey = 'demo_private_key';
      final signedCredential = credential.sign(dummyPrivateKey);

      _credentials[credential.id] = signedCredential;

      AppLogger.info('Credential issued: ${credential.id}');
      return Result.success(signedCredential);
    } catch (e) {
      AppLogger.error('Failed to issue credential', e);
      return Result.failure(e);
    }
  }

  /// Проверка верифицируемого креденшиала
  Future<Result<bool, Exception>> verifyCredential(VerifiableCredential credential) async {
    try {
      // В реальной реализации:
      // 1. Проверка подписи
      // 2. Проверка истечения срока
      // 3. Проверка отзыва
      // 4. Проверка доверия к издателю
      
      final isValid = credential.verify('demo_public_key');
      final isExpired = credential.expiresAt != null && 
                        credential.expiresAt!.isBefore(DateTime.now());
      
      return Result.success(isValid && !isExpired && !credential.isRevoked);
    } catch (e) {
      AppLogger.error('Failed to verify credential', e);
      return Result.failure(e);
    }
  }

  /// Получение всех креденшиалов для субъекта
  Future<Result<List<VerifiableCredential>, Exception>> getCredentialsForSubject(String subjectDid) async {
    try {
      final subjectCredentials = _credentials.values
          .where((vc) => vc.subject == subjectDid && !vc.isRevoked)
          .toList();
      
      return Result.success(subjectCredentials);
    } catch (e) {
      AppLogger.error('Failed to get credentials', e);
      return Result.failure(e);
    }
  }

  /// Отзыв креденшиала
  Future<Result<void, Exception>> revokeCredential(String credentialId) async {
    try {
      if (_credentials.containsKey(credentialId)) {
        final credential = _credentials[credentialId]!;
        _credentials[credentialId] = VerifiableCredential(
          id: credential.id,
          issuer: credential.issuer,
          subject: credential.subject,
          claims: credential.claims,
          issuedAt: credential.issuedAt,
          expiresAt: credential.expiresAt,
          signature: credential.signature,
          isRevoked: true,
        );
        
        AppLogger.info('Credential revoked: $credentialId');
        return Result.success(null);
      }
      
      return Result.failure(Exception('Credential not found'));
    } catch (e) {
      AppLogger.error('Failed to revoke credential', e);
      return Result.failure(e);
    }
  }

  /// Создание DID документа
  String _createDidDocument(String userId) {
    return json.encode({
      '@context': [
        'https://www.w3.org/ns/did/v1',
        'https://w3id.org/security/suites/jws-2020/v1'
      ],
      'id': 'did:web:example.com:user:$userId',
      'verificationMethod': [
        {
          'id': 'did:web:example.com:user:$userId#keys-1',
          'type': 'JsonWebKey2020',
          'controller': 'did:web:example.com:user:$userId',
          'publicKeyJwk': {
            'kty': 'EC',
            'crv': 'P-256K',
            'x': 'demo_x_coordinate',
            'y': 'demo_y_coordinate'
          }
        }
      ],
      'authentication': ['did:web:example.com:user:$userId#keys-1'],
      'assertionMethod': ['did:web:example.com:user:$userId#keys-1']
    });
  }

  /// Загрузка всех сохранённых DID
  Future<void> loadStoredDids() async {
    try {
      final keys = await _secureStorage.keySet();
      if (keys != null) {
        for (final key in keys) {
          if (key.startsWith('did_')) {
            final stored = await _secureStorage.read(key: key);
            if (stored != null) {
              final did = DID.fromJson(json.decode(stored));
              _didRegistry[did.id] = did;
            }
          }
        }
      }
      AppLogger.info('Loaded ${_didRegistry.length} stored DIDs');
    } catch (e) {
      AppLogger.error('Failed to load stored DIDs', e);
    }
  }
}
