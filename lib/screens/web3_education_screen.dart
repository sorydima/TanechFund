import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Web3 Education — образовательные ресурсы по блокчейну
class Web3EducationScreen extends StatefulWidget {
  const Web3EducationScreen({super.key});

  @override
  State<Web3EducationScreen> createState() => _Web3EducationScreenState();
}

class _Web3EducationScreenState extends State<Web3EducationScreen> {
  final List<Map<String, dynamic>> _resources = [
    {'id': '1', 'title': 'Blockchain Basics', 'type': 'course', 'level': 'Beginner', 'duration': '4h', 'students': 15420, 'rating': 4.8, 'image': '📚', 'color': Colors.blue},
    {'id': '2', 'title': 'DeFi Deep Dive', 'type': 'course', 'level': 'Advanced', 'duration': '8h', 'students': 8750, 'rating': 4.9, 'image': '💰', 'color': Colors.green},
    {'id': '3', 'title': 'NFT Masterclass', 'type': 'workshop', 'level': 'Intermediate', 'duration': '3h', 'students': 12300, 'rating': 4.7, 'image': '🎨', 'color': Colors.purple},
    {'id': '4', 'title': 'Smart Contract Dev', 'type': 'course', 'level': 'Advanced', 'duration': '12h', 'students': 6500, 'rating': 4.9, 'image': '💻', 'color': Colors.orange},
    {'id': '5', 'title': 'DAO Governance', 'type': 'guide', 'level': 'Intermediate', 'duration': '2h', 'students': 9800, 'rating': 4.6, 'image': '🏛️', 'color': Colors.red},
    {'id': '6', 'title': 'Crypto Security', 'type': 'workshop', 'level': 'Beginner', 'duration': '2h', 'students': 18500, 'rating': 4.8, 'image': '🔒', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Web3 Education'), backgroundColor: Colors.transparent, elevation: 0, actions: [IconButton(icon: const Icon(Icons.search), onPressed: _searchResources)]),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _buildStats()),
        SliverToBoxAdapter(child: _buildFilterChips()),
        SliverToBoxAdapter(child: _buildSectionHeader('Ресурсы', Icons.school)),
        SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildResourcesList()),
      ]),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.accentColor]), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.school, color: Colors.white, size: 28)), const SizedBox(width: 16), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('REChain Academy', style: TextStyle(color: Colors.white70, fontSize: 14)), Text('Обучение Web3', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))])]),
        const SizedBox(height: 20),
        Row(children: [Expanded(child: _buildStatItem('Курсы', '24', Icons.class_)), Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)), Expanded(child: _buildStatItem('Студенты', '71K', Icons.people)), Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)), Expanded(child: _buildStatItem('Рейтинг', '4.8★', Icons.star))]),
      ]),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(children: [Icon(icon, color: Colors.white.withOpacity(0.9), size: 20), const SizedBox(height: 6), Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10))]);
  }

  Widget _buildFilterChips() {
    final types = ['Все', 'Course', 'Workshop', 'Guide'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: types.map((t) => Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: Text(t), selected: t == 'Все', onSelected: (s) {}))).toList())),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), child: Row(children: [Icon(icon, size: 18, color: AppTheme.primaryColor), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]));
  }

  Widget _buildResourcesList() {
    return SliverList(delegate: SliverChildBuilderDelegate((context, index) => _buildResourceCard(_resources[index], index), childCount: _resources.length));
  }

  Widget _buildResourceCard(Map<String, dynamic> resource, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: (resource['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(resource['image'] as String, style: const TextStyle(fontSize: 30)))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(resource['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: (resource['color'] as Color).withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: Text(resource['type'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: resource['color']))), const SizedBox(width: 6), Text(resource['level'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600]))]),
            const SizedBox(height: 6),
            Row(children: [Icon(Icons.people, size: 12, color: Colors.grey[600]), const SizedBox(width: 4), Text('${(resource['students'] as int) ~/ 1000}K студентов', style: TextStyle(fontSize: 11, color: Colors.grey[600])), const SizedBox(width: 12), Icon(Icons.access_time, size: 12, color: Colors.grey[600]), const SizedBox(width: 4), Text(resource['duration'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600]))]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Row(children: [const Icon(Icons.star, size: 14, color: Colors.amber), Text(' ${resource['rating']}', style: const TextStyle(fontWeight: FontWeight.bold))]), const SizedBox(height: 8), IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), onPressed: () => _openResource(resource))]),
        ]),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideX(begin: 0.2, end: 0);
  }

  void _searchResources() => AppLogger.info('Search education resources');
  void _openResource(Map<String, dynamic> r) => AppLogger.info('Open resource: ${r['title']}');
}
