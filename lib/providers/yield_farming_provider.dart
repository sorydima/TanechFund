import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Farming Pool Types
enum FarmingPoolType {
  liquidity,    // Liquidity provision
  staking,      // Token staking
  lending,      // Lending protocols
  yield,        // Yield aggregators
  governance,   // Governance token staking
}

// Farming Pool
class FarmingPool {
  final String id;
  final String name;
  final String description;
  final FarmingPoolType type;
  final String protocol;
  final String chain;
  final List<String> rewardTokens;
  final double totalValueLocked;
  final double apy;
  final double apr;
  final double dailyReward;
  final double minStake;
  final double maxStake;
  final bool isActive;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  FarmingPool({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.protocol,
    required this.chain,
    required this.rewardTokens,
    required this.totalValueLocked,
    required this.apy,
    required this.apr,
    required this.dailyReward,
    required this.minStake,
    required this.maxStake,
    required this.isActive,
    required this.createdAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'protocol': protocol,
      'chain': chain,
      'rewardTokens': rewardTokens,
      'totalValueLocked': totalValueLocked,
      'apy': apy,
      'apr': apr,
      'dailyReward': dailyReward,
      'minStake': minStake,
      'maxStake': maxStake,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory FarmingPool.fromJson(Map<String, dynamic> json) {
    return FarmingPool(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: FarmingPoolType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FarmingPoolType.liquidity,
      ),
      protocol: json['protocol'],
      chain: json['chain'],
      rewardTokens: List<String>.from(json['rewardTokens']),
      totalValueLocked: json['totalValueLocked'].toDouble(),
      apy: json['apy'].toDouble(),
      apr: json['apr'].toDouble(),
      dailyReward: json['dailyReward'].toDouble(),
      minStake: json['minStake'].toDouble(),
      maxStake: json['maxStake'].toDouble(),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  FarmingPool copyWith({
    String? id,
    String? name,
    String? description,
    FarmingPoolType? type,
    String? protocol,
    String? chain,
    List<String>? rewardTokens,
    double? totalValueLocked,
    double? apy,
    double? apr,
    double? dailyReward,
    double? minStake,
    double? maxStake,
    bool? isActive,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return FarmingPool(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      protocol: protocol ?? this.protocol,
      chain: chain ?? this.chain,
      rewardTokens: rewardTokens ?? this.rewardTokens,
      totalValueLocked: totalValueLocked ?? this.totalValueLocked,
      apy: apy ?? this.apy,
      apr: apr ?? this.apr,
      dailyReward: dailyReward ?? this.dailyReward,
      minStake: minStake ?? this.minStake,
      maxStake: maxStake ?? this.maxStake,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Staking Position
class StakingPosition {
  final String id;
  final String poolId;
  final String walletAddress;
  final double stakedAmount;
  final double earnedRewards;
  final double pendingRewards;
  final DateTime stakedAt;
  final DateTime? lastClaimedAt;
  final bool isActive;
  final Map<String, dynamic> metadata;

  StakingPosition({
    required this.id,
    required this.poolId,
    required this.walletAddress,
    required this.stakedAmount,
    required this.earnedRewards,
    required this.pendingRewards,
    required this.stakedAt,
    this.lastClaimedAt,
    required this.isActive,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poolId': poolId,
      'walletAddress': walletAddress,
      'stakedAmount': stakedAmount,
      'earnedRewards': earnedRewards,
      'pendingRewards': pendingRewards,
      'stakedAt': stakedAt.toIso8601String(),
      'lastClaimedAt': lastClaimedAt?.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory StakingPosition.fromJson(Map<String, dynamic> json) {
    return StakingPosition(
      id: json['id'],
      poolId: json['poolId'],
      walletAddress: json['walletAddress'],
      stakedAmount: json['stakedAmount'].toDouble(),
      earnedRewards: json['earnedRewards'].toDouble(),
      pendingRewards: json['pendingRewards'].toDouble(),
      stakedAt: DateTime.parse(json['stakedAt']),
      lastClaimedAt: json['lastClaimedAt'] != null ? DateTime.parse(json['lastClaimedAt']) : null,
      isActive: json['isActive'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  StakingPosition copyWith({
    String? id,
    String? poolId,
    String? walletAddress,
    double? stakedAmount,
    double? earnedRewards,
    double? pendingRewards,
    DateTime? stakedAt,
    DateTime? lastClaimedAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return StakingPosition(
      id: id ?? this.id,
      poolId: poolId ?? this.poolId,
      walletAddress: walletAddress ?? this.walletAddress,
      stakedAmount: stakedAmount ?? this.stakedAmount,
      earnedRewards: earnedRewards ?? this.earnedRewards,
      pendingRewards: pendingRewards ?? this.pendingRewards,
      stakedAt: stakedAt ?? this.stakedAt,
      lastClaimedAt: lastClaimedAt ?? this.lastClaimedAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Reward Token
class RewardToken {
  final String id;
  final String symbol;
  final String name;
  final String address;
  final String chain;
  final double price;
  final double dailyReward;
  final double totalDistributed;
  final Map<String, dynamic> metadata;

  RewardToken({
    required this.id,
    required this.symbol,
    required this.name,
    required this.address,
    required this.chain,
    required this.price,
    required this.dailyReward,
    required this.totalDistributed,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'address': address,
      'chain': chain,
      'price': price,
      'dailyReward': dailyReward,
      'totalDistributed': totalDistributed,
      'metadata': metadata,
    };
  }

  factory RewardToken.fromJson(Map<String, dynamic> json) {
    return RewardToken(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      address: json['address'],
      chain: json['chain'],
      price: json['price'].toDouble(),
      dailyReward: json['dailyReward'].toDouble(),
      totalDistributed: json['totalDistributed'].toDouble(),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  RewardToken copyWith({
    String? id,
    String? symbol,
    String? name,
    String? address,
    String? chain,
    double? price,
    double? dailyReward,
    double? totalDistributed,
    Map<String, dynamic>? metadata,
  }) {
    return RewardToken(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      address: address ?? this.address,
      chain: chain ?? this.chain,
      price: price ?? this.price,
      dailyReward: dailyReward ?? this.dailyReward,
      totalDistributed: totalDistributed ?? this.totalDistributed,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Farming Strategy
class FarmingStrategy {
  final String id;
  final String name;
  final String description;
  final List<String> poolIds;
  final double targetApy;
  final double riskLevel; // 1-10 scale
  final double minInvestment;
  final double maxInvestment;
  final bool isActive;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  FarmingStrategy({
    required this.id,
    required this.name,
    required this.description,
    required this.poolIds,
    required this.targetApy,
    required this.riskLevel,
    required this.minInvestment,
    required this.maxInvestment,
    required this.isActive,
    required this.createdAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'poolIds': poolIds,
      'targetApy': targetApy,
      'riskLevel': riskLevel,
      'minInvestment': minInvestment,
      'maxInvestment': maxInvestment,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory FarmingStrategy.fromJson(Map<String, dynamic> json) {
    return FarmingStrategy(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      poolIds: List<String>.from(json['poolIds']),
      targetApy: json['targetApy'].toDouble(),
      riskLevel: json['riskLevel'].toDouble(),
      minInvestment: json['minInvestment'].toDouble(),
      maxInvestment: json['maxInvestment'].toDouble(),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  FarmingStrategy copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? poolIds,
    double? targetApy,
    double? riskLevel,
    double? minInvestment,
    double? maxInvestment,
    bool? isActive,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return FarmingStrategy(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      poolIds: poolIds ?? this.poolIds,
      targetApy: targetApy ?? this.targetApy,
      riskLevel: riskLevel ?? this.riskLevel,
      minInvestment: minInvestment ?? this.minInvestment,
      maxInvestment: maxInvestment ?? this.maxInvestment,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Yield Farming Provider
class YieldFarmingProvider extends ChangeNotifier {
  List<FarmingPool> _pools = [];
  List<StakingPosition> _positions = [];
  List<RewardToken> _rewardTokens = [];
  List<FarmingStrategy> _strategies = [];
  String _currentUserId = 'current_user';
  String _selectedChain = 'all';
  FarmingPoolType _selectedType = FarmingPoolType.liquidity;

  // Getters
  List<FarmingPool> get pools => _pools;
  List<StakingPosition> get positions => _positions;
  List<RewardToken> get rewardTokens => _rewardTokens;
  List<FarmingStrategy> get strategies => _strategies;
  String get selectedChain => _selectedChain;
  FarmingPoolType get selectedType => _selectedType;

  List<FarmingPool> get filteredPools {
    var filtered = _pools.where((pool) => pool.isActive).toList();
    
    if (_selectedChain != 'all') {
      filtered = filtered.where((pool) => pool.chain == _selectedChain).toList();
    }
    
    if (_selectedType != FarmingPoolType.liquidity) {
      filtered = filtered.where((pool) => pool.type == _selectedType).toList();
    }
    
    return filtered;
  }

  List<StakingPosition> get userPositions => _positions.where((pos) => 
      pos.walletAddress == _currentUserId && pos.isActive).toList();

  List<FarmingPool> get topPools => _pools
      .where((pool) => pool.isActive)
      .toList()
    ..sort((a, b) => b.apy.compareTo(a.apy));

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_pools.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final poolsJson = prefs.getStringList('yield_farming_pools') ?? [];
      _pools = poolsJson
          .map((json) => FarmingPool.fromJson(jsonDecode(json)))
          .toList();

      final positionsJson = prefs.getStringList('yield_farming_positions') ?? [];
      _positions = positionsJson
          .map((json) => StakingPosition.fromJson(jsonDecode(json)))
          .toList();

      final tokensJson = prefs.getStringList('yield_farming_reward_tokens') ?? [];
      _rewardTokens = tokensJson
          .map((json) => RewardToken.fromJson(jsonDecode(json)))
          .toList();

      final strategiesJson = prefs.getStringList('yield_farming_strategies') ?? [];
      _strategies = strategiesJson
          .map((json) => FarmingStrategy.fromJson(jsonDecode(json)))
          .toList();

      _selectedChain = prefs.getString('yield_farming_selected_chain') ?? 'all';
      final selectedTypeString = prefs.getString('yield_farming_selected_type');
      _selectedType = FarmingPoolType.values.firstWhere(
        (e) => e.name == (selectedTypeString ?? 'liquidity'),
        orElse: () => FarmingPoolType.liquidity,
      );

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Yield Farming data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setStringList('yield_farming_pools',
          _pools.map((pool) => jsonEncode(pool.toJson())).toList());

      await prefs.setStringList('yield_farming_positions',
          _positions.map((pos) => jsonEncode(pos.toJson())).toList());

      await prefs.setStringList('yield_farming_reward_tokens',
          _rewardTokens.map((token) => jsonEncode(token.toJson())).toList());

      await prefs.setStringList('yield_farming_strategies',
          _strategies.map((strategy) => jsonEncode(strategy.toJson())).toList());

      await prefs.setString('yield_farming_selected_chain', _selectedChain);
      await prefs.setString('yield_farming_selected_type', _selectedType.name);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Yield Farming data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample reward tokens
    _rewardTokens = [
      RewardToken(
        id: '1',
        symbol: 'REW',
        name: 'Reward Token',
        address: '0x1234567890abcdef1234567890abcdef12345678',
        chain: 'ethereum',
        price: 0.15,
        dailyReward: 1000.0,
        totalDistributed: 50000.0,
        metadata: {
          'decimals': 18,
          'category': 'Governance',
        },
      ),
      RewardToken(
        id: '2',
        symbol: 'FARM',
        name: 'Farm Token',
        address: '0xabcdef1234567890abcdef1234567890abcdef12',
        chain: 'bsc',
        price: 0.08,
        dailyReward: 2500.0,
        totalDistributed: 75000.0,
        metadata: {
          'decimals': 18,
          'category': 'Utility',
        },
      ),
      RewardToken(
        id: '3',
        symbol: 'YIELD',
        name: 'Yield Token',
        address: '0x7890abcdef1234567890abcdef1234567890abcd',
        chain: 'polygon',
        price: 0.25,
        dailyReward: 800.0,
        totalDistributed: 30000.0,
        metadata: {
          'decimals': 18,
          'category': 'Reward',
        },
      ),
    ];

    // Create sample farming pools
    _pools = [
      FarmingPool(
        id: '1',
        name: 'ETH/USDC Liquidity Pool',
        description: 'Provide liquidity for ETH/USDC pair and earn rewards',
        type: FarmingPoolType.liquidity,
        protocol: 'Uniswap V3',
        chain: 'ethereum',
        rewardTokens: ['REW'],
        totalValueLocked: 5000000.0,
        apy: 45.2,
        apr: 37.8,
        dailyReward: 500.0,
        minStake: 100.0,
        maxStake: 100000.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        metadata: {
          'fee_tier': 0.003,
          'concentration': 'medium',
        },
      ),
      FarmingPool(
        id: '2',
        name: 'BNB Staking Pool',
        description: 'Stake BNB and earn passive income',
        type: FarmingPoolType.staking,
        protocol: 'PancakeSwap',
        chain: 'bsc',
        rewardTokens: ['FARM'],
        totalValueLocked: 2500000.0,
        apy: 38.7,
        apr: 32.1,
        dailyReward: 300.0,
        minStake: 50.0,
        maxStake: 50000.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        metadata: {
          'lock_period': 30,
          'early_withdrawal_fee': 0.05,
        },
      ),
      FarmingPool(
        id: '3',
        name: 'MATIC Lending Pool',
        description: 'Lend MATIC and earn interest',
        type: FarmingPoolType.lending,
        protocol: 'Aave',
        chain: 'polygon',
        rewardTokens: ['YIELD'],
        totalValueLocked: 1500000.0,
        apy: 28.5,
        apr: 25.2,
        dailyReward: 200.0,
        minStake: 25.0,
        maxStake: 25000.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        metadata: {
          'collateral_ratio': 0.8,
          'liquidation_threshold': 0.75,
        },
      ),
      FarmingPool(
        id: '4',
        name: 'USDC Yield Aggregator',
        description: 'Automated yield optimization for USDC',
        type: FarmingPoolType.yield,
        protocol: 'Yearn Finance',
        chain: 'ethereum',
        rewardTokens: ['REW', 'YIELD'],
        totalValueLocked: 3000000.0,
        apy: 52.1,
        apr: 43.8,
        dailyReward: 400.0,
        minStake: 1000.0,
        maxStake: 100000.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        metadata: {
          'strategy_count': 5,
          'rebalance_frequency': 'daily',
        },
      ),
      FarmingPool(
        id: '5',
        name: 'REW Governance Staking',
        description: 'Stake REW tokens to participate in governance',
        type: FarmingPoolType.governance,
        protocol: 'REChain DAO',
        chain: 'ethereum',
        rewardTokens: ['REW'],
        totalValueLocked: 800000.0,
        apy: 15.8,
        apr: 14.7,
        dailyReward: 100.0,
        minStake: 10.0,
        maxStake: 10000.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        metadata: {
          'voting_power': true,
          'proposal_creation': false,
        },
      ),
    ];

    // Create sample staking positions
    _positions = [
      StakingPosition(
        id: '1',
        poolId: '1',
        walletAddress: _currentUserId,
        stakedAmount: 2500.0,
        earnedRewards: 125.0,
        pendingRewards: 15.5,
        stakedAt: DateTime.now().subtract(const Duration(days: 15)),
        lastClaimedAt: DateTime.now().subtract(const Duration(days: 3)),
        isActive: true,
        metadata: {
          'pool_name': 'ETH/USDC Liquidity Pool',
          'reward_token': 'REW',
        },
      ),
      StakingPosition(
        id: '2',
        poolId: '2',
        walletAddress: _currentUserId,
        stakedAmount: 1000.0,
        earnedRewards: 45.2,
        pendingRewards: 8.3,
        stakedAt: DateTime.now().subtract(const Duration(days: 20)),
        lastClaimedAt: DateTime.now().subtract(const Duration(days: 7)),
        isActive: true,
        metadata: {
          'pool_name': 'BNB Staking Pool',
          'reward_token': 'FARM',
        },
      ),
    ];

    // Create sample farming strategies
    _strategies = [
      FarmingStrategy(
        id: '1',
        name: 'Conservative Yield',
        description: 'Low-risk strategy focusing on stable pools with moderate APY',
        poolIds: ['3', '5'],
        targetApy: 22.0,
        riskLevel: 3.0,
        minInvestment: 100.0,
        maxInvestment: 10000.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        metadata: {
          'rebalance_frequency': 'weekly',
          'max_single_pool_allocation': 0.6,
        },
      ),
      FarmingStrategy(
        id: '2',
        name: 'Aggressive Growth',
        description: 'High-risk strategy targeting maximum APY through volatile pools',
        poolIds: ['1', '4'],
        targetApy: 48.0,
        riskLevel: 8.0,
        minInvestment: 500.0,
        maxInvestment: 50000.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        metadata: {
          'rebalance_frequency': 'daily',
          'max_single_pool_allocation': 0.8,
        },
      ),
      FarmingStrategy(
        id: '3',
        name: 'Balanced Portfolio',
        description: 'Medium-risk strategy balancing different pool types',
        poolIds: ['1', '2', '3'],
        targetApy: 35.0,
        riskLevel: 5.0,
        minInvestment: 200.0,
        maxInvestment: 20000.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        metadata: {
          'rebalance_frequency': 'bi-weekly',
          'max_single_pool_allocation': 0.4,
        },
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // Filter management
  void selectChain(String chain) {
    _selectedChain = chain;
    _saveData();
    notifyListeners();
  }

  void selectPoolType(FarmingPoolType type) {
    _selectedType = type;
    _saveData();
    notifyListeners();
  }

  // Pool management
  Future<void> addPool(FarmingPool pool) async {
    _pools.add(pool);
    await _saveData();
    notifyListeners();
  }

  Future<void> updatePool(String poolId, Map<String, dynamic> updates) async {
    final poolIndex = _pools.indexWhere((pool) => pool.id == poolId);
    if (poolIndex == -1) return;

    _pools[poolIndex] = _pools[poolIndex].copyWith(
      totalValueLocked: updates['totalValueLocked'] ?? _pools[poolIndex].totalValueLocked,
      apy: updates['apy'] ?? _pools[poolIndex].apy,
      apr: updates['apr'] ?? _pools[poolIndex].apr,
      dailyReward: updates['dailyReward'] ?? _pools[poolIndex].dailyReward,
    );

    await _saveData();
    notifyListeners();
  }

  // Position management
  Future<StakingPosition?> createStakingPosition({
    required String poolId,
    required double amount,
    required String walletAddress,
  }) async {
    final pool = _pools.firstWhere((p) => p.id == poolId);
    if (amount < pool.minStake || amount > pool.maxStake) {
      return null;
    }

    final position = StakingPosition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      poolId: poolId,
      walletAddress: walletAddress,
      stakedAmount: amount,
      earnedRewards: 0.0,
      pendingRewards: 0.0,
      stakedAt: DateTime.now(),
      isActive: true,
      metadata: {
        'pool_name': pool.name,
        'reward_token': pool.rewardTokens.isNotEmpty ? pool.rewardTokens.first : '',
      },
    );

    _positions.add(position);
    await _saveData();
    notifyListeners();
    return position;
  }

  Future<bool> unstakePosition(String positionId) async {
    final positionIndex = _positions.indexWhere((pos) => pos.id == positionId);
    if (positionIndex == -1) return false;

    _positions[positionIndex] = _positions[positionIndex].copyWith(
      isActive: false,
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  Future<bool> claimRewards(String positionId) async {
    final positionIndex = _positions.indexWhere((pos) => pos.id == positionId);
    if (positionIndex == -1) return false;

    final position = _positions[positionIndex];
    if (position.pendingRewards <= 0) return false;

    _positions[positionIndex] = position.copyWith(
      earnedRewards: position.earnedRewards + position.pendingRewards,
      pendingRewards: 0.0,
      lastClaimedAt: DateTime.now(),
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  // Strategy management
  Future<void> addStrategy(FarmingStrategy strategy) async {
    _strategies.add(strategy);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateStrategy(String strategyId, Map<String, dynamic> updates) async {
    final strategyIndex = _strategies.indexWhere((s) => s.id == strategyId);
    if (strategyIndex == -1) return;

    _strategies[strategyIndex] = _strategies[strategyIndex].copyWith(
      targetApy: updates['targetApy'] ?? _strategies[strategyIndex].targetApy,
      riskLevel: updates['riskLevel'] ?? _strategies[strategyIndex].riskLevel,
      isActive: updates['isActive'] ?? _strategies[strategyIndex].isActive,
    );

    await _saveData();
    notifyListeners();
  }

  // Analytics methods
  double getTotalValueLocked() {
    return _pools.fold(0.0, (sum, pool) => sum + pool.totalValueLocked);
  }

  double getAverageAPY() {
    if (_pools.isEmpty) return 0.0;
    final totalAPY = _pools.fold(0.0, (sum, pool) => sum + pool.apy);
    return totalAPY / _pools.length;
  }

  double getTotalDailyRewards() {
    return _pools.fold(0.0, (sum, pool) => sum + pool.dailyReward);
  }

  Map<String, double> getChainDistribution() {
    final distribution = <String, double>{};
    for (final pool in _pools) {
      distribution[pool.chain] = (distribution[pool.chain] ?? 0.0) + pool.totalValueLocked;
    }
    return distribution;
  }

  Map<String, double> getTypeDistribution() {
    final distribution = <String, double>{};
    for (final pool in _pools) {
      final typeName = pool.type.name;
      distribution[typeName] = (distribution[typeName] ?? 0.0) + pool.totalValueLocked;
    }
    return distribution;
  }

  // Search methods
  List<FarmingPool> searchPools(String query) {
    if (query.isEmpty) return _pools;

    return _pools.where((pool) =>
        pool.name.toLowerCase().contains(query.toLowerCase()) ||
        pool.description.toLowerCase().contains(query.toLowerCase()) ||
        pool.protocol.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<FarmingStrategy> searchStrategies(String query) {
    if (query.isEmpty) return _strategies;

    return _strategies.where((strategy) =>
        strategy.name.toLowerCase().contains(query.toLowerCase()) ||
        strategy.description.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Utility methods
  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }

  // Simulate daily rewards update
  void updateDailyRewards() {
    for (final position in _positions) {
      if (position.isActive) {
        final pool = _pools.firstWhere((p) => p.id == position.poolId);
        final dailyReward = (position.stakedAmount * pool.apy / 365) / 100;
        
        final positionIndex = _positions.indexWhere((p) => p.id == position.id);
        if (positionIndex != -1) {
          _positions[positionIndex] = position.copyWith(
            pendingRewards: position.pendingRewards + dailyReward,
          );
        }
      }
    }
    _saveData();
    notifyListeners();
  }
}
