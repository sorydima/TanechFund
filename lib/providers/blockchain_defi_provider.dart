import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Blockchain Wallet Model
class BlockchainWallet {
  final String id;
  final String name;
  final String address;
  final String blockchain; // 'ethereum', 'polygon', 'bsc', 'solana'
  final double balance;
  final List<String> supportedTokens;
  final DateTime createdAt;
  final bool isActive;
  final Map<String, dynamic> metadata; // For additional wallet info

  BlockchainWallet({
    required this.id,
    required this.name,
    required this.address,
    required this.blockchain,
    required this.balance,
    required this.supportedTokens,
    required this.createdAt,
    required this.isActive,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'blockchain': blockchain,
      'balance': balance,
      'supportedTokens': supportedTokens,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory BlockchainWallet.fromJson(Map<String, dynamic> json) {
    return BlockchainWallet(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      blockchain: json['blockchain'],
      balance: json['balance'].toDouble(),
      supportedTokens: List<String>.from(json['supportedTokens']),
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  BlockchainWallet copyWith({
    String? id,
    String? name,
    String? address,
    String? blockchain,
    double? balance,
    List<String>? supportedTokens,
    DateTime? createdAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return BlockchainWallet(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      blockchain: blockchain ?? this.blockchain,
      balance: balance ?? this.balance,
      supportedTokens: supportedTokens ?? this.supportedTokens,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }
}

// DeFi Protocol Model
class DeFiProtocol {
  final String id;
  final String name;
  final String description;
  final String type; // 'dex', 'lending', 'yield_farming', 'staking'
  final String blockchain;
  final String contractAddress;
  final double tvl; // Total Value Locked
  final double apy; // Annual Percentage Yield
  final List<String> supportedTokens;
  final String status; // 'active', 'paused', 'deprecated'
  final Map<String, dynamic> parameters;

  DeFiProtocol({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.blockchain,
    required this.contractAddress,
    required this.tvl,
    required this.apy,
    required this.supportedTokens,
    required this.status,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'blockchain': blockchain,
      'contractAddress': contractAddress,
      'tvl': tvl,
      'apy': apy,
      'supportedTokens': supportedTokens,
      'status': status,
      'parameters': parameters,
    };
  }

  factory DeFiProtocol.fromJson(Map<String, dynamic> json) {
    return DeFiProtocol(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      blockchain: json['blockchain'],
      contractAddress: json['contractAddress'],
      tvl: json['tvl'].toDouble(),
      apy: json['apy'].toDouble(),
      supportedTokens: List<String>.from(json['supportedTokens']),
      status: json['status'],
      parameters: Map<String, dynamic>.from(json['parameters']),
    );
  }

  DeFiProtocol copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? blockchain,
    String? contractAddress,
    double? tvl,
    double? apy,
    List<String>? supportedTokens,
    String? status,
    Map<String, dynamic>? parameters,
  }) {
    return DeFiProtocol(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      blockchain: blockchain ?? this.blockchain,
      contractAddress: contractAddress ?? this.contractAddress,
      tvl: tvl ?? this.tvl,
      apy: apy ?? this.apy,
      supportedTokens: supportedTokens ?? this.supportedTokens,
      status: status ?? this.status,
      parameters: parameters ?? this.parameters,
    );
  }
}

// Smart Contract Model
class SmartContract {
  final String id;
  final String name;
  final String description;
  final String address;
  final String blockchain;
  final String type; // 'token', 'nft', 'defi', 'governance', 'custom'
  String status; // 'deployed', 'pending', 'failed', 'upgraded'
  DateTime deployedAt;
  final String sourceCode;
  final String abi;
  final Map<String, dynamic> metadata;

  SmartContract({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.blockchain,
    required this.type,
    required this.status,
    required this.deployedAt,
    required this.sourceCode,
    required this.abi,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'blockchain': blockchain,
      'type': type,
      'status': status,
      'deployedAt': deployedAt.toIso8601String(),
      'sourceCode': sourceCode,
      'abi': abi,
      'metadata': metadata,
    };
  }

  factory SmartContract.fromJson(Map<String, dynamic> json) {
    return SmartContract(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      blockchain: json['blockchain'],
      type: json['type'],
      status: json['status'],
      deployedAt: DateTime.parse(json['deployedAt']),
      sourceCode: json['sourceCode'],
      abi: json['abi'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  SmartContract copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? blockchain,
    String? type,
    String? status,
    DateTime? deployedAt,
    String? sourceCode,
    String? abi,
    Map<String, dynamic>? metadata,
  }) {
    return SmartContract(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      blockchain: blockchain ?? this.blockchain,
      type: type ?? this.type,
      status: status ?? this.status,
      deployedAt: deployedAt ?? this.deployedAt,
      sourceCode: sourceCode ?? this.sourceCode,
      abi: abi ?? this.abi,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Token Model
class Token {
  final String id;
  final String name;
  final String symbol;
  final String contractAddress;
  final String blockchain;
  final double totalSupply;
  double price;
  double marketCap;
  final double volume24h;
  final String tokenType; // 'erc20', 'erc721', 'erc1155', 'native'
  final Map<String, dynamic> metadata;

  Token({
    required this.id,
    required this.name,
    required this.symbol,
    required this.contractAddress,
    required this.blockchain,
    required this.totalSupply,
    required this.price,
    required this.marketCap,
    required this.volume24h,
    required this.tokenType,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'contractAddress': contractAddress,
      'blockchain': blockchain,
      'totalSupply': totalSupply,
      'price': price,
      'marketCap': marketCap,
      'volume24h': volume24h,
      'tokenType': tokenType,
      'metadata': metadata,
    };
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      contractAddress: json['contractAddress'],
      blockchain: json['blockchain'],
      totalSupply: json['totalSupply'].toDouble(),
      price: json['price'].toDouble(),
      marketCap: json['marketCap'].toDouble(),
      volume24h: json['volume24h'].toDouble(),
      tokenType: json['tokenType'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Token copyWith({
    String? id,
    String? name,
    String? symbol,
    String? contractAddress,
    String? blockchain,
    double? totalSupply,
    double? price,
    double? marketCap,
    double? volume24h,
    String? tokenType,
    Map<String, dynamic>? metadata,
  }) {
    return Token(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      contractAddress: contractAddress ?? this.contractAddress,
      blockchain: blockchain ?? this.blockchain,
      totalSupply: totalSupply ?? this.totalSupply,
      price: price ?? this.price,
      marketCap: marketCap ?? this.marketCap,
      volume24h: volume24h ?? this.volume24h,
      tokenType: tokenType ?? this.tokenType,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Transaction Model
class BlockchainTransaction {
  final String id;
  final String hash;
  final String fromAddress;
  final String toAddress;
  final String blockchain;
  final double amount;
  final String tokenSymbol;
  final double gasPrice;
  final double gasUsed;
  String status; // 'pending', 'confirmed', 'failed'
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  BlockchainTransaction({
    required this.id,
    required this.hash,
    required this.fromAddress,
    required this.toAddress,
    required this.blockchain,
    required this.amount,
    required this.tokenSymbol,
    required this.gasPrice,
    required this.gasUsed,
    required this.status,
    required this.timestamp,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hash': hash,
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'blockchain': blockchain,
      'amount': amount,
      'tokenSymbol': tokenSymbol,
      'gasPrice': gasPrice,
      'gasUsed': gasUsed,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory BlockchainTransaction.fromJson(Map<String, dynamic> json) {
    return BlockchainTransaction(
      id: json['id'],
      hash: json['hash'],
      fromAddress: json['fromAddress'],
      toAddress: json['toAddress'],
      blockchain: json['blockchain'],
      amount: json['amount'].toDouble(),
      tokenSymbol: json['tokenSymbol'],
      gasPrice: json['gasPrice'].toDouble(),
      gasUsed: json['gasUsed'].toDouble(),
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  BlockchainTransaction copyWith({
    String? id,
    String? hash,
    String? fromAddress,
    String? toAddress,
    String? blockchain,
    double? amount,
    String? tokenSymbol,
    double? gasPrice,
    double? gasUsed,
    String? status,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return BlockchainTransaction(
      id: id ?? this.id,
      hash: hash ?? this.hash,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      blockchain: blockchain ?? this.blockchain,
      amount: amount ?? this.amount,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      gasPrice: gasPrice ?? this.gasPrice,
      gasUsed: gasUsed ?? this.gasUsed,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Blockchain/DeFi Provider
class BlockchainDeFiProvider extends ChangeNotifier {
  List<BlockchainWallet> _wallets = [];
  List<DeFiProtocol> _protocols = [];
  List<SmartContract> _contracts = [];
  List<Token> _tokens = [];
  List<BlockchainTransaction> _transactions = [];
  String _currentUserId = 'current_user';

  // Getters
  List<BlockchainWallet> get wallets => _wallets;
  List<DeFiProtocol> get protocols => _protocols;
  List<SmartContract> get contracts => _contracts;
  List<Token> get tokens => _tokens;
  List<BlockchainTransaction> get transactions => _transactions;

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_wallets.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final walletsJson = prefs.getStringList('blockchain_wallets') ?? [];
      _wallets = walletsJson
          .map((json) => BlockchainWallet.fromJson(jsonDecode(json)))
          .toList();

      final protocolsJson = prefs.getStringList('defi_protocols') ?? [];
      _protocols = protocolsJson
          .map((json) => DeFiProtocol.fromJson(jsonDecode(json)))
          .toList();

      final contractsJson = prefs.getStringList('smart_contracts') ?? [];
      _contracts = contractsJson
          .map((json) => SmartContract.fromJson(jsonDecode(json)))
          .toList();

      final tokensJson = prefs.getStringList('tokens') ?? [];
      _tokens = tokensJson
          .map((json) => Token.fromJson(jsonDecode(json)))
          .toList();

      final transactionsJson = prefs.getStringList('blockchain_transactions') ?? [];
      _transactions = transactionsJson
          .map((json) => BlockchainTransaction.fromJson(jsonDecode(json)))
          .toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Blockchain/DeFi data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setStringList('blockchain_wallets', 
          _wallets.map((w) => jsonEncode(w.toJson())).toList());
      
      await prefs.setStringList('defi_protocols', 
          _protocols.map((p) => jsonEncode(p.toJson())).toList());
      
      await prefs.setStringList('smart_contracts', 
          _contracts.map((c) => jsonEncode(c.toJson())).toList());
      
      await prefs.setStringList('tokens', 
          _tokens.map((t) => jsonEncode(t.toJson())).toList());
      
      await prefs.setStringList('blockchain_transactions', 
          _transactions.map((tx) => jsonEncode(tx.toJson())).toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Blockchain/DeFi data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample wallets
    _wallets = [
      BlockchainWallet(
        id: '1',
        name: 'Основной кошелек',
        address: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        blockchain: 'ethereum',
        balance: 2.45,
        supportedTokens: ['ETH', 'USDC', 'USDT', 'DAI'],
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        isActive: true,
        metadata: {
          'derivation_path': "m/44'/60'/0'/0/0",
          'wallet_type': 'hd_wallet',
        },
      ),
      BlockchainWallet(
        id: '2',
        name: 'DeFi кошелек',
        address: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        blockchain: 'polygon',
        balance: 1500.0,
        supportedTokens: ['MATIC', 'USDC', 'WETH', 'QUICK'],
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        isActive: true,
        metadata: {
          'derivation_path': "m/44'/60'/0'/0/1",
          'wallet_type': 'hd_wallet',
        },
      ),
    ];

    // Create sample DeFi protocols
    _protocols = [
      DeFiProtocol(
        id: '1',
        name: 'Uniswap V3',
        description: 'Децентрализованная биржа с автоматическим маркет-мейкингом',
        type: 'dex',
        blockchain: 'ethereum',
        contractAddress: '0xE592427A0AEce92De3Edee1F18E0157C05861564',
        tvl: 2500000000.0,
        apy: 15.5,
        supportedTokens: ['ETH', 'USDC', 'USDT', 'DAI', 'WETH'],
        status: 'active',
        parameters: {
          'fee_tier': '0.3%',
          'version': '3.0',
          'governance_token': 'UNI',
        },
      ),
      DeFiProtocol(
        id: '2',
        name: 'Aave V3',
        description: 'Протокол лендинга и заимствования',
        type: 'lending',
        blockchain: 'ethereum',
        contractAddress: '0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9',
        tvl: 1800000000.0,
        apy: 8.2,
        supportedTokens: ['ETH', 'USDC', 'USDT', 'DAI', 'WETH'],
        status: 'active',
        parameters: {
          'liquidation_threshold': '0.85',
          'collateral_factor': '0.75',
          'governance_token': 'AAVE',
        },
      ),
      DeFiProtocol(
        id: '3',
        name: 'Curve Finance',
        description: 'DEX для стабильных монет с низкими комиссиями',
        type: 'dex',
        blockchain: 'ethereum',
        contractAddress: '0xDC24316b9AE028F1497c275EB9192a3Ea0f67022',
        tvl: 3200000000.0,
        apy: 12.8,
        supportedTokens: ['USDC', 'USDT', 'DAI', 'FRAX', 'TUSD'],
        status: 'active',
        parameters: {
          'fee_tier': '0.04%',
          'amplification': '100',
          'governance_token': 'CRV',
        },
      ),
    ];

    // Create sample smart contracts
    _contracts = [
      SmartContract(
        id: '1',
        name: 'REChain Token',
        description: 'Основной токен экосистемы REChain',
        address: '0x1234567890123456789012345678901234567890',
        blockchain: 'ethereum',
        type: 'token',
        status: 'deployed',
        deployedAt: DateTime.now().subtract(const Duration(days: 90)),
        sourceCode: '// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;',
        abi: '[{"inputs":[],"name":"totalSupply","outputs":[{"type":"uint256"}],"stateMutability":"view"}]',
        metadata: {
          'decimals': 18,
          'total_supply': '1000000000000000000000000000',
          'owner': '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        },
      ),
      SmartContract(
        id: '2',
        name: 'REChain NFT Collection',
        description: 'Коллекция NFT для участников экосистемы',
        address: '0x2345678901234567890123456789012345678901',
        blockchain: 'ethereum',
        type: 'nft',
        status: 'deployed',
        deployedAt: DateTime.now().subtract(const Duration(days: 60)),
        sourceCode: '// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;',
        abi: '[{"inputs":[],"name":"name","outputs":[{"type":"string"}],"stateMutability":"view"}]',
        metadata: {
          'standard': 'ERC-721',
          'max_supply': 10000,
          'base_uri': 'https://api.rechain.com/nft/',
        },
      ),
    ];

    // Create sample tokens
    _tokens = [
      Token(
        id: '1',
        name: 'Ethereum',
        symbol: 'ETH',
        contractAddress: '0x0000000000000000000000000000000000000000',
        blockchain: 'ethereum',
        totalSupply: 120000000.0,
        price: 3200.0,
        marketCap: 384000000000.0,
        volume24h: 15000000000.0,
        tokenType: 'native',
        metadata: {
          'decimals': 18,
          'coingecko_id': 'ethereum',
        },
      ),
      Token(
        id: '2',
        name: 'USD Coin',
        symbol: 'USDC',
        contractAddress: '0xA0b86a33E6441b8c4C3B1b1EF4F2dC4FcF98a4e',
        blockchain: 'ethereum',
        totalSupply: 25000000000.0,
        price: 1.0,
        marketCap: 25000000000.0,
        volume24h: 5000000000.0,
        tokenType: 'erc20',
        metadata: {
          'decimals': 6,
          'issuer': 'Circle',
          'backed_by': 'USD',
        },
      ),
      Token(
        id: '3',
        name: 'REChain Token',
        symbol: 'RECH',
        contractAddress: '0x1234567890123456789012345678901234567890',
        blockchain: 'ethereum',
        totalSupply: 1000000000.0,
        price: 0.15,
        marketCap: 150000000.0,
        volume24h: 2500000.0,
        tokenType: 'erc20',
        metadata: {
          'decimals': 18,
          'project': 'REChain VC Lab',
          'utility': 'governance, staking, rewards',
        },
      ),
    ];

    // Create sample transactions
    _transactions = [
      BlockchainTransaction(
        id: '1',
        hash: '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef',
        fromAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        toAddress: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        blockchain: 'ethereum',
        amount: 0.5,
        tokenSymbol: 'ETH',
        gasPrice: 25.0,
        gasUsed: 21000.0,
        status: 'confirmed',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        metadata: {
          'block_number': 18500000,
          'confirmations': 12,
        },
      ),
      BlockchainTransaction(
        id: '2',
        hash: '0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
        fromAddress: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        toAddress: '0xE592427A0AEce92De3Edee1F18E0157C05861564',
        blockchain: 'ethereum',
        amount: 1000.0,
        tokenSymbol: 'USDC',
        gasPrice: 30.0,
        gasUsed: 150000.0,
        status: 'confirmed',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        metadata: {
          'block_number': 18500001,
          'confirmations': 8,
          'protocol': 'Uniswap V3',
        },
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // Wallet methods
  Future<void> createWallet(String name, String blockchain) async {
    final wallet = BlockchainWallet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      address: _generateWalletAddress(blockchain),
      blockchain: blockchain,
      balance: 0.0,
      supportedTokens: _getDefaultTokensForBlockchain(blockchain),
      createdAt: DateTime.now(),
      isActive: true,
      metadata: {
        'derivation_path': "m/44'/${_getCoinType(blockchain)}'/0'/0/${_wallets.length}",
        'wallet_type': 'hd_wallet',
      },
    );

    _wallets.add(wallet);
    await _saveData();
    notifyListeners();
  }

  Future<void> importWallet(String name, String address, String blockchain) async {
    final wallet = BlockchainWallet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      address: address,
      blockchain: blockchain,
      balance: 0.0,
      supportedTokens: _getDefaultTokensForBlockchain(blockchain),
      createdAt: DateTime.now(),
      isActive: true,
      metadata: {
        'derivation_path': 'imported',
        'wallet_type': 'imported',
      },
    );

    _wallets.add(wallet);
    await _saveData();
    notifyListeners();
  }

  Future<void> deleteWallet(String walletId) async {
    _wallets.removeWhere((w) => w.id == walletId);
    await _saveData();
    notifyListeners();
  }

  // DeFi Protocol methods
  Future<void> addProtocol(DeFiProtocol protocol) async {
    _protocols.add(protocol);
    await _saveData();
    notifyListeners();
  }

  Future<void> removeProtocol(String protocolId) async {
    _protocols.removeWhere((p) => p.id == protocolId);
    await _saveData();
    notifyListeners();
  }

  // Smart Contract methods
  Future<void> deployContract(SmartContract contract) async {
    contract.status = 'pending';
    _contracts.add(contract);
    notifyListeners();

    // Simulate deployment process
    await Future.delayed(const Duration(seconds: 3));
    
    contract.status = 'deployed';
    contract.deployedAt = DateTime.now();
    
    await _saveData();
    notifyListeners();
  }

  Future<void> updateContractStatus(String contractId, String status) async {
    final contractIndex = _contracts.indexWhere((c) => c.id == contractId);
    if (contractIndex == -1) return;

    _contracts[contractIndex].status = status;
    await _saveData();
    notifyListeners();
  }

  // Token methods
  Future<void> addToken(Token token) async {
    _tokens.add(token);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateTokenPrice(String tokenId, double price) async {
    final tokenIndex = _tokens.indexWhere((t) => t.id == tokenId);
    if (tokenIndex == -1) return;

    _tokens[tokenIndex].price = price;
    _tokens[tokenIndex].marketCap = price * _tokens[tokenIndex].totalSupply;
    
    await _saveData();
    notifyListeners();
  }

  // Transaction methods
  Future<void> addTransaction(BlockchainTransaction transaction) async {
    _transactions.add(transaction);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateTransactionStatus(String transactionId, String status) async {
    final transactionIndex = _transactions.indexWhere((t) => t.id == transactionId);
    if (transactionIndex == -1) return;

    _transactions[transactionIndex].status = status;
    await _saveData();
    notifyListeners();
  }

  // Utility methods
  String _generateWalletAddress(String blockchain) {
    // Simple address generation for demo purposes
    final random = Random();
    final chars = '0123456789abcdef';
    String address = '0x';
    for (int i = 0; i < 40; i++) {
      address += chars[random.nextInt(chars.length)];
    }
    return address;
  }

  List<String> _getDefaultTokensForBlockchain(String blockchain) {
    switch (blockchain.toLowerCase()) {
      case 'ethereum':
        return ['ETH', 'USDC', 'USDT', 'DAI', 'WETH'];
      case 'polygon':
        return ['MATIC', 'USDC', 'USDT', 'WETH', 'QUICK'];
      case 'bsc':
        return ['BNB', 'BUSD', 'USDT', 'CAKE', 'WBNB'];
      case 'solana':
        return ['SOL', 'USDC', 'USDT', 'RAY', 'SRM'];
      default:
        return ['ETH', 'USDC'];
    }
  }

  String _getCoinType(String blockchain) {
    switch (blockchain.toLowerCase()) {
      case 'ethereum':
        return '60';
      case 'polygon':
        return '60';
      case 'bsc':
        return '60';
      case 'solana':
        return '501';
      default:
        return '60';
    }
  }

  // Search methods
  List<BlockchainWallet> searchWallets(String query) {
    if (query.isEmpty) return _wallets;
    
    return _wallets.where((wallet) =>
        wallet.name.toLowerCase().contains(query.toLowerCase()) ||
        wallet.address.toLowerCase().contains(query.toLowerCase()) ||
        wallet.blockchain.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<DeFiProtocol> searchProtocols(String query) {
    if (query.isEmpty) return _protocols;
    
    return _protocols.where((protocol) =>
        protocol.name.toLowerCase().contains(query.toLowerCase()) ||
        protocol.description.toLowerCase().contains(query.toLowerCase()) ||
        protocol.type.toLowerCase().contains(query.toLowerCase()) ||
        protocol.blockchain.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<SmartContract> searchContracts(String query) {
    if (query.isEmpty) return _contracts;
    
    return _contracts.where((contract) =>
        contract.name.toLowerCase().contains(query.toLowerCase()) ||
        contract.description.toLowerCase().contains(query.toLowerCase()) ||
        contract.type.toLowerCase().contains(query.toLowerCase()) ||
        contract.blockchain.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<Token> searchTokens(String query) {
    if (query.isEmpty) return _tokens;
    
    return _tokens.where((token) =>
        token.name.toLowerCase().contains(query.toLowerCase()) ||
        token.symbol.toLowerCase().contains(query.toLowerCase()) ||
        token.blockchain.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Analytics methods
  double getTotalPortfolioValue() {
    double total = 0.0;
    for (final wallet in _wallets) {
      total += wallet.balance * _getTokenPrice('ETH'); // Assuming ETH as base
    }
    return total;
  }

  double _getTokenPrice(String symbol) {
    final token = _tokens.firstWhere(
      (t) => t.symbol == symbol,
      orElse: () => Token(
        id: '0',
        name: 'Unknown',
        symbol: symbol,
        contractAddress: '',
        blockchain: '',
        totalSupply: 0.0,
        price: 0.0,
        marketCap: 0.0,
        volume24h: 0.0,
        tokenType: 'unknown',
        metadata: {},
      ),
    );
    return token.price;
  }

  List<BlockchainTransaction> getWalletTransactions(String walletAddress) {
    return _transactions.where((tx) =>
        tx.fromAddress.toLowerCase() == walletAddress.toLowerCase() ||
        tx.toAddress.toLowerCase() == walletAddress.toLowerCase()).toList();
  }

  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }
}
