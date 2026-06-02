import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Web3 Gaming — блокчейн игры, NFT, Play-to-Earn
class Web3GamingScreen extends StatefulWidget {
  const Web3GamingScreen({super.key});

  @override
  State<Web3GamingScreen> createState() => _Web3GamingScreenState();
}

class _Web3GamingScreenState extends State<Web3GamingScreen> {
  final List<Map<String, dynamic>> _games = [
    {'id': '1', 'name': 'Axie Infinity', 'genre': 'RPG', 'token': 'AXS', 'players': '2.5M', 'rating': 4.5, 'image': '🎮', 'color': Colors.orange, 'earning': '\$150-500/мес'},
    {'id': '2', 'name': 'The Sandbox', 'genre': 'Metaverse', 'token': 'SAND', 'players': '1.8M', 'rating': 4.3, 'image': '🏝️', 'color': Colors.blue, 'earning': '\$100-300/мес'},
    {'id': '3', 'name': 'Decentraland', 'genre': 'Metaverse', 'token': 'MANA', 'players': '1.2M', 'rating': 4.2, 'image': '🌍', 'color': Colors.purple, 'earning': '\$80-250/мес'},
    {'id': '4', 'name': 'Gods Unchained', 'genre': 'Card Game', 'token': 'GODS', 'players': '850K', 'rating': 4.6, 'image': '🃏', 'color': Colors.red, 'earning': '\$50-200/мес'},
    {'id': '5', 'name': 'Splinterlands', 'genre': 'Card Game', 'token': 'SPS', 'players': '650K', 'rating': 4.4, 'image': '⚔️', 'color': Colors.green, 'earning': '\$30-150/мес'},
    {'id': '6', 'name': 'Illuvium', 'genre': 'RPG', 'token': 'ILV', 'players': '420K', 'rating': 4.7, 'image': '👾', 'color': Colors.purple.shade700, 'earning': '\$200-600/мес'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Web3 Gaming'), backgroundColor: Colors.transparent, elevation: 0, actions: [IconButton(icon: const Icon(Icons.leaderboard), onPressed: _showLeaderboard)]),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _buildStats()),
        SliverToBoxAdapter(child: _buildSectionHeader('Популярные игры', Icons.whatshot)),
        SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildGamesGrid()),
      ]),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.accentColor]), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.games, color: Colors.white, size: 28)), const SizedBox(width: 16), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Web3 Gaming', style: TextStyle(color: Colors.white70, fontSize: 14)), Text('Play-to-Earn', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))])]),
        const SizedBox(height: 20),
        Row(children: [Expanded(child: _buildStatItem('Игроки', '7.4M', Icons.people)), Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)), Expanded(child: _buildStatItem('Игры', '${_games.length}', Icons.gamepad)), Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)), Expanded(child: _buildStatItem('Объём', '\$2.1B', Icons.trending_up))]),
      ]),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(children: [Icon(icon, color: Colors.white.withOpacity(0.9), size: 20), const SizedBox(height: 6), Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10))]);
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), child: Row(children: [Icon(icon, size: 18, color: AppTheme.primaryColor), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]));
  }

  Widget _buildGamesGrid() {
    return SliverGrid(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12), delegate: SliverChildBuilderDelegate((context, index) => _buildGameCard(_games[index], index), childCount: _games.length));
  }

  Widget _buildGameCard(Map<String, dynamic> game, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [(game['color'] as Color).withOpacity(0.3), (game['color'] as Color).withOpacity(0.1)])), child: Center(child: Text(game['image'] as String, style: const TextStyle(fontSize: 60))))),
        Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(game['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: (game['color'] as Color).withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: Text(game['genre'] as String, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: game['color']))), const SizedBox(width: 6), Row(children: [const Icon(Icons.star, size: 10, color: Colors.amber), Text(' ${game['rating']}', style: const TextStyle(fontSize: 10))])]),
          const SizedBox(height: 6),
          Row(children: [Icon(Icons.people, size: 10, color: Colors.grey[600]), const SizedBox(width: 4), Text(game['players'] as String, style: TextStyle(fontSize: 10, color: Colors.grey[600]))]),
          const SizedBox(height: 4),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(game['earning'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green))),
        ])),
      ]),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).scale(begin: const Offset(0.95, 0.95));
  }

  void _showLeaderboard() => AppLogger.info('Show gaming leaderboard');
}
