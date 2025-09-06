import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/payment_provider.dart';
import 'package:intl/intl.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Платежи'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showPaymentDialog(
              title: 'Новый платеж',
              type: TransactionType.payment,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Баланс'),
            Tab(text: 'Транзакции'),
            Tab(text: 'Способы оплаты'),
            Tab(text: 'Статистика'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBalanceTab(),
          _buildTransactionsTab(),
          _buildPaymentMethodsTab(),
          _buildStatisticsTab(),
        ],
      ),
    );
  }

  // Вкладка баланса
  Widget _buildBalanceTab() {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Карточка баланса
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Текущий баланс',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${paymentProvider.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBalanceAction(
                          icon: Icons.add,
                          label: 'Пополнить',
                          onTap: () => _showDepositDialog(),
                        ),
                        _buildBalanceAction(
                          icon: Icons.remove,
                          label: 'Вывести',
                          onTap: () => _showWithdrawalDialog(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Быстрые действия
              const Text(
                'Быстрые действия',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.event,
                      title: 'Оплатить хакатон',
                      subtitle: 'Участие в соревнованиях',
                      onTap: () => _showHackathonPaymentDialog(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.emoji_events,
                      title: 'Оплатить челлендж',
                      subtitle: 'Доступ к заданиям',
                      onTap: () => _showChallengePaymentDialog(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Вкладка транзакций
  Widget _buildTransactionsTab() {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        final transactions = paymentProvider.transactions;
        
        if (transactions.isEmpty) {
          return const Center(
            child: Text('Нет транзакций'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionCard(transaction, paymentProvider);
          },
        );
      },
    );
  }

  // Вкладка способов оплаты
  Widget _buildPaymentMethodsTab() {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: paymentProvider.paymentMethods.length,
          itemBuilder: (context, index) {
            final method = paymentProvider.paymentMethods[index];
            return _buildPaymentMethodCard(method);
          },
        );
      },
    );
  }

  // Вкладка статистики
  Widget _buildStatisticsTab() {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        final stats = paymentProvider.getPaymentStatistics();
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Статистика за месяц
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Статистика за месяц',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Доходы',
                            '\$${stats['totalIncome'].toStringAsFixed(2)}',
                            Colors.green,
                            Icons.trending_up,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            'Расходы',
                            '\$${stats['totalExpenses'].toStringAsFixed(2)}',
                            Colors.red,
                            Icons.trending_down,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Чистый доход',
                            '\$${stats['netIncome'].toStringAsFixed(2)}',
                            stats['netIncome'] >= 0 ? Colors.green : Colors.red,
                            Icons.account_balance_wallet,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            'Успешность',
                            '${stats['successRate']}%',
                            Colors.blue,
                            Icons.check_circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // График транзакций
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Активность транзакций',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Простой график (в реальном приложении можно использовать fl_chart)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'График транзакций\n(требует интеграции с fl_chart)',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Виджет действия с балансом
  Widget _buildBalanceAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка быстрого действия
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Карточка транзакции
  Widget _buildTransactionCard(PaymentTransaction transaction, PaymentProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: provider.getTransactionTypeColor(transaction.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              provider.getTransactionTypeIcon(transaction.type),
              color: provider.getTransactionTypeColor(transaction.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ?? 'Транзакция',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(transaction.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (transaction.reference != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Ref: ${transaction.reference}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.type == TransactionType.withdrawal || transaction.type == TransactionType.payment || transaction.type == TransactionType.fee ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: provider.getTransactionTypeColor(transaction.type),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: provider.getStatusColor(transaction.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(transaction.status),
                  style: TextStyle(
                    color: provider.getStatusColor(transaction.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Карточка способа оплаты
  Widget _buildPaymentMethodCard(PaymentMethodInfo method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: method.isEnabled 
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              method.icon,
              color: method.isEnabled 
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: method.isEnabled ? null : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  method.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: method.supportedCurrencies.map((currency) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        currency,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (method.fee != null && method.fee! > 0)
                Text(
                  'Комиссия: \$${method.fee!.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 8),
              Switch(
                value: method.isEnabled,
                onChanged: (value) {
                  // В реальном приложении здесь будет логика включения/выключения
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Элемент статистики
  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Диалог пополнения
  void _showDepositDialog() {
    _showPaymentDialog(
      title: 'Пополнить счет',
      type: TransactionType.deposit,
    );
  }

  // Диалог вывода средств
  void _showWithdrawalDialog() {
    _showPaymentDialog(
      title: 'Вывести средства',
      type: TransactionType.withdrawal,
    );
  }

  // Диалог оплаты хакатона
  void _showHackathonPaymentDialog() {
    _showPaymentDialog(
      title: 'Оплатить хакатон',
      type: TransactionType.payment,
      description: 'Участие в хакатоне',
    );
  }

  // Диалог оплаты челленджа
  void _showChallengePaymentDialog() {
    _showPaymentDialog(
      title: 'Оплатить челлендж',
      type: TransactionType.payment,
      description: 'Доступ к челленджу',
    );
  }

  // Общий диалог платежа
  void _showPaymentDialog({
    required String title,
    required TransactionType type,
    String? description,
  }) {
    _amountController.clear();
    _descriptionController.text = description ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Сумма',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0) {
                _processPayment(type, amount, _descriptionController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );
  }

  // Обработка платежа
  void _processPayment(TransactionType type, double amount, String description) {
    final provider = context.read<PaymentProvider>();
    
    provider.createTransaction(
      type: type,
      amount: amount,
      currency: provider.defaultCurrency,
      method: PaymentMethod.creditCard, // По умолчанию
      description: description,
    );
  }

  // Получение текста статуса
  String _getStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Ожидает';
      case PaymentStatus.processing:
        return 'Обрабатывается';
      case PaymentStatus.completed:
        return 'Завершено';
      case PaymentStatus.failed:
        return 'Ошибка';
      case PaymentStatus.cancelled:
        return 'Отменено';
      case PaymentStatus.refunded:
        return 'Возвращено';
    }
  }
}
