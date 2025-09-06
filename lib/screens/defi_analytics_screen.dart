import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/defi_analytics_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class DeFiAnalyticsScreen extends StatefulWidget {
  const DeFiAnalyticsScreen({super.key});

  @override
  State<DeFiAnalyticsScreen> createState() => _DeFiAnalyticsScreenState();
}

class _DeFiAnalyticsScreenState extends State<DeFiAnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeFiAnalyticsProvider>().initialize();
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
                  'DeFi Analytics',
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
                      Icons.analytics,
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
                      hintText: 'Поиск протоколов, пулов...',
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
                  Tab(text: 'Протоколы'),
                  Tab(text: 'Фарминг'),
                  Tab(text: 'Ликвидность'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProtocolsTab(),
                  _buildFarmingTab(),
                  _buildLiquidityTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolsTab() {
    return Consumer<DeFiAnalyticsProvider>(
      builder: (context, provider, child) {
        final protocols = _searchQuery.isEmpty
            ? provider.protocols
            : provider.searchProtocols(_searchQuery);

        if (protocols.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет протоколов',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: protocols.length,
          itemBuilder: (context, index) {
            final protocol = protocols[index];
            return _buildProtocolCard(protocol);
          },
        );
      },
    );
  }

  Widget _buildProtocolCard(DeFiProtocolAnalytics protocol) {
    final priceChangeColor = protocol.priceChange24h >= 0 ? Colors.green : Colors.red;
    final priceChangeIcon = protocol.priceChange24h >= 0 ? Icons.trending_up : Icons.trending_down;

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
                    _getProtocolIcon(protocol.protocolType),
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
                        protocol.protocolName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${protocol.protocolType.toUpperCase()} • ${protocol.blockchain.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${_formatNumber(protocol.price)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(priceChangeIcon, color: priceChangeColor, size: 16),
                        Text(
                          '${protocol.priceChange24h >= 0 ? '+' : ''}${protocol.priceChange24h.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: priceChangeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'TVL',
                    '\$${_formatNumber(protocol.totalValueLocked)}',
                    Icons.account_balance_wallet,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Объем 24ч',
                    '\$${_formatNumber(protocol.dailyVolume)}',
                    Icons.trending_up,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'APY',
                    '${protocol.apy.toStringAsFixed(2)}%',
                    Icons.percent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Комиссии 24ч',
                    '\$${_formatNumber(protocol.dailyFees)}',
                    Icons.payment,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Пользователи',
                    _formatNumber(protocol.activeUsers.toDouble()),
                    Icons.people,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Транзакции',
                    _formatNumber(protocol.totalTransactions.toDouble()),
                    Icons.swap_horiz,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showProtocolDetails(protocol),
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

  Widget _buildFarmingTab() {
    return Consumer<DeFiAnalyticsProvider>(
      builder: (context, provider, child) {
        final pools = _searchQuery.isEmpty
            ? provider.farmingPools
            : provider.searchFarmingPools(_searchQuery);

        if (pools.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.agriculture, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет пулов фарминга',
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
            return _buildFarmingPoolCard(pool);
          },
        );
      },
    );
  }

  Widget _buildFarmingPoolCard(YieldFarmingPool pool) {
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pool.poolName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${pool.protocolName} • ${pool.token0}-${pool.token1}',
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
                    pool.isActive ? 'АКТИВЕН' : 'НЕАКТИВЕН',
                    style: TextStyle(
                      color: pool.isActive ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: (pool.isActive ? Colors.green : Colors.red).withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Застейкано',
                    '\$${_formatNumber(pool.totalStaked)}',
                    Icons.lock,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'APY',
                    '${pool.apy.toStringAsFixed(2)}%',
                    Icons.percent,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Награды/день',
                    '${_formatNumber(pool.rewardsPerDay)} ${pool.rewardToken}',
                    Icons.card_giftcard,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'APY 7д',
                    '${pool.apy7d.toStringAsFixed(2)}%',
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'APY 30д',
                    '${pool.apy30d.toStringAsFixed(2)}%',
                    Icons.calendar_month,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Начало',
                    DateFormat('dd.MM.yyyy').format(pool.startDate),
                    Icons.play_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showFarmingPoolDetails(pool),
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

  Widget _buildLiquidityTab() {
    return Consumer<DeFiAnalyticsProvider>(
      builder: (context, provider, child) {
        final pools = _searchQuery.isEmpty
            ? provider.liquidityPools
            : provider.searchLiquidityPools(_searchQuery);

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
            return _buildLiquidityPoolCard(pool);
          },
        );
      },
    );
  }

  Widget _buildLiquidityPoolCard(LiquidityPool pool) {
    final impermanentLossColor = pool.impermanentLoss >= 0 ? Colors.green : Colors.red;

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
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pool.poolName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${pool.protocolName} • ${pool.token0}-${pool.token1}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${pool.apy.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'APY',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Резерв ${pool.token0}',
                    _formatNumber(pool.reserve0),
                    Icons.account_balance,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Резерв ${pool.token1}',
                    _formatNumber(pool.reserve1),
                    Icons.account_balance,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Общий запас',
                    _formatNumber(pool.totalSupply),
                    Icons.inventory,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Объем 24ч',
                    '\$${_formatNumber(pool.volume24h)}',
                    Icons.trending_up,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Комиссии 24ч',
                    '\$${_formatNumber(pool.fees24h)}',
                    Icons.payment,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'IL',
                    '${pool.impermanentLoss.toStringAsFixed(2)}%',
                    Icons.trending_down,
                    color: impermanentLossColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showLiquidityPoolDetails(pool),
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

  Widget _buildMetricItem(String label, String value, IconData icon, {Color? color}) {
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
            Icon(icon, size: 16, color: color ?? Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getProtocolIcon(String protocolType) {
    switch (protocolType) {
      case 'dex':
        return Icons.swap_horiz;
      case 'lending':
        return Icons.account_balance;
      case 'yield_farming':
        return Icons.agriculture;
      case 'derivatives':
        return Icons.trending_up;
      default:
        return Icons.analytics;
    }
  }

  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }

  void _showProtocolDetails(DeFiProtocolAnalytics protocol) {
    showDialog(
      context: context,
      builder: (context) => ProtocolDetailsDialog(protocol: protocol),
    );
  }

  void _showFarmingPoolDetails(YieldFarmingPool pool) {
    showDialog(
      context: context,
      builder: (context) => FarmingPoolDetailsDialog(pool: pool),
    );
  }

  void _showLiquidityPoolDetails(LiquidityPool pool) {
    showDialog(
      context: context,
      builder: (context) => LiquidityPoolDetailsDialog(pool: pool),
    );
  }
}

// Protocol Details Dialog
class ProtocolDetailsDialog extends StatelessWidget {
  final DeFiProtocolAnalytics protocol;

  const ProtocolDetailsDialog({
    super.key,
    required this.protocol,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(protocol.protocolName),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Тип', protocol.protocolType.toUpperCase()),
            _buildDetailRow('Блокчейн', protocol.blockchain.toUpperCase()),
            _buildDetailRow('TVL', '\$${_formatNumber(protocol.totalValueLocked)}'),
            _buildDetailRow('Объем 24ч', '\$${_formatNumber(protocol.dailyVolume)}'),
            _buildDetailRow('Комиссии 24ч', '\$${_formatNumber(protocol.dailyFees)}'),
            _buildDetailRow('APY', '${protocol.apy.toStringAsFixed(2)}%'),
            _buildDetailRow('APY 7д', '${protocol.apy7d.toStringAsFixed(2)}%'),
            _buildDetailRow('APY 30д', '${protocol.apy30d.toStringAsFixed(2)}%'),
            _buildDetailRow('Активные пользователи', protocol.activeUsers.toString()),
            _buildDetailRow('Всего транзакций', protocol.totalTransactions.toString()),
            _buildDetailRow('Рыночная капитализация', '\$${_formatNumber(protocol.marketCap)}'),
            _buildDetailRow('Цена', '\$${protocol.price.toStringAsFixed(2)}'),
            _buildDetailRow('Изменение 24ч', '${protocol.priceChange24h >= 0 ? '+' : ''}${protocol.priceChange24h.toStringAsFixed(2)}%'),
            _buildDetailRow('Изменение 7д', '${protocol.priceChange7d >= 0 ? '+' : ''}${protocol.priceChange7d.toStringAsFixed(2)}%'),
            _buildDetailRow('Обновлено', DateFormat('dd.MM.yyyy HH:mm').format(protocol.lastUpdated)),
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

  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }
}

// Farming Pool Details Dialog
class FarmingPoolDetailsDialog extends StatelessWidget {
  final YieldFarmingPool pool;

  const FarmingPoolDetailsDialog({
    super.key,
    required this.pool,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(pool.poolName),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Протокол', pool.protocolName),
            _buildDetailRow('Токены', '${pool.token0}-${pool.token1}'),
            _buildDetailRow('Застейкано', '\$${_formatNumber(pool.totalStaked)}'),
            _buildDetailRow('APY', '${pool.apy.toStringAsFixed(2)}%'),
            _buildDetailRow('APY 7д', '${pool.apy7d.toStringAsFixed(2)}%'),
            _buildDetailRow('APY 30д', '${pool.apy30d.toStringAsFixed(2)}%'),
            _buildDetailRow('Награды/день', '${_formatNumber(pool.rewardsPerDay)} ${pool.rewardToken}'),
            _buildDetailRow('Токен наград', pool.rewardToken),
            _buildDetailRow('Дата начала', DateFormat('dd.MM.yyyy').format(pool.startDate)),
            if (pool.endDate != null)
              _buildDetailRow('Дата окончания', DateFormat('dd.MM.yyyy').format(pool.endDate!)),
            _buildDetailRow('Статус', pool.isActive ? 'Активен' : 'Неактивен'),
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

  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }
}

// Liquidity Pool Details Dialog
class LiquidityPoolDetailsDialog extends StatelessWidget {
  final LiquidityPool pool;

  const LiquidityPoolDetailsDialog({
    super.key,
    required this.pool,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(pool.poolName),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Протокол', pool.protocolName),
            _buildDetailRow('Токены', '${pool.token0}-${pool.token1}'),
            _buildDetailRow('Резерв ${pool.token0}', _formatNumber(pool.reserve0)),
            _buildDetailRow('Резерв ${pool.token1}', _formatNumber(pool.reserve1)),
            _buildDetailRow('Общий запас', _formatNumber(pool.totalSupply)),
            _buildDetailRow('Объем 24ч', '\$${_formatNumber(pool.volume24h)}'),
            _buildDetailRow('Комиссии 24ч', '\$${_formatNumber(pool.fees24h)}'),
            _buildDetailRow('APY', '${pool.apy.toStringAsFixed(2)}%'),
            _buildDetailRow('Имперманентный убыток', '${pool.impermanentLoss.toStringAsFixed(2)}%'),
            _buildDetailRow('Дата создания', DateFormat('dd.MM.yyyy').format(pool.createdAt)),
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

  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }
}
