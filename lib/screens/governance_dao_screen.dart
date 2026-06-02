import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Governance DAO — управление DAO, голосования, предложения
class GovernanceDAOScreen extends StatefulWidget {
  const GovernanceDAOScreen({super.key});

  @override
  State<GovernanceDAOScreen> createState() => _GovernanceDAOScreenState();
}

class _GovernanceDAOScreenState extends State<GovernanceDAOScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDao = 'all';

  final List<Map<String, dynamic>> _daos = [
    {
      'id': '1',
      'name': 'Uniswap DAO',
      'token': 'UNI',
      'treasury': 4200000000,
      'members': 285000,
      'proposals': 145,
      'votingPower': 1250,
      'logo': '🦄',
      'color': Colors.pink,
      'description': 'Крупнейший DEX протокол',
    },
    {
      'id': '2',
      'name': 'MakerDAO',
      'token': 'MKR',
      'treasury': 6700000000,
      'members': 145000,
      'proposals': 312,
      'votingPower': 850,
      'logo': '🏛️',
      'color': Colors.black,
      'description': 'DeFi стейблкоин DAI',
    },
    {
      'id': '3',
      'name': 'Aave DAO',
      'token': 'AAVE',
      'treasury': 2800000000,
      'members': 98000,
      'proposals': 89,
      'votingPower': 620,
      'logo': '👻',
      'color': Colors.purple,
      'description': 'Лендинг протокол',
    },
    {
      'id': '4',
      'name': 'Compound DAO',
      'token': 'COMP',
      'treasury': 1500000000,
      'members': 75000,
      'proposals': 156,
      'votingPower': 420,
      'logo': '🧬',
      'color': Colors.green,
      'description': 'Децентрализованное кредитование',
    },
  ];

  final List<Map<String, dynamic>> _activeProposals = [
    {
      'id': 'p1',
      'dao': 'Uniswap DAO',
      'title': 'Снижение комиссий для стейблкоинов',
      'proposer': '0x742d...8f3a',
      'for': 12500000,
      'against': 3200000,
      'abstain': 850000,
      'endTime': DateTime.now().add(const Duration(days: 3)),
      'status': 'active',
      'description': 'Предложение снизить fees для USDC/ETH пары с 0.3% до 0.05%',
    },
    {
      'id': 'p2',
      'dao': 'MakerDAO',
      'title': 'Увеличение стабильности DAI',
      'proposer': '0x8a5c...2b1e',
      'for': 8500000,
      'against': 2100000,
      'abstain': 450000,
      'endTime': DateTime.now().add(const Duration(days: 5)),
      'status': 'active',
      'description': 'Добавить больше collateral типов для укрепления DAI',
    },
    {
      'id': 'p3',
      'dao': 'Aave DAO',
      'title': 'Запуск V4 протокола',
      'proposer': '0x3f7d...9c4a',
      'for': 6200000,
      'against': 1800000,
      'abstain': 320000,
      'endTime': DateTime.now().add(const Duration(hours: 48)),
      'status': 'active',
      'description': 'Обновление протокола с улучшенной эффективностью капитала',
    },
    {
      'id': 'p4',
      'dao': 'Compound DAO',
      'title': 'Интеграция с Layer 2',
      'proposer': '0x1a2b...7e8f',
      'for': 4200000,
      'against': 950000,
      'abstain': 180000,
      'endTime': DateTime.now().add(const Duration(days: 2)),
      'status': 'active',
      'description': 'Развертывание Compound на Arbitrum и Optimism',
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
        title: const Text('Governance DAO'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createProposal,
            tooltip: 'Создать предложение',
          ),
        ],
      ),
      body: Column(
        children: [
          // DAO Stats
          _buildDAOStats(),

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
                Tab(text: 'DAO'),
                Tab(text: 'Предложения'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDAOTab(),
                _buildProposalsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DAO Stats
  Widget _buildDAOStats() {
    final totalTreasury = _daos.fold<int>(0, (sum, d) => sum + (d['treasury'] as int));
    final totalMembers = _daos.fold<int>(0, (sum, d) => sum + (d['members'] as int));
    final totalProposals = _daos.fold<int>(0, (sum, d) => sum + (d['proposals'] as int));

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
                child: const Icon(Icons.account_balance, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Governance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text('Управление DAO', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatItem('Казна', '\$${(totalTreasury / 1e9).toStringAsFixed(1)}B', Icons.account_balance_wallet)),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(child: _buildStatItem('Участники', '${(totalMembers / 1000).toStringAsFixed(0)}K', Icons.people)),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(child: _buildStatItem('Предложения', '$totalProposals', Icons.gavel)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
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

  // DAO Tab
  Widget _buildDAOTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _daos.length,
      itemBuilder: (context, index) => _buildDAOCard(_daos[index], index),
    );
  }

  Widget _buildDAOCard(Map<String, dynamic> dao, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (dao['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(dao['logo'] as String, style: const TextStyle(fontSize: 32))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dao['name'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (dao['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(dao['token'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: dao['color'])),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('VP: ${dao['votingPower']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('ваша сила', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(dao['description'] as String, style: TextStyle(color: Colors.grey[700], height: 1.4)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDAOStat('\$${((dao['treasury'] as int) / 1e9).toStringAsFixed(1)}B', 'казна', Colors.green),
                const SizedBox(width: 16),
                _buildDAOStat('${((dao['members'] as int) / 1000).toStringAsFixed(0)}K', 'участники', Colors.blue),
                const SizedBox(width: 16),
                _buildDAOStat('${dao['proposals']}', 'предложения', Colors.purple),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewDAO(dao),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: const Text('Инфо'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _voteInDAO(dao),
                    style: ElevatedButton.styleFrom(backgroundColor: dao['color'], padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: const Text('Голосовать'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideX(begin: 0.2, end: 0);
  }

  Widget _buildDAOStat(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  // Proposals Tab
  Widget _buildProposalsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activeProposals.length,
      itemBuilder: (context, index) => _buildProposalCard(_activeProposals[index], index),
    );
  }

  Widget _buildProposalCard(Map<String, dynamic> proposal, int index) {
    final total = (proposal['for'] as int) + (proposal['against'] as int) + (proposal['abstain'] as int);
    final forPercent = ((proposal['for'] as int) / total * 100);
    final againstPercent = ((proposal['against'] as int) / total * 100);
    final abstainPercent = ((proposal['abstain'] as int) / total * 100);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: const Text('Active', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(proposal['dao'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]))),
                Text(' ${(proposal['endTime'] as DateTime).difference(DateTime.now()).inDays}д', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(proposal['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(proposal['description'] as String, style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: 1,
                backgroundColor: Colors.grey[200],
                minHeight: 8,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('За: ${forPercent.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                Text('Против: ${againstPercent.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                Text('Воздерж: ${abstainPercent.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _vote(proposal, 'for'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 10)),
                    child: const Text('За'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _vote(proposal, 'against'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 10)),
                    child: const Text('Против'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _vote(proposal, 'abstain'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                    child: const Text('Воздерж.'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideY(begin: 0.1, end: 0);
  }

  void _createProposal() {
    AppLogger.info('Create new proposal');
  }

  void _viewDAO(Map<String, dynamic> dao) {
    AppLogger.info('View DAO: ${dao['name']}');
  }

  void _voteInDAO(Map<String, dynamic> dao) {
    AppLogger.info('Vote in DAO: ${dao['name']}');
  }

  void _vote(Map<String, dynamic> proposal, String choice) {
    AppLogger.info('Vote $choice on proposal: ${proposal['title']}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Голос "$choice" принят'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
