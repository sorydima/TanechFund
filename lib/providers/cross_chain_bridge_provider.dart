import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Cross-chain Bridge Transaction Model
class BridgeTransaction {
  final String id;
  final String sourceBlockchain;
  final String destinationBlockchain;
  final String sourceAddress;
  final String destinationAddress;
  final String tokenSymbol;
  final double amount;
  final String status; // 'pending', 'processing', 'completed', 'failed', 'cancelled'
  final DateTime createdAt;
  final DateTime? completedAt;
  final double bridgeFee;
  final String bridgeProvider; // 'multichain', 'stargate', 'hop', 'custom'
  final Map<String, dynamic> metadata;
  final String? transactionHash;
  final String? errorMessage;

  BridgeTransaction({
    required this.id,
    required this.sourceBlockchain,
    required this.destinationBlockchain,
    required this.sourceAddress,
    required this.destinationAddress,
    required this.tokenSymbol,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.completedAt,
    required this.bridgeFee,
    required this.bridgeProvider,
    required this.metadata,
    this.transactionHash,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceBlockchain': sourceBlockchain,
      'destinationBlockchain': destinationBlockchain,
      'sourceAddress': sourceAddress,
      'destinationAddress': destinationAddress,
      'tokenSymbol': tokenSymbol,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'bridgeFee': bridgeFee,
      'bridgeProvider': bridgeProvider,
      'metadata': metadata,
      'transactionHash': transactionHash,
      'errorMessage': errorMessage,
    };
  }

