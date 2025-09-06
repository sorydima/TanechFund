import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Proposal Status
enum ProposalStatus {
  draft,      // Черновик
  active,     // Активно для голосования
  passed,     // Принято
  rejected,   // Отклонено
  executed,   // Выполнено
  expired,    // Истекло
}

// Proposal Type
enum ProposalType {
  general,        // Общие предложения
  treasury,       // Управление казной
  protocol,       // Изменения протокола
  governance,     // Изменения в управлении
  emergency,      // Экстренные решения
}

// Voting Power Source
enum VotingPowerSource {
  staked,         // Застейканные токены
  delegated,      // Делегированные голоса
  nft,            // NFT владение
  reputation,     // Репутация в системе
}

// Governance Proposal
class GovernanceProposal {
  final String id;
  final String title;
  final String description;
  final String authorAddress;
  final ProposalType type;
  final ProposalStatus status;
  final DateTime createdAt;
  final DateTime votingStart;
  final DateTime votingEnd;
  final DateTime? executedAt;
  final double quorumRequired;
  final double currentQuorum;
  final int totalVotes;
  final Map<String, dynamic> metadata;
  final List<String> actions; // JSON строки с действиями

  GovernanceProposal({
    required this.id,
    required this.title,
    required this.description,
    required this.authorAddress,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.votingStart,
    required this.votingEnd,
    this.executedAt,
    required this.quorumRequired,
    required this.currentQuorum,
    required this.totalVotes,
    required this.metadata,
    required this.actions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'authorAddress': authorAddress,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'votingStart': votingStart.toIso8601String(),
      'votingEnd': votingEnd.toIso8601String(),
      'executedAt': executedAt?.toIso8601String(),
      'quorumRequired': quorumRequired,
      'currentQuorum': currentQuorum,
      'totalVotes': totalVotes,
      'metadata': metadata,
      'actions': actions,
    };
  }

  factory GovernanceProposal.fromJson(Map<String, dynamic> json) {
    return GovernanceProposal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      authorAddress: json['authorAddress'],
      type: ProposalType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ProposalType.general,
      ),
      status: ProposalStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProposalStatus.draft,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      votingStart: DateTime.parse(json['votingStart']),
      votingEnd: DateTime.parse(json['votingEnd']),
      executedAt: json['executedAt'] != null ? DateTime.parse(json['executedAt']) : null,
      quorumRequired: json['quorumRequired'].toDouble(),
      currentQuorum: json['currentQuorum'].toDouble(),
      totalVotes: json['totalVotes'],
      metadata: Map<String, dynamic>.from(json['metadata']),
      actions: List<String>.from(json['actions']),
    );
  }

  GovernanceProposal copyWith({
    String? id,
    String? title,
    String? description,
    String? authorAddress,
    ProposalType? type,
    ProposalStatus? status,
    DateTime? createdAt,
    DateTime? votingStart,
    DateTime? votingEnd,
    DateTime? executedAt,
    double? quorumRequired,
    double? currentQuorum,
    int? totalVotes,
    Map<String, dynamic>? metadata,
    List<String>? actions,
  }) {
    return GovernanceProposal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorAddress: authorAddress ?? this.authorAddress,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      votingStart: votingStart ?? this.votingStart,
      votingEnd: votingEnd ?? this.votingEnd,
      executedAt: executedAt ?? this.executedAt,
      quorumRequired: quorumRequired ?? this.quorumRequired,
      currentQuorum: currentQuorum ?? this.currentQuorum,
      totalVotes: totalVotes ?? this.totalVotes,
      metadata: metadata ?? this.metadata,
      actions: actions ?? this.actions,
    );
  }
}

// Vote
class Vote {
  final String id;
  final String proposalId;
  final String voterAddress;
  final bool support; // true = за, false = против
  final double votingPower;
  final String? reason;
  final DateTime votedAt;
  final VotingPowerSource powerSource;

