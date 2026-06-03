import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Децентрализованная Идентичность (Decentralized Identifier - DID)
class DID {
  final String id;
  final String didDocument;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DID({
    required this.id,
    required this.didDocument,
    required this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  /// Генерация нового DID в формате did:web
  static String generateDid(String domain, String path) {
    return 'did:web:$domain:user:$path';
  }

  /// Генерация DID в формате did:key (самодостаточный)
  static String generateDidKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    final data = '$timestamp-$random-${_uuid()}';
    final hash = sha256.convert(utf8.encode(data));
    return 'did:key:z${hash.toString().substring(0, 32)}';
  }

  /// Уникальный идентификатор
  static String _uuid() {
    final uuid = DateTime.now().millisecondsSinceEpoch.toRadixString(16) +
        DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    return uuid.substring(uuid.length - 32);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'didDocument': didDocument,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory DID.fromJson(Map<String, dynamic> json) {
    return DID(
      id: json['id'],
      didDocument: json['didDocument'],
      metadata: Map<String, dynamic>.from(json['metadata']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  DID copyWith({
    String? id,
    String? didDocument,
    Map<String, dynamic>? metadata,
    DateTime? updatedAt,
  }) {
    return DID(
      id: id ?? this.id,
      didDocument: didDocument ?? this.didDocument,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

/// Верифицируемая Креденшиал (Verifiable Credential)
class VerifiableCredential {
  final String id;
  final String issuer;
  final String subject;
  final Map<String, dynamic> claims;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final String? signature;
  final bool isRevoked;

  VerifiableCredential({
    required this.id,
    required this.issuer,
    required this.subject,
    required this.claims,
    required this.issuedAt,
    this.expiresAt,
    this.signature,
    this.isRevoked = false,
  });

  /// Создание подписанного креденшиала
  VerifiableCredential sign(String privateKey) {
    final data = json.encode({
      'id': id,
      'issuer': issuer,
      'subject': subject,
      'claims': claims,
      'issuedAt': issuedAt.toIso8601String(),
    });
    
    final hash = sha256.convert(utf8.encode(data + privateKey));
    final signature = 'sig_${hash.toString()}';
    
    return VerifiableCredential(
      id: id,
      issuer: issuer,
      subject: subject,
      claims: claims,
      issuedAt: issuedAt,
      expiresAt: expiresAt,
      signature: signature,
      isRevoked: isRevoked,
    );
  }

  /// Проверка подписи креденшиала
  bool verify(String publicKey) {
    if (signature == null) return false;
    
    final data = json.encode({
      'id': id,
      'issuer': issuer,
      'subject': subject,
      'claims': claims,
      'issuedAt': issuedAt.toIso8601String(),
    });
    
    final expectedHash = sha256.convert(utf8.encode(data + publicKey));
    final expectedSignature = 'sig_${expectedHash.toString()}';
    
    return signature == expectedSignature && !isRevoked;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issuer': issuer,
      'subject': subject,
      'claims': claims,
      'issuedAt': issuedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'signature': signature,
      'isRevoked': isRevoked,
    };
  }

  factory VerifiableCredential.fromJson(Map<String, dynamic> json) {
    return VerifiableCredential(
      id: json['id'],
      issuer: json['issuer'],
      subject: json['subject'],
      claims: Map<String, dynamic>.from(json['claims']),
      issuedAt: DateTime.parse(json['issuedAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      signature: json['signature'],
      isRevoked: json['isRevoked'] ?? false,
    );
  }
}
