import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/cross_chain_bridge_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class CrossChainBridgeScreen extends StatefulWidget {
  const CrossChainBridgeScreen({super.key});

  @override
  State<CrossChainBridgeScreen> createState() => _CrossChainBridgeScreenState();
}

class _CrossChainBridgeScreenState extends State<CrossChainBridgeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CrossChainBridgeProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Cross-chain Bridge',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.swap_horiz,
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск транзакций, маршрутов...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'Транзакции'),
                  Tab(text: 'Маршруты'),
                  Tab(text: 'Провайдеры'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionsTab(),
                  _buildRoutesTab(),
                  _buildProvidersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBridgeDialog(context),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Consumer<CrossChainBridgeProvider>(
      builder: (context, provider, child) {
        final transactions = _searchQuery.isEmpty
            ? provider.transactions
            : provider.searchTransactions(_searchQuery);

        if (transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swap_horiz, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет транзакций',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionCard(transaction, provider);
          },
        );
      },
    );
  }

  Widget _buildTransactionCard(BridgeTransaction transaction, CrossChainBridgeProvider provider) {
    final statusColor = _getStatusColor(transaction.status);
    final statusIcon = _getStatusIcon(transaction.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${transaction.sourceBlockchain.toUpperCase()} → ${transaction.destinationBlockchain.toUpperCase()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${transaction.amount} ${transaction.tokenSymbol}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    transaction.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: statusColor.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Откуда',
                    transaction.sourceAddress,
                    Icons.account_circle,
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                Expanded(
                  child: _buildInfoItem(
                    'Куда',
                    transaction.destinationAddress,
                    Icons.account_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Провайдер',
                    transaction.bridgeProvider,
                    Icons.link,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Комиссия',
                    '${transaction.bridgeFee} ${transaction.tokenSymbol}',
                    Icons.payment,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Создано',
                    DateFormat('dd.MM.yyyy HH:mm').format(transaction.createdAt),
                    Icons.schedule,
                  ),
                ),
                if (transaction.completedAt != null)
                  Expanded(
                    child: _buildInfoItem(
                      'Завершено',
                      DateFormat('dd.MM.yyyy HH:mm').format(transaction.completedAt!),
                      Icons.check_circle,
                    ),
                  ),
              ],
            ),
            if (transaction.transactionHash != null) ...[
              const SizedBox(height: 12),
              _buildInfoItem(
                'Хеш',
                '${transaction.transactionHash!.substring(0, 10)}...',
                Icons.fingerprint,
              ),
            ],
            if (transaction.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        transaction.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (transaction.status == 'pending')
                  ElevatedButton.icon(
                    onPressed: () => _cancelTransaction(transaction.id, provider),
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text('Отменить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: () => _showTransactionDetails(transaction),
                  icon: const Icon(Icons.info, size: 16),
                  label: const Text('Детали'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoutesTab() {
    return Consumer<CrossChainBridgeProvider>(
      builder: (context, provider, child) {
        final routes = provider.routes;

        if (routes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.route, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных маршрутов',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: routes.length,
          itemBuilder: (context, index) {
            final route = routes[index];
            return _buildRouteCard(route);
          },
        );
      },
    );
  }

  Widget _buildRouteCard(BridgeRoute route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.route,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${route.sourceBlockchain.toUpperCase()} → ${route.destinationBlockchain.toUpperCase()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Провайдер: ${route.bridgeProvider}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    route.isActive ? 'АКТИВЕН' : 'НЕАКТИВЕН',
                    style: TextStyle(
                      color: route.isActive ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: (route.isActive ? Colors.green : Colors.red).withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Поддерживаемые токены',
                    route.supportedTokens.join(', '),
                    Icons.token,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Диапазон',
                    '${route.minAmount} - ${route.maxAmount}',
                    Icons.linear_scale,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Комиссия',
                    '${route.bridgeFee}',
                    Icons.payment,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Время',
                    '${route.estimatedTime.toInt()} мин',
                    Icons.schedule,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showRouteDetails(route),
              icon: const Icon(Icons.info, size: 16),
              label: const Text('Подробнее'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProvidersTab() {
    return Consumer<CrossChainBridgeProvider>(
      builder: (context, provider, child) {
        final providers = provider.providers;

        if (providers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных провайдеров',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: providers.length,
          itemBuilder: (context, index) {
            final bridgeProvider = providers[index];
            return _buildProviderCard(bridgeProvider);
          },
        );
      },
    );
  }

  Widget _buildProviderCard(BridgeProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(provider.logoUrl),
                  backgroundColor: Colors.grey[200],
                  child: provider.logoUrl.isEmpty
                      ? Text(
                          provider.name[0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            provider.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (provider.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        provider.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Блокчейны',
                    '${provider.supportedBlockchains.length}',
                    Icons.account_balance,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Токены',
                    '${provider.supportedTokens.length}',
                    Icons.token,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Средняя комиссия',
                    '${provider.averageFee}',
                    Icons.payment,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Среднее время',
                    '${provider.averageTime.toInt()} мин',
                    Icons.schedule,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Безопасность',
                    '${provider.metadata['security_score'] ?? 'N/A'}',
                    Icons.security,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showProviderDetails(provider),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Подробнее'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _visitProviderWebsite(provider.website),
                    icon: const Icon(Icons.language, size: 16),
                    label: const Text('Сайт'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'processing':
        return Icons.sync;
      case 'completed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  void _showCreateBridgeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateBridgeDialog(),
    );
  }

  void _showTransactionDetails(BridgeTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => TransactionDetailsDialog(transaction: transaction),
    );
  }

  void _showRouteDetails(BridgeRoute route) {
    showDialog(
      context: context,
      builder: (context) => RouteDetailsDialog(route: route),
    );
  }

  void _showProviderDetails(BridgeProvider provider) {
    showDialog(
      context: context,
      builder: (context) => ProviderDetailsDialog(provider: provider),
    );
  }

  void _visitProviderWebsite(String website) {
    // TODO: Implement website opening
  }

  void _cancelTransaction(String transactionId, CrossChainBridgeProvider provider) {
    provider.cancelTransaction(transactionId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Транзакция отменена')),
    );
  }
}

// Create Bridge Dialog
class CreateBridgeDialog extends StatefulWidget {
  const CreateBridgeDialog({super.key});

  @override
  State<CreateBridgeDialog> createState() => _CreateBridgeDialogState();
}

class _CreateBridgeDialogState extends State<CreateBridgeDialog> {
  final _formKey = GlobalKey<FormState>();
  String _sourceBlockchain = 'ethereum';
  String _destinationBlockchain = 'polygon';
  String _tokenSymbol = 'USDC';
  final _amountController = TextEditingController();
  final _sourceAddressController = TextEditingController();
  final _destinationAddressController = TextEditingController();
  String _selectedProvider = 'multichain';

  final List<String> _blockchains = [
    'ethereum',
    'binance',
    'polygon',
    'avalanche',
    'arbitrum',
    'optimism',
    'fantom',
    'gnosis',
  ];

  final List<String> _tokens = [
    'USDC',
    'USDT',
    'ETH',
    'BTC',
    'DAI',
    'BNB',
    'MATIC',
    'AVAX',
  ];

  final List<String> _providers = [
    'multichain',
    'stargate',
    'hop',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _sourceAddressController.dispose();
    _destinationAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать Bridge транзакцию'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _sourceBlockchain,
                decoration: const InputDecoration(
                  labelText: 'Исходный блокчейн',
                  border: OutlineInputBorder(),
                ),
                items: _blockchains.map((blockchain) {
                  return DropdownMenuItem(
                    value: blockchain,
                    child: Text(blockchain.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _sourceBlockchain = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Выберите исходный блокчейн';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _destinationBlockchain,
                decoration: const InputDecoration(
                  labelText: 'Целевой блокчейн',
                  border: OutlineInputBorder(),
                ),
                items: _blockchains.map((blockchain) {
                  return DropdownMenuItem(
                    value: blockchain,
                    child: Text(blockchain.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _destinationBlockchain = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Выберите целевой блокчейн';
                  }
                  if (value == _sourceBlockchain) {
                    return 'Исходный и целевой блокчейны должны отличаться';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tokenSymbol,
                decoration: const InputDecoration(
                  labelText: 'Токен',
                  border: OutlineInputBorder(),
                ),
                items: _tokens.map((token) {
                  return DropdownMenuItem(
                    value: token,
                    child: Text(token),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tokenSymbol = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Выберите токен';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Количество',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите количество';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Количество должно быть больше 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sourceAddressController,
                decoration: const InputDecoration(
                  labelText: 'Исходный адрес',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите исходный адрес';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationAddressController,
                decoration: const InputDecoration(
                  labelText: 'Целевой адрес',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите целевой адрес';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedProvider,
                decoration: const InputDecoration(
                  labelText: 'Провайдер',
                  border: OutlineInputBorder(),
                ),
                items: _providers.map((provider) {
                  return DropdownMenuItem(
                    value: provider,
                    child: Text(provider.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProvider = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Выберите провайдера';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _createBridge,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Создать'),
        ),
      ],
    );
  }

  void _createBridge() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CrossChainBridgeProvider>();
      final amount = double.parse(_amountController.text);

      try {
        provider.createBridgeTransaction(
          sourceBlockchain: _sourceBlockchain,
          destinationBlockchain: _destinationBlockchain,
          sourceAddress: _sourceAddressController.text,
          destinationAddress: _destinationAddressController.text,
          tokenSymbol: _tokenSymbol,
          amount: amount,
          bridgeProvider: _selectedProvider,
        );

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bridge транзакция создана')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }
}

// Transaction Details Dialog
class TransactionDetailsDialog extends StatelessWidget {
  final BridgeTransaction transaction;

  const TransactionDetailsDialog({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Детали транзакции'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('ID', transaction.id),
            _buildDetailRow('Статус', transaction.status),
            _buildDetailRow('Исходный блокчейн', transaction.sourceBlockchain),
            _buildDetailRow('Целевой блокчейн', transaction.destinationBlockchain),
            _buildDetailRow('Исходный адрес', transaction.sourceAddress),
            _buildDetailRow('Целевой адрес', transaction.destinationAddress),
            _buildDetailRow('Токен', transaction.tokenSymbol),
            _buildDetailRow('Количество', '${transaction.amount}'),
            _buildDetailRow('Комиссия', '${transaction.bridgeFee}'),
            _buildDetailRow('Провайдер', transaction.bridgeProvider),
            _buildDetailRow('Создано', DateFormat('dd.MM.yyyy HH:mm:ss').format(transaction.createdAt)),
            if (transaction.completedAt != null)
              _buildDetailRow('Завершено', DateFormat('dd.MM.yyyy HH:mm:ss').format(transaction.completedAt!)),
            if (transaction.transactionHash != null)
              _buildDetailRow('Хеш транзакции', transaction.transactionHash!),
            if (transaction.errorMessage != null)
              _buildDetailRow('Ошибка', transaction.errorMessage!),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

// Route Details Dialog
class RouteDetailsDialog extends StatelessWidget {
  final BridgeRoute route;

  const RouteDetailsDialog({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Детали маршрута'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('ID', route.id),
            _buildDetailRow('Исходный блокчейн', route.sourceBlockchain),
            _buildDetailRow('Целевой блокчейн', route.destinationBlockchain),
            _buildDetailRow('Провайдер', route.bridgeProvider),
            _buildDetailRow('Статус', route.isActive ? 'Активен' : 'Неактивен'),
            _buildDetailRow('Поддерживаемые токены', route.supportedTokens.join(', ')),
            _buildDetailRow('Минимальная сумма', '${route.minAmount}'),
            _buildDetailRow('Максимальная сумма', '${route.maxAmount}'),
            _buildDetailRow('Комиссия', '${route.bridgeFee}'),
            _buildDetailRow('Время (мин)', '${route.estimatedTime}'),
            _buildDetailRow('Газ (ETH)', '${route.metadata['gas_fee'] ?? 'N/A'}'),
            _buildDetailRow('Уровень безопасности', '${route.metadata['security_level'] ?? 'N/A'}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// Provider Details Dialog
class ProviderDetailsDialog extends StatelessWidget {
  final BridgeProvider provider;

  const ProviderDetailsDialog({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(provider.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Описание', provider.description),
            _buildDetailRow('Веб-сайт', provider.website),
            _buildDetailRow('Поддерживаемые блокчейны', provider.supportedBlockchains.join(', ')),
            _buildDetailRow('Поддерживаемые токены', provider.supportedTokens.join(', ')),
            _buildDetailRow('Средняя комиссия', '${provider.averageFee}'),
            _buildDetailRow('Среднее время (мин)', '${provider.averageTime}'),
            _buildDetailRow('Верифицирован', provider.isVerified ? 'Да' : 'Нет'),
            _buildDetailRow('Оценка безопасности', '${provider.metadata['security_score'] ?? 'N/A'}'),
            _buildDetailRow('Общий объем', '${provider.metadata['total_volume'] ?? 'N/A'}'),
            _buildDetailRow('Поддерживаемые сети', '${provider.metadata['supported_chains'] ?? 'N/A'}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            // TODO: Implement website opening
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Открыть сайт'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
