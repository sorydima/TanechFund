import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// DEX Protocol Types
enum DEXProtocol {
  uniswap,    // Ethereum
  pancakeswap, // BSC
  quickswap,  // Polygon
  traderjoe,  // Avalanche
  raydium,    // Solana
}

// Token Information
class Token {
  final String id;
  final String symbol;
  final String name;
  final String address;
  final String chain;
  final int decimals;
  final double price;
  final double marketCap;
  final double volume24h;
  final double priceChange24h;
  final String logoUrl;
  final bool isVerified;
  final Map<String, dynamic> metadata;

  Token({
    required this.id,
    required this.symbol,
    required this.name,
    required this.address,
    required this.chain,
    required this.decimals,
    required this.price,
    required this.marketCap,
    required this.volume24h,
    required this.priceChange24h,
    required this.logoUrl,
    required this.isVerified,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'address': address,
      'chain': chain,
      'decimals': decimals,
      'price': price,
      'marketCap': marketCap,
      'volume24h': volume24h,
      'priceChange24h': priceChange24h,
      'logoUrl': logoUrl,
      'isVerified': isVerified,
      'metadata': metadata,
    };
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      address: json['address'],
      chain: json['chain'],
      decimals: json['decimals'],
      price: json['price'].toDouble(),
      marketCap: json['marketCap'].toDouble(),
      volume24h: json['volume24h'].toDouble(),
      priceChange24h: json['priceChange24h'].toDouble(),
      logoUrl: json['logoUrl'],
      isVerified: json['isVerified'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Token copyWith({
    String? id,
    String? symbol,
    String? name,
    String? address,
    String? chain,
    int? decimals,
    double? price,
    double? marketCap,
    double? volume24h,
    double? priceChange24h,
    String? logoUrl,
    bool? isVerified,
    Map<String, dynamic>? metadata,
  }) {
    return Token(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      address: address ?? this.address,
      chain: chain ?? this.chain,
      decimals: decimals ?? this.decimals,
      price: price ?? this.price,
      marketCap: marketCap ?? this.marketCap,
      volume24h: volume24h ?? this.volume24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      logoUrl: logoUrl ?? this.logoUrl,
      isVerified: isVerified ?? this.isVerified,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Liquidity Pool
class LiquidityPool {
  final String id;
  final String name;
  final Token token0;
  final Token token1;
  final double reserve0;
  final double reserve1;
  final double totalSupply;
  final double fee;
  final DEXProtocol protocol;
  final double apy;
  final double volume24h;
  final bool isActive;
  final Map<String, dynamic> metadata;

  LiquidityPool({
    required this.id,
    required this.name,
    required this.token0,
    required this.token1,
    required this.reserve0,
    required this.reserve1,
    required this.totalSupply,
    required this.fee,
    required this.protocol,
    required this.apy,
    required this.volume24h,
    required this.isActive,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'token0': token0.toJson(),
      'token1': token1.toJson(),
      'reserve0': reserve0,
      'reserve1': reserve1,
      'totalSupply': totalSupply,
      'fee': fee,
      'protocol': protocol.name,
      'apy': apy,
      'volume24h': volume24h,
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory LiquidityPool.fromJson(Map<String, dynamic> json) {
    return LiquidityPool(
      id: json['id'],
      name: json['name'],
      token0: Token.fromJson(json['token0']),
      token1: Token.fromJson(json['token1']),
      reserve0: json['reserve0'].toDouble(),
      reserve1: json['reserve1'].toDouble(),
      totalSupply: json['totalSupply'].toDouble(),
      fee: json['fee'].toDouble(),
      protocol: DEXProtocol.values.firstWhere(
        (e) => e.name == json['protocol'],
        orElse: () => DEXProtocol.uniswap,
      ),
      apy: json['apy'].toDouble(),
      volume24h: json['volume24h'].toDouble(),
      isActive: json['isActive'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  LiquidityPool copyWith({
    String? id,
    String? name,
    Token? token0,
    Token? token1,
    double? reserve0,
    double? reserve1,
    double? totalSupply,
    double? fee,
    DEXProtocol? protocol,
    double? apy,
    double? volume24h,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return LiquidityPool(
      id: id ?? this.id,
      name: name ?? this.name,
      token0: token0 ?? this.token0,
      token1: token1 ?? this.token1,
      reserve0: reserve0 ?? this.reserve0,
      reserve1: reserve1 ?? this.reserve1,
      totalSupply: totalSupply ?? this.totalSupply,
      fee: fee ?? this.fee,
      protocol: protocol ?? this.protocol,
      apy: apy ?? this.apy,
      volume24h: volume24h ?? this.volume24h,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Swap Transaction
class SwapTransaction {
  final String id;
  final String fromToken;
  final String toToken;
  final double amountIn;
  final double amountOut;
  final double priceImpact;
  final double slippage;
  final DEXProtocol protocol;
  final String walletAddress;
  final DateTime timestamp;
  final String status; // 'pending', 'completed', 'failed'
  final String? txHash;
  final double gasUsed;
  final double gasPrice;
  final Map<String, dynamic> metadata;

  SwapTransaction({
    required this.id,
    required this.fromToken,
    required this.toToken,
    required this.amountIn,
    required this.amountOut,
    required this.priceImpact,
    required this.slippage,
    required this.protocol,
    required this.walletAddress,
    required this.timestamp,
    required this.status,
    this.txHash,
    required this.gasUsed,
    required this.gasPrice,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromToken': fromToken,
      'toToken': toToken,
      'amountIn': amountIn,
      'amountOut': amountOut,
      'priceImpact': priceImpact,
      'slippage': slippage,
      'protocol': protocol.name,
      'walletAddress': walletAddress,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'txHash': txHash,
      'gasUsed': gasUsed,
      'gasPrice': gasPrice,
      'metadata': metadata,
    };
  }

  factory SwapTransaction.fromJson(Map<String, dynamic> json) {
    return SwapTransaction(
      id: json['id'],
      fromToken: json['fromToken'],
      toToken: json['toToken'],
      amountIn: json['amountIn'].toDouble(),
      amountOut: json['amountOut'].toDouble(),
      priceImpact: json['priceImpact'].toDouble(),
      slippage: json['slippage'].toDouble(),
      protocol: DEXProtocol.values.firstWhere(
        (e) => e.name == json['protocol'],
        orElse: () => DEXProtocol.uniswap,
      ),
      walletAddress: json['walletAddress'],
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
      txHash: json['txHash'],
      gasUsed: json['gasUsed'].toDouble(),
      gasPrice: json['gasPrice'].toDouble(),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  SwapTransaction copyWith({
    String? id,
    String? fromToken,
    String? toToken,
    double? amountIn,
    double? amountOut,
    double? priceImpact,
    double? slippage,
    DEXProtocol? protocol,
    String? walletAddress,
    DateTime? timestamp,
    String? status,
    String? txHash,
    double? gasUsed,
    double? gasPrice,
    Map<String, dynamic>? metadata,
  }) {
    return SwapTransaction(
      id: id ?? this.id,
      fromToken: fromToken ?? this.fromToken,
      toToken: toToken ?? this.toToken,
      amountIn: amountIn ?? this.amountIn,
      amountOut: amountOut ?? this.amountOut,
      priceImpact: priceImpact ?? this.priceImpact,
      slippage: slippage ?? this.slippage,
      protocol: protocol ?? this.protocol,
      walletAddress: walletAddress ?? this.walletAddress,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      txHash: txHash ?? this.txHash,
      gasUsed: gasUsed ?? this.gasUsed,
      gasPrice: gasPrice ?? this.gasPrice,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Limit Order
class LimitOrder {
  final String id;
  final String tokenIn;
  final String tokenOut;
  final double amountIn;
  final double price;
  final DEXProtocol protocol;
  final String walletAddress;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status; // 'active', 'filled', 'cancelled', 'expired'
  final String? txHash;
  final Map<String, dynamic> metadata;

  LimitOrder({
    required this.id,
    required this.tokenIn,
    required this.tokenOut,
    required this.amountIn,
    required this.price,
    required this.protocol,
    required this.walletAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    this.txHash,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tokenIn': tokenIn,
      'tokenOut': tokenOut,
      'amountIn': amountIn,
      'price': price,
      'protocol': protocol.name,
      'walletAddress': walletAddress,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'status': status,
      'txHash': txHash,
      'metadata': metadata,
    };
  }

  factory LimitOrder.fromJson(Map<String, dynamic> json) {
    return LimitOrder(
      id: json['id'],
      tokenIn: json['tokenIn'],
      tokenOut: json['tokenOut'],
      amountIn: json['amountIn'].toDouble(),
      price: json['price'].toDouble(),
      protocol: DEXProtocol.values.firstWhere(
        (e) => e.name == json['protocol'],
        orElse: () => DEXProtocol.uniswap,
      ),
      walletAddress: json['walletAddress'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      status: json['status'],
      txHash: json['txHash'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  LimitOrder copyWith({
    String? id,
    String? tokenIn,
    String? tokenOut,
    double? amountIn,
    double? price,
    DEXProtocol? protocol,
    String? walletAddress,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? status,
    String? txHash,
    Map<String, dynamic>? metadata,
  }) {
    return LimitOrder(
      id: id ?? this.id,
      tokenIn: tokenIn ?? this.tokenIn,
      tokenOut: tokenOut ?? this.tokenOut,
      amountIn: amountIn ?? this.amountIn,
      price: price ?? this.price,
      protocol: protocol ?? this.protocol,
      walletAddress: walletAddress ?? this.walletAddress,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      txHash: txHash ?? this.txHash,
      metadata: metadata ?? this.metadata,
    );
  }
}

// DEX Trading Provider
class DEXTradingProvider extends ChangeNotifier {
  List<Token> _tokens = [];
  List<LiquidityPool> _pools = [];
  List<SwapTransaction> _transactions = [];
  List<LimitOrder> _limitOrders = [];
  String _currentUserId = 'current_user';
  DEXProtocol _selectedProtocol = DEXProtocol.uniswap;
  double _slippageTolerance = 0.5;
  double _gasPrice = 20.0;

  // Getters
  List<Token> get tokens => _tokens;
  List<LiquidityPool> get pools => _pools;
  List<SwapTransaction> get transactions => _transactions;
  List<LimitOrder> get limitOrders => _limitOrders;
  DEXProtocol get selectedProtocol => _selectedProtocol;
  double get slippageTolerance => _slippageTolerance;
  double get gasPrice => _gasPrice;

  List<Token> get tokensByChain => _tokens.where((token) => 
      token.chain == _selectedProtocol.name).toList();

  List<LiquidityPool> get poolsByProtocol => _pools.where((pool) => 
      pool.protocol == _selectedProtocol).toList();

  List<SwapTransaction> get transactionsByProtocol => _transactions.where((tx) => 
      tx.protocol == _selectedProtocol).toList();

  List<LimitOrder> get activeLimitOrders => _limitOrders.where((order) => 
      order.status == 'active').toList();

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_tokens.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final tokensJson = prefs.getStringList('dex_trading_tokens') ?? [];
      _tokens = tokensJson
          .map((json) => Token.fromJson(jsonDecode(json)))
          .toList();

      final poolsJson = prefs.getStringList('dex_trading_pools') ?? [];
      _pools = poolsJson
          .map((json) => LiquidityPool.fromJson(jsonDecode(json)))
          .toList();

      final transactionsJson = prefs.getStringList('dex_trading_transactions') ?? [];
      _transactions = transactionsJson
          .map((json) => SwapTransaction.fromJson(jsonDecode(json)))
          .toList();

      final ordersJson = prefs.getStringList('dex_trading_limit_orders') ?? [];
      _limitOrders = ordersJson
          .map((json) => LimitOrder.fromJson(jsonDecode(json)))
          .toList();

      _slippageTolerance = prefs.getDouble('dex_slippage_tolerance') ?? 0.5;
      _gasPrice = prefs.getDouble('dex_gas_price') ?? 20.0;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading DEX Trading data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setStringList('dex_trading_tokens', 
          _tokens.map((token) => jsonEncode(token.toJson())).toList());
      
      await prefs.setStringList('dex_trading_pools', 
          _pools.map((pool) => jsonEncode(pool.toJson())).toList());
      
      await prefs.setStringList('dex_trading_transactions', 
          _transactions.map((tx) => jsonEncode(tx.toJson())).toList());
      
      await prefs.setStringList('dex_trading_limit_orders', 
          _limitOrders.map((order) => jsonEncode(order.toJson())).toList());

      await prefs.setDouble('dex_slippage_tolerance', _slippageTolerance);
      await prefs.setDouble('dex_gas_price', _gasPrice);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving DEX Trading data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample tokens
    _tokens = [
      Token(
        id: '1',
        symbol: 'ETH',
        name: 'Ethereum',
        address: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
        chain: 'uniswap',
        decimals: 18,
        price: 3200.0,
        marketCap: 385000000000,
        volume24h: 15000000000,
        priceChange24h: 2.5,
        logoUrl: 'https://example.com/eth.png',
        isVerified: true,
        metadata: {
          'coingecko_id': 'ethereum',
          'category': 'Layer 1',
        },
      ),
      Token(
        id: '2',
        symbol: 'USDC',
        name: 'USD Coin',
        address: '0xA0b86a33E6441b8c4C8C8C8C8C8C8C8C8C8C8C8',
        chain: 'uniswap',
        decimals: 6,
        price: 1.0,
        marketCap: 25000000000,
        volume24h: 5000000000,
        priceChange24h: 0.0,
        logoUrl: 'https://example.com/usdc.png',
        isVerified: true,
        metadata: {
          'coingecko_id': 'usd-coin',
          'category': 'Stablecoin',
        },
      ),
      Token(
        id: '3',
        symbol: 'BNB',
        name: 'Binance Coin',
        address: '0xbb4CdB9CBd36B01bD1cBaEF2F8d6d6b6b6b6b6b6',
        chain: 'pancakeswap',
        decimals: 18,
        price: 580.0,
        marketCap: 95000000000,
        volume24h: 8000000000,
        priceChange24h: -1.2,
        logoUrl: 'https://example.com/bnb.png',
        isVerified: true,
        metadata: {
          'coingecko_id': 'binancecoin',
          'category': 'Exchange Token',
        },
      ),
      Token(
        id: '4',
        symbol: 'MATIC',
        name: 'Polygon',
        address: '0x7D1AfA7B718fb893dB30A3aBc0Cfc608aC3c3c3c3',
        chain: 'quickswap',
        decimals: 18,
        price: 0.85,
        marketCap: 8500000000,
        volume24h: 3000000000,
        priceChange24h: 5.8,
        logoUrl: 'https://example.com/matic.png',
        isVerified: true,
        metadata: {
          'coingecko_id': 'matic-network',
          'category': 'Layer 2',
        },
      ),
      Token(
        id: '5',
        symbol: 'AVAX',
        name: 'Avalanche',
        address: '0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7',
        chain: 'traderjoe',
        decimals: 18,
        price: 28.50,
        marketCap: 10500000000,
        volume24h: 2500000000,
        priceChange24h: 3.2,
        logoUrl: 'https://example.com/avax.png',
        isVerified: true,
        metadata: {
          'coingecko_id': 'avalanche-2',
          'category': 'Layer 1',
        },
      ),
    ];

    // Create sample liquidity pools
    _pools = [
      LiquidityPool(
        id: '1',
        name: 'ETH/USDC',
        token0: _tokens[0],
        token1: _tokens[1],
        reserve0: 1000000.0,
        reserve1: 3200000000.0,
        totalSupply: 1000000.0,
        fee: 0.003,
        protocol: DEXProtocol.uniswap,
        apy: 45.2,
        volume24h: 5000000000.0,
        isActive: true,
        metadata: {
          'tick_spacing': 60,
          'concentration': 'medium',
        },
      ),
      LiquidityPool(
        id: '2',
        name: 'BNB/BUSD',
        token0: _tokens[2],
        token1: _tokens[1],
        reserve0: 500000.0,
        reserve1: 290000000.0,
        totalSupply: 500000.0,
        fee: 0.0025,
        protocol: DEXProtocol.pancakeswap,
        apy: 38.7,
        volume24h: 3000000000.0,
        isActive: true,
        metadata: {
          'tick_spacing': 50,
          'concentration': 'high',
        },
      ),
      LiquidityPool(
        id: '3',
        name: 'MATIC/USDC',
        token0: _tokens[3],
        token1: _tokens[1],
        reserve0: 10000000.0,
        reserve1: 8500000.0,
        totalSupply: 10000000.0,
        fee: 0.003,
        protocol: DEXProtocol.quickswap,
        apy: 52.1,
        volume24h: 1500000000.0,
        isActive: true,
        metadata: {
          'tick_spacing': 60,
          'concentration': 'medium',
        },
      ),
    ];

    // Create sample transactions
    _transactions = [
      SwapTransaction(
        id: '1',
        fromToken: 'ETH',
        toToken: 'USDC',
        amountIn: 1.5,
        amountOut: 4800.0,
        priceImpact: 0.12,
        slippage: 0.5,
        protocol: DEXProtocol.uniswap,
        walletAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'completed',
        txHash: '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
        gasUsed: 150000,
        gasPrice: 25.0,
        metadata: {
          'route': ['ETH', 'USDC'],
          'execution_time': 15,
        },
      ),
      SwapTransaction(
        id: '2',
        fromToken: 'USDC',
        toToken: 'MATIC',
        amountIn: 1000.0,
        amountOut: 1176.47,
        priceImpact: 0.08,
        slippage: 0.5,
        protocol: DEXProtocol.quickswap,
        walletAddress: '0x8ba1f109551bA432bDF5c3c92bEa5e236bc33488',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        status: 'completed',
        txHash: '0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
        gasUsed: 120000,
        gasPrice: 30.0,
        metadata: {
          'route': ['USDC', 'MATIC'],
          'execution_time': 12,
        },
      ),
    ];

    // Create sample limit orders
    _limitOrders = [
      LimitOrder(
        id: '1',
        tokenIn: 'ETH',
        tokenOut: 'USDC',
        amountIn: 2.0,
        price: 3100.0,
        protocol: DEXProtocol.uniswap,
        walletAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        status: 'active',
        metadata: {
          'order_type': 'limit_buy',
          'partial_fill': false,
        },
      ),
      LimitOrder(
        id: '2',
        tokenIn: 'USDC',
        tokenOut: 'BNB',
        amountIn: 5000.0,
        price: 0.0017,
        protocol: DEXProtocol.pancakeswap,
        walletAddress: '0x8ba1f109551bA432bDF5c3c92bEa5e236bc33488',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        expiresAt: DateTime.now().add(const Duration(days: 3)),
        status: 'active',
        metadata: {
          'order_type': 'limit_sell',
          'partial_fill': true,
        },
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // Protocol selection
  void selectProtocol(DEXProtocol protocol) {
    _selectedProtocol = protocol;
    _saveData();
    notifyListeners();
  }

  // Settings management
  void updateSlippageTolerance(double slippage) {
    _slippageTolerance = slippage;
    _saveData();
    notifyListeners();
  }

  void updateGasPrice(double gasPrice) {
    _gasPrice = gasPrice;
    _saveData();
    notifyListeners();
  }

  // Token management
  Future<void> addToken(Token token) async {
    _tokens.add(token);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateToken(String tokenId, Map<String, dynamic> updates) async {
    final tokenIndex = _tokens.indexWhere((token) => token.id == tokenId);
    if (tokenIndex == -1) return;

    _tokens[tokenIndex] = _tokens[tokenIndex].copyWith(
      price: updates['price'] ?? _tokens[tokenIndex].price,
      marketCap: updates['marketCap'] ?? _tokens[tokenIndex].marketCap,
      volume24h: updates['volume24h'] ?? _tokens[tokenIndex].volume24h,
      priceChange24h: updates['priceChange24h'] ?? _tokens[tokenIndex].priceChange24h,
    );

    await _saveData();
    notifyListeners();
  }

  // Pool management
  Future<void> addPool(LiquidityPool pool) async {
    _pools.add(pool);
    await _saveData();
    notifyListeners();
  }

  Future<void> updatePool(String poolId, Map<String, dynamic> updates) async {
    final poolIndex = _pools.indexWhere((pool) => pool.id == poolId);
    if (poolIndex == -1) return;

    // Update pool reserves and other dynamic data
    _pools[poolIndex] = _pools[poolIndex].copyWith(
      reserve0: updates['reserve0'] ?? _pools[poolIndex].reserve0,
      reserve1: updates['reserve1'] ?? _pools[poolIndex].reserve1,
      totalSupply: updates['totalSupply'] ?? _pools[poolIndex].totalSupply,
      apy: updates['apy'] ?? _pools[poolIndex].apy,
      volume24h: updates['volume24h'] ?? _pools[poolIndex].volume24h,
    );

    await _saveData();
    notifyListeners();
  }

  // Transaction management
  Future<SwapTransaction?> createSwapTransaction({
    required String fromToken,
    required String toToken,
    required double amountIn,
    required double amountOut,
    required double priceImpact,
    required String walletAddress,
  }) async {
    final transaction = SwapTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromToken: fromToken,
      toToken: toToken,
      amountIn: amountIn,
      amountOut: amountOut,
      priceImpact: priceImpact,
      slippage: _slippageTolerance,
      protocol: _selectedProtocol,
      walletAddress: walletAddress,
      timestamp: DateTime.now(),
      status: 'pending',
      gasUsed: 0.0,
      gasPrice: _gasPrice,
      metadata: {
        'route': [fromToken, toToken],
        'execution_time': 0,
      },
    );

    _transactions.add(transaction);
    await _saveData();
    notifyListeners();
    return transaction;
  }

  Future<bool> updateTransactionStatus(String transactionId, String status, {String? txHash}) async {
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == transactionId);
    if (transactionIndex == -1) return false;

    _transactions[transactionIndex] = _transactions[transactionIndex].copyWith(
      status: status,
      txHash: txHash,
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  // Limit order management
  Future<LimitOrder?> createLimitOrder({
    required String tokenIn,
    required String tokenOut,
    required double amountIn,
    required double price,
    required String walletAddress,
    int? expiresInDays,
  }) async {
    final order = LimitOrder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tokenIn: tokenIn,
      tokenOut: tokenOut,
      amountIn: amountIn,
      price: price,
      protocol: _selectedProtocol,
      walletAddress: walletAddress,
      createdAt: DateTime.now(),
      expiresAt: expiresInDays != null 
          ? DateTime.now().add(Duration(days: expiresInDays))
          : null,
      status: 'active',
      metadata: {
        'order_type': price > _getTokenPrice(tokenIn) ? 'limit_buy' : 'limit_sell',
        'partial_fill': false,
      },
    );

    _limitOrders.add(order);
    await _saveData();
    notifyListeners();
    return order;
  }

  Future<bool> cancelLimitOrder(String orderId) async {
    final orderIndex = _limitOrders.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) return false;

    _limitOrders[orderIndex] = _limitOrders[orderIndex].copyWith(
      status: 'cancelled',
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  // Utility methods
  double _getTokenPrice(String tokenSymbol) {
    final token = _tokens.firstWhere(
      (t) => t.symbol == tokenSymbol,
      orElse: () => _tokens.first,
    );
    return token.price;
  }

  // Search methods
  List<Token> searchTokens(String query) {
    if (query.isEmpty) return _tokens;
    
    return _tokens.where((token) =>
        token.symbol.toLowerCase().contains(query.toLowerCase()) ||
        token.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<LiquidityPool> searchPools(String query) {
    if (query.isEmpty) return _pools;
    
    return _pools.where((pool) =>
        pool.name.toLowerCase().contains(query.toLowerCase()) ||
        pool.token0.symbol.toLowerCase().contains(query.toLowerCase()) ||
        pool.token1.symbol.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<SwapTransaction> searchTransactions(String query) {
    if (query.isEmpty) return _transactions;
    
    return _transactions.where((tx) =>
        tx.fromToken.toLowerCase().contains(query.toLowerCase()) ||
        tx.toToken.toLowerCase().contains(query.toLowerCase()) ||
        tx.walletAddress.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Analytics methods
  double getTotalVolume24h() {
    return _pools.fold(0.0, (sum, pool) => sum + pool.volume24h);
  }

  double getAverageAPY() {
    if (_pools.isEmpty) return 0.0;
    final totalAPY = _pools.fold(0.0, (sum, pool) => sum + pool.apy);
    return totalAPY / _pools.length;
  }

  Map<String, double> getProtocolVolumes() {
    final volumes = <String, double>{};
    for (final pool in _pools) {
      final protocolName = pool.protocol.name;
      volumes[protocolName] = (volumes[protocolName] ?? 0.0) + pool.volume24h;
    }
    return volumes;
  }

  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }
}
