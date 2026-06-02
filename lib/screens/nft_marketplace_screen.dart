import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// NFT Marketplace — покупка, продажа, аукционы NFT
class NFTMarketplaceScreen extends StatefulWidget {
  const NFTMarketplaceScreen({super.key});

  @override
  State<NFTMarketplaceScreen> createState() => _NFTMarketplaceScreenState();
}

class _NFTMarketplaceScreenState extends State<NFTMarketplaceScreen> {
  String _selectedCategory = 'all';
  String _sortBy = 'featured';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _nftCollections = [
    {
      'id': '1',
      'name': 'Bored Ape Yacht Club',
      'floor': 28.5,
      'volume24h': 1250.5,
      'volumeTotal': 658000,
      'items': 10000,
      'owners': 6400,
      'creator': 'Yuga Labs',
      'royalty': 2.5,
      'description': 'Коллекция из 10,000 уникальных Bored Ape NFT',
      'image': '🐵',
      'color': Colors.orange,
      'verified': true,
    },
    {
      'id': '2',
      'name': 'CryptoPunks',
      'floor': 45.2,
      'volume24h': 890.3,
      'volumeTotal': 920000,
      'items': 10000,
      'owners': 3500,
      'creator': 'Larva Labs',
      'royalty': 0,
      'description': 'Оригинальные 10,000 пиксельных панков',
      'image': '👽',
      'color': Colors.purple,
      'verified': true,
    },
    {
      'id': '3',
      'name': 'Azuki',
      'floor': 12.8,
      'volume24h': 567.2,
      'volumeTotal': 285000,
      'items': 10000,
      'owners': 5200,
      'creator': 'Chiru Labs',
      'royalty': 5.0,
      'description': 'Аниме-инспирированная NFT коллекция',
      'image': '🎭',
      'color': Colors.red,
      'verified': true,
    },
    {
      'id': '4',
      'name': 'Doodles',
      'floor': 5.6,
      'volume24h': 234.8,
      'volumeTotal': 125000,
      'items': 10000,
      'owners': 4800,
      'creator': 'Doodles LLC',
      'royalty': 5.0,
      'description': 'Яркие и красочные персонажи',
      'image': '🎨',
      'color': Colors.pink,
      'verified': true,
    },
  ];

