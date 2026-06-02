import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// DeFi экран — протоколы, стейкинг, ликвидность, фарминг
class BlockchainDeFiScreen extends StatefulWidget {
  const BlockchainDeFiScreen({super.key});

  @override
  State<BlockchainDeFiScreen> createState() => _BlockchainDeFiScreenState();
}

class _BlockchainDeFiScreenState extends State<BlockchainDeFiScreen> {
  String _selectedCategory = 'all';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _defiProtocols = [
    {
      'id': '1',
      'name': 'Uniswap V3',
      'category': 'dex',
      'tvl': 3200000000,
      'apy': 12.5,
      'volume24h': 1500000000,
      'token': 'UNI',
      'chain': 'Ethereum',
      'risk': 'low',
      'description': 'Крупнейший DEX на Ethereum с концентрированной ликвидностью',
      'logo': '🦄',
      'color': Colors.pink,
    },
    {
      'id': '2',
      'name': 'Aave V3',
      'category': 'lending',
      'tvl': 5800000000,
      'apy': 8.3,
      'volume24h': 450000000,
      'token': 'AAVE',
      'chain': 'Multi-chain',
      'risk': 'low',
      'description': 'Децентрализованный протокол кредитования',
      'logo': '👻',
      'color': Colors.purple,
    },
    {
      'id': '3',
      'name': 'Lido',
      'category': 'staking',
      'tvl': 14500000000,
      'apy': 4.2,
      'volume24h': 120000000,
      'token': 'LDO',
      'chain': 'Ethereum',
      'risk': 'low',
      'description': 'Ликвидный стейкинг ETH',
      'logo': '🐙',
      'color': Colors.blue,
    },
    {
      'id': '4',
      'name': 'Curve Finance',
      'category': 'dex',
      'tvl': 4100000000,
      'apy': 15.7,
      'volume24h': 380000000,
      'token': 'CRV',
      'chain': 'Multi-chain',
      'risk': 'medium',
      'description': 'DEX оптимизированный для стейблкоинов',
      'logo': '📈',
      'color': Colors.blue.shade700,
    },
    {
      'id': '5',
      'name': 'MakerDAO',
      'category': 'lending',
      'tvl': 6700000000,
      'apy': 5.5,
      'volume24h': 200000000,
      'token': 'MKR',
      'chain': 'Ethereum',
      'risk': 'low',
      'description': 'Децентрализованный стейблкоин DAI',
      'logo': '🏛️',
      'color': Colors.black,
    },
    {
      'id': '6',
      'name': 'Convex Finance',
      'category': 'yield',
      'tvl': 2900000000,
      'apy': 18.2,
      'volume24h': 95000000,
      'token': 'CVX',
      'chain': 'Ethereum',
      'risk': 'medium',
      'description': 'Бустер доходности для Curve',
      'logo': '⬡',
      'color': Colors.purple.shade700,
    },
    {
      'id': '7',
      'name': 'Rocket Pool',
      'category': 'staking',
      'tvl': 3400000000,
      'apy': 4.5,
      'volume24h': 45000000,
      'token': 'RPL',
      'chain': 'Ethereum',
      'risk': 'low',
      'description': 'Децентрализованный стейкинг ETH',
      'logo': '🚀',
      'color': Colors.orange,
    },
    {
      'id': '8',
      'name': 'GMX',
      'category': 'derivatives',
      'tvl': 650000000,
      'apy': 25.3,
      'volume24h': 180000000,
      'token': 'GMX',
      'chain': 'Arbitrum',
      'risk': 'high',
      'description': 'Децентрализованные перпетуальные контракты',
      'logo': '📊',
      'color': Colors.blue.shade400,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeFi Протоколы'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Обновить',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Фильтр',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // TVL Overview
          SliverToBoxAdapter(
            child: _buildTVLOverview(),
          ),

          // Category Filter
          SliverToBoxAdapter(
            child: _buildCategoryFilter(),
          ),

          // Protocols List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _isLoading
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _buildProtocolsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProtocol,
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // TVL Overview
  Widget _buildTVLOverview() {
    final totalTVL = _defiProtocols.fold<int>(
      0,
      (sum, p) => sum + (p['tvl'] as int),
    );
    final totalVolume = _defiProtocols.fold<int>(
      0,
      (sum, p) => sum + (p['volume24h'] as int),
    );
    final avgAPY = _defiProtocols.fold<double>(
      0,
      (sum, p) => sum + (p['apy'] as double),
    ) / _defiProtocols.length;

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
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DeFi Обзор',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Общая статистика',
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
                  '\$${(totalTVL / 1e9).toStringAsFixed(1)}B',
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
                  '24h Объём',
                  '\$${(totalVolume / 1e9).toStringAsFixed(1)}B',
                  Icons.trending_up,
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

  // Category Filter
  Widget _buildCategoryFilter() {
    final categories = [
      {'id': 'all', 'label': 'Все', 'icon': Icons.view_agenda},
      {'id': 'dex', 'label': 'DEX', 'icon': Icons.swap_horiz},
      {'id': 'lending', 'label': 'Кредитование', 'icon': Icons.account_balance},
      {'id': 'staking', 'label': 'Стейкинг', 'icon': Icons.lock},
      {'id': 'yield', 'label': 'Фарминг', 'icon': Icons.grass},
      {'id': 'derivatives', 'label': 'Деривативы', 'icon': Icons.show_chart},
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: Icon(category['icon'] as IconData, size: 18),
              label: Text(category['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category['id'] as String);
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  // Protocols List
  Widget _buildProtocolsList() {
    var filtered = _defiProtocols;
    
    if (_selectedCategory != 'all') {
      filtered = filtered.where((p) => p['category'] == _selectedCategory).toList();
    }

    // Sort by TVL
    filtered.sort((a, b) => (b['tvl'] as int).compareTo(a['tvl'] as int));

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildProtocolCard(filtered[index], index),
        childCount: filtered.length,
      ),
    );
  }

  // Protocol Card
  Widget _buildProtocolCard(Map<String, dynamic> protocol, int index) {
    final tvlFormatted = _formatTVL(protocol['tvl'] as int);
    final riskColor = _getRiskColor(protocol['risk'] as String);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _openProtocol(protocol),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo and name
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (protocol['color'] as Color).withOpacity(0.1),
                    (protocol['color'] as Color).withOpacity(0.05),
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
                  // Logo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: (protocol['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        protocol['logo'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          protocol['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (protocol['color'] as Color).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                protocol['token'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: protocol['color'],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              protocol['chain'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // APY Badge
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
                          '${protocol['apy']}%',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    protocol['description'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildProtocolStat(
                          'TVL',
                          tvlFormatted,
                          Icons.savings,
                          Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildProtocolStat(
                          '24h',
                          _formatVolume(protocol['volume24h'] as int),
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildProtocolStat(
                          'Риск',
                          _getRiskText(protocol['risk'] as String),
                          Icons.shield,
                          riskColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showProtocolDetails(protocol),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: protocol['color']),
                          ),
                          child: Text(
                            'Детали',
                            style: TextStyle(color: protocol['color']),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _investInProtocol(protocol),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: protocol['color'],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Инвестировать'),
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

  Widget _buildProtocolStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Протоколы не найдены',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Измените фильтры',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTVL(int tvl) {
    if (tvl >= 1e9) return '\$${(tvl / 1e9).toStringAsFixed(1)}B';
    if (tvl >= 1e6) return '\$${(tvl / 1e6).toStringAsFixed(1)}M';
    return '\$${(tvl / 1e3).toStringAsFixed(1)}K';
  }

  String _formatVolume(int volume) {
    if (volume >= 1e9) return '${(volume / 1e9).toStringAsFixed(1)}B';
    if (volume >= 1e6) return '${(volume / 1e6).toStringAsFixed(0)}M';
    return '${(volume / 1e3).toStringAsFixed(0)}K';
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

  String _getRiskText(String risk) {
    switch (risk) {
      case 'low':
        return 'Низкий';
      case 'medium':
        return 'Средний';
      case 'high':
        return 'Высокий';
      default:
        return risk;
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  void _showFilterDialog() {
    AppLogger.info('Show DeFi filter dialog');
  }

  void _openProtocol(Map<String, dynamic> protocol) {
    AppLogger.info('Open protocol: ${protocol['name']}');
  }

  void _showProtocolDetails(Map<String, dynamic> protocol) {
    AppLogger.info('Show details: ${protocol['name']}');
  }

  void _investInProtocol(Map<String, dynamic> protocol) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Инвестирование в ${protocol['name']}'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddProtocol() {
    AppLogger.info('Add new protocol');
  }
}