  factory BridgeTransaction.fromJson(Map<String, dynamic> json) {
    return BridgeTransaction(
      id: json['id'],
      sourceBlockchain: json['sourceBlockchain'],
      destinationBlockchain: json['destinationBlockchain'],
      sourceAddress: json['sourceAddress'],
      destinationAddress: json['destinationAddress'],
      tokenSymbol: json['tokenSymbol'],
      amount: json['amount'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      bridgeFee: json['bridgeFee'].toDouble(),
      bridgeProvider: json['bridgeProvider'],
      metadata: Map<String, dynamic>.from(json['metadata']),
      transactionHash: json['transactionHash'],
      errorMessage: json['errorMessage'],
    );
  }

  BridgeTransaction copyWith({
    String? id,
    String? sourceBlockchain,
    String? destinationBlockchain,
    String? sourceAddress,
    String? destinationAddress,
    String? tokenSymbol,
    double? amount,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
    double? bridgeFee,
    String? bridgeProvider,
    Map<String, dynamic>? metadata,
    String? transactionHash,
    String? errorMessage,
  }) {
    return BridgeTransaction(
      id: id ?? this.id,
      sourceBlockchain: sourceBlockchain ?? this.sourceBlockchain,
      destinationBlockchain: destinationBlockchain ?? this.destinationBlockchain,
      sourceAddress: sourceAddress ?? this.sourceAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      bridgeFee: bridgeFee ?? this.bridgeFee,
      bridgeProvider: bridgeProvider ?? this.bridgeProvider,
      metadata: metadata ?? this.metadata,
      transactionHash: transactionHash ?? this.transactionHash,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Bridge Route Model
class BridgeRoute {
  final String id;
  final String sourceBlockchain;
  final String destinationBlockchain;
  final List<String> supportedTokens;
  final double minAmount;
  final double maxAmount;
  final double bridgeFee;
  final double estimatedTime; // in minutes
  final String bridgeProvider;
  final bool isActive;
  final Map<String, dynamic> metadata;

  BridgeRoute({
    required this.id,
    required this.sourceBlockchain,
    required this.destinationBlockchain,
    required this.supportedTokens,
    required this.minAmount,
    required this.maxAmount,
    required this.bridgeFee,
    required this.estimatedTime,
    required this.bridgeProvider,
    required this.isActive,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceBlockchain': sourceBlockchain,
      'destinationBlockchain': destinationBlockchain,
      'supportedTokens': supportedTokens,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'bridgeFee': bridgeFee,
      'estimatedTime': estimatedTime,
      'bridgeProvider': bridgeProvider,
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory BridgeRoute.fromJson(Map<String, dynamic> json) {
    return BridgeRoute(
      id: json['id'],
      sourceBlockchain: json['sourceBlockchain'],
      destinationBlockchain: json['destinationBlockchain'],
      supportedTokens: List<String>.from(json['supportedTokens']),
      minAmount: json['minAmount'].toDouble(),
      maxAmount: json['maxAmount'].toDouble(),
      bridgeFee: json['bridgeFee'].toDouble(),
      estimatedTime: json['estimatedTime'].toDouble(),
      bridgeProvider: json['bridgeProvider'],
      isActive: json['isActive'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }
}

// Bridge Provider Model
class BridgeProvider {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final List<String> supportedBlockchains;
  final List<String> supportedTokens;
  final double averageFee;
  final double averageTime; // in minutes
  final bool isVerified;
  final String website;
  final Map<String, dynamic> metadata;

  BridgeProvider({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.supportedBlockchains,
    required this.supportedTokens,
    required this.averageFee,
    required this.averageTime,
    required this.isVerified,
    required this.website,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'supportedBlockchains': supportedBlockchains,
      'supportedTokens': supportedTokens,
      'averageFee': averageFee,
      'averageTime': averageTime,
      'isVerified': isVerified,
      'website': website,
      'metadata': metadata,
    };
  }

  factory BridgeProvider.fromJson(Map<String, dynamic> json) {
    return BridgeProvider(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logoUrl: json['logoUrl'],
      supportedBlockchains: List<String>.from(json['supportedBlockchains']),
      supportedTokens: List<String>.from(json['supportedTokens']),
      averageFee: json['averageFee'].toDouble(),
      averageTime: json['averageTime'].toDouble(),
      isVerified: json['isVerified'],
      website: json['website'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }
}

// Cross-chain Bridge Provider
class CrossChainBridgeProvider extends ChangeNotifier {
  List<BridgeTransaction> _transactions = [];
  List<BridgeRoute> _routes = [];
  List<BridgeProvider> _providers = [];
  String _currentUserId = 'current_user';

  // Getters
  List<BridgeTransaction> get transactions => _transactions;
  List<BridgeRoute> get routes => _routes;
  List<BridgeProvider> get providers => _providers;

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_transactions.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final transactionsJson = prefs.getStringList('cross_chain_bridge_transactions') ?? [];
      _transactions = transactionsJson
          .map((json) => BridgeTransaction.fromJson(jsonDecode(json)))
          .toList();

      final routesJson = prefs.getStringList('cross_chain_bridge_routes') ?? [];
      _routes = routesJson
          .map((json) => BridgeRoute.fromJson(jsonDecode(json)))
          .toList();

      final providersJson = prefs.getStringList('cross_chain_bridge_providers') ?? [];
      _providers = providersJson
          .map((json) => BridgeProvider.fromJson(jsonDecode(json)))
          .toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Cross-chain Bridge data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setStringList('cross_chain_bridge_transactions', 
          _transactions.map((tx) => jsonEncode(tx.toJson())).toList());
      
      await prefs.setStringList('cross_chain_bridge_routes', 
          _routes.map((route) => jsonEncode(route.toJson())).toList());
      
      await prefs.setStringList('cross_chain_bridge_providers', 
          _providers.map((provider) => jsonEncode(provider.toJson())).toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Cross-chain Bridge data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample providers
    _providers = [
      BridgeProvider(
        id: '1',
        name: 'Multichain',
        description: 'Децентрализованный кросс-чейн мост для передачи активов',
        logoUrl: 'https://via.placeholder.com/100x100/6366f1/ffffff?text=M',
        supportedBlockchains: ['ethereum', 'binance', 'polygon', 'avalanche', 'arbitrum'],
        supportedTokens: ['USDC', 'USDT', 'ETH', 'BTC', 'DAI'],
        averageFee: 0.1,
        averageTime: 15.0,
        isVerified: true,
        website: 'https://multichain.org',
        metadata: {
          'security_score': 95,
          'total_volume': 1000000.0,
          'supported_chains': 25,
        },
      ),
      BridgeProvider(
        id: '2',
        name: 'Stargate',
        description: 'Мост для передачи нативных токенов между блокчейнами',
        logoUrl: 'https://via.placeholder.com/100x100/10b981/ffffff?text=S',
        supportedBlockchains: ['ethereum', 'binance', 'polygon', 'avalanche', 'fantom'],
        supportedTokens: ['USDC', 'USDT', 'ETH', 'BNB', 'MATIC'],
        averageFee: 0.05,
        averageTime: 10.0,
        isVerified: true,
        website: 'https://stargateprotocol.com',
        metadata: {
          'security_score': 98,
          'total_volume': 5000000.0,
          'supported_chains': 15,
        },
      ),
      BridgeProvider(
        id: '3',
        name: 'Hop Protocol',
        description: 'Быстрый мост для L2 решений Ethereum',
        logoUrl: 'https://via.placeholder.com/100x100/f59e0b/ffffff?text=H',
        supportedBlockchains: ['ethereum', 'arbitrum', 'optimism', 'polygon', 'gnosis'],
        supportedTokens: ['USDC', 'USDT', 'ETH', 'DAI', 'MATIC'],
        averageFee: 0.02,
        averageTime: 5.0,
        isVerified: true,
        website: 'https://hop.exchange',
        metadata: {
          'security_score': 92,
          'total_volume': 2000000.0,
          'supported_chains': 8,
        },
      ),
    ];

    // Create sample routes
    _routes = [
      BridgeRoute(
        id: '1',
        sourceBlockchain: 'ethereum',
        destinationBlockchain: 'polygon',
        supportedTokens: ['USDC', 'USDT', 'ETH', 'DAI'],
        minAmount: 10.0,
        maxAmount: 100000.0,
        bridgeFee: 0.1,
        estimatedTime: 15.0,
        bridgeProvider: 'multichain',
        isActive: true,
        metadata: {
          'gas_fee': 0.005,
          'security_level': 'high',
        },
      ),
      BridgeRoute(
        id: '2',
        sourceBlockchain: 'ethereum',
        destinationBlockchain: 'binance',
        supportedTokens: ['USDC', 'USDT', 'ETH', 'BTC'],
        minAmount: 50.0,
        maxAmount: 500000.0,
        bridgeFee: 0.15,
        estimatedTime: 20.0,
        bridgeProvider: 'stargate',
        isActive: true,
        metadata: {
          'gas_fee': 0.008,
          'security_level': 'high',
        },
      ),
      BridgeRoute(
        id: '3',
        sourceBlockchain: 'ethereum',
        destinationBlockchain: 'arbitrum',
        supportedTokens: ['USDC', 'USDT', 'ETH', 'DAI'],
        minAmount: 5.0,
        maxAmount: 1000000.0,
        bridgeFee: 0.02,
        estimatedTime: 5.0,
        bridgeProvider: 'hop',
        isActive: true,
        metadata: {
          'gas_fee': 0.001,
          'security_level': 'medium',
        },
      ),
    ];

    // Create sample transactions
    _transactions = [
      BridgeTransaction(
        id: '1',
        sourceBlockchain: 'ethereum',
        destinationBlockchain: 'polygon',
        sourceAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        destinationAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        tokenSymbol: 'USDC',
        amount: 1000.0,
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        completedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        bridgeFee: 0.1,
        bridgeProvider: 'multichain',
        metadata: {
          'gas_used': 150000,
          'gas_price': 20,
        },
        transactionHash: '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
      ),
      BridgeTransaction(
        id: '2',
        sourceBlockchain: 'ethereum',
        destinationBlockchain: 'binance',
        sourceAddress: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        destinationAddress: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        tokenSymbol: 'ETH',
        amount: 5.0,
        status: 'processing',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        bridgeFee: 0.15,
        bridgeProvider: 'stargate',
        metadata: {
          'gas_used': 200000,
          'gas_price': 25,
        },
        transactionHash: '0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // Bridge transaction methods
  Future<void> createBridgeTransaction({
    required String sourceBlockchain,
    required String destinationBlockchain,
    required String sourceAddress,
    required String destinationAddress,
    required String tokenSymbol,
    required double amount,
    required String bridgeProvider,
  }) async {
    // Find route
    final route = _routes.firstWhere(
      (route) => route.sourceBlockchain == sourceBlockchain &&
                 route.destinationBlockchain == destinationBlockchain &&
                 route.bridgeProvider == bridgeProvider &&
                 route.isActive,
      orElse: () => throw Exception('Route not found'),
    );

    // Validate amount
    if (amount < route.minAmount || amount > route.maxAmount) {
      throw Exception('Amount out of range');
    }

    // Validate token
    if (!route.supportedTokens.contains(tokenSymbol)) {
      throw Exception('Token not supported');
    }

    final transaction = BridgeTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sourceBlockchain: sourceBlockchain,
      destinationBlockchain: destinationBlockchain,
      sourceAddress: sourceAddress,
      destinationAddress: destinationAddress,
      tokenSymbol: tokenSymbol,
      amount: amount,
      status: 'pending',
      createdAt: DateTime.now(),
      bridgeFee: route.bridgeFee,
      bridgeProvider: bridgeProvider,
      metadata: {
        'route_id': route.id,
        'estimated_time': route.estimatedTime,
      },
    );

    _transactions.add(transaction);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateTransactionStatus(String transactionId, String status, {
    String? transactionHash,
    String? errorMessage,
  }) async {
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == transactionId);
    if (transactionIndex == -1) return;

    _transactions[transactionIndex] = _transactions[transactionIndex].copyWith(
      status: status,
      transactionHash: transactionHash,
      errorMessage: errorMessage,
      completedAt: status == 'completed' ? DateTime.now() : null,
    );

    await _saveData();
    notifyListeners();
  }

  Future<void> cancelTransaction(String transactionId) async {
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == transactionId);
    if (transactionIndex == -1) return;

    if (_transactions[transactionIndex].status == 'pending') {
      _transactions[transactionIndex] = _transactions[transactionIndex].copyWith(
        status: 'cancelled',
      );
      await _saveData();
      notifyListeners();
    }
  }

  // Route methods
  List<BridgeRoute> getRoutesForBlockchains(String source, String destination) {
    return _routes.where((route) =>
        route.sourceBlockchain == source &&
        route.destinationBlockchain == destination &&
        route.isActive).toList();
  }

  List<BridgeRoute> getRoutesForToken(String tokenSymbol) {
    return _routes.where((route) =>
        route.supportedTokens.contains(tokenSymbol) &&
        route.isActive).toList();
  }

  // Provider methods
  BridgeProvider? getProvider(String providerId) {
    try {
      return _providers.firstWhere((provider) => provider.id == providerId);
    } catch (e) {
      return null;
    }
  }

  List<BridgeProvider> getProvidersForBlockchain(String blockchain) {
    return _providers.where((provider) =>
        provider.supportedBlockchains.contains(blockchain)).toList();
  }

  // Search methods
  List<BridgeTransaction> searchTransactions(String query) {
    if (query.isEmpty) return _transactions;
    
    return _transactions.where((tx) =>
        tx.sourceBlockchain.toLowerCase().contains(query.toLowerCase()) ||
        tx.destinationBlockchain.toLowerCase().contains(query.toLowerCase()) ||
        tx.tokenSymbol.toLowerCase().contains(query.toLowerCase()) ||
        tx.bridgeProvider.toLowerCase().contains(query.toLowerCase()) ||
        tx.status.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<BridgeTransaction> getTransactionsByStatus(String status) {
    return _transactions.where((tx) => tx.status == status).toList();
  }

  List<BridgeTransaction> getTransactionsByUser(String address) {
    return _transactions.where((tx) =>
        tx.sourceAddress.toLowerCase() == address.toLowerCase() ||
        tx.destinationAddress.toLowerCase() == address.toLowerCase()).toList();
  }

  // Analytics methods
  double getTotalBridgeVolume() {
    double total = 0.0;
    for (final tx in _transactions) {
      if (tx.status == 'completed') {
        total += tx.amount;
      }
    }
    return total;
  }

  double getTotalBridgeFees() {
    double total = 0.0;
    for (final tx in _transactions) {
      if (tx.status == 'completed') {
        total += tx.bridgeFee;
      }
    }
    return total;
  }

  Map<String, int> getTransactionsStatusCount() {
    final Map<String, int> statusCount = {};
    for (final tx in _transactions) {
      statusCount[tx.status] = (statusCount[tx.status] ?? 0) + 1;
    }
    return statusCount;
  }

  Map<String, double> getVolumeByBlockchain() {
    final Map<String, double> volumeByChain = {};
    for (final tx in _transactions) {
      if (tx.status == 'completed') {
        volumeByChain[tx.sourceBlockchain] = (volumeByChain[tx.sourceBlockchain] ?? 0.0) + tx.amount;
        volumeByChain[tx.destinationBlockchain] = (volumeByChain[tx.destinationBlockchain] ?? 0.0) + tx.amount;
      }
    }
    return volumeByChain;
  }

  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }
}
