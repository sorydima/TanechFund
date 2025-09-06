import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// DID Document Status
enum DIDStatus {
  active,     // Активен
  suspended,  // Приостановлен
  revoked,    // Отозван
  expired,    // Истек
}

// Verification Method Type
enum VerificationMethodType {
  ed25519,    // Ed25519 ключ
  secp256k1,  // Secp256k1 ключ
  rsa,        // RSA ключ
  ecdsa,      // ECDSA ключ
}

// Achievement Type
enum AchievementType {
  skill,      // Навык
  contribution, // Вклад в проект
  community,  // Активность в сообществе
  innovation, // Инновация
  leadership, // Лидерство
}

// Reputation Score Source
enum ReputationSource {
  peer_review,    // Оценка коллег
  project_success, // Успех проектов
  community_votes, // Голоса сообщества
  skill_verification, // Верификация навыков
  contribution_impact, // Влияние вкладов
}

// Web3 Identity (DID Document)
class Web3Identity {
  final String did; // Decentralized Identifier
  final String controller; // Контроллер DID
  final DIDStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;
  final List<VerificationMethod> verificationMethods;
  final List<String> services; // Сервисы (IPFS, Arweave и т.д.)
  final Map<String, dynamic> metadata;

  Web3Identity({
    required this.did,
    required this.controller,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.expiresAt,
    required this.verificationMethods,
    required this.services,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'did': did,
      'controller': controller,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'verificationMethods': verificationMethods.map((vm) => vm.toJson()).toList(),
      'services': services,
      'metadata': metadata,
    };
  }

