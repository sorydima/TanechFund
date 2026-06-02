import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Web3 Identity — децентрализованная идентификация (DID)
class Web3IdentityScreen extends StatefulWidget {
  const Web3IdentityScreen({super.key});

  @override
  State<Web3IdentityScreen> createState() => _Web3IdentityScreenState();
}

class _Web3IdentityScreenState extends State<Web3IdentityScreen> {
  final Map<String, dynamic> _identity = {
    'did': 'did:eth:0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
    'ens': 'user.eth',
    'reputation': 875,
    'verified': true,
    'badges': [
      {'name': 'Early Adopter', 'icon': '🎯', 'date': '2023-01'},
      {'name': 'DeFi Expert', 'icon': '💰', 'date': '2023-06'},
      {'name': 'NFT Collector', 'icon': '🎨', 'date': '2023-09'},
      {'name': 'DAO Member', 'icon': '🏛️', 'date': '2023-12'},
    ],
    'connections': 145,
    'transactions': 2847,
  };

  final List<Map<String, dynamic>> _credentials = [
    {'id': '1', 'issuer': 'Uniswap', 'type': 'LP Provider', 'issued': '2024-01-15', 'verified': true, 'icon': '🦄'},
    {'id': '2', 'issuer': 'Aave', 'type': 'Borrower', 'issued': '2024-02-20', 'verified': true, 'icon': '👻'},
    {'id': '3', 'issuer': 'OpenSea', 'type': 'Trader', 'issued': '2024-03-10', 'verified': true, 'icon': '🌊'},
    {'id': '4', 'issuer': 'Gitcoin', 'type': 'Contributor', 'issued': '2024-04-05', 'verified': false, 'icon': '🐙'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web3 Identity'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: _editIdentity, tooltip: 'Редактировать')],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildIdentityCard()),
          SliverToBoxAdapter(child: _buildStats()),
          SliverToBoxAdapter(child: _buildSectionHeader('Бейджи', Icons.emoji_events)),
          SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildBadgesGrid()),
          SliverToBoxAdapter(child: _buildSectionHeader('Верификации', Icons.verified)),
          SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildCredentialsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _verifyIdentity, icon: const Icon(Icons.verified_user), label: const Text('Верифицировать'), backgroundColor: AppTheme.primaryColor),
    );
  }

  Widget _buildIdentityCard() {
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
            CircleAvatar(radius: 35, backgroundColor: Colors.white, child: Text(_identity['ens'][0].toUpperCase(), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(_identity['ens'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                if (_identity['verified'] as bool) const Padding(padding: EdgeInsets.only(left: 6), child: Icon(Icons.verified, color: Colors.white, size: 20)),
              ]),
              const SizedBox(height: 4),
              Text(_identity['did'], style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11), overflow: TextOverflow.ellipsis),
            ])),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _buildIdentityStat('Репутация', '${_identity['reputation']}', Icons.star)),
            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
            Expanded(child: _buildIdentityStat('Связи', '${_identity['connections']}', Icons.people)),
            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
            Expanded(child: _buildIdentityStat('TXs', '${_identity['transactions']}', Icons.swap_horiz)),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildIdentityStat(String label, String value, IconData icon) {
    return Column(children: [
      Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
    ]);
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _buildStatItem('Бейджи', '${_identity['badges'].length}', Icons.emoji_events),
        Container(width: 1, height: 30, color: Colors.grey[300]),
        _buildStatItem('Верификации', '${_credentials.where((c) => c['verified'] as bool).length}/${_credentials.length}', Icons.check_circle),
        Container(width: 1, height: 30, color: Colors.grey[300]),
        _buildStatItem('Аккаунтов', '8', Icons.account_balance),
      ]),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(children: [Icon(icon, size: 20, color: AppTheme.primaryColor), const SizedBox(height: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600]))]);
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 24, 16, 12), child: Row(children: [Icon(icon, size: 18, color: AppTheme.primaryColor), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]));
  }

  Widget _buildBadgesGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
      delegate: SliverChildBuilderDelegate((context, index) => _buildBadgeCard((_identity['badges'] as List)[index], index), childCount: (_identity['badges'] as List).length),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(badge['icon'] as String, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(badge['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(badge['date'] as String, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ])),
        ]),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
  }

  Widget _buildCredentialsList() {
    return SliverList(delegate: SliverChildBuilderDelegate((context, index) => _buildCredentialCard(_credentials[index], index), childCount: _credentials.length));
  }

  Widget _buildCredentialCard(Map<String, dynamic> credential, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: Text(credential['icon'] as String, style: const TextStyle(fontSize: 20))),
        title: Text(credential['type'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${credential['issuer']} • ${credential['issued']}'),
        trailing: credential['verified'] as bool ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.pending, color: Colors.orange),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
  }

  void _editIdentity() => AppLogger.info('Edit identity');
  void _verifyIdentity() {
    AppLogger.info('Verify identity');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Запуск верификации...'), backgroundColor: AppTheme.primaryColor, behavior: SnackBarBehavior.floating));
  }
}
