import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// DeFi Analytics — аналитика DeFi протоколов и метрик
class DeFiAnalyticsScreen extends StatefulWidget {
  const DeFiAnalyticsScreen({super.key});

  @override
  State<DeFiAnalyticsScreen> createState() => _DeFiAnalyticsScreenState();
}

class _DeFiAnalyticsScreenState extends State<DeFiAnalyticsScreen> {
  String _selectedPeriod = '7d';
  String _selectedCategory = 'all';

  final List<Map<String, dynamic>> _topProtocols = [
    {'rank': 1, 'name': 'Lido', 'tvl': 14500000000, 'change24h': 2.5, 'category': 'staking', 'logo': '🐙'},
    {'rank': 2, 'name': 'MakerDAO', 'tvl': 6700000000, 'change24h': -1.2, 'category': 'lending', 'logo': '🏛️'},
    {'rank': 3, 'name': 'Aave V3', 'tvl': 5800000000, 'change24h': 3.8, 'category': 'lending', 'logo': '👻'},
    {'rank': 4, 'name': 'Curve', 'tvl': 4100000000, 'change24h': 1.5, 'category': 'dex', 'logo': '📈'},
    {'rank': 5, 'name': 'Uniswap V3', 'tvl': 3200000000, 'change24h': -0.8, 'category': 'dex', 'logo': '🦄'},
  ];

  final List<Map<String, dynamic>> _marketMetrics = [
    {'name': 'Total Value Locked', 'value': '\$85.4B', 'change': 5.2, 'icon': Icons.savings},
    {'name': '24h Volume', 'value': '\$12.8B', 'change': 8.5, 'icon': Icons.trending_up},
    {'name': 'Active Users', 'value': '2.4M', 'change': 12.3, 'icon': Icons.people},
    {'name': 'Total Transactions', 'value': '45.2M', 'change': 6.7, 'icon': Icons.swap_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeFi Analytics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: _exportData, tooltip: 'Экспорт'),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData, tooltip: 'Обновить'),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildMarketOverview()),
          SliverToBoxAdapter(child: _buildPeriodSelector()),
          SliverToBoxAdapter(child: _buildCategoryFilter()),
          SliverToBoxAdapter(child: _buildSectionHeader('Топ протоколы', Icons.leaderboard)),
          SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildProtocolsList()),
          SliverToBoxAdapter(child: _buildSectionHeader('Метрики рынка', Icons.insights)),
          SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildMetricsGrid()),
        ],
      ),
    );
  }

  Widget _buildMarketOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.accentColor]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.insights, color: Colors.white, size: 28)),
            const SizedBox(width: 16),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('DeFi Analytics', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text('Аналитика рынка', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ]),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _buildMetricCard('TVL', '\$85.4B', '+5.2%', true)),
            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
            Expanded(child: _buildMetricCard('24h', '\$12.8B', '+8.5%', true)),
            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
            Expanded(child: _buildMetricCard('Users', '2.4M', '+12.3%', true)),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMetricCard(String label, String value, String change, bool positive) {
    return Column(children: [
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(positive ? Icons.arrow_upward : Icons.arrow_downward, size: 12, color: Colors.white),
        Text(change, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ]),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
    ]);
  }

  Widget _buildPeriodSelector() {
    final periods = ['24h', '7d', '30d', '90d', '1y'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: periods.map((p) => Expanded(child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = p),
        child: Container(
          margin: const EdgeInsets.only(right: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: _selectedPeriod == p ? AppTheme.primaryColor : Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(p, style: TextStyle(color: _selectedPeriod == p ? Colors.white : Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 12))),
        ),
      ))).toList()),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      {'id': 'all', 'label': 'Все', 'icon': Icons.view_agenda},
      {'id': 'dex', 'label': 'DEX', 'icon': Icons.swap_horiz},
      {'id': 'lending', 'label': 'Lending', 'icon': Icons.account_balance},
      {'id': 'staking', 'label': 'Staking', 'icon': Icons.lock},
    ];
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final c = categories[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(avatar: Icon(c['icon'] as IconData, size: 16), label: Text(c['label'] as String), selected: _selectedCategory == c['id'], onSelected: (s) => setState(() => _selectedCategory = c['id'] as String)),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 24, 16, 12), child: Row(children: [Icon(icon, size: 18, color: AppTheme.primaryColor), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]));
  }

  Widget _buildProtocolsList() {
    return SliverList(delegate: SliverChildBuilderDelegate((context, index) => _buildProtocolRow(_topProtocols[index], index), childCount: _topProtocols.length));
  }

  Widget _buildProtocolRow(Map<String, dynamic> protocol, int index) {
    final change = protocol['change24h'] as double;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Text('#${protocol['rank']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
          const SizedBox(width: 12),
          Text(protocol['logo'] as String, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(protocol['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)), Text(protocol['category'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600]))])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$${((protocol['tvl'] as int) / 1e9).toStringAsFixed(1)}B', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${change > 0 ? '+' : ''}${change}%', style: TextStyle(color: change >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
          ]),
        ]),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
  }

  Widget _buildMetricsGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 12, mainAxisSpacing: 12),
      delegate: SliverChildBuilderDelegate((context, index) => _buildMetricCardSmall(_marketMetrics[index]), childCount: _marketMetrics.length),
    );
  }

  Widget _buildMetricCardSmall(Map<String, dynamic> metric) {
    final change = metric['change'] as double;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(metric['icon'] as IconData, size: 28, color: AppTheme.primaryColor),
          const SizedBox(height: 8),
          Text(metric['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(metric['name'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600]), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(change > 0 ? Icons.trending_up : Icons.trending_down, size: 12, color: change > 0 ? Colors.green : Colors.red), Text(' ${change}%', style: TextStyle(color: change > 0 ? Colors.green : Colors.red, fontSize: 11, fontWeight: FontWeight.bold))]),
        ]),
      ),
    );
  }

  void _exportData() => AppLogger.info('Export analytics data');
  void _refreshData() => AppLogger.info('Refresh analytics data');
}
