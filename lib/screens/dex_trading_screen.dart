import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/dex_trading_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class DEXTradingScreen extends StatefulWidget {
  const DEXTradingScreen({super.key});

  @override
  State<DEXTradingScreen> createState() => _DEXTradingScreenState();
}

class _DEXTradingScreenState extends State<DEXTradingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DEXTradingProvider>().initialize();
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
                  'DEX Trading',
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
                      hintText: 'Поиск токенов, пулов...',
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
            // Protocol Selector
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Consumer<DEXTradingProvider>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: DEXProtocol.values.map((protocol) {
                        final isSelected = provider.selectedProtocol == protocol;
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(_getProtocolName(protocol)),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                provider.selectProtocol(protocol);
                              }
                            },
                            selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                            checkmarkColor: AppTheme.primaryColor,
                            avatar: Icon(
                              _getProtocolIcon(protocol),
                              color: isSelected ? AppTheme.primaryColor : Colors.grey,
                              size: 18,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'Свап'),
                  Tab(text: 'Пулы'),
                  Tab(text: 'Ордера'),
                  Tab(text: 'История'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSwapTab(),
                  _buildPoolsTab(),
                  _buildOrdersTab(),
                  _buildHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSettingsDialog(),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.settings),
      ),
    );
  }

  Widget _buildSwapTab() {
    return Consumer<DEXTradingProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Swap Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.swap_horiz, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          const Text(
                            'Быстрый свап',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // From Token
                      _buildTokenInput(
                        label: 'Отправляете',
                        token: 'ETH',
                        amount: '1.5',
                        onTap: () => _showTokenSelector('from'),
                      ),
                      const SizedBox(height: 16),
                      // Swap Arrow
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.swap_vert,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // To Token
                      _buildTokenInput(
                        label: 'Получаете',
                        token: 'USDC',
                        amount: '4800.0',
                        onTap: () => _showTokenSelector('to'),
                      ),
                      const SizedBox(height: 16),
                      // Swap Details
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildSwapDetailRow('Цена влияния', '0.12%'),
                            _buildSwapDetailRow('Slippage', '${provider.slippageTolerance}%'),
                            _buildSwapDetailRow('Протокол', _getProtocolName(provider.selectedProtocol)),
                            _buildSwapDetailRow('Комиссия', '0.3%'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Swap Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _executeSwap(provider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Выполнить свап',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Recent Pools
              const Text(
                'Популярные пулы',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...provider.poolsByProtocol.take(3).map((pool) => 
                  _buildPoolCard(pool, provider)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPoolsTab() {
    return Consumer<DEXTradingProvider>(
      builder: (context, provider, child) {
        final pools = _searchQuery.isEmpty
            ? provider.poolsByProtocol
            : provider.searchPools(_searchQuery);

        if (pools.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет пулов ликвидности',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pools.length,
          itemBuilder: (context, index) {
            final pool = pools[index];
            return _buildPoolCard(pool, provider);
          },
        );
      },
    );
  }

  Widget _buildOrdersTab() {
    return Consumer<DEXTradingProvider>(
      builder: (context, provider, child) {
        final orders = provider.activeLimitOrders;

        if (orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет активных ордеров',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return _buildOrderCard(order, provider);
          },
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<DEXTradingProvider>(
      builder: (context, provider, child) {
        final transactions = _searchQuery.isEmpty
            ? provider.transactionsByProtocol
            : provider.searchTransactions(_searchQuery);

        if (transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
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

  // Helper Widgets
  Widget _buildTokenInput({
    required String label,
    required String token,
    required String amount,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        token,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwapDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolCard(LiquidityPool pool, DEXTradingProvider provider) {
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
                Expanded(
                  child: Text(
                    pool.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getProtocolColor(pool.protocol).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getProtocolName(pool.protocol),
                    style: TextStyle(
                      color: _getProtocolColor(pool.protocol),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'APY',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${pool.apy.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Объем 24ч',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${_formatNumber(pool.volume24h)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Комиссия',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${(pool.fee * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddLiquidityDialog(pool, provider),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Добавить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showPoolDetails(pool),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Детали'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      foregroundColor: Colors.grey,
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

  Widget _buildOrderCard(LimitOrder order, DEXTradingProvider provider) {
    final isBuy = order.metadata['order_type'] == 'limit_buy';
    
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
                    color: (isBuy ? Colors.green : Colors.red).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isBuy ? Icons.trending_up : Icons.trending_down,
                    color: isBuy ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.tokenIn} → ${order.tokenOut}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Цена: \$${order.price.toStringAsFixed(4)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'АКТИВЕН',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Количество',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${order.amountIn.toStringAsFixed(4)} ${order.tokenIn}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Создан',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd.MM HH:mm').format(order.createdAt),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
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
                  child: ElevatedButton.icon(
                    onPressed: () => _cancelOrder(order.id, provider),
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text('Отменить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showOrderDetails(order),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Детали'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      foregroundColor: Colors.grey,
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

  Widget _buildTransactionCard(SwapTransaction transaction, DEXTradingProvider provider) {
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
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.swap_horiz,
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
                        '${transaction.fromToken} → ${transaction.toToken}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${transaction.amountIn.toStringAsFixed(4)} ${transaction.fromToken}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(transaction.status),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Получаете',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${transaction.amountOut.toStringAsFixed(4)} ${transaction.toToken}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Время',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd.MM HH:mm').format(transaction.timestamp),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (transaction.txHash != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'TX: ${transaction.txHash!.substring(0, 10)}...',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper Methods
  String _getProtocolName(DEXProtocol protocol) {
    switch (protocol) {
      case DEXProtocol.uniswap:
        return 'Uniswap';
      case DEXProtocol.pancakeswap:
        return 'PancakeSwap';
      case DEXProtocol.quickswap:
        return 'QuickSwap';
      case DEXProtocol.traderjoe:
        return 'Trader Joe';
      case DEXProtocol.raydium:
        return 'Raydium';
    }
  }

  IconData _getProtocolIcon(DEXProtocol protocol) {
    switch (protocol) {
      case DEXProtocol.uniswap:
        return Icons.currency_exchange;
      case DEXProtocol.pancakeswap:
        return Icons.cake;
      case DEXProtocol.quickswap:
        return Icons.flash_on;
      case DEXProtocol.traderjoe:
        return Icons.sports_esports;
      case DEXProtocol.raydium:
        return Icons.radio;
    }
  }

  Color _getProtocolColor(DEXProtocol protocol) {
    switch (protocol) {
      case DEXProtocol.uniswap:
        return Colors.pink;
      case DEXProtocol.pancakeswap:
        return Colors.orange;
      case DEXProtocol.quickswap:
        return Colors.purple;
      case DEXProtocol.traderjoe:
        return Colors.red;
      case DEXProtocol.raydium:
        return Colors.blue;
    }
  }

  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'ЗАВЕРШЕН';
      case 'pending':
        return 'В ПРОЦЕССЕ';
      case 'failed':
        return 'ОШИБКА';
      default:
        return 'НЕИЗВЕСТНО';
    }
  }

  // Action Methods
  void _showTokenSelector(String type) {
    // TODO: Implement token selector dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Выбор токена $type - в разработке')),
    );
  }

  void _executeSwap(DEXTradingProvider provider) {
    // TODO: Implement swap execution
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Выполнение свапа - в разработке')),
    );
  }

  void _showAddLiquidityDialog(LiquidityPool pool, DEXTradingProvider provider) {
    // TODO: Implement add liquidity dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Добавление ликвидности - в разработке')),
    );
  }

  void _showPoolDetails(LiquidityPool pool) {
    // TODO: Implement pool details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Детали пула - в разработке')),
    );
  }

  Future<void> _cancelOrder(String orderId, DEXTradingProvider provider) async {
    final success = await provider.cancelLimitOrder(orderId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ордер отменен')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка отмены ордера')),
      );
    }
  }

  void _showOrderDetails(LimitOrder order) {
    // TODO: Implement order details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Детали ордера - в разработке')),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => Consumer<DEXTradingProvider>(
        builder: (context, provider, child) {
          return AlertDialog(
            title: const Text('Настройки DEX'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Slippage Tolerance
                ListTile(
                  title: const Text('Slippage Tolerance'),
                  subtitle: Text('${provider.slippageTolerance}%'),
                  trailing: SizedBox(
                    width: 100,
                    child: Slider(
                      value: provider.slippageTolerance,
                      min: 0.1,
                      max: 5.0,
                      divisions: 49,
                      label: '${provider.slippageTolerance.toStringAsFixed(1)}%',
                      onChanged: (value) {
                        provider.updateSlippageTolerance(value);
                      },
                    ),
                  ),
                ),
                // Gas Price
                ListTile(
                  title: const Text('Gas Price (Gwei)'),
                  subtitle: Text('${provider.gasPrice.toStringAsFixed(1)}'),
                  trailing: SizedBox(
                    width: 100,
                    child: Slider(
                      value: provider.gasPrice,
                      min: 1.0,
                      max: 100.0,
                      divisions: 99,
                      label: provider.gasPrice.toStringAsFixed(1),
                      onChanged: (value) {
                        provider.updateGasPrice(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Закрыть'),
              ),
            ],
          );
        },
      ),
    );
  }
}