  final List<Map<String, dynamic>> _liveAuctions = [
    {
      'id': 'a1',
      'name': 'Bored Ape #7234',
      'collection': 'BAYC',
      'currentBid': 32.5,
      'buyNow': 38.0,
      'bids': 12,
      'endTime': DateTime.now().add(const Duration(hours: 2, minutes: 30)),
      'image': '🐵',
      'color': Colors.orange,
    },
    {
      'id': 'a2',
      'name': 'CryptoPunk #4156',
      'collection': 'CryptoPunks',
      'currentBid': 48.2,
      'buyNow': 52.0,
      'bids': 24,
      'endTime': DateTime.now().add(const Duration(minutes: 45)),
      'image': '👽',
      'color': Colors.purple,
    },
    {
      'id': 'a3',
      'name': 'Azuki #9876',
      'collection': 'Azuki',
      'currentBid': 14.5,
      'buyNow': 16.0,
      'bids': 8,
      'endTime': DateTime.now().add(const Duration(hours: 5)),
      'image': '🎭',
      'color': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> _recentSales = [
    {'id': 's1', 'name': 'Bored Ape #1234', 'price': 29.5, 'image': '🐵'},
    {'id': 's2', 'name': 'Azuki #5678', 'price': 13.2, 'image': '🎭'},
    {'id': 's3', 'name': 'Doodle #9012', 'price': 5.8, 'image': '🎨'},
    {'id': 's4', 'name': 'Punk #3456', 'price': 46.0, 'image': '👽'},
    {'id': 's5', 'name': 'Bored Ape #7890', 'price': 30.1, 'image': '🐵'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFT Маркетплейс'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchNFT,
            tooltip: 'Поиск',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Фильтр',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Market Stats
          SliverToBoxAdapter(
            child: _buildMarketStats(),
          ),

          // Category Filter
          SliverToBoxAdapter(
            child: _buildCategoryFilter(),
          ),

          // Live Auctions
          SliverToBoxAdapter(
            child: _buildSectionHeader('🔥 Горячие аукционы', 'live'),
          ),
          SliverToBoxAdapter(
            child: _buildLiveAuctions(),
          ),

          // Featured Collections
          SliverToBoxAdapter(
            child: _buildSectionHeader('⭐ Топ коллекции', 'collections'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _buildCollectionsGrid(),
          ),

          // Recent Sales
          SliverToBoxAdapter(
            child: _buildSectionHeader('📈 Последние продажи', 'sales'),
          ),
          SliverToBoxAdapter(
            child: _buildRecentSales(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'create',
            onPressed: _createNFT,
            backgroundColor: AppTheme.accentColor,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: 'buy',
            onPressed: _buyNFT,
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
    );
  }

  // Market Stats
  Widget _buildMarketStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.accentColor,
          ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NFT Рынок',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Статистика рынка',
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
                child: _buildMarketStat(
                  'Объём 24h',
                  '2.4K ETH',
                  Icons.trending_up,
                  '+12.5%',
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildMarketStat(
                  'Продажи',
                  '1,234',
                  Icons.shopping_bag,
                  '+8.2%',
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildMarketStat(
                  'Активные',
                  '45.6K',
                  Icons.people,
                  '+5.1%',
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMarketStat(String label, String value, IconData icon, String change) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            change,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Category Filter
  Widget _buildCategoryFilter() {
    final categories = [
      {'id': 'all', 'label': 'Все', 'icon': Icons.view_agenda},
      {'id': 'art', 'label': 'Искусство', 'icon': Icons.palette},
      {'id': 'collectibles', 'label': 'Коллекции', 'icon': Icons.star},
      {'id': 'gaming', 'label': 'Игры', 'icon': Icons.sports_esports},
      {'id': 'metaverse', 'label': 'Метавселенная', 'icon': Icons.public},
      {'id': 'music', 'label': 'Музыка', 'icon': Icons.music_note},
      {'id': 'photography', 'label': 'Фото', 'icon': Icons.photo_camera},
    ];

    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: Icon(category['icon'] as IconData, size: 18),
              label: Text(category['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category['id'] as String);
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title, String section) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () => _viewAll(section),
            child: const Text('Все'),
          ),
        ],
      ),
    );
  }

  // Live Auctions
  Widget _buildLiveAuctions() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _liveAuctions.length,
        itemBuilder: (context, index) {
          return _buildAuctionCard(_liveAuctions[index], index);
        },
      ),
    );
  }

  Widget _buildAuctionCard(Map<String, dynamic> auction, int index) {
    final timeLeft = _formatTimeLeft(auction['endTime'] as DateTime);
    
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (auction['color'] as Color).withOpacity(0.3),
                      (auction['color'] as Color).withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    auction['image'] as String,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auction['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auction['collection'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Текущая',
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          ),
                          Text(
                            '${auction['currentBid']} ETH',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Купить',
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          ),
                          Text(
                            '${auction['buyNow']} ETH',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Timer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, size: 12, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          timeLeft,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 100))
      .scale(begin: const Offset(0.95, 0.95));
  }

  // Collections Grid
  Widget _buildCollectionsGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildCollectionCard(_nftCollections[index], index),
        childCount: _nftCollections.length,
      ),
    );
  }

  Widget _buildCollectionCard(Map<String, dynamic> collection, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (collection['color'] as Color).withOpacity(0.3),
                    (collection['color'] as Color).withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      collection['image'] as String,
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                  if (collection['verified'] as bool)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified, size: 14, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCollectionStat('Floor', '${collection['floor']} ETH'),
                    _buildCollectionStat('24h', '+${collection['volume24h']}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${collection['items']} items',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    Text(
                      '${collection['owners']} owners',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildCollectionStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Recent Sales
  Widget _buildRecentSales() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _recentSales.length,
        itemBuilder: (context, index) {
          return _buildRecentSaleCard(_recentSales[index], index);
        },
      ),
    );
  }

  Widget _buildRecentSaleCard(Map<String, dynamic> sale, int index) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    sale['image'] as String,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale['name'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${sale['price']} ETH',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50));
  }

  String _formatTimeLeft(DateTime endTime) {
    final diff = endTime.difference(DateTime.now());
    if (diff.inMinutes < 1) return '< 1 мин';
    if (diff.inMinutes < 60) return '${diff.inMinutes}м';
    if (diff.inHours < 24) return '${diff.inHours}ч ${diff.inMinutes % 60}м';
    return '${diff.inDays}д ${diff.inHours % 24}ч';
  }

  // Actions
  void _searchNFT() {
    AppLogger.info('Search NFT');
  }

  void _showFilterDialog() {
    AppLogger.info('Show NFT filter');
  }

  void _viewAll(String section) {
    AppLogger.info('View all: $section');
  }

  void _createNFT() {
    AppLogger.info('Create NFT');
  }

  void _buyNFT() {
    AppLogger.info('Buy NFT');
  }
}