  Vote({
    required this.id,
    required this.proposalId,
    required this.voterAddress,
    required this.support,
    required this.votingPower,
    this.reason,
    required this.votedAt,
    required this.powerSource,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proposalId': proposalId,
      'voterAddress': voterAddress,
      'support': support,
      'votingPower': votingPower,
      'reason': reason,
      'votedAt': votedAt.toIso8601String(),
      'powerSource': powerSource.name,
    };
  }

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      proposalId: json['proposalId'],
      voterAddress: json['voterAddress'],
      support: json['support'],
      votingPower: json['votingPower'].toDouble(),
      reason: json['reason'],
      votedAt: DateTime.parse(json['votedAt']),
      powerSource: VotingPowerSource.values.firstWhere(
        (e) => e.name == json['powerSource'],
        orElse: () => VotingPowerSource.staked,
      ),
    );
  }

  Vote copyWith({
    String? id,
    String? proposalId,
    String? voterAddress,
    bool? support,
    double? votingPower,
    String? reason,
    DateTime? votedAt,
    VotingPowerSource? powerSource,
  }) {
    return Vote(
      id: id ?? this.id,
      proposalId: proposalId ?? this.proposalId,
      voterAddress: voterAddress ?? this.voterAddress,
      support: support ?? this.support,
      votingPower: votingPower ?? this.votingPower,
      reason: reason ?? this.reason,
      votedAt: votedAt ?? this.votedAt,
      powerSource: powerSource ?? this.powerSource,
    );
  }
}

// Delegation
class Delegation {
  final String id;
  final String delegatorAddress;
  final String delegateAddress;
  final double amount;
  final DateTime delegatedAt;
  final DateTime? revokedAt;
  final bool isActive;
  final Map<String, dynamic> metadata;

