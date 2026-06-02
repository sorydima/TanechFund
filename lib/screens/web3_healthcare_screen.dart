import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Web3 Healthcare — блокчейн в здравоохранении
class Web3HealthcareScreen extends StatefulWidget {
  const Web3HealthcareScreen({super.key});

  @override
  State<Web3HealthcareScreen> createState() => _Web3HealthcareScreenState();
}

class _Web3HealthcareScreenState extends State<Web3HealthcareScreen> {
  final List<Map<String, dynamic>> _projects = [
    {'id': '1', 'name': 'MediChain', 'focus': 'Мед. записи', 'token': 'MEDI', 'marketCap': '\$125M', 'partners': 45, 'rating': 4.5, 'image': '🏥', 'color': Colors.red},
    {'id': '2', 'name': 'Doc.ai', 'focus': 'Данные пациентов', 'token': 'SNR', 'marketCap': '\$85M', 'partners': 32, 'rating': 4.3, 'image': '👨‍⚕️', 'color': Colors.blue},
    {'id': '3', 'name': 'Solve.Care', 'focus': 'Страхование', 'token': 'SOLVE', 'marketCap': '\$65M', 'partners': 28, 'rating': 4.4, 'image': '🛡️', 'color': Colors.green},
    {'id': '4', 'name': 'Patientory', 'focus': 'EMR система', 'token': 'PTOY', 'marketCap': '\$45M', 'partners': 18, 'rating': 4.2, 'image': '📋', 'color': Colors.purple},
    {'id': '5', 'name': 'Medicalchain', 'focus': 'Телемедицина', 'token': 'MTN', 'marketCap': '\$55M', 'partners': 22, 'rating': 4.3, 'image': '💊', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Web3 Healthcare'), backgroundColor: Colors.transparent, elevation: 0),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _buildStats()),
        SliverToBoxAdapter(child: _buildSectionHeader('Проекты', Icons.medical_services)),
        SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildProjectsList()),
        SliverToBoxAdapter(child: _buildSectionHeader('Преимущества', Icons.check_circle_outline)),
        SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildBenefitsGrid()),
      ]),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.accentColor]), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.medical_services, color: Colors.white, size: 28)), const SizedBox(width: 16), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Healthcare', style: TextStyle(color: Colors.white70, fontSize: 14)), Text('Блокчейн в медицине', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))])]),
        const SizedBox(height: 20),
        Row(children: [Expanded(child: _buildStatItem('Проекты', '${_projects.length}', Icons.business)), Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)), Expanded(child: _buildStatItem('Партнёры', '${_projects.fold<int>(0, (s, p) => s + (p['partners'] as int))}', Icons.handshake)), Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)), Expanded(child: _buildStatItem('Капитал', '\$375M', Icons.account_balance_wallet))]),
      ]),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(children: [Icon(icon, color: Colors.white.withOpacity(0.9), size: 20), const SizedBox(height: 6), Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10))]);
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 24, 16, 12), child: Row(children: [Icon(icon, size: 18, color: AppTheme.primaryColor), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]));
  }

  Widget _buildProjectsList() {
    return SliverList(delegate: SliverChildBuilderDelegate((context, index) => _buildProjectCard(_projects[index], index), childCount: _projects.length));
  }

  Widget _buildProjectCard(Map<String, dynamic> project, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: (project['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(project['image'] as String, style: const TextStyle(fontSize: 30)))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(project['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(project['focus'] as String, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            const SizedBox(height: 6),
            Row(children: [Icon(Icons.business, size: 12, color: Colors.grey[600]), const SizedBox(width: 4), Text('${project['partners']} партнёров', style: TextStyle(fontSize: 11, color: Colors.grey[600]))]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(project['marketCap'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.star, size: 12, color: Colors.amber), Text(' ${project['rating']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => _viewProject(project), style: ElevatedButton.styleFrom(backgroundColor: project['color'], padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), minimumSize: const Size(0, 0)), child: const Text('Инфо', style: TextStyle(fontSize: 11))),
          ]),
        ]),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideX(begin: 0.2, end: 0);
  }

  Widget _buildBenefitsGrid() {
    final benefits = [
      {'icon': Icons.security, 'title': 'Безопасность', 'desc': 'Защита данных пациентов'},
      {'icon': Icons.swap_horiz, 'title': 'Интероперабельность', 'desc': 'Обмен между системами'},
      {'icon': Icons.visibility, 'title': 'Прозрачность', 'desc': 'Отслеживание доступа'},
      {'icon': Icons.speed, 'title': 'Эффективность', 'desc': 'Быстрые транзакции'},
    ];
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
      delegate: SliverChildBuilderDelegate((context, index) => _buildBenefitCard(benefits[index]), childCount: benefits.length),
    );
  }

  Widget _buildBenefitCard(Map<String, dynamic> benefit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(benefit['icon'] as IconData, size: 32, color: AppTheme.primaryColor),
          const SizedBox(height: 12),
          Text(benefit['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(benefit['desc'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600]), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  void _viewProject(Map<String, dynamic> p) => AppLogger.info('View project: ${p['name']}');
}
