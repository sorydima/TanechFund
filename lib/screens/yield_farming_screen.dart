import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Yield Farming — фарминг доходности, стейкинг, награды
class YieldFarmingScreen extends StatefulWidget {
  const YieldFarmingScreen({super.key});

  @override
  State<YieldFarmingScreen> createState() => _YieldFarmingScreenState();
}

class _YieldFarmingScreenState extends State<YieldFarmingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPool = 'all';

  final List<Map<String, dynamic>> _farmingPools = [
    {
      'id': '1',
      'name': 'ETH-USDC LP',
      'token0': 'ETH',
      'token1': 'USDC',
      'apy': 24.5,
      'tvl': 125000000,
      'reward': 'UNI',
      'rewardPerDay': 1250,
      'staked': 2.5,
      'earned': 0.045,
      'lockPeriod': 0,
      'risk': 'medium',
      'color': Colors.blue,
      'verified': true,
    },
    {
      'id': '2',
      'name': 'WBTC-ETH LP',
      'token0': 'WBTC',
      'token1': 'ETH',
      'apy': 18.3,
      'tvl': 285000000,
      'reward': 'SUSHI',
      'rewardPerDay': 850,
      'staked': 1.2,
      'earned': 0.032,
      'lockPeriod': 0,
      'risk': 'low',
      'color': Colors.orange,
      'verified': true,
    },
    {
      'id': '3',
      'name': 'UNI Staking',
      'token0': 'UNI',
      'token1': null,
      'apy': 12.8,
      'tvl': 95000000,
      'reward': 'UNI',
      'rewardPerDay': 2500,
      'staked': 500,
      'earned': 1.85,
      'lockPeriod': 7,
      'risk': 'low',
      'color': Colors.pink,
      'verified': true,
    },
    {
      'id': '4',
      'name': 'LINK-ETH LP',
      'token0': 'LINK',
      'token1': 'ETH',
      'apy': 28.7,
      'tvl': 45000000,
      'reward': 'LINK',
      'rewardPerDay': 450,
      'staked': 0,
      'earned': 0,
      'lockPeriod': 0,
      'risk': 'medium',
      'color': Colors.blue.shade700,
      'verified': true,
    },
    {
      'id': '5',
      'name': 'AAVE Staking',
      'token0': 'AAVE',
      'token1': null,
      'apy': 8.5,
      'tvl': 180000000,
      'reward': 'AAVE',
      'rewardPerDay': 180,
      'staked': 25,
      'earned': 0.12,
      'lockPeriod': 30,
      'risk': 'low',
      'color': Colors.purple,
      'verified': true,
    },
    {
      'id': '6',
      'name': 'CRV-ETH LP',
      'token0': 'CRV',
      'token1': 'ETH',
      'apy': 35.2,
      'tvl': 68000000,
      'reward': 'CRV',
      'rewardPerDay': 950,
      'staked': 0,
      'earned': 0,
      'lockPeriod': 14,
      'risk': 'high',
      'color': Colors.blue.shade600,
      'verified': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yield Farming'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfo,
            tooltip: 'Инфо',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: Column(
        children: [
          // TVL Overview
          _buildTVLOverview(),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[700],
              indicator: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Все пулы'),
                Tab(text: 'Мои позиции'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllPoolsTab(),
                _buildMyPositionsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewPosition,
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // TVL Overview
  Widget _buildTVLOverview() {
    final totalTVL = _farmingPools.fold<int>(
      0,
      (sum, p) => sum + (p['tvl'] as int),
    );
    final totalStaked = _farmingPools.fold<double>(
      0,
      (sum, p) => sum + (p['staked'] as double),
    );
    final totalEarned = _farmingPools.fold<double>(
      0,
      (sum, p) => sum + (p['earned'] as double),
    );
    final avgAPY = _farmingPools.fold<double>(
      0,
      (sum, p) => sum + (p['apy'] as double),
    ) / _farmingPools.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.accentColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.agriculture, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yield Farming',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Обзор фарминга',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildOverviewStat(
                  'TVL',
                  '\$${(totalTVL / 1e9).toStringAsFixed(2)}B',
                  Icons.savings,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildOverviewStat(
                  'Средний APY',
                  '${avgAPY.toStringAsFixed(1)}%',
                  Icons.percent,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildOverviewStat(
                  'Заработано',
                  '${totalEarned.toStringAsFixed(2)}',
                  Icons.redeem,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildOverviewStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // All Pools Tab
  Widget _buildAllPoolsTab() {
    var filtered = _farmingPools;
    
    if (_selectedPool != 'all') {
      filtered = _farmingPools.where((p) => p['risk'] == _selectedPool).toList();
    }

    // Sort by APY
    filtered.sort((a, b) => (b['apy'] as double).compareTo(a['apy'] as double));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildPoolCard(filtered[index], index);
      },
    );
  }

  // My Positions Tab
  Widget _buildMyPositionsTab() {
    final myPositions = _farmingPools.where((p) => (p['staked'] as double) > 0).toList();

    if (myPositions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Нет активных позиций',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте ликвидность для начала фарминга',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myPositions.length,
      itemBuilder: (context, index) {
        return _buildPositionCard(myPositions[index], index);
      },
    );
  }

  // Pool Card
  Widget _buildPoolCard(Map<String, dynamic> pool, int index) {
    final apy = pool['apy'] as double;
    final tvl = pool['tvl'] as int;
    final riskColor = _getRiskColor(pool['risk'] as String);
    final hasStaked = (pool['staked'] as double) > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _openPool(pool),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (pool['color'] as Color).withOpacity(0.2),
                    (pool['color'] as Color).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  // Token icons
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (pool['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        pool['token0'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: pool['color'],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              pool['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (pool['verified'] as bool)
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(Icons.verified, size: 16, color: Colors.blue),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildRiskBadge(pool['risk'] as String),
                            if (pool['lockPeriod'] as int > 0) ...[
                              const SizedBox(width: 8),
                              _buildLockBadge(pool['lockPeriod'] as int),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // APY
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'APY',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        Text(
                          '${apy.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildPoolStat(
                          'TVL',
                          '\$${_formatNumber(tvl)}',
                          Icons.savings,
                          Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildPoolStat(
                          'Награда',
                          '${pool['reward']} ${pool['rewardPerDay']}/д',
                          Icons.redeem,
                          Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: _buildPoolStat(
                          'В пуле',
                          '${_farmingPools.where((p) => p['name'] == pool['name']).length}',
                          Icons.people,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Actions
                  Row(
                    children: [
                      if (hasStaked)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _harvestRewards(pool),
                            icon: const Icon(Icons.grass, size: 18),
                            label: const Text('Собрать'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      if (hasStaked) const SizedBox(width: 12),
                      Expanded(
                        flex: hasStaked ? 1 : 2,
                        child: ElevatedButton(
                          onPressed: () => _stakeInPool(pool),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pool['color'],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(hasStaked ? 'Добавить' : 'Стейкать'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .slideX(begin: 0.2, end: 0);
  }

  // Position Card
  Widget _buildPositionCard(Map<String, dynamic> position, int index) {
    final staked = position['staked'] as double;
    final earned = position['earned'] as double;
    final apy = position['apy'] as double;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (position['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      position['token0'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: position['color'],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'APY: ${apy.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.green,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'В пуле',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '$staked ${position['token0']}',
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
                        'Награда',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '$earned ${position['reward']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
                  child: OutlinedButton.icon(
                    onPressed: () => _harvestRewards(position),
                    icon: const Icon(Icons.grass, size: 18),
                    label: const Text('Собрать'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _unstakeFromPool(position),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Вывести'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildRiskBadge(String risk) {
    Color color;
    String label;
    
    switch (risk) {
      case 'low':
        color = Colors.green;
        label = 'Низкий';
        break;
      case 'medium':
        color = Colors.orange;
        label = 'Средний';
        break;
      case 'high':
        color = Colors.red;
        label = 'Высокий';
        break;
      default:
        color = Colors.grey;
        label = risk;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildLockBadge(int days) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 10, color: Colors.orange),
          const SizedBox(width: 3),
          Text(
            '$days д',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _formatNumber(int num) {
    if (num >= 1e9) return '${(num / 1e9).toStringAsFixed(1)}B';
    if (num >= 1e6) return '${(num / 1e6).toStringAsFixed(1)}M';
    return '${(num / 1e3).toStringAsFixed(1)}K';
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Actions
  void _showInfo() {
    AppLogger.info('Show farming info');
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void _openPool(Map<String, dynamic> pool) {
    AppLogger.info('Open pool: ${pool['name']}');
  }

  void _stakeInPool(Map<String, dynamic> pool) {
    AppLogger.info('Stake in pool: ${pool['name']}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Стейкинг в ${pool['name']}'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _harvestRewards(Map<String, dynamic> pool) {
    AppLogger.info('Harvest rewards: ${pool['name']}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Награды собраны: ${(pool['earned'] as double).toStringAsFixed(4)} ${pool['reward']}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _unstakeFromPool(Map<String, dynamic> pool) {
    AppLogger.info('Unstake from pool: ${pool['name']}');
  }

  void _addNewPosition() {
    AppLogger.info('Add new position');
  }
}
