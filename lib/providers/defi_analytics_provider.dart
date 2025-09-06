import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// DeFi Protocol Analytics Model
class DeFiProtocolAnalytics {
  final String id;
  final String protocolName;
  final String protocolType; // 'dex', 'lending', 'yield_farming', 'derivatives'
  final String blockchain;
  final double totalValueLocked;
  final double dailyVolume;
  final double dailyFees;
  final double apy;
  final double apy7d;
  final double apy30d;
  final int activeUsers;
  final int totalTransactions;
  final double marketCap;
  final double price;
  final double priceChange24h;
  final double priceChange7d;
  final DateTime lastUpdated;
  final Map<String, dynamic> metadata;

  DeFiProtocolAnalytics({
    required this.id,
    required this.protocolName,
    required this.protocolType,
    required this.blockchain,
    required this.totalValueLocked,
    required this.dailyVolume,
    required this.dailyFees,
    required this.apy,
    required this.apy7d,
    required this.apy30d,
    required this.activeUsers,
    required this.totalTransactions,
    required this.marketCap,
    required this.price,
    required this.priceChange24h,
    required this.priceChange7d,
    required this.lastUpdated,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'protocolName': protocolName,
      'protocolType': protocolType,
      'blockchain': blockchain,
      'totalValueLocked': totalValueLocked,
      'dailyVolume': dailyVolume,
      'dailyFees': dailyFees,
      'apy': apy,
      'apy7d': apy7d,
      'apy30d': apy30d,
      'activeUsers': activeUsers,
      'totalTransactions': totalTransactions,
      'marketCap': marketCap,
      'price': price,
      'priceChange24h': priceChange24h,
      'priceChange7d': priceChange7d,
      'lastUpdated': lastUpdated.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory DeFiProtocolAnalytics.fromJson(Map<String, dynamic> json) {
    return DeFiProtocolAnalytics(
      id: json['id'],
      protocolName: json['protocolName'],
      protocolType: json['protocolType'],
      blockchain: json['blockchain'],
      totalValueLocked: json['totalValueLocked'].toDouble(),
      dailyVolume: json['dailyVolume'].toDouble(),
      dailyFees: json['dailyFees'].toDouble(),
      apy: json['apy'].toDouble(),
      apy7d: json['apy7d'].toDouble(),
      apy30d: json['apy30d'].toDouble(),
      activeUsers: json['activeUsers'],
      totalTransactions: json['totalTransactions'],
      marketCap: json['marketCap'].toDouble(),
      price: json['price'].toDouble(),
      priceChange24h: json['priceChange24h'].toDouble(),
      priceChange7d: json['priceChange7d'].toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }
}

// Yield Farming Pool Model
class YieldFarmingPool {
  final String id;
  final String poolName;
  final String protocolName;
  final String token0;
  final String token1;
  final double totalStaked;
  final double apy;
  final double apy7d;
  final double apy30d;
  final double rewardsPerDay;
  final String rewardToken;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final Map<String, dynamic> metadata;

  YieldFarmingPool({
    required this.id,
    required this.poolName,
    required this.protocolName,
    required this.token0,
    required this.token1,
    required this.totalStaked,
    required this.apy,
    required this.apy7d,
    required this.apy30d,
    required this.rewardsPerDay,
    required this.rewardToken,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poolName': poolName,
      'protocolName': protocolName,
      'token0': token0,
      'token1': token1,
      'totalStaked': totalStaked,
      'apy': apy,
      'apy7d': apy7d,
      'apy30d': apy30d,
      'rewardsPerDay': rewardsPerDay,
      'rewardToken': rewardToken,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory YieldFarmingPool.fromJson(Map<String, dynamic> json) {
    return YieldFarmingPool(
      id: json['id'],
      poolName: json['poolName'],
      protocolName: json['protocolName'],
      token0: json['token0'],
      token1: json['token1'],
      totalStaked: json['totalStaked'].toDouble(),
      apy: json['apy'].toDouble(),
      apy7d: json['apy7d'].toDouble(),
      apy30d: json['apy30d'].toDouble(),
      rewardsPerDay: json['rewardsPerDay'].toDouble(),
      rewardToken: json['rewardToken'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }
}

// Liquidity Pool Model
class LiquidityPool {
  final String id;
  final String poolName;
  final String protocolName;
  final String token0;
  final String token1;
  final double reserve0;
  final double reserve1;
  final double totalSupply;
  final double volume24h;
  final double fees24h;
  final double apy;
  final double impermanentLoss;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  LiquidityPool({
    required this.id,
    required this.poolName,
    required this.protocolName,
    required this.token0,
    required this.token1,
    required this.reserve0,
    required this.reserve1,
    required this.totalSupply,
    required this.volume24h,
    required this.fees24h,
    required this.apy,
    required this.impermanentLoss,
    required this.createdAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poolName': poolName,
      'protocolName': protocolName,
      'token0': token0,
      'token1': token1,
      'reserve0': reserve0,
      'reserve1': reserve1,
      'totalSupply': totalSupply,
      'volume24h': volume24h,
      'fees24h': fees24h,
      'apy': apy,
      'impermanentLoss': impermanentLoss,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory LiquidityPool.fromJson(Map<String, dynamic> json) {
    return LiquidityPool(
      id: json['id'],
      poolName: json['poolName'],
      protocolName: json['protocolName'],
      token0: json['token0'],
      token1: json['token1'],
      reserve0: json['reserve0'].toDouble(),
      reserve1: json['reserve1'].toDouble(),
      totalSupply: json['totalSupply'].toDouble(),
      volume24h: json['volume24h'].toDouble(),
      fees24h: json['fees24h'].toDouble(),
      apy: json['apy'].toDouble(),
      impermanentLoss: json['impermanentLoss'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }
}

// DeFi Analytics Provider
class DeFiAnalyticsProvider extends ChangeNotifier {
  List<DeFiProtocolAnalytics> _protocols = [];
  List<YieldFarmingPool> _farmingPools = [];
  List<LiquidityPool> _liquidityPools = [];
  String _currentUserId = 'current_user';

  // Getters
  List<DeFiProtocolAnalytics> get protocols => _protocols;
  List<YieldFarmingPool> get farmingPools => _farmingPools;
  List<LiquidityPool> get liquidityPools => _liquidityPools;

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_protocols.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final protocolsJson = prefs.getStringList('defi_analytics_protocols') ?? [];
      _protocols = protocolsJson
          .map((json) => DeFiProtocolAnalytics.fromJson(jsonDecode(json)))
          .toList();

      final farmingPoolsJson = prefs.getStringList('defi_analytics_farming_pools') ?? [];
      _farmingPools = farmingPoolsJson
          .map((json) => YieldFarmingPool.fromJson(jsonDecode(json)))
          .toList();

      final liquidityPoolsJson = prefs.getStringList('defi_analytics_liquidity_pools') ?? [];
      _liquidityPools = liquidityPoolsJson
          .map((json) => LiquidityPool.fromJson(jsonDecode(json)))
          .toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading DeFi Analytics data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setStringList('defi_analytics_protocols', 
          _protocols.map((protocol) => jsonEncode(protocol.toJson())).toList());
      
      await prefs.setStringList('defi_analytics_farming_pools', 
          _farmingPools.map((pool) => jsonEncode(pool.toJson())).toList());
      
      await prefs.setStringList('defi_analytics_liquidity_pools', 
          _liquidityPools.map((pool) => jsonEncode(pool.toJson())).toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving DeFi Analytics data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample protocols
    _protocols = [
      DeFiProtocolAnalytics(
        id: '1',
        protocolName: 'Uniswap V3',
        protocolType: 'dex',
        blockchain: 'ethereum',
        totalValueLocked: 2500000000.0,
        dailyVolume: 150000000.0,
        dailyFees: 450000.0,
        apy: 12.5,
        apy7d: 11.8,
        apy30d: 10.2,
        activeUsers: 45000,
        totalTransactions: 1250000,
        marketCap: 8500000000.0,
        price: 8.50,
        priceChange24h: 2.3,
        priceChange7d: -1.2,
        lastUpdated: DateTime.now(),
        metadata: {
          'version': '3.0',
          'fee_tiers': [0.01, 0.05, 0.3, 1.0],
          'concentrated_liquidity': true,
        },
      ),
      DeFiProtocolAnalytics(
        id: '2',
        protocolName: 'Aave V3',
        protocolType: 'lending',
        blockchain: 'ethereum',
        totalValueLocked: 1800000000.0,
        dailyVolume: 25000000.0,
        dailyFees: 180000.0,
        apy: 8.2,
        apy7d: 8.5,
        apy30d: 7.8,
        activeUsers: 28000,
        totalTransactions: 850000,
        marketCap: 1200000000.0,
        price: 120.0,
        priceChange24h: 1.8,
        priceChange7d: 3.2,
        lastUpdated: DateTime.now(),
        metadata: {
          'version': '3.0',
          'cross_chain': true,
          'risk_adjustment': true,
        },
      ),
      DeFiProtocolAnalytics(
        id: '3',
        protocolName: 'Compound V3',
        protocolType: 'lending',
        blockchain: 'ethereum',
        totalValueLocked: 950000000.0,
        dailyVolume: 18000000.0,
        dailyFees: 95000.0,
        apy: 7.8,
        apy7d: 8.1,
        apy30d: 7.5,
        activeUsers: 22000,
        totalTransactions: 650000,
        marketCap: 850000000.0,
        price: 85.0,
        priceChange24h: -0.5,
        priceChange7d: 1.8,
        lastUpdated: DateTime.now(),
        metadata: {
          'version': '3.0',
          'e_mode': true,
          'collateral_factor': 0.8,
        },
      ),
      DeFiProtocolAnalytics(
        id: '4',
        protocolName: 'Curve Finance',
        protocolType: 'dex',
        blockchain: 'ethereum',
        totalValueLocked: 3200000000.0,
        dailyVolume: 85000000.0,
        dailyFees: 280000.0,
        apy: 15.2,
        apy7d: 14.8,
        apy30d: 13.5,
        activeUsers: 35000,
        totalTransactions: 950000,
        marketCap: 2800000000.0,
        price: 2.80,
        priceChange24h: 3.2,
        priceChange7d: 5.8,
        lastUpdated: DateTime.now(),
        metadata: {
          'amm_type': 'constant_product',
          'stable_swap': true,
          'gauge_system': true,
        },
      ),
    ];

    // Create sample farming pools
    _farmingPools = [
      YieldFarmingPool(
        id: '1',
        poolName: 'USDC-ETH LP',
        protocolName: 'Uniswap V3',
        token0: 'USDC',
        token1: 'ETH',
        totalStaked: 45000000.0,
        apy: 18.5,
        apy7d: 17.8,
        apy30d: 16.2,
        rewardsPerDay: 22500.0,
        rewardToken: 'UNI',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
        metadata: {
          'fee_tier': 0.3,
          'concentrated_range': 'medium',
        },
      ),
      YieldFarmingPool(
        id: '2',
        poolName: 'DAI-USDC LP',
        protocolName: 'Curve Finance',
        token0: 'DAI',
        token1: 'USDC',
        totalStaked: 28000000.0,
        apy: 12.8,
        apy7d: 12.5,
        apy30d: 11.8,
        rewardsPerDay: 12000.0,
        rewardToken: 'CRV',
        startDate: DateTime.now().subtract(const Duration(days: 45)),
        isActive: true,
        metadata: {
          'pool_type': 'stable',
          'gauge_weight': 0.8,
        },
      ),
      YieldFarmingPool(
        id: '3',
        poolName: 'WBTC-ETH LP',
        protocolName: 'Uniswap V3',
        token0: 'WBTC',
        token1: 'ETH',
        totalStaked: 32000000.0,
        apy: 22.5,
        apy7d: 21.8,
        apy30d: 20.2,
        rewardsPerDay: 28000.0,
        rewardToken: 'UNI',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        isActive: true,
        metadata: {
          'fee_tier': 0.05,
          'concentrated_range': 'wide',
        },
      ),
    ];

    // Create sample liquidity pools
    _liquidityPools = [
      LiquidityPool(
        id: '1',
        poolName: 'USDC-ETH',
        protocolName: 'Uniswap V3',
        token0: 'USDC',
        token1: 'ETH',
        reserve0: 50000000.0,
        reserve1: 25000.0,
        totalSupply: 1000000.0,
        volume24h: 8500000.0,
        fees24h: 25500.0,
        apy: 18.5,
        impermanentLoss: -0.8,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        metadata: {
          'fee_tier': 0.3,
          'liquidity_range': 'medium',
        },
      ),
      LiquidityPool(
        id: '2',
        poolName: 'DAI-USDC',
        protocolName: 'Curve Finance',
        token0: 'DAI',
        token1: 'USDC',
        reserve0: 40000000.0,
        reserve1: 40000000.0,
        totalSupply: 80000000.0,
        volume24h: 2500000.0,
        fees24h: 7500.0,
        apy: 12.8,
        impermanentLoss: -0.2,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        metadata: {
          'pool_type': 'stable',
          'amplification': 100,
        },
      ),
      LiquidityPool(
        id: '3',
        poolName: 'WBTC-ETH',
        protocolName: 'Uniswap V3',
        token0: 'WBTC',
        token1: 'ETH',
        reserve0: 800.0,
        reserve1: 12000.0,
        totalSupply: 400000.0,
        volume24h: 1800000.0,
        fees24h: 5400.0,
        apy: 22.5,
        impermanentLoss: -1.5,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        metadata: {
          'fee_tier': 0.05,
          'liquidity_range': 'wide',
        },
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // Protocol methods
  List<DeFiProtocolAnalytics> getProtocolsByType(String type) {
    return _protocols.where((protocol) => protocol.protocolType == type).toList();
  }

  List<DeFiProtocolAnalytics> getProtocolsByBlockchain(String blockchain) {
    return _protocols.where((protocol) => protocol.blockchain == blockchain).toList();
  }

  List<DeFiProtocolAnalytics> getTopProtocolsByTVL(int limit) {
    final sorted = List<DeFiProtocolAnalytics>.from(_protocols);
    sorted.sort((a, b) => b.totalValueLocked.compareTo(a.totalValueLocked));
    return sorted.take(limit).toList();
  }

  List<DeFiProtocolAnalytics> getTopProtocolsByVolume(int limit) {
    final sorted = List<DeFiProtocolAnalytics>.from(_protocols);
    sorted.sort((a, b) => b.dailyVolume.compareTo(a.dailyVolume));
    return sorted.take(limit).toList();
  }

  List<DeFiProtocolAnalytics> getTopProtocolsByAPY(int limit) {
    final sorted = List<DeFiProtocolAnalytics>.from(_protocols);
    sorted.sort((a, b) => b.apy.compareTo(a.apy));
    return sorted.take(limit).toList();
  }

  // Farming pool methods
  List<YieldFarmingPool> getFarmingPoolsByProtocol(String protocolName) {
    return _farmingPools.where((pool) => pool.protocolName == protocolName).toList();
  }

  List<YieldFarmingPool> getTopFarmingPoolsByAPY(int limit) {
    final sorted = List<YieldFarmingPool>.from(_farmingPools);
    sorted.sort((a, b) => b.apy.compareTo(a.apy));
    return sorted.take(limit).toList();
  }

  List<YieldFarmingPool> getActiveFarmingPools() {
    return _farmingPools.where((pool) => pool.isActive).toList();
  }

  // Liquidity pool methods
  List<LiquidityPool> getLiquidityPoolsByProtocol(String protocolName) {
    return _liquidityPools.where((pool) => pool.protocolName == protocolName).toList();
  }

  List<LiquidityPool> getTopLiquidityPoolsByVolume(int limit) {
    final sorted = List<LiquidityPool>.from(_liquidityPools);
    sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
    return sorted.take(limit).toList();
  }

  List<LiquidityPool> getTopLiquidityPoolsByAPY(int limit) {
    final sorted = List<LiquidityPool>.from(_liquidityPools);
    sorted.sort((a, b) => b.apy.compareTo(a.apy));
    return sorted.take(limit).toList();
  }

  // Analytics methods
  double getTotalTVL() {
    return _protocols.fold(0.0, (sum, protocol) => sum + protocol.totalValueLocked);
  }

  double getTotalDailyVolume() {
    return _protocols.fold(0.0, (sum, protocol) => sum + protocol.dailyVolume);
  }

  double getTotalDailyFees() {
    return _protocols.fold(0.0, (sum, protocol) => sum + protocol.dailyFees);
  }

  double getAverageAPY() {
    if (_protocols.isEmpty) return 0.0;
    final totalAPY = _protocols.fold(0.0, (sum, protocol) => sum + protocol.apy);
    return totalAPY / _protocols.length;
  }

  Map<String, double> getTVLByProtocolType() {
    final Map<String, double> tvlByType = {};
    for (final protocol in _protocols) {
      tvlByType[protocol.protocolType] = (tvlByType[protocol.protocolType] ?? 0.0) + protocol.totalValueLocked;
    }
    return tvlByType;
  }

  Map<String, double> getTVLByBlockchain() {
    final Map<String, double> tvlByChain = {};
    for (final protocol in _protocols) {
      tvlByChain[protocol.blockchain] = (tvlByChain[protocol.blockchain] ?? 0.0) + protocol.totalValueLocked;
    }
    return tvlByChain;
  }

  Map<String, int> getProtocolCountByType() {
    final Map<String, int> countByType = {};
    for (final protocol in _protocols) {
      countByType[protocol.protocolType] = (countByType[protocol.protocolType] ?? 0) + 1;
    }
    return countByType;
  }

  // Search methods
  List<DeFiProtocolAnalytics> searchProtocols(String query) {
    if (query.isEmpty) return _protocols;
    
    return _protocols.where((protocol) =>
        protocol.protocolName.toLowerCase().contains(query.toLowerCase()) ||
        protocol.protocolType.toLowerCase().contains(query.toLowerCase()) ||
        protocol.blockchain.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<YieldFarmingPool> searchFarmingPools(String query) {
    if (query.isEmpty) return _farmingPools;
    
    return _farmingPools.where((pool) =>
        pool.poolName.toLowerCase().contains(query.toLowerCase()) ||
        pool.protocolName.toLowerCase().contains(query.toLowerCase()) ||
        pool.token0.toLowerCase().contains(query.toLowerCase()) ||
        pool.token1.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<LiquidityPool> searchLiquidityPools(String query) {
    if (query.isEmpty) return _liquidityPools;
    
    return _liquidityPools.where((pool) =>
        pool.poolName.toLowerCase().contains(query.toLowerCase()) ||
        pool.protocolName.toLowerCase().contains(query.toLowerCase()) ||
        pool.token0.toLowerCase().contains(query.toLowerCase()) ||
        pool.token1.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }
}
