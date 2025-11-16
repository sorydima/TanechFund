import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/screens/platforms/solana_screen.dart';
import 'package:rechain_vc_lab/screens/platforms/polkadot_screen.dart';
import 'package:rechain_vc_lab/screens/platforms/ethereum_screen.dart';
import 'package:rechain_vc_lab/screens/platforms/cardano_screen.dart';
import 'package:rechain_vc_lab/screens/platforms/cosmos_screen.dart';

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
            // Заголовок
            Text(
              'Изучайте ведущие блокчейн платформы',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Выбирайте платформу и участвуйте в челленджах для получения практического опыта',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Список платформ
            _buildPlatformsList(),
            
            const SizedBox(height: 32),
            
            // Статистика
            _buildPlatformStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformsList() {
    final platforms = [
      {
        'name': 'Solana',
        'challenges': 7,
        'builders': 266103,
        'color': const Color(0xFF14F195),
        'description': 'Высокопроизводительный блокчейн для DeFi и NFT',
        'icon': Icons.flash_on,
        'route': SolanaScreen(),
      },
      {
        'name': 'Polkadot',
        'challenges': 49,
        'builders': 97103,
        'color': const Color(0xFFE6007A),
        'description': 'Мультичейн экосистема для Web3',
        'icon': Icons.polygon,
        'route': PolkadotScreen(),
      },
      {
        'name': 'Ethereum',
        'challenges': 67,
        'builders': 150000,
        'color': const Color(0xFF627EEA),
        'description': 'Мировая компьютерная платформа',
        'icon': Icons.currency_bitcoin,
        'route': EthereumScreen(),
      },
      {
        'name': 'Cardano',
        'challenges': 34,
        'builders': 75000,
        'color': const Color(0xFF0033CC),
        'description': 'Научно обоснованная блокчейн платформа',
        'icon': Icons.hexagon,
        'route': CardanoScreen(),
      },
      {
        'name': 'Cosmos',
        'challenges': 28,
        'builders': 45000,
        'color': const Color(0xFF2E3148),
        'description': 'Интернет блокчейнов',
        'icon': Icons.public,
        'route': CosmosScreen(),
      },
      {
        'name': 'ImmutableX',
        'challenges': 5,
        'builders': 30091,
        'color': const Color(0xFF6366F1),
        'description': 'Слой 2 для NFT на Ethereum',
        'icon': Icons.image,
        'route': null,
      },
      {
        'name': 'Soroban',
        'challenges': 6,
        'builders': 22103,
        'color': const Color(0xFF7B3FE4),
        'description': 'Смарт-контракты для Stellar',
        'icon': Icons.star,
        'route': null,
      },
      {
        'name': 'VeChain',
        'challenges': 6,
        'builders': 178991,
        'color': const Color(0xFF00D4AA),
        'description': 'Блокчейн для цепочек поставок',
        'icon': Icons.inventory,
        'route': null,
      },
      {
        'name': 'Stacks',
        'challenges': 6,
        'builders': 99102,
        'color': const Color(0xFF5546FF),
        'description': 'Смарт-контракты для Bitcoin',
        'icon': Icons.currency_bitcoin,
        'route': null,
      },
      {
        'name': 'Tezos',
        'challenges': 3,
        'builders': 5437,
        'color': const Color(0xFF2C7DF7),
        'description': 'Самообновляющийся блокчейн',
        'icon': Icons.auto_fix_high,
        'route': null,
      },
      {
        'name': 'Polygon',
        'challenges': 2,
        'builders': 6759,
        'color': const Color(0xFF8247E5),
        'description': 'Масштабируемое решение для Ethereum',
        'icon': Icons.polygon,
        'route': null,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: platforms.length,
      itemBuilder: (context, index) {
        final platform = platforms[index];
        return _buildPlatformCard(
          platform['name'] as String,
          platform['challenges'] as int,
          platform['builders'] as int,
          platform['color'] as Color,
          platform['description'] as String,
          platform['icon'] as IconData,
          platform['route'] as Widget?,
        );
      },
    );
  }

  Widget _buildPlatformCard(
    String name,
    int challenges,
    int builders,
    Color color,
    String description,
    IconData icon,
    Widget? route,
  ) {
    return Builder(
      builder: (context) => Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (route != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route!),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
          child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок и иконка
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Описание
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              
              const Spacer(),
              
              // Статистика
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      '$challenges',
                      'Челленджей',
                      color,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      _formatNumber(builders),
                      'Разработчиков',
                      color,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Кнопка
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (route != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => route!),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    route != null ? 'Смотреть челленджи' : 'Скоро',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: 0.8, duration: 300.ms);
      },
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Общая статистика платформ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTotalStatItem(
                    '185',
                    'Всего челленджей',
                    Icons.emoji_events,
                    AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildTotalStatItem(
                    '1M+',
                    'Разработчиков',
                    Icons.people,
                    AppTheme.secondaryColor,
                  ),
                ),
                Expanded(
                  child: _buildTotalStatItem(
                    '11',
                    'Платформ',
                    Icons.block,
                    AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
