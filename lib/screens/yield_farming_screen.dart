import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/yield_farming_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class YieldFarmingScreen extends StatefulWidget {
  const YieldFarmingScreen({super.key});

  @override
  State<YieldFarmingScreen> createState() => _YieldFarmingScreenState();
}

class _YieldFarmingScreenState extends State<YieldFarmingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<YieldFarmingProvider>().initialize();
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
                  'Yield Farming',
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
                      Icons.agriculture,
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
                      hintText: 'Поиск пулов, стратегий...',
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
            // Overview Cards
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Consumer<YieldFarmingProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Общий TVL',
                              '\$${_formatNumber(provider.getTotalValueLocked())}',
                              Icons.account_balance_wallet,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Средний APY',
                              '${provider.getAverageAPY().toStringAsFixed(1)}%',
                              Icons.trending_up,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Дневные награды',
                              '\$${_formatNumber(provider.getTotalDailyRewards())}',
                              Icons.monetization_on,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Активные позиции',
                              '${provider.userPositions.length}',
                              Icons.assignment,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            // Filters
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Chain Filter
                  Expanded(
                    child: Consumer<YieldFarmingProvider>(
                      builder: (context, provider, child) {
                        return DropdownButtonFormField<String>(
                          value: provider.selectedChain,
                          decoration: const InputDecoration(
                            labelText: 'Блокчейн',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [
                            const DropdownMenuItem(value: 'all', child: Text('Все')),
                            const DropdownMenuItem(value: 'ethereum', child: Text('Ethereum')),
                            const DropdownMenuItem(value: 'bsc', child: Text('BSC')),
                            const DropdownMenuItem(value: 'polygon', child: Text('Polygon')),
                            const DropdownMenuItem(value: 'avalanche', child: Text('Avalanche')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              provider.selectChain(value);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Type Filter
                  Expanded(
                    child: Consumer<YieldFarmingProvider>(
                      builder: (context, provider, child) {
                        return DropdownButtonFormField<FarmingPoolType>(
                          value: provider.selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Тип',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: FarmingPoolType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(_getPoolTypeName(type)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              provider.selectPoolType(value);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
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
                  Tab(text: 'Пулы'),
                  Tab(text: 'Позиции'),
                  Tab(text: 'Стратегии'),
                  Tab(text: 'Аналитика'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPoolsTab(),
                  _buildPositionsTab(),
                  _buildStrategiesTab(),
                  _buildAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateStrategyDialog(),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolsTab() {
    return Consumer<YieldFarmingProvider>(
      builder: (context, provider, child) {
        final pools = _searchQuery.isEmpty
            ? provider.filteredPools
            : provider.searchPools(_searchQuery);

        if (pools.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных пулов',
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

  Widget _buildPositionsTab() {
    return Consumer<YieldFarmingProvider>(
      builder: (context, provider, child) {
        final positions = provider.userPositions;

        if (positions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'У вас нет активных позиций',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Начните стейкинг в любом из доступных пулов',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: positions.length,
          itemBuilder: (context, index) {
            final position = positions[index];
            final pool = provider.pools.firstWhere((p) => p.id == position.poolId);
            return _buildPositionCard(position, pool, provider);
          },
        );
      },
    );
  }

  Widget _buildStrategiesTab() {
    return Consumer<YieldFarmingProvider>(
      builder: (context, provider, child) {
        final strategies = _searchQuery.isEmpty
            ? provider.strategies
            : provider.searchStrategies(_searchQuery);

        if (strategies.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_graph, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных стратегий',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: strategies.length,
          itemBuilder: (context, index) {
            final strategy = strategies[index];
            return _buildStrategyCard(strategy, provider);
          },
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer<YieldFarmingProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chain Distribution
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Распределение по блокчейнам',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...provider.getChainDistribution().entries.map((entry) {
                        final percentage = (entry.value / provider.getTotalValueLocked() * 100);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _getChainName(entry.key),
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '\$${_formatNumber(entry.value)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Type Distribution
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Распределение по типам',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...provider.getTypeDistribution().entries.map((entry) {
                        final percentage = (entry.value / provider.getTotalValueLocked() * 100);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _getPoolTypeName(FarmingPoolType.values.firstWhere(
                                    (e) => e.name == entry.key,
                                    orElse: () => FarmingPoolType.liquidity,
                                  )),
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '\$${_formatNumber(entry.value)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Top Performing Pools
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Топ пулы по APY',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...provider.topPools.take(5).map((pool) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  pool.name,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${pool.apy.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPoolCard(FarmingPool pool, YieldFarmingProvider provider) {
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
                    color: _getPoolTypeColor(pool.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getPoolTypeName(pool.type),
                    style: TextStyle(
                      color: _getPoolTypeColor(pool.type),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              pool.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
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
                          fontSize: 18,
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
                        'TVL',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${_formatNumber(pool.totalValueLocked)}',
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
                        'Мин. стейк',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${pool.minStake.toStringAsFixed(0)}',
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
                    onPressed: () => _showStakeDialog(pool, provider),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Стейк'),
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

  Widget _buildPositionCard(StakingPosition position, FarmingPool pool, YieldFarmingProvider provider) {
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'АКТИВНА',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Застейкано',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${position.stakedAmount.toStringAsFixed(2)}',
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
                        'Заработано',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${position.earnedRewards.toStringAsFixed(2)}',
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
                        'Ожидает',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${position.pendingRewards.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
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
                    onPressed: () => _claimRewards(position.id, provider),
                    icon: const Icon(Icons.monetization_on, size: 16),
                    label: const Text('Забрать'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showUnstakeDialog(position, provider),
                    icon: const Icon(Icons.remove, size: 16),
                    label: const Text('Вывести'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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

  Widget _buildStrategyCard(FarmingStrategy strategy, YieldFarmingProvider provider) {
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
                    strategy.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRiskColor(strategy.riskLevel).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Риск ${strategy.riskLevel.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: _getRiskColor(strategy.riskLevel),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              strategy.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Целевой APY',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${strategy.targetApy.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 18,
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
                        'Мин. инвестиция',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${strategy.minInvestment.toStringAsFixed(0)}',
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
                        'Макс. инвестиция',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${strategy.maxInvestment.toStringAsFixed(0)}',
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
                    onPressed: () => _showStrategyDetails(strategy),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Детали'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showInvestDialog(strategy, provider),
                    icon: const Icon(Icons.trending_up, size: 16),
                    label: const Text('Инвестировать'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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

  // Helper Methods
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

  String _getPoolTypeName(FarmingPoolType type) {
    switch (type) {
      case FarmingPoolType.liquidity:
        return 'Ликвидность';
      case FarmingPoolType.staking:
        return 'Стейкинг';
      case FarmingPoolType.lending:
        return 'Кредитование';
      case FarmingPoolType.yield:
        return 'Доходность';
      case FarmingPoolType.governance:
        return 'Управление';
    }
  }

  Color _getPoolTypeColor(FarmingPoolType type) {
    switch (type) {
      case FarmingPoolType.liquidity:
        return Colors.blue;
      case FarmingPoolType.staking:
        return Colors.green;
      case FarmingPoolType.lending:
        return Colors.orange;
      case FarmingPoolType.yield:
        return Colors.purple;
      case FarmingPoolType.governance:
        return Colors.red;
    }
  }

  String _getChainName(String chain) {
    switch (chain) {
      case 'ethereum':
        return 'Ethereum';
      case 'bsc':
        return 'BSC';
      case 'polygon':
        return 'Polygon';
      case 'avalanche':
        return 'Avalanche';
      default:
        return chain;
    }
  }

  Color _getRiskColor(double riskLevel) {
    if (riskLevel <= 3) return Colors.green;
    if (riskLevel <= 6) return Colors.orange;
    return Colors.red;
  }

  // Action Methods
  void _showStakeDialog(FarmingPool pool, YieldFarmingProvider provider) {
    // TODO: Implement stake dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Диалог стейкинга - в разработке')),
    );
  }

  void _showPoolDetails(FarmingPool pool) {
    // TODO: Implement pool details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Детали пула - в разработке')),
    );
  }

  Future<void> _claimRewards(String positionId, YieldFarmingProvider provider) async {
    final success = await provider.claimRewards(positionId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Награды успешно получены')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка получения наград')),
      );
    }
  }

  void _showUnstakeDialog(StakingPosition position, YieldFarmingProvider provider) {
    // TODO: Implement unstake dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Диалог вывода средств - в разработке')),
    );
  }

  void _showStrategyDetails(FarmingStrategy strategy) {
    // TODO: Implement strategy details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Детали стратегии - в разработке')),
    );
  }

  void _showInvestDialog(FarmingStrategy strategy, YieldFarmingProvider provider) {
    // TODO: Implement invest dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Диалог инвестирования - в разработке')),
    );
  }

  void _showCreateStrategyDialog() {
    // TODO: Implement create strategy dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Создание стратегии - в разработке')),
    );
  }
}
