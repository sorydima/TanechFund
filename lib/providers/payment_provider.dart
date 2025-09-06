import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
}

enum PaymentMethod {
  creditCard,
  bankTransfer,
  crypto,
  paypal,
  applePay,
  googlePay,
}

enum TransactionType {
  deposit,
  withdrawal,
  transfer,
  payment,
  refund,
  fee,
  reward,
}

class PaymentTransaction {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String currency;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime timestamp;
  final String? description;
  final String? reference;
  final Map<String, dynamic>? metadata;
  final String? errorMessage;

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.timestamp,
    this.description,
    this.reference,
    this.metadata,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.index,
      'amount': amount,
      'currency': currency,
      'method': method.index,
      'status': status.index,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'reference': reference,
      'metadata': metadata,
      'errorMessage': errorMessage,
    };
  }

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'],
      userId: json['userId'],
      type: TransactionType.values[json['type']],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      method: PaymentMethod.values[json['method']],
      status: PaymentStatus.values[json['status']],
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      reference: json['reference'],
      metadata: json['metadata'],
      errorMessage: json['errorMessage'],
    );
  }

  PaymentTransaction copyWith({
    String? id,
    String? userId,
    TransactionType? type,
    double? amount,
    String? currency,
    PaymentMethod? method,
    PaymentStatus? status,
    DateTime? timestamp,
    String? description,
    String? reference,
    Map<String, dynamic>? metadata,
    String? errorMessage,
  }) {
    return PaymentTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      method: method ?? this.method,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      metadata: metadata ?? this.metadata,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PaymentMethodInfo {
  final PaymentMethod method;
  final String name;
  final String description;
  final IconData icon;
  final bool isEnabled;
  final double? fee;
  final String? feeCurrency;
  final List<String> supportedCurrencies;

  PaymentMethodInfo({
    required this.method,
    required this.name,
    required this.description,
    required this.icon,
    required this.isEnabled,
    this.fee,
    this.feeCurrency,
    required this.supportedCurrencies,
  });
}

class PaymentProvider extends ChangeNotifier {
  List<PaymentTransaction> _transactions = [];
  double _balance = 0.0;
  String _defaultCurrency = 'USD';
  List<PaymentMethodInfo> _paymentMethods = [];
  bool _isLoading = false;
  String? _error;

  // Геттеры
  List<PaymentTransaction> get transactions => _transactions;
  double get balance => _balance;
  String get defaultCurrency => _defaultCurrency;
  List<PaymentMethodInfo> get paymentMethods => _paymentMethods;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Получение транзакций по статусу
  List<PaymentTransaction> getTransactionsByStatus(PaymentStatus status) {
    return _transactions.where((tx) => tx.status == status).toList();
  }

  // Получение транзакций по типу
  List<PaymentTransaction> getTransactionsByType(TransactionType type) {
    return _transactions.where((tx) => tx.type == type).toList();
  }

  // Получение транзакций за период
  List<PaymentTransaction> getTransactionsInPeriod(DateTime start, DateTime end) {
    return _transactions
        .where((tx) => tx.timestamp.isAfter(start) && tx.timestamp.isBefore(end))
        .toList();
  }

  PaymentProvider() {
    _loadPaymentData();
    _initializePaymentMethods();
    _createDemoTransactions();
  }

  // Загрузка данных платежей
  Future<void> _loadPaymentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Загрузка баланса
      _balance = prefs.getDouble('payment_balance') ?? 0.0;
      
      // Загрузка валюты
      _defaultCurrency = prefs.getString('payment_currency') ?? 'USD';
      
      // Загрузка транзакций
      final transactionsJson = prefs.getStringList('payment_transactions') ?? [];
      _transactions = transactionsJson
          .map((json) => PaymentTransaction.fromJson(jsonDecode(json)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки платежных данных: $e';
      notifyListeners();
    }
  }

  // Сохранение данных платежей
  Future<void> _savePaymentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Сохранение баланса
      await prefs.setDouble('payment_balance', _balance);
      
      // Сохранение валюты
      await prefs.setString('payment_currency', _defaultCurrency);
      
      // Сохранение транзакций
      final transactionsJson = _transactions
          .map((tx) => jsonEncode(tx.toJson()))
          .toList();
      await prefs.setStringList('payment_transactions', transactionsJson);
    } catch (e) {
      _error = 'Ошибка сохранения платежных данных: $e';
      notifyListeners();
    }
  }

  // Инициализация способов оплаты
  void _initializePaymentMethods() {
    _paymentMethods = [
      PaymentMethodInfo(
        method: PaymentMethod.creditCard,
        name: 'Банковская карта',
        description: 'Visa, MasterCard, МИР',
        icon: Icons.credit_card,
        isEnabled: true,
        fee: 2.5,
        feeCurrency: 'USD',
        supportedCurrencies: ['USD', 'EUR', 'RUB'],
      ),
      PaymentMethodInfo(
        method: PaymentMethod.bankTransfer,
        name: 'Банковский перевод',
        description: 'SWIFT, SEPA, местные переводы',
        icon: Icons.account_balance,
        isEnabled: true,
        fee: 15.0,
        feeCurrency: 'USD',
        supportedCurrencies: ['USD', 'EUR', 'RUB'],
      ),
      PaymentMethodInfo(
        method: PaymentMethod.crypto,
        name: 'Криптовалюта',
        description: 'Bitcoin, Ethereum, USDT',
        icon: Icons.currency_bitcoin,
        isEnabled: true,
        fee: 0.0,
        feeCurrency: null,
        supportedCurrencies: ['BTC', 'ETH', 'USDT', 'SOL'],
      ),
      PaymentMethodInfo(
        method: PaymentMethod.paypal,
        name: 'PayPal',
        description: 'Быстрые платежи',
        icon: Icons.payment,
        isEnabled: true,
        fee: 3.5,
        feeCurrency: 'USD',
        supportedCurrencies: ['USD', 'EUR'],
      ),
      PaymentMethodInfo(
        method: PaymentMethod.applePay,
        name: 'Apple Pay',
        description: 'Безопасные платежи Apple',
        icon: Icons.apple,
        isEnabled: false,
        fee: 0.0,
        feeCurrency: null,
        supportedCurrencies: ['USD', 'EUR'],
      ),
      PaymentMethodInfo(
        method: PaymentMethod.googlePay,
        name: 'Google Pay',
        description: 'Быстрые платежи Google',
        icon: Icons.android,
        isEnabled: false,
        fee: 0.0,
        feeCurrency: null,
        supportedCurrencies: ['USD', 'EUR'],
      ),
    ];
  }

  // Создание демо транзакций
  void _createDemoTransactions() {
    if (_transactions.isEmpty) {
      final demoTransactions = [
        PaymentTransaction(
          id: 'tx_001',
          userId: 'user_001',
          type: TransactionType.deposit,
          amount: 1000.0,
          currency: 'USD',
          method: PaymentMethod.creditCard,
          status: PaymentStatus.completed,
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
          description: 'Пополнение счета',
          reference: 'DEP-001',
        ),
        PaymentTransaction(
          id: 'tx_002',
          userId: 'user_001',
          type: TransactionType.payment,
          amount: 150.0,
          currency: 'USD',
          method: PaymentMethod.crypto,
          status: PaymentStatus.completed,
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          description: 'Оплата хакатона Solana Builders',
          reference: 'HACK-001',
        ),
        PaymentTransaction(
          id: 'tx_003',
          userId: 'user_001',
          type: TransactionType.reward,
          amount: 500.0,
          currency: 'USD',
          method: PaymentMethod.crypto,
          status: PaymentStatus.completed,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          description: 'Приз за победу в челлендже',
          reference: 'REW-001',
        ),
        PaymentTransaction(
          id: 'tx_004',
          userId: 'user_001',
          type: TransactionType.withdrawal,
          amount: 200.0,
          currency: 'USD',
          method: PaymentMethod.bankTransfer,
          status: PaymentStatus.processing,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          description: 'Вывод средств',
          reference: 'WTH-001',
        ),
        PaymentTransaction(
          id: 'tx_005',
          userId: 'user_001',
          type: TransactionType.fee,
          amount: 2.5,
          currency: 'USD',
          method: PaymentMethod.creditCard,
          status: PaymentStatus.completed,
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          description: 'Комиссия за пополнение',
          reference: 'FEE-001',
        ),
      ];
      
      _transactions.addAll(demoTransactions);
      
      // Обновить баланс
      _updateBalance();
      
      _savePaymentData();
      notifyListeners();
    }
  }

  // Обновление баланса
  void _updateBalance() {
    double newBalance = 0.0;
    
    for (final tx in _transactions) {
      switch (tx.type) {
        case TransactionType.deposit:
        case TransactionType.reward:
        case TransactionType.refund:
          newBalance += tx.amount;
          break;
        case TransactionType.withdrawal:
        case TransactionType.payment:
        case TransactionType.fee:
          newBalance -= tx.amount;
          break;
        case TransactionType.transfer:
          // Для трансферов нужно учитывать направление
          if (tx.metadata?['direction'] == 'in') {
            newBalance += tx.amount;
          } else {
            newBalance -= tx.amount;
          }
          break;
      }
    }
    
    _balance = newBalance;
  }

  // Создание новой транзакции
  Future<PaymentTransaction?> createTransaction({
    required TransactionType type,
    required double amount,
    required String currency,
    required PaymentMethod method,
    String? description,
    String? reference,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _setLoading(true);
      
      final transaction = PaymentTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user_001', // В реальном приложении из AuthProvider
        type: type,
        amount: amount,
        currency: currency,
        method: method,
        status: PaymentStatus.pending,
        timestamp: DateTime.now(),
        description: description,
        reference: reference,
        metadata: metadata,
      );
      
      _transactions.add(transaction);
      
      // Обновить баланс
      _updateBalance();
      
      await _savePaymentData();
      notifyListeners();
      
      // Имитация обработки платежа
      _processTransaction(transaction);
      
      return transaction;
    } catch (e) {
      _error = 'Ошибка создания транзакции: $e';
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Обработка транзакции
  void _processTransaction(PaymentTransaction transaction) {
    Future.delayed(const Duration(seconds: 2), () {
      PaymentStatus newStatus;
      String? errorMessage;
      
      // Имитация успешности платежа (90% успех)
      final isSuccess = DateTime.now().millisecondsSinceEpoch % 10 < 9;
      
      if (isSuccess) {
        newStatus = PaymentStatus.completed;
      } else {
        newStatus = PaymentStatus.failed;
        errorMessage = 'Ошибка обработки платежа';
      }
      
      // Обновить статус транзакции
      final index = _transactions.indexWhere((tx) => tx.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction.copyWith(
          status: newStatus,
          errorMessage: errorMessage,
        );
        
        // Обновить баланс
        _updateBalance();
        
        _savePaymentData();
        notifyListeners();
      }
    });
  }

  // Отмена транзакции
  Future<bool> cancelTransaction(String transactionId) async {
    try {
      final index = _transactions.indexWhere((tx) => tx.id == transactionId);
      if (index == -1) return false;
      
      final transaction = _transactions[index];
      if (transaction.status != PaymentStatus.pending) return false;
      
      _transactions[index] = transaction.copyWith(
        status: PaymentStatus.cancelled,
      );
      
      // Обновить баланс
      _updateBalance();
      
      await _savePaymentData();
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = 'Ошибка отмены транзакции: $e';
      notifyListeners();
      return false;
    }
  }

  // Возврат средств
  Future<bool> refundTransaction(String transactionId, double amount) async {
    try {
      final index = _transactions.indexWhere((tx) => tx.id == transactionId);
      if (index == -1) return false;
      
      final transaction = _transactions[index];
      if (transaction.status != PaymentStatus.completed) return false;
      
      // Создать транзакцию возврата
      final refundTransaction = PaymentTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: transaction.userId,
        type: TransactionType.refund,
        amount: amount,
        currency: transaction.currency,
        method: transaction.method,
        status: PaymentStatus.completed,
        timestamp: DateTime.now(),
        description: 'Возврат средств',
        reference: 'REF-${transaction.reference}',
        metadata: {'originalTransactionId': transactionId},
      );
      
      _transactions.add(refundTransaction);
      
      // Обновить баланс
      _updateBalance();
      
      await _savePaymentData();
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = 'Ошибка возврата средств: $e';
      notifyListeners();
      return false;
    }
  }

  // Изменение валюты по умолчанию
  Future<void> changeDefaultCurrency(String currency) async {
    _defaultCurrency = currency;
    await _savePaymentData();
    notifyListeners();
  }

  // Получение статистики
  Map<String, dynamic> getPaymentStatistics() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthTransactions = getTransactionsInPeriod(monthStart, now);
    
    double totalIncome = 0.0;
    double totalExpenses = 0.0;
    int successfulTransactions = 0;
    int failedTransactions = 0;
    
    for (final tx in monthTransactions) {
      if (tx.status == PaymentStatus.completed) {
        successfulTransactions++;
        
        switch (tx.type) {
          case TransactionType.deposit:
          case TransactionType.reward:
          case TransactionType.refund:
            totalIncome += tx.amount;
            break;
          case TransactionType.withdrawal:
          case TransactionType.payment:
          case TransactionType.fee:
            totalExpenses += tx.amount;
            break;
          case TransactionType.transfer:
            if (tx.metadata?['direction'] == 'in') {
              totalIncome += tx.amount;
            } else {
              totalExpenses += tx.amount;
            }
            break;
        }
      } else if (tx.status == PaymentStatus.failed) {
        failedTransactions++;
      }
    }
    
    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'netIncome': totalIncome - totalExpenses,
      'successfulTransactions': successfulTransactions,
      'failedTransactions': failedTransactions,
      'successRate': monthTransactions.isNotEmpty 
          ? (successfulTransactions / monthTransactions.length * 100).toStringAsFixed(1)
          : '0.0',
    };
  }

  // Получение цвета для статуса
  Color getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.processing:
        return Colors.blue;
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.cancelled:
        return Colors.grey;
      case PaymentStatus.refunded:
        return Colors.purple;
    }
  }

  // Получение иконки для типа транзакции
  IconData getTransactionTypeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return Icons.add_circle;
      case TransactionType.withdrawal:
        return Icons.remove_circle;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.payment:
        return Icons.payment;
      case TransactionType.refund:
        return Icons.undo;
      case TransactionType.fee:
        return Icons.account_balance_wallet;
      case TransactionType.reward:
        return Icons.emoji_events;
    }
  }

  // Получение цвета для типа транзакции
  Color getTransactionTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
      case TransactionType.reward:
      case TransactionType.refund:
        return Colors.green;
      case TransactionType.withdrawal:
      case TransactionType.payment:
      case TransactionType.fee:
        return Colors.red;
      case TransactionType.transfer:
        return Colors.blue;
    }
  }

  // Установка загрузки
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Очистка ошибки
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
