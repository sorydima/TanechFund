import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Hardware Wallet Types
enum HardwareWalletType {
  ledger,
  trezor,
  keystone,
  bitbox,
  coldcard,
}

// Hardware Wallet Connection Status
enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
  locked,
}

// Hardware Wallet Account
class HardwareWalletAccount {
  final String id;
  final String walletId;
  final String name;
  final String address;
  final String derivationPath;
  final double balance;
  final String currency;
  final bool isActive;
  final DateTime lastUsed;
  final Map<String, dynamic> metadata;

  HardwareWalletAccount({
    required this.id,
    required this.walletId,
    required this.name,
    required this.address,
    required this.derivationPath,
    required this.balance,
    required this.currency,
    required this.isActive,
    required this.lastUsed,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletId': walletId,
      'name': name,
      'address': address,
      'derivationPath': derivationPath,
      'balance': balance,
      'currency': currency,
      'isActive': isActive,
      'lastUsed': lastUsed.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory HardwareWalletAccount.fromJson(Map<String, dynamic> json) {
    return HardwareWalletAccount(
      id: json['id'],
      walletId: json['walletId'],
      name: json['name'],
      address: json['address'],
      derivationPath: json['derivationPath'],
      balance: json['balance'].toDouble(),
      currency: json['currency'],
      isActive: json['isActive'],
      lastUsed: DateTime.parse(json['lastUsed']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  HardwareWalletAccount copyWith({
    String? id,
    String? walletId,
    String? name,
    String? address,
    String? derivationPath,
    double? balance,
    String? currency,
    bool? isActive,
    DateTime? lastUsed,
    Map<String, dynamic>? metadata,
  }) {
    return HardwareWalletAccount(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      name: name ?? this.name,
      address: address ?? this.address,
      derivationPath: derivationPath ?? this.derivationPath,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      lastUsed: lastUsed ?? this.lastUsed,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Hardware Wallet Device
class HardwareWalletDevice {
  final String id;
  final String name;
  final HardwareWalletType type;
  final String model;
  final String firmwareVersion;
  final ConnectionStatus status;
  final String? errorMessage;
  final DateTime lastConnected;
  final bool isLocked;
  final Map<String, dynamic> capabilities;
  final Map<String, dynamic> metadata;

  HardwareWalletDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.model,
    required this.firmwareVersion,
    required this.status,
    this.errorMessage,
    required this.lastConnected,
    required this.isLocked,
    required this.capabilities,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'model': model,
      'firmwareVersion': firmwareVersion,
      'status': status.name,
      'errorMessage': errorMessage,
      'lastConnected': lastConnected.toIso8601String(),
      'isLocked': isLocked,
      'capabilities': capabilities,
      'metadata': metadata,
    };
  }

  factory HardwareWalletDevice.fromJson(Map<String, dynamic> json) {
    return HardwareWalletDevice(
      id: json['id'],
      name: json['name'],
      type: HardwareWalletType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => HardwareWalletType.ledger,
      ),
      model: json['model'],
      firmwareVersion: json['firmwareVersion'],
      status: ConnectionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ConnectionStatus.disconnected,
      ),
      errorMessage: json['errorMessage'],
      lastConnected: DateTime.parse(json['lastConnected']),
      isLocked: json['isLocked'],
      capabilities: Map<String, dynamic>.from(json['capabilities']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  HardwareWalletDevice copyWith({
    String? id,
    String? name,
    HardwareWalletType? type,
    String? model,
    String? firmwareVersion,
    ConnectionStatus? status,
    String? errorMessage,
    DateTime? lastConnected,
    bool? isLocked,
    Map<String, dynamic>? capabilities,
    Map<String, dynamic>? metadata,
  }) {
    return HardwareWalletDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      model: model ?? this.model,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastConnected: lastConnected ?? this.lastConnected,
      isLocked: isLocked ?? this.isLocked,
      capabilities: capabilities ?? this.capabilities,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Transaction to Sign
class TransactionToSign {
  final String id;
  final String accountId;
  final String type; // 'send', 'swap', 'stake', 'unstake'
  final Map<String, dynamic> transactionData;
  final String? message;
  final DateTime createdAt;
  final bool isSigned;
  final String? signature;
  final String? txHash;

  TransactionToSign({
    required this.id,
    required this.accountId,
    required this.type,
    required this.transactionData,
    this.message,
    required this.createdAt,
    required this.isSigned,
    this.signature,
    this.txHash,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountId': accountId,
      'type': type,
      'transactionData': transactionData,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isSigned': isSigned,
      'signature': signature,
      'txHash': txHash,
    };
  }

  factory TransactionToSign.fromJson(Map<String, dynamic> json) {
    return TransactionToSign(
      id: json['id'],
      accountId: json['accountId'],
      type: json['type'],
      transactionData: Map<String, dynamic>.from(json['transactionData']),
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      isSigned: json['isSigned'],
      signature: json['signature'],
      txHash: json['txHash'],
    );
  }

  TransactionToSign copyWith({
    String? id,
    String? accountId,
    String? type,
    Map<String, dynamic>? transactionData,
    String? message,
    DateTime? createdAt,
    bool? isSigned,
    String? signature,
    String? txHash,
  }) {
    return TransactionToSign(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      type: type ?? this.type,
      transactionData: transactionData ?? this.transactionData,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isSigned: isSigned ?? this.isSigned,
      signature: signature ?? this.signature,
      txHash: txHash ?? this.txHash,
    );
  }
}

// Hardware Wallet Provider
class HardwareWalletProvider extends ChangeNotifier {
  List<HardwareWalletDevice> _devices = [];
  List<HardwareWalletAccount> _accounts = [];
  List<TransactionToSign> _pendingTransactions = [];
  String _currentUserId = 'current_user';

  // Getters
  List<HardwareWalletDevice> get devices => _devices;
  List<HardwareWalletAccount> get accounts => _accounts;
  List<TransactionToSign> get pendingTransactions => _pendingTransactions;
  List<HardwareWalletDevice> get connectedDevices => 
      _devices.where((device) => device.status == ConnectionStatus.connected).toList();

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_devices.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final devicesJson = prefs.getStringList('hardware_wallet_devices') ?? [];
      _devices = devicesJson
          .map((json) => HardwareWalletDevice.fromJson(jsonDecode(json)))
          .toList();

      final accountsJson = prefs.getStringList('hardware_wallet_accounts') ?? [];
      _accounts = accountsJson
          .map((json) => HardwareWalletAccount.fromJson(jsonDecode(json)))
          .toList();

      final transactionsJson = prefs.getStringList('hardware_wallet_transactions') ?? [];
      _pendingTransactions = transactionsJson
          .map((json) => TransactionToSign.fromJson(jsonDecode(json)))
          .toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Hardware Wallet data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setStringList('hardware_wallet_devices', 
          _devices.map((device) => jsonEncode(device.toJson())).toList());
      
      await prefs.setStringList('hardware_wallet_accounts', 
          _accounts.map((account) => jsonEncode(account.toJson())).toList());
      
      await prefs.setStringList('hardware_wallet_transactions', 
          _pendingTransactions.map((tx) => jsonEncode(tx.toJson())).toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Hardware Wallet data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample devices
    _devices = [
      HardwareWalletDevice(
        id: '1',
        name: 'Ledger Nano X',
        type: HardwareWalletType.ledger,
        model: 'Nano X',
        firmwareVersion: '2.1.0',
        status: ConnectionStatus.connected,
        lastConnected: DateTime.now(),
        isLocked: false,
        capabilities: {
          'ethereum': true,
          'bitcoin': true,
          'polygon': true,
          'bsc': true,
          'solana': true,
          'multisig': true,
        },
        metadata: {
          'bluetooth': true,
          'battery': 85,
          'color': 'black',
        },
      ),
      HardwareWalletDevice(
        id: '2',
        name: 'Trezor Model T',
        type: HardwareWalletType.trezor,
        model: 'Model T',
        firmwareVersion: '2.6.0',
        status: ConnectionStatus.disconnected,
        lastConnected: DateTime.now().subtract(const Duration(days: 2)),
        isLocked: true,
        capabilities: {
          'ethereum': true,
          'bitcoin': true,
          'polygon': true,
          'bsc': true,
          'cardano': true,
          'multisig': true,
        },
        metadata: {
          'touchscreen': true,
          'color': 'white',
        },
      ),
      HardwareWalletDevice(
        id: '3',
        name: 'Keystone Pro',
        type: HardwareWalletType.keystone,
        model: 'Pro',
        firmwareVersion: '1.2.0',
        status: ConnectionStatus.connected,
        lastConnected: DateTime.now(),
        isLocked: false,
        capabilities: {
          'ethereum': true,
          'bitcoin': true,
          'polygon': true,
          'bsc': true,
          'multisig': true,
        },
        metadata: {
          'air_gapped': true,
          'color': 'blue',
        },
      ),
    ];

    // Create sample accounts
    _accounts = [
      HardwareWalletAccount(
        id: '1',
        walletId: '1',
        name: 'Main ETH Account',
        address: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        derivationPath: "m/44'/60'/0'/0/0",
        balance: 2.45,
        currency: 'ETH',
        isActive: true,
        lastUsed: DateTime.now(),
        metadata: {
          'label': 'Main Account',
          'favorite': true,
        },
      ),
      HardwareWalletAccount(
        id: '2',
        walletId: '1',
        name: 'DeFi Account',
        address: '0x8ba1f109551bA432bDF5c3c92bEa5e236bc33488',
        derivationPath: "m/44'/60'/0'/0/1",
        balance: 1250.75,
        currency: 'USDC',
        isActive: true,
        lastUsed: DateTime.now().subtract(const Duration(hours: 2)),
        metadata: {
          'label': 'DeFi Operations',
          'favorite': false,
        },
      ),
      HardwareWalletAccount(
        id: '3',
        walletId: '2',
        name: 'Trezor BTC',
        address: 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh',
        derivationPath: "m/44'/0'/0'/0/0",
        balance: 0.125,
        currency: 'BTC',
        isActive: true,
        lastUsed: DateTime.now().subtract(const Duration(days: 1)),
        metadata: {
          'label': 'Bitcoin Storage',
          'favorite': true,
        },
      ),
    ];

    // Create sample pending transactions
    _pendingTransactions = [
      TransactionToSign(
        id: '1',
        accountId: '1',
        type: 'send',
        transactionData: {
          'to': '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
          'amount': '0.1',
          'gas': '21000',
          'gasPrice': '20000000000',
          'nonce': 5,
        },
        message: 'Send 0.1 ETH to main account',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isSigned: false,
      ),
      TransactionToSign(
        id: '2',
        accountId: '2',
        type: 'swap',
        transactionData: {
          'from': 'USDC',
          'to': 'ETH',
          'amount': '500',
          'slippage': '0.5',
          'router': '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
        },
        message: 'Swap 500 USDC to ETH',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        isSigned: false,
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // Device management methods
  Future<bool> connectDevice(String deviceId) async {
    final deviceIndex = _devices.indexWhere((device) => device.id == deviceId);
    if (deviceIndex == -1) return false;

    // Simulate connection process
    _devices[deviceIndex] = _devices[deviceIndex].copyWith(
      status: ConnectionStatus.connecting,
    );
    notifyListeners();

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    _devices[deviceIndex] = _devices[deviceIndex].copyWith(
      status: ConnectionStatus.connected,
      lastConnected: DateTime.now(),
      isLocked: false,
      errorMessage: null,
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  Future<bool> disconnectDevice(String deviceId) async {
    final deviceIndex = _devices.indexWhere((device) => device.id == deviceId);
    if (deviceIndex == -1) return false;

    _devices[deviceIndex] = _devices[deviceIndex].copyWith(
      status: ConnectionStatus.disconnected,
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  Future<bool> unlockDevice(String deviceId, String pin) async {
    final deviceIndex = _devices.indexWhere((device) => device.id == deviceId);
    if (deviceIndex == -1) return false;

    // Simulate PIN verification
    if (pin == '1234') {
      _devices[deviceIndex] = _devices[deviceIndex].copyWith(
        isLocked: false,
        errorMessage: null,
      );
      await _saveData();
      notifyListeners();
      return true;
    } else {
      _devices[deviceIndex] = _devices[deviceIndex].copyWith(
        errorMessage: 'Invalid PIN',
      );
      notifyListeners();
      return false;
    }
  }

  // Account management methods
  Future<HardwareWalletAccount?> createAccount(
    String walletId,
    String name,
    String derivationPath,
    String currency,
  ) async {
    final device = _devices.firstWhere((d) => d.id == walletId);
    if (device.status != ConnectionStatus.connected) return null;

    final account = HardwareWalletAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      walletId: walletId,
      name: name,
      address: _generateAddress(),
      derivationPath: derivationPath,
      balance: 0.0,
      currency: currency,
      isActive: true,
      lastUsed: DateTime.now(),
      metadata: {
        'label': name,
        'favorite': false,
      },
    );

    _accounts.add(account);
    await _saveData();
    notifyListeners();
    return account;
  }

  Future<bool> updateAccount(String accountId, Map<String, dynamic> updates) async {
    final accountIndex = _accounts.indexWhere((account) => account.id == accountId);
    if (accountIndex == -1) return false;

    _accounts[accountIndex] = _accounts[accountIndex].copyWith(
      name: updates['name'] ?? _accounts[accountIndex].name,
      isActive: updates['isActive'] ?? _accounts[accountIndex].isActive,
      metadata: updates['metadata'] ?? _accounts[accountIndex].metadata,
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  Future<bool> removeAccount(String accountId) async {
    final accountIndex = _accounts.indexWhere((account) => account.id == accountId);
    if (accountIndex == -1) return false;

    _accounts.removeAt(accountIndex);
    await _saveData();
    notifyListeners();
    return true;
  }

  // Transaction methods
  Future<TransactionToSign?> createTransaction(
    String accountId,
    String type,
    Map<String, dynamic> transactionData,
    String? message,
  ) async {
    final account = _accounts.firstWhere((acc) => acc.id == accountId);
    if (!account.isActive) return null;

    final transaction = TransactionToSign(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      accountId: accountId,
      type: type,
      transactionData: transactionData,
      message: message,
      createdAt: DateTime.now(),
      isSigned: false,
    );

    _pendingTransactions.add(transaction);
    await _saveData();
    notifyListeners();
    return transaction;
  }

  Future<bool> signTransaction(String transactionId, String signature) async {
    final transactionIndex = _pendingTransactions.indexWhere((tx) => tx.id == transactionId);
    if (transactionIndex == -1) return false;

    _pendingTransactions[transactionIndex] = _pendingTransactions[transactionIndex].copyWith(
      isSigned: true,
      signature: signature,
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  Future<bool> completeTransaction(String transactionId, String txHash) async {
    final transactionIndex = _pendingTransactions.indexWhere((tx) => tx.id == transactionId);
    if (transactionIndex == -1) return false;

    _pendingTransactions[transactionIndex] = _pendingTransactions[transactionIndex].copyWith(
      txHash: txHash,
    );

    await _saveData();
    notifyListeners();
    return true;
  }

  // Utility methods
  String _generateAddress() {
    const chars = '0123456789abcdef';
    final random = Random();
    return '0x${List.generate(40, (index) => chars[random.nextInt(chars.length)]).join()}';
  }

  List<HardwareWalletAccount> getAccountsByWallet(String walletId) {
    return _accounts.where((account) => account.walletId == walletId).toList();
  }

  List<TransactionToSign> getPendingTransactionsByAccount(String accountId) {
    return _pendingTransactions.where((tx) => tx.accountId == accountId && !tx.isSigned).toList();
  }

  List<TransactionToSign> getCompletedTransactionsByAccount(String accountId) {
    return _pendingTransactions.where((tx) => tx.accountId == accountId && tx.isSigned).toList();
  }

  // Search methods
  List<HardwareWalletDevice> searchDevices(String query) {
    if (query.isEmpty) return _devices;
    
    return _devices.where((device) =>
        device.name.toLowerCase().contains(query.toLowerCase()) ||
        device.model.toLowerCase().contains(query.toLowerCase()) ||
        device.type.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<HardwareWalletAccount> searchAccounts(String query) {
    if (query.isEmpty) return _accounts;
    
    return _accounts.where((account) =>
        account.name.toLowerCase().contains(query.toLowerCase()) ||
        account.address.toLowerCase().contains(query.toLowerCase()) ||
        account.currency.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }
}