  Delegation({
    required this.id,
    required this.delegatorAddress,
    required this.delegateAddress,
    required this.amount,
    required this.delegatedAt,
    this.revokedAt,
    required this.isActive,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delegatorAddress': delegatorAddress,
      'delegateAddress': delegateAddress,
      'amount': amount,
      'delegatedAt': delegatedAt.toIso8601String(),
      'revokedAt': revokedAt?.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory Delegation.fromJson(Map<String, dynamic> json) {
    return Delegation(
      id: json['id'],
      delegatorAddress: json['delegatorAddress'],
      delegateAddress: json['delegateAddress'],
      amount: json['amount'].toDouble(),
      delegatedAt: DateTime.parse(json['delegatedAt']),
      revokedAt: json['revokedAt'] != null ? DateTime.parse(json['revokedAt']) : null,
      isActive: json['isActive'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Delegation copyWith({
    String? id,
    String? delegatorAddress,
    String? delegateAddress,
    double? amount,
    DateTime? delegatedAt,
    DateTime? revokedAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return Delegation(
      id: id ?? this.id,
      delegatorAddress: delegatorAddress ?? this.delegatorAddress,
      delegateAddress: delegateAddress ?? this.delegateAddress,
      amount: amount ?? this.amount,
      delegatedAt: delegatedAt ?? this.delegatedAt,
      revokedAt: revokedAt ?? this.revokedAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Tokenomics
class Tokenomics {
  final String id;
  final String tokenSymbol;
  final String tokenName;
  final double totalSupply;
  final double circulatingSupply;
  final double stakedSupply;
  final double delegatedSupply;
  final double treasurySupply;
  final double inflationRate;
  final double stakingRewardRate;
  final Map<String, double> distribution; // Распределение токенов
  final Map<String, dynamic> metadata;

  Tokenomics({
    required this.id,
    required this.tokenSymbol,
    required this.tokenName,
    required this.totalSupply,
    required this.circulatingSupply,
    required this.stakedSupply,
    required this.delegatedSupply,
    required this.treasurySupply,
    required this.inflationRate,
    required this.stakingRewardRate,
    required this.distribution,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tokenSymbol': tokenSymbol,
      'tokenName': tokenName,
      'totalSupply': totalSupply,
      'circulatingSupply': circulatingSupply,
      'stakedSupply': stakedSupply,
      'delegatedSupply': delegatedSupply,
      'treasurySupply': treasurySupply,
      'inflationRate': inflationRate,
      'stakingRewardRate': stakingRewardRate,
      'distribution': distribution,
      'metadata': metadata,
    };
  }

  factory Tokenomics.fromJson(Map<String, dynamic> json) {
    return Tokenomics(
      id: json['id'],
      tokenSymbol: json['tokenSymbol'],
      tokenName: json['tokenName'],
      totalSupply: json['totalSupply'].toDouble(),
      circulatingSupply: json['circulatingSupply'].toDouble(),
      stakedSupply: json['stakedSupply'].toDouble(),
      delegatedSupply: json['delegatedSupply'].toDouble(),
      treasurySupply: json['treasurySupply'].toDouble(),
      inflationRate: json['inflationRate'].toDouble(),
      stakingRewardRate: json['stakingRewardRate'].toDouble(),
      distribution: Map<String, double>.from(json['distribution']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Tokenomics copyWith({
    String? id,
    String? tokenSymbol,
    String? tokenName,
    double? totalSupply,
    double? circulatingSupply,
    double? stakedSupply,
    double? delegatedSupply,
    double? treasurySupply,
    double? inflationRate,
    double? stakingRewardRate,
    Map<String, double>? distribution,
    Map<String, dynamic>? metadata,
  }) {
    return Tokenomics(
      id: id ?? this.id,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      tokenName: tokenName ?? this.tokenName,
      totalSupply: totalSupply ?? this.totalSupply,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      stakedSupply: stakedSupply ?? this.stakedSupply,
      delegatedSupply: delegatedSupply ?? this.delegatedSupply,
      treasurySupply: treasurySupply ?? this.treasurySupply,
      inflationRate: inflationRate ?? this.inflationRate,
      stakingRewardRate: stakingRewardRate ?? this.stakingRewardRate,
      distribution: distribution ?? this.distribution,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Governance DAO Provider
class GovernanceDAOProvider extends ChangeNotifier {
  List<GovernanceProposal> _proposals = [];
  List<Vote> _votes = [];
  List<Delegation> _delegations = [];
  late Tokenomics _tokenomics;
  String _currentUserId = 'current_user';

  // Getters
  List<GovernanceProposal> get proposals => _proposals;
  List<Vote> get votes => _votes;
  List<Delegation> get delegations => _delegations;
  Tokenomics get tokenomics => _tokenomics;
  String get currentUserId => _currentUserId;

  List<GovernanceProposal> get activeProposals => _proposals
      .where((proposal) => proposal.status == ProposalStatus.active)
      .toList();

  List<GovernanceProposal> get userProposals => _proposals
      .where((proposal) => proposal.authorAddress == _currentUserId)
      .toList();

  List<Delegation> get userDelegations => _delegations
      .where((delegation) => delegation.delegatorAddress == _currentUserId)
      .toList();

  List<Delegation> get receivedDelegations => _delegations
      .where((delegation) => delegation.delegateAddress == _currentUserId && delegation.isActive)
      .toList();

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_proposals.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final proposalsJson = prefs.getStringList('governance_dao_proposals') ?? [];
      _proposals = proposalsJson
          .map((json) => GovernanceProposal.fromJson(jsonDecode(json)))
          .toList();

      final votesJson = prefs.getStringList('governance_dao_votes') ?? [];
      _votes = votesJson
          .map((json) => Vote.fromJson(jsonDecode(json)))
          .toList();

      final delegationsJson = prefs.getStringList('governance_dao_delegations') ?? [];
      _delegations = delegationsJson
          .map((json) => Delegation.fromJson(jsonDecode(json)))
          .toList();

      final tokenomicsJson = prefs.getString('governance_dao_tokenomics');
      if (tokenomicsJson != null) {
        _tokenomics = Tokenomics.fromJson(jsonDecode(tokenomicsJson));
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Governance DAO data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setStringList('governance_dao_proposals',
          _proposals.map((proposal) => jsonEncode(proposal.toJson())).toList());

      await prefs.setStringList('governance_dao_votes',
          _votes.map((vote) => jsonEncode(vote.toJson())).toList());

      await prefs.setStringList('governance_dao_delegations',
          _delegations.map((delegation) => jsonEncode(delegation.toJson())).toList());

      await prefs.setString('governance_dao_tokenomics', jsonEncode(_tokenomics.toJson()));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Governance DAO data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample tokenomics
    _tokenomics = Tokenomics(
      id: '1',
      tokenSymbol: 'REW',
      tokenName: 'REChain Governance Token',
      totalSupply: 1000000000.0,
      circulatingSupply: 750000000.0,
      stakedSupply: 450000000.0,
      delegatedSupply: 200000000.0,
      treasurySupply: 100000000.0,
      inflationRate: 5.0,
      stakingRewardRate: 12.0,
      distribution: {
        'Community': 40.0,
        'Team': 20.0,
        'Treasury': 15.0,
        'Ecosystem': 15.0,
        'Advisors': 10.0,
      },
      metadata: {
        'decimals': 18,
        'contract_address': '0x1234567890abcdef1234567890abcdef12345678',
        'launch_date': '2024-01-01',
      },
    );

    // Create sample proposals
    _proposals = [
      GovernanceProposal(
        id: '1',
        title: 'Увеличение стейкинг-наград до 15%',
        description: 'Предлагаем увеличить годовые награды за стейкинг REW токенов с 12% до 15% для стимулирования участия в управлении',
        authorAddress: '0x1234567890abcdef1234567890abcdef12345678',
        type: ProposalType.protocol,
        status: ProposalStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        votingStart: DateTime.now().subtract(const Duration(days: 3)),
        votingEnd: DateTime.now().add(const Duration(days: 7)),
        quorumRequired: 10.0,
        currentQuorum: 8.5,
        totalVotes: 1250,
        metadata: {
          'category': 'staking',
          'impact': 'medium',
          'estimated_cost': 50000.0,
        },
        actions: [
          '{"type": "update_staking_rate", "value": 15.0}',
          '{"type": "update_treasury_allocation", "value": 50000.0}',
        ],
      ),
      GovernanceProposal(
        id: '2',
        title: 'Создание фонда для развития экосистемы',
        description: 'Создание фонда в размере 100,000 REW для поддержки стартапов и проектов в экосистеме REChain',
        authorAddress: '0xabcdef1234567890abcdef1234567890abcdef12',
        type: ProposalType.treasury,
        status: ProposalStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        votingStart: DateTime.now().subtract(const Duration(days: 8)),
        votingEnd: DateTime.now().add(const Duration(days: 2)),
        quorumRequired: 15.0,
        currentQuorum: 12.3,
        totalVotes: 890,
        metadata: {
          'category': 'ecosystem',
          'impact': 'high',
          'estimated_cost': 100000.0,
        },
        actions: [
          '{"type": "create_ecosystem_fund", "amount": 100000.0}',
          '{"type": "appoint_fund_managers", "count": 5}',
        ],
      ),
      GovernanceProposal(
        id: '3',
        title: 'Обновление параметров голосования',
        description: 'Изменение минимального кворума с 10% до 8% и минимального времени голосования с 7 до 5 дней',
        authorAddress: '0x7890abcdef1234567890abcdef1234567890abcd',
        type: ProposalType.governance,
        status: ProposalStatus.passed,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        votingStart: DateTime.now().subtract(const Duration(days: 18)),
        votingEnd: DateTime.now().subtract(const Duration(days: 11)),
        executedAt: DateTime.now().subtract(const Duration(days: 10)),
        quorumRequired: 8.0,
        currentQuorum: 12.1,
        totalVotes: 2100,
        metadata: {
          'category': 'governance',
          'impact': 'low',
          'estimated_cost': 0.0,
        },
        actions: [
          '{"type": "update_quorum", "value": 8.0}',
          '{"type": "update_voting_period", "value": 5}',
        ],
      ),
    ];

    // Create sample votes
    _votes = [
      Vote(
        id: '1',
        proposalId: '1',
        voterAddress: '0x1111111111111111111111111111111111111111',
        support: true,
        votingPower: 50000.0,
        reason: 'Поддерживаю увеличение наград для стимулирования участия',
        votedAt: DateTime.now().subtract(const Duration(days: 2)),
        powerSource: VotingPowerSource.staked,
      ),
      Vote(
        id: '2',
        proposalId: '1',
        voterAddress: '0x2222222222222222222222222222222222222222',
        support: false,
        votingPower: 30000.0,
        reason: 'Считаю, что текущие награды достаточны',
        votedAt: DateTime.now().subtract(const Duration(days: 1)),
        powerSource: VotingPowerSource.delegated,
      ),
      Vote(
        id: '3',
        proposalId: '2',
        voterAddress: '0x3333333333333333333333333333333333333333',
        support: true,
        votingPower: 75000.0,
        reason: 'Отличная идея для развития экосистемы',
        votedAt: DateTime.now().subtract(const Duration(days: 5)),
        powerSource: VotingPowerSource.staked,
      ),
    ];

    // Create sample delegations
    _delegations = [
      Delegation(
        id: '1',
        delegatorAddress: '0x4444444444444444444444444444444444444444',
        delegateAddress: '0x2222222222222222222222222222222222222222',
        amount: 50000.0,
        delegatedAt: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
        metadata: {
          'reason': 'Доверяю опыту в DeFi',
          'terms': 'До отзыва',
        },
      ),
      Delegation(
        id: '2',
        delegatorAddress: '0x5555555555555555555555555555555555555555',
        delegateAddress: '0x2222222222222222222222222222222222222222',
        amount: 30000.0,
        delegatedAt: DateTime.now().subtract(const Duration(days: 25)),
        isActive: true,
        metadata: {
          'reason': 'Активный участник сообщества',
          'terms': 'До отзыва',
        },
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // Proposal management
  Future<void> createProposal({
    required String title,
    required String description,
    required ProposalType type,
    required DateTime votingStart,
    required DateTime votingEnd,
    required double quorumRequired,
    required List<String> actions,
    Map<String, dynamic>? metadata,
  }) async {
    final proposal = GovernanceProposal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      authorAddress: _currentUserId,
      type: type,
      status: ProposalStatus.draft,
      createdAt: DateTime.now(),
      votingStart: votingStart,
      votingEnd: votingEnd,
      quorumRequired: quorumRequired,
      currentQuorum: 0.0,
      totalVotes: 0,
      metadata: metadata ?? {},
      actions: actions,
    );

    _proposals.add(proposal);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateProposalStatus(String proposalId, ProposalStatus status) async {
    final proposalIndex = _proposals.indexWhere((p) => p.id == proposalId);
    if (proposalIndex == -1) return;

    _proposals[proposalIndex] = _proposals[proposalIndex].copyWith(
      status: status,
      executedAt: status == ProposalStatus.executed ? DateTime.now() : null,
    );

    await _saveData();
    notifyListeners();
  }

  // Voting
  Future<void> castVote({
    required String proposalId,
    required bool support,
    required double votingPower,
    required VotingPowerSource powerSource,
    String? reason,
  }) async {
    // Check if user already voted
    final existingVoteIndex = _votes.indexWhere(
      (vote) => vote.proposalId == proposalId && vote.voterAddress == _currentUserId,
    );

    if (existingVoteIndex != -1) {
      // Update existing vote
      _votes[existingVoteIndex] = _votes[existingVoteIndex].copyWith(
        support: support,
        votingPower: votingPower,
        reason: reason,
        votedAt: DateTime.now(),
        powerSource: powerSource,
      );
    } else {
      // Create new vote
      final vote = Vote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        proposalId: proposalId,
        voterAddress: _currentUserId,
        support: support,
        votingPower: votingPower,
        reason: reason,
        votedAt: DateTime.now(),
        powerSource: powerSource,
      );
      _votes.add(vote);
    }

    // Update proposal quorum
    await _updateProposalQuorum(proposalId);
    await _saveData();
    notifyListeners();
  }

  Future<void> _updateProposalQuorum(String proposalId) async {
    final proposalIndex = _proposals.indexWhere((p) => p.id == proposalId);
    if (proposalIndex == -1) return;

    final proposal = _proposals[proposalIndex];
    final proposalVotes = _votes.where((v) => v.proposalId == proposalId).toList();
    
    final totalVotingPower = proposalVotes.fold(0.0, (sum, vote) => sum + vote.votingPower);
    final currentQuorum = (totalVotingPower / _tokenomics.totalSupply) * 100;

    _proposals[proposalIndex] = proposal.copyWith(
      currentQuorum: currentQuorum,
      totalVotes: proposalVotes.length,
    );
  }

  // Delegation management
  Future<void> delegateVotes({
    required String delegateAddress,
    required double amount,
    Map<String, dynamic>? metadata,
  }) async {
    final delegation = Delegation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      delegatorAddress: _currentUserId,
      delegateAddress: delegateAddress,
      amount: amount,
      delegatedAt: DateTime.now(),
      isActive: true,
      metadata: metadata ?? {},
    );

    _delegations.add(delegation);
    await _saveData();
    notifyListeners();
  }

  Future<void> revokeDelegation(String delegationId) async {
    final delegationIndex = _delegations.indexWhere((d) => d.id == delegationId);
    if (delegationIndex == -1) return;

    _delegations[delegationIndex] = _delegations[delegationIndex].copyWith(
      isActive: false,
      revokedAt: DateTime.now(),
    );

    await _saveData();
    notifyListeners();
  }

  // Analytics methods
  double getUserVotingPower(String userAddress) {
    // Calculate total voting power from staked tokens and received delegations
    final stakedPower = 100000.0; // This would come from staking provider
    final delegatedPower = _delegations
        .where((d) => d.delegateAddress == userAddress && d.isActive)
        .fold(0.0, (sum, d) => sum + d.amount);
    
    return stakedPower + delegatedPower;
  }

  Map<String, int> getProposalTypeDistribution() {
    final distribution = <String, int>{};
    for (final proposal in _proposals) {
      final typeName = proposal.type.name;
      distribution[typeName] = (distribution[typeName] ?? 0) + 1;
    }
    return distribution;
  }

  Map<String, int> getProposalStatusDistribution() {
    final distribution = <String, int>{};
    for (final proposal in _proposals) {
      final statusName = proposal.status.name;
      distribution[statusName] = (distribution[statusName] ?? 0) + 1;
    }
    return distribution;
  }

  List<GovernanceProposal> getTopProposals() {
    return _proposals
        .where((p) => p.status == ProposalStatus.active)
        .toList()
      ..sort((a, b) => b.totalVotes.compareTo(a.totalVotes));
  }

  // Search methods
  List<GovernanceProposal> searchProposals(String query) {
    if (query.isEmpty) return _proposals;

    return _proposals.where((proposal) =>
        proposal.title.toLowerCase().contains(query.toLowerCase()) ||
        proposal.description.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Utility methods
  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }

  // Check if proposal can be executed
  bool canExecuteProposal(GovernanceProposal proposal) {
    if (proposal.status != ProposalStatus.passed) return false;
    if (DateTime.now().isBefore(proposal.votingEnd)) return false;
    if (proposal.currentQuorum < proposal.quorumRequired) return false;
    
    final supportVotes = _votes
        .where((v) => v.proposalId == proposal.id && v.support)
        .fold(0.0, (sum, v) => sum + v.votingPower);
    
    final totalVotes = _votes
        .where((v) => v.proposalId == proposal.id)
        .fold(0.0, (sum, v) => sum + v.votingPower);
    
    return supportVotes > (totalVotes / 2);
  }
}
