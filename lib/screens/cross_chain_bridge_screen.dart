import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Cross-Chain Bridge — мосты между блокчейнами
class CrossChainBridgeScreen extends StatefulWidget {
  const CrossChainBridgeScreen({super.key});

  @override
  State<CrossChainBridgeScreen> createState() => _CrossChainBridgeScreenState();
}

class _CrossChainBridgeScreenState extends State<CrossChainBridgeScreen> {
  String _fromChain = 'Ethereum';
  String _toChain = 'Solana';
  double _amount = 0;
  String _selectedBridge = 'all';

  final Map<String, Map<String, dynamic>> _chains = {
    'Ethereum': {'icon': '⟐', 'color': Colors.purple, 'fee': 0.001},
    'Solana': {'icon': '◎', 'color': Colors.purple.shade600, 'fee': 0.00025},
    'Polygon': {'icon': '⬡', 'color': Colors.purple.shade300, 'fee': 0.001},
    'Avalanche': {'icon': '🔺', 'color': Colors.red, 'fee': 0.001},
    'BNB': {'icon': '⬡', 'color': Colors.amber, 'fee': 0.001},
    'Arbitrum': {'icon': '◆', 'color': Colors.blue, 'fee': 0.001},
    'Optimism': {'icon': '⬤', 'color': Colors.red.shade400, 'fee': 0.001},
    'Near': {'icon': 'Ⓝ', 'color': Colors.black, 'fee': 0.001},
  };