  factory Web3Identity.fromJson(Map<String, dynamic> json) {
    return Web3Identity(
      did: json['did'],
      controller: json['controller'],
      status: DIDStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DIDStatus.active,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      verificationMethods: (json['verificationMethods'] as List)
          .map((vm) => VerificationMethod.fromJson(vm))
          .toList(),
      services: List<String>.from(json['services']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Web3Identity copyWith({
    String? did,
    String? controller,
    DIDStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
    List<VerificationMethod>? verificationMethods,
    List<String>? services,
    Map<String, dynamic>? metadata,
  }) {
    return Web3Identity(
      did: did ?? this.did,
      controller: controller ?? this.controller,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      verificationMethods: verificationMethods ?? this.verificationMethods,
      services: services ?? this.services,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Verification Method
class VerificationMethod {
  final String id;
  final String type;
  final String controller;
  final String publicKeyMultibase;
  final VerificationMethodType verificationMethodType;
  final Map<String, dynamic> metadata;

  VerificationMethod({
    required this.id,
    required this.type,
    required this.controller,
    required this.publicKeyMultibase,
    required this.verificationMethodType,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'controller': controller,
      'publicKeyMultibase': publicKeyMultibase,
      'verificationMethodType': verificationMethodType.name,
      'metadata': metadata,
    };
  }

  factory VerificationMethod.fromJson(Map<String, dynamic> json) {
    return VerificationMethod(
      id: json['id'],
      type: json['type'],
      controller: json['controller'],
      publicKeyMultibase: json['publicKeyMultibase'],
      verificationMethodType: VerificationMethodType.values.firstWhere(
        (e) => e.name == json['verificationMethodType'],
        orElse: () => VerificationMethodType.ed25519,
      ),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  VerificationMethod copyWith({
    String? id,
    String? type,
    String? controller,
    String? publicKeyMultibase,
    VerificationMethodType? verificationMethodType,
    Map<String, dynamic>? metadata,
  }) {
    return VerificationMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      controller: controller ?? this.controller,
      publicKeyMultibase: publicKeyMultibase ?? this.publicKeyMultibase,
      verificationMethodType: verificationMethodType ?? this.verificationMethodType,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Achievement
class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final int points; // Очки репутации
  final String issuer; // Кто выдал достижение
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final List<String> evidence; // Доказательства (IPFS хеши)
  final Map<String, dynamic> metadata;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.points,
    required this.issuer,
    required this.issuedAt,
    this.expiresAt,
    required this.evidence,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'points': points,
      'issuer': issuer,
      'issuedAt': issuedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'evidence': evidence,
      'metadata': metadata,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: AchievementType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AchievementType.skill,
      ),
      points: json['points'],
      issuer: json['issuer'],
      issuedAt: DateTime.parse(json['issuedAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      evidence: List<String>.from(json['evidence']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    AchievementType? type,
    int? points,
    String? issuer,
    DateTime? issuedAt,
    DateTime? expiresAt,
    List<String>? evidence,
    Map<String, dynamic>? metadata,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      points: points ?? this.points,
      issuer: issuer ?? this.issuer,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      evidence: evidence ?? this.evidence,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Reputation Score
class ReputationScore {
  final String id;
  final String userId;
  final String sourceId; // ID источника репутации
  final ReputationSource source;
  final double score; // Оценка от 0 до 100
  final String reason; // Причина оценки
  final DateTime scoredAt;
  final String scorerId; // Кто поставил оценку
  final Map<String, dynamic> metadata;

  ReputationScore({
    required this.id,
    required this.userId,
    required this.sourceId,
    required this.source,
    required this.score,
    required this.reason,
    required this.scoredAt,
    required this.scorerId,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sourceId': sourceId,
      'source': source.name,
      'score': score,
      'reason': reason,
      'scoredAt': scoredAt.toIso8601String(),
      'scorerId': scorerId,
      'metadata': metadata,
    };
  }

  factory ReputationScore.fromJson(Map<String, dynamic> json) {
    return ReputationScore(
      id: json['id'],
      userId: json['userId'],
      sourceId: json['sourceId'],
      source: ReputationSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => ReputationSource.peer_review,
      ),
      score: json['score'].toDouble(),
      reason: json['reason'],
      scoredAt: DateTime.parse(json['scoredAt']),
      scorerId: json['scorerId'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  ReputationScore copyWith({
    String? id,
    String? userId,
    String? sourceId,
    ReputationSource? source,
    double? score,
    String? reason,
    DateTime? scoredAt,
    String? scorerId,
    Map<String, dynamic>? metadata,
  }) {
    return ReputationScore(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sourceId: sourceId ?? this.sourceId,
      source: source ?? this.source,
      score: score ?? this.score,
      reason: reason ?? this.reason,
      scoredAt: scoredAt ?? this.scoredAt,
      scorerId: scorerId ?? this.scorerId,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Skill Verification
class SkillVerification {
  final String id;
  final String userId;
  final String skillName;
  final String skillCategory;
  final String description;
  final List<String> evidence; // Доказательства навыка
  final List<String> verifiers; // Верификаторы
  final DateTime verifiedAt;
  final DateTime? expiresAt;
  final bool isActive;
  final Map<String, dynamic> metadata;

  SkillVerification({
    required this.id,
    required this.userId,
    required this.skillName,
    required this.skillCategory,
    required this.description,
    required this.evidence,
    required this.verifiers,
    required this.verifiedAt,
    this.expiresAt,
    required this.isActive,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'skillName': skillName,
      'skillCategory': skillCategory,
      'description': description,
      'evidence': evidence,
      'verifiers': verifiers,
      'verifiedAt': verifiedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory SkillVerification.fromJson(Map<String, dynamic> json) {
    return SkillVerification(
      id: json['id'],
      userId: json['userId'],
      skillName: json['skillName'],
      skillCategory: json['skillCategory'],
      description: json['description'],
      evidence: List<String>.from(json['evidence']),
      verifiers: List<String>.from(json['verifiers']),
      verifiedAt: DateTime.parse(json['verifiedAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      isActive: json['isActive'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  SkillVerification copyWith({
    String? id,
    String? userId,
    String? skillName,
    String? skillCategory,
    String? description,
    List<String>? evidence,
    List<String>? verifiers,
    DateTime? verifiedAt,
    DateTime? expiresAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return SkillVerification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      skillName: skillName ?? this.skillName,
      skillCategory: skillCategory ?? this.skillCategory,
      description: description ?? this.description,
      evidence: evidence ?? this.evidence,
      verifiers: verifiers ?? this.verifiers,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Web3 Identity Provider
class Web3IdentityProvider extends ChangeNotifier {
  List<Web3Identity> _identities = [];
  List<Achievement> _achievements = [];
  List<ReputationScore> _reputationScores = [];
  List<SkillVerification> _skillVerifications = [];
  String _currentUserId = 'current_user';

  // Getters
  List<Web3Identity> get identities => _identities;
  List<Achievement> get achievements => _achievements;
  List<ReputationScore> get reputationScores => _reputationScores;
  List<SkillVerification> get skillVerifications => _skillVerifications;
  String get currentUserId => _currentUserId;

  // Filtered getters
  List<Web3Identity> get activeIdentities => _identities
      .where((identity) => identity.status == DIDStatus.active)
      .toList();

  List<Achievement> get userAchievements => _achievements
      .where((achievement) => achievement.issuer == _currentUserId)
      .toList();

  List<ReputationScore> get userReputationScores => _reputationScores
      .where((score) => score.userId == _currentUserId)
      .toList();

  List<SkillVerification> get userSkillVerifications => _skillVerifications
      .where((verification) => verification.userId == _currentUserId && verification.isActive)
      .toList();

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_identities.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final identitiesJson = prefs.getStringList('web3_identity_identities') ?? [];
      _identities = identitiesJson
          .map((json) => Web3Identity.fromJson(jsonDecode(json)))
          .toList();

      final achievementsJson = prefs.getStringList('web3_identity_achievements') ?? [];
      _achievements = achievementsJson
          .map((json) => Achievement.fromJson(jsonDecode(json)))
          .toList();

      final reputationJson = prefs.getStringList('web3_identity_reputation') ?? [];
      _reputationScores = reputationJson
          .map((json) => ReputationScore.fromJson(jsonDecode(json)))
          .toList();

      final skillsJson = prefs.getStringList('web3_identity_skills') ?? [];
      _skillVerifications = skillsJson
          .map((json) => SkillVerification.fromJson(jsonDecode(json)))
          .toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Web3 Identity data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setStringList('web3_identity_identities',
          _identities.map((identity) => jsonEncode(identity.toJson())).toList());

      await prefs.setStringList('web3_identity_achievements',
          _achievements.map((achievement) => jsonEncode(achievement.toJson())).toList());

      await prefs.setStringList('web3_identity_reputation',
          _reputationScores.map((score) => jsonEncode(score.toJson())).toList());

      await prefs.setStringList('web3_identity_skills',
          _skillVerifications.map((skill) => jsonEncode(skill.toJson())).toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Web3 Identity data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample identities
    _identities = [
      Web3Identity(
        did: 'did:rechain:1234567890abcdef',
        controller: '0x1234567890abcdef1234567890abcdef12345678',
        status: DIDStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        verificationMethods: [
          VerificationMethod(
            id: 'did:rechain:1234567890abcdef#key-1',
            type: 'Ed25519VerificationKey2020',
            controller: 'did:rechain:1234567890abcdef',
            publicKeyMultibase: 'z6Mkf5rGM4rBp9ETQGm1YcGxjff3bevVVwRz9iZaB3oL4Zw5',
            verificationMethodType: VerificationMethodType.ed25519,
            metadata: {
              'curve': 'ed25519',
              'keySize': 256,
            },
          ),
        ],
        services: [
          'ipfs://QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG',
          'ar://a4Oi2QJ_348mjsdN3cakLmj-qnCvPO7iD3QckIFEkbw',
        ],
        metadata: {
          'name': 'REChain Developer',
          'avatar': 'ipfs://QmAvatar123...',
          'bio': 'Blockchain developer and DeFi enthusiast',
        },
      ),
    ];

    // Create sample achievements
    _achievements = [
      Achievement(
        id: '1',
        title: 'Smart Contract Master',
        description: 'Successfully deployed 10+ smart contracts with zero vulnerabilities',
        type: AchievementType.skill,
        points: 100,
        issuer: 'REChain Community',
        issuedAt: DateTime.now().subtract(const Duration(days: 60)),
        evidence: [
          'ipfs://QmContract1...',
          'ipfs://QmContract2...',
        ],
        metadata: {
          'category': 'blockchain',
          'difficulty': 'expert',
          'verification_count': 5,
        },
      ),
      Achievement(
        id: '2',
        title: 'Community Leader',
        description: 'Organized 5+ successful community events and hackathons',
        type: AchievementType.leadership,
        points: 150,
        issuer: 'REChain Foundation',
        issuedAt: DateTime.now().subtract(const Duration(days: 30)),
        evidence: [
          'ipfs://QmEvent1...',
          'ipfs://QmEvent2...',
        ],
        metadata: {
          'category': 'community',
          'impact': 'high',
          'participant_count': 500,
        },
      ),
    ];

    // Create sample reputation scores
    _reputationScores = [
      ReputationScore(
        id: '1',
        userId: 'current_user',
        sourceId: 'project_1',
        source: ReputationSource.project_success,
        score: 95.0,
        reason: 'Excellent contribution to DeFi protocol development',
        scoredAt: DateTime.now().subtract(const Duration(days: 15)),
        scorerId: '0xabcdef1234567890abcdef1234567890abcdef12',
        metadata: {
          'project_name': 'REChain DeFi Protocol',
          'contribution_type': 'smart_contracts',
        },
      ),
      ReputationScore(
        id: '2',
        userId: 'current_user',
        sourceId: 'community_1',
        source: ReputationSource.peer_review,
        score: 88.0,
        reason: 'Helpful mentor and active community member',
        scoredAt: DateTime.now().subtract(const Duration(days: 7)),
        scorerId: '0x7890abcdef1234567890abcdef1234567890abcd',
        metadata: {
          'mentorship_sessions': 25,
          'community_posts': 150,
        },
      ),
    ];

    // Create sample skill verifications
    _skillVerifications = [
      SkillVerification(
        id: '1',
        userId: 'current_user',
        skillName: 'Solidity Development',
        skillCategory: 'Blockchain',
        description: 'Expert-level Solidity smart contract development',
        evidence: [
          'ipfs://QmSolidityCode1...',
          'ipfs://QmSolidityCode2...',
          'ipfs://QmSolidityCode3...',
        ],
        verifiers: [
          '0x1234567890abcdef1234567890abcdef12345678',
          '0xabcdef1234567890abcdef1234567890abcdef12',
        ],
        verifiedAt: DateTime.now().subtract(const Duration(days: 90)),
        isActive: true,
        metadata: {
          'experience_years': 3,
          'projects_completed': 15,
          'security_audits': 8,
        },
      ),
      SkillVerification(
        id: '2',
        userId: 'current_user',
        skillName: 'DeFi Protocol Design',
        skillCategory: 'DeFi',
        description: 'Advanced DeFi protocol architecture and design',
        evidence: [
          'ipfs://QmDeFiDesign1...',
          'ipfs://QmDeFiDesign2...',
        ],
        verifiers: [
          '0x7890abcdef1234567890abcdef1234567890abcd',
        ],
        verifiedAt: DateTime.now().subtract(const Duration(days: 45)),
        isActive: true,
        metadata: {
          'experience_years': 2,
          'protocols_designed': 5,
          'tvl_managed': 1000000.0,
        },
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // Identity management
  Future<void> createIdentity({
    required String did,
    required String controller,
    required List<VerificationMethod> verificationMethods,
    required List<String> services,
    Map<String, dynamic>? metadata,
  }) async {
    final identity = Web3Identity(
      did: did,
      controller: controller,
      status: DIDStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      verificationMethods: verificationMethods,
      services: services,
      metadata: metadata ?? {},
    );

    _identities.add(identity);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateIdentityStatus(String did, DIDStatus status) async {
    final identityIndex = _identities.indexWhere((i) => i.did == did);
    if (identityIndex == -1) return;

    _identities[identityIndex] = _identities[identityIndex].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    await _saveData();
    notifyListeners();
  }

  // Achievement management
  Future<void> issueAchievement({
    required String title,
    required String description,
    required AchievementType type,
    required int points,
    required String recipient,
    required List<String> evidence,
    Map<String, dynamic>? metadata,
  }) async {
    final achievement = Achievement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      type: type,
      points: points,
      issuer: _currentUserId,
      issuedAt: DateTime.now(),
      evidence: evidence,
      metadata: metadata ?? {},
    );

    _achievements.add(achievement);
    await _saveData();
    notifyListeners();
  }

  // Reputation management
  Future<void> addReputationScore({
    required String userId,
    required String sourceId,
    required ReputationSource source,
    required double score,
    required String reason,
    Map<String, dynamic>? metadata,
  }) async {
    final reputationScore = ReputationScore(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      sourceId: sourceId,
      source: source,
      score: score,
      reason: reason,
      scoredAt: DateTime.now(),
      scorerId: _currentUserId,
      metadata: metadata ?? {},
    );

    _reputationScores.add(reputationScore);
    await _saveData();
    notifyListeners();
  }

  // Skill verification
  Future<void> verifySkill({
    required String userId,
    required String skillName,
    required String skillCategory,
    required String description,
    required List<String> evidence,
    Map<String, dynamic>? metadata,
  }) async {
    final skillVerification = SkillVerification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      skillName: skillName,
      skillCategory: skillCategory,
      description: description,
      evidence: evidence,
      verifiers: [_currentUserId],
      verifiedAt: DateTime.now(),
      isActive: true,
      metadata: metadata ?? {},
    );

    _skillVerifications.add(skillVerification);
    await _saveData();
    notifyListeners();
  }

  // Analytics methods
  double getUserTotalReputation(String userId) {
    final userScores = _reputationScores.where((score) => score.userId == userId).toList();
    if (userScores.isEmpty) return 0.0;
    
    final totalScore = userScores.fold(0.0, (sum, score) => sum + score.score);
    return totalScore / userScores.length;
  }

  int getUserTotalPoints(String userId) {
    final userAchievements = _achievements.where((achievement) => achievement.issuer == userId).toList();
    return userAchievements.fold(0, (sum, achievement) => sum + achievement.points);
  }

  Map<String, int> getAchievementTypeDistribution() {
    final distribution = <String, int>{};
    for (final achievement in _achievements) {
      final typeName = achievement.type.name;
      distribution[typeName] = (distribution[typeName] ?? 0) + 1;
    }
    return distribution;
  }

  Map<String, int> getSkillCategoryDistribution() {
    final distribution = <String, int>{};
    for (final skill in _skillVerifications) {
      final categoryName = skill.skillCategory;
      distribution[categoryName] = (distribution[categoryName] ?? 0) + 1;
    }
    return distribution;
  }

  List<Achievement> getTopAchievements() {
    return _achievements
        .toList()
      ..sort((a, b) => b.points.compareTo(a.points));
  }

  // Search methods
  List<Web3Identity> searchIdentities(String query) {
    if (query.isEmpty) return _identities;

    return _identities.where((identity) =>
        identity.did.toLowerCase().contains(query.toLowerCase()) ||
        identity.controller.toLowerCase().contains(query.toLowerCase()) ||
        (identity.metadata['name']?.toString().toLowerCase().contains(query.toLowerCase()) ?? false)).toList();
  }

  List<Achievement> searchAchievements(String query) {
    if (query.isEmpty) return _achievements;

    return _achievements.where((achievement) =>
        achievement.title.toLowerCase().contains(query.toLowerCase()) ||
        achievement.description.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Utility methods
  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }

  // Check if user has specific skill
  bool hasSkill(String userId, String skillName) {
    return _skillVerifications.any((skill) =>
        skill.userId == userId &&
        skill.skillName.toLowerCase() == skillName.toLowerCase() &&
        skill.isActive);
  }

  // Get user's verified skills
  List<SkillVerification> getUserSkills(String userId) {
    return _skillVerifications
        .where((skill) => skill.userId == userId && skill.isActive)
        .toList();
  }
}
