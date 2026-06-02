import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Hardware Wallet — управление аппаратными кошельками
class HardwareWalletScreen extends StatefulWidget {
  const HardwareWalletScreen({super.key});

  @override
  State<HardwareWalletScreen> createState() => _HardwareWalletScreenState();
}

class _HardwareWalletScreenState extends State<HardwareWalletScreen> {
  final List<Map<String, dynamic>> _wallets = [
    {
      'id': '1',
      'name': 'Ledger Nano X',
      'type': 'hardware',
      'connected': true,
      'balance': 15420.50,
      'assets': ['BTC', 'ETH', 'SOL', 'USDC'],
      'firmware': '2.2.1',
      'battery': 85,
      'image': '🔐',
      'color': Colors.blue,
    },
    {
      'id': '2',
      'name': 'Trezor Model T',
      'type': 'hardware',
      'connected': false,
      'balance': 8750.25,
      'assets': ['BTC', 'ETH', 'ADA'],
      'firmware': '2.6.3',
      'battery': null,
      'image': '🛡️',
      'color': Colors.orange,
    },
    {
      'id': '3',
      'name': 'Ledger Nano S Plus',
      'type': 'hardware',
      'connected': true,
      'balance': 5230.80,
      'assets': ['ETH', 'USDT', 'LINK'],
      'firmware': '2.1.0',
      'battery': null,
      'image': '🔑',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hardware Wallet'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addWallet,
            tooltip: 'Добавить кошелёк',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Stats
          SliverToBoxAdapter(child: _buildStats()),
          // Connected Wallets
          SliverToBoxAdapter(child: _buildSectionHeader('Подключенные', Icons.usb)),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildWalletsList(connected: true),
          ),
          // Other Wallets
          SliverToBoxAdapter(child: _buildSectionHeader('Другие кошельки', Icons.wallet)),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildWalletsList(connected: false),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final totalBalance = _wallets.fold<double>(0, (sum, w) => sum + (w['balance'] as double));
    final connected = _wallets.where((w) => w['connected'] as bool).length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.accentColor]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.security, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Text('Аппаратные кошельки', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatItem('Баланс', '\$${totalBalance.toStringAsFixed(0)}', Icons.account_balance_wallet)),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(child: _buildStatItem('Подключено', '$connected', Icons.usb)),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(child: _buildStatItem('Всего', '${_wallets.length}', Icons.devices)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(children: [
      Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
    ]);
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildWalletsList({required bool connected}) {
    final wallets = _wallets.where((w) => w['connected'] == connected).toList();
    if (wallets.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('Нет кошельков', style: TextStyle(color: Colors.grey[400])))),
      );
    }
    return SliverList(delegate: SliverChildBuilderDelegate((context, index) => _buildWalletCard(wallets[index], index), childCount: wallets.length));
  }

  Widget _buildWalletCard(Map<String, dynamic> wallet, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: (wallet['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(wallet['image'] as String, style: const TextStyle(fontSize: 30))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(wallet['name'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        if (wallet['connected'] as bool)
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: const Text('✓', style: TextStyle(color: Colors.green, fontSize: 12))),
                      ]),
                      const SizedBox(height: 4),
                      Text('Firmware: ${wallet['firmware']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('\$${(wallet['balance'] as double).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (wallet['battery'] != null)
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.battery_std, size: 14, color: (wallet['battery'] as int) > 50 ? Colors.green : Colors.orange),
                      const SizedBox(width: 4),
                      Text('${wallet['battery']}%', style: const TextStyle(fontSize: 11)),
                    ]),
                ]),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (wallet['assets'] as List).map((asset) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                child: Text(asset as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              )).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (wallet['connected'] as bool) ...[
                  Expanded(child: OutlinedButton.icon(onPressed: () => _disconnectWallet(wallet), icon: const Icon(Icons.usb_off, size: 18), label: const Text('Отключить'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)))),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton.icon(onPressed: () => _viewWallet(wallet), icon: const Icon(Icons.visibility, size: 18), label: const Text('Обзор'), style: ElevatedButton.styleFrom(backgroundColor: wallet['color'], padding: const EdgeInsets.symmetric(vertical: 10)))),
                ] else
                  Expanded(child: ElevatedButton.icon(onPressed: () => _connectWallet(wallet), icon: const Icon(Icons.usb, size: 18), label: const Text('Подключить'), style: ElevatedButton.styleFrom(backgroundColor: wallet['color'], padding: const EdgeInsets.symmetric(vertical: 12)))),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideX(begin: 0.2, end: 0);
  }

  void _addWallet() => AppLogger.info('Add hardware wallet');
  void _connectWallet(Map<String, dynamic> w) {
    setState(() => w['connected'] = true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${w['name']} подключен'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
  }
  void _disconnectWallet(Map<String, dynamic> w) {
    setState(() => w['connected'] = false);
  }
  void _viewWallet(Map<String, dynamic> w) => AppLogger.info('View wallet: ${w['name']}');
}