  final List<Map<String, dynamic>> _bridges = [
    {
      'id': '1',
      'name': 'Multichain',
      'chains': ['Ethereum', 'Solana', 'Polygon', 'Avalanche', 'BNB', 'Arbitrum'],
      'volume24h': 185000000,
      'fee': 0.1,
      'time': '5-15 мин',
      'logo': '🌉',
      'color': Colors.blue,
      'rating': 4.5,
    },
    {
      'id': '2',
      'name': 'Stargate',
      'chains': ['Ethereum', 'Solana', 'Avalanche', 'Polygon'],
      'volume24h': 125000000,
      'fee': 0.06,
      'time': '3-10 мин',
      'logo': '🚀',
      'color': Colors.green,
      'rating': 4.7,
    },
    {
      'id': '3',
      'name': 'LayerZero',
      'chains': ['Ethereum', 'Solana', 'Avalanche', 'Arbitrum', 'Optimism'],
      'volume24h': 98000000,
      'fee': 0.05,
      'time': '2-5 мин',
      'logo': '🔗',
      'color': Colors.orange,
      'rating': 4.8,
    },
    {
      'id': '4',
      'name': 'Wormhole',
      'chains': ['Ethereum', 'Solana', 'Avalanche', 'Polygon'],
      'volume24h': 250000000,
      'fee': 0.15,
      'time': '10-20 мин',
      'logo': '🐛',
      'color': Colors.purple,
      'rating': 4.3,
    },
    {
      'id': '5',
      'name': 'Celer Bridge',
      'chains': ['Ethereum', 'Solana', 'Polygon', 'Avalanche'],
      'volume24h': 75000000,
      'fee': 0.08,
      'time': '5-15 мин',
      'logo': '🏃',
      'color': Colors.blue.shade600,
      'rating': 4.4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross-Chain Мосты'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: _swapChains,
            tooltip: 'Поменять цепи',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshRates,
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Bridge Stats
          SliverToBoxAdapter(
            child: _buildBridgeStats(),
          ),

          // Transfer Card
          SliverToBoxAdapter(
            child: _buildTransferCard(),
          ),

          // Bridge Filter
          SliverToBoxAdapter(
            child: _buildBridgeFilter(),
          ),

          // Bridges List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildBridgesList(),
          ),
        ],
      ),
    );
  }

  // Bridge Stats
  Widget _buildBridgeStats() {
    final totalVolume = _bridges.fold<int>(
      0,
      (sum, b) => sum + (b['volume24h'] as int),
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.swap_horizontal_circle, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cross-Chain',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    'Мосты и обмен',
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
                child: _buildStatItem('Объём 24ч', '\$${(totalVolume / 1e9).toStringAsFixed(2)}B', Icons.trending_up),
              ),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: _buildStatItem('Мостов', '${_bridges.length}', Icons.horizontal_split),
              ),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: _buildStatItem('Цепей', '${_chains.length}', Icons.account_tree),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
      ],
    );
  }

  // Transfer Card
  Widget _buildTransferCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Перевод между цепями', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // From Chain
            _buildChainSelector('Из', _fromChain, (chain) => setState(() => _fromChain = chain)),
            const SizedBox(height: 12),
            // Swap Button
            Center(
              child: IconButton(
                onPressed: _swapChains,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.swap_vert, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // To Chain
            _buildChainSelector('В', _toChain, (chain) => setState(() => _toChain = chain)),
            const SizedBox(height: 16),
            // Amount
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Сумма',
                suffixText: _fromChain,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => _amount = double.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 16),
            // Fee estimate
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Комиссия моста:', style: TextStyle(color: Colors.grey)),
                  Text('~${((_amount * 0.001) + 0.5).toStringAsFixed(2)} USD', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _amount > 0 ? _initiateTransfer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Перевести', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: 200.ms)
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildChainSelector(String label, String selectedChain, Function(String) onSelect) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: selectedChain,
              isExpanded: true,
              underline: const SizedBox(),
              items: _chains.keys.map((chain) {
                final data = _chains[chain]!;
                return DropdownMenuItem(
                  value: chain,
                  child: Row(
                    children: [
                      Text(data['icon'] as String, style: TextStyle(fontSize: 18, color: data['color'])),
                      const SizedBox(width: 8),
                      Text(chain),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => onSelect(value!),
            ),
          ),
        ],
      ),
    );
  }

  // Bridge Filter
  Widget _buildBridgeFilter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text('Фильтр:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Все', 'all'),
                  _buildFilterChip('Multichain', '1'),
                  _buildFilterChip('Stargate', '2'),
                  _buildFilterChip('LayerZero', '3'),
                  _buildFilterChip('Wormhole', '4'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedBridge == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => setState(() => _selectedBridge = value),
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      ),
    );
  }

  // Bridges List
  Widget _buildBridgesList() {
    var filtered = _bridges;
    if (_selectedBridge != 'all') {
      filtered = _bridges.where((b) => b['id'] == _selectedBridge).toList();
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildBridgeCard(filtered[index], index),
        childCount: filtered.length,
      ),
    );
  }

  Widget _buildBridgeCard(Map<String, dynamic> bridge, int index) {
    final chains = (bridge['chains'] as List).take(4).toList();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (bridge['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(bridge['logo'] as String, style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bridge['name'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${bridge['rating']}', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${bridge['fee']}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: bridge['color'])),
                    Text('комиссия', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.account_tree, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    chains.join(' → '),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildBridgeStat('${((bridge['volume24h'] as int) / 1e6).toStringAsFixed(0)}M', 'объём 24ч'),
                const SizedBox(width: 16),
                _buildBridgeStat(bridge['time'] as String, 'время'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _useBridge(bridge),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bridge['color'],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Использовать мост'),
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .slideX(begin: 0.2, end: 0);
  }

  Widget _buildBridgeStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  void _swapChains() {
    setState(() {
      final temp = _fromChain;
      _fromChain = _toChain;
      _toChain = temp;
    });
    AppLogger.info('Swapped chains: $_fromChain -> $_toChain');
  }

  void _refreshRates() {
    AppLogger.info('Refreshing bridge rates');
  }

  void _initiateTransfer() {
    AppLogger.info('Initiating transfer: $_amount from $_fromChain to $_toChain');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Перевод $_amount $_fromChain → $_toChain'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _useBridge(Map<String, dynamic> bridge) {
    AppLogger.info('Using bridge: ${bridge['name']}');
  }
}
