import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/screens/platforms/solana_screen.dart';
import 'package:rechain_vc_lab/screens/platforms/polkadot_screen.dart';
import 'package:rechain_vc_lab/screens/platforms/ethereum_screen.dart';
import 'package:rechain_vc_lab/screens/platforms/cardano_screen.dart';

class BlockchainPlatformsScreen extends StatelessWidget {
  const BlockchainPlatformsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Блокчейн платформы'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Изучайте ведущие блокчейн платформы',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Выбирайте платформу и участвуйте в челленджах',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildPlatformsList(context),
            const SizedBox(height: 32),
            _buildPlatformStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformsList(BuildContext context) {
    final platforms = [
      _PlatformData('Solana', 7, 266103, const Color(0xFF14F195), 'Высокопроизводительный блокчейн', Icons.flash_on, const SolanaScreen()),
      _PlatformData('Polkadot', 49, 97103, const Color(0xFFE6007A), 'Мультичейн экосистема', Icons.network_check, const PolkadotScreen()),
      _PlatformData('Ethereum', 67, 150000, const Color(0xFF627EEA), 'Мировая компьютерная платформа', Icons.currency_bitcoin, const EthereumScreen()),
      _PlatformData('Cardano', 34, 75000, const Color(0xFF0033CC), 'Научно обоснованный блокчейн', Icons.hexagon_outlined, const CardanoScreen()),
      _PlatformData('Cosmos', 28, 45000, const Color(0xFF2E3148), 'Интернет блокчейнов', Icons.public, null),
      _PlatformData('ImmutableX', 5, 30091, const Color(0xFF6366F1), 'Слой 2 для NFT', Icons.image, null),
      _PlatformData('Soroban', 6, 22103, const Color(0xFF7B3FE4), 'Смарт-контракты Stellar', Icons.star_outline, null),
      _PlatformData('VeChain', 6, 178991, const Color(0xFF00D4AA), 'Блокчейн для поставок', Icons.inventory_2_outlined, null),
      _PlatformData('Stacks', 6, 99102, const Color(0xFF5546FF), 'Смарт-контракты Bitcoin', Icons.currency_bitcoin, null),
      _PlatformData('Tezos', 3, 5437, const Color(0xFF2C7DF7), 'Самообновляющийся блокчейн', Icons.auto_fix_high, null),
      _PlatformData('Polygon', 2, 6759, const Color(0xFF8247E5), 'Масштабирование Ethereum', Icons.layers_outlined, null),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: platforms.length,
      itemBuilder: (ctx, index) => _buildPlatformCard(ctx, platforms[index]).animate().fadeIn(delay: Duration(milliseconds: index * 50)).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  Widget _buildPlatformCard(BuildContext context, _PlatformData platform) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: platform.route != null ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => platform.route!)) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [platform.color.withOpacity(0.15), platform.color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: platform.color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: Icon(platform.icon, color: platform.color, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(platform.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 12),
              Text(platform.description, style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Row(
                children: [
                  Expanded(child: _buildStatItem('${platform.challenges}', 'Челленджей', platform.color)),
                  Expanded(child: _buildStatItem(_formatNumber(platform.builders), 'Разработчиков', platform.color)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: platform.route != null ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => platform.route!)) : null,
                  style: ElevatedButton.styleFrom(backgroundColor: platform.color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text(platform.route != null ? 'Челленджи' : 'Скоро', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)), Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600]))],
    );
  }

  Widget _buildPlatformStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Общая статистика', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _buildTotalStatItem('185', 'Челленджей', Icons.emoji_events, AppTheme.primaryColor)),
            Expanded(child: _buildTotalStatItem('1M+', 'Разработчиков', Icons.people, AppTheme.secondaryColor)),
            Expanded(child: _buildTotalStatItem('11', 'Платформ', Icons.block, AppTheme.accentColor)),
          ]),
        ]),
      ),
    );
  }

  Widget _buildTotalStatItem(String value, String label, IconData icon, Color color) {
    return Column(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
    ]);
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(0)}K';
    return number.toString();
  }
}

class _PlatformData {
  final String name;
  final int challenges;
  final int builders;
  final Color color;
  final String description;
  final IconData icon;
  final Widget? route;
  const _PlatformData(this.name, this.challenges, this.builders, this.color, this.description, this.icon, this.route);
}

