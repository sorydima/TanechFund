import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/nft_marketplace_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:intl/intl.dart';

class NFTMarketplaceScreen extends StatefulWidget {
  const NFTMarketplaceScreen({super.key});

  @override
  State<NFTMarketplaceScreen> createState() => _NFTMarketplaceScreenState();
}

class _NFTMarketplaceScreenState extends State<NFTMarketplaceScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NFTMarketplaceProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'NFT Marketplace',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Поиск по NFT и коллекциям...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Коллекции', icon: Icon(Icons.collections)),
                  Tab(text: 'NFT', icon: Icon(Icons.image)),
                  Tab(text: 'Торговля', icon: Icon(Icons.shopping_cart)),
                  Tab(text: 'Аукционы', icon: Icon(Icons.gavel)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCollectionsTab(),
                  _buildNFTsTab(),
                  _buildMarketplaceTab(),
                  _buildAuctionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateNFTDialog();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCollectionsTab() {
    return Consumer<NFTMarketplaceProvider>(
      builder: (context, provider, child) {
        final collections = provider.searchCollections(_searchController.text);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final collection = collections[index];
            return _buildCollectionCard(collection, provider);
          },
        );
      },
    );
  }

  Widget _buildCollectionCard(NFTCollection collection, NFTMarketplaceProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner image
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(collection.bannerUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Collection avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: NetworkImage(collection.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                collection.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (collection.isVerified)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            collection.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Floor Price',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${collection.floorPrice} ETH',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Объем',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${(collection.totalVolume / 1000).toStringAsFixed(1)}K ETH',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NFT',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${collection.mintedCount}/${collection.totalSupply}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: collection.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      labelStyle: TextStyle(color: AppTheme.primaryColor),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Создана: ${DateFormat('dd.MM.yyyy').format(collection.createdAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showCollectionDetails(collection);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Просмотр'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _showCreateNFTDialog(collectionId: collection.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Создать NFT'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNFTsTab() {
    return Consumer<NFTMarketplaceProvider>(
      builder: (context, provider, child) {
        final nfts = provider.searchNFTs(_searchController.text);
        
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: nfts.length,
          itemBuilder: (context, index) {
            final nft = nfts[index];
            return _buildNFTCard(nft, provider);
          },
        );
      },
    );
  }

  Widget _buildNFTCard(NFT nft, NFTMarketplaceProvider provider) {
    final collection = provider.collections.firstWhere(
      (c) => c.id == nft.collectionId,
      orElse: () => NFTCollection(
        id: '',
        name: 'Unknown',
        description: '',
        imageUrl: '',
        bannerUrl: '',
        creatorAddress: '',
        blockchain: '',
        contractAddress: '',
        totalSupply: 0,
        mintedCount: 0,
        floorPrice: 0.0,
        totalVolume: 0.0,
        metadata: {},
        createdAt: DateTime.now(),
        isVerified: false,
        category: '',
        tags: [],
      ),
    );

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NFT Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(nft.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nft.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  collection.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getNFTStatusColor(nft.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getNFTStatusText(nft.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (nft.listingPrice != null)
                      Text(
                        '${nft.listingPrice} ETH',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.favorite, size: 16, color: Colors.red[400]),
                    const SizedBox(width: 4),
                    Text(
                      nft.likes.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      nft.views.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketplaceTab() {
    return Consumer<NFTMarketplaceProvider>(
      builder: (context, provider, child) {
        final listings = provider.getActiveListings();
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final listing = listings[index];
            final nft = provider.nfts.firstWhere(
              (n) => n.id == listing.nftId,
              orElse: () => NFT(
                id: '',
                name: 'Unknown',
                description: '',
                imageUrl: '',
                collectionId: '',
                ownerAddress: '',
                creatorAddress: '',
                blockchain: '',
                tokenId: '',
                contractAddress: '',
                attributes: {},
                metadata: {},
                createdAt: DateTime.now(),
                status: '',
                tags: [],
                likes: 0,
                views: 0,
              ),
            );
            
            return _buildListingCard(listing, nft, provider);
          },
        );
      },
    );
  }

  Widget _buildListingCard(NFTListing listing, NFT nft, NFTMarketplaceProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // NFT Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(nft.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nft.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Продавец: ${listing.sellerAddress.substring(0, 8)}...${listing.sellerAddress.substring(listing.sellerAddress.length - 6)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Цена: ',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${listing.price} ${listing.currency}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Выставлен: ${DateFormat('dd.MM.yyyy').format(listing.listedAt)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showBuyNFTDialog(listing, nft, provider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Купить'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    _showNFTDetails(nft);
                  },
                  child: const Text('Детали'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionsTab() {
    return Consumer<NFTMarketplaceProvider>(
      builder: (context, provider, child) {
        final auctions = provider.auctions;
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: auctions.length,
          itemBuilder: (context, index) {
            final auction = auctions[index];
            final nft = provider.nfts.firstWhere(
              (n) => n.id == auction.nftId,
              orElse: () => NFT(
                id: '',
                name: 'Unknown',
                description: '',
                imageUrl: '',
                collectionId: '',
                ownerAddress: '',
                creatorAddress: '',
                blockchain: '',
                tokenId: '',
                contractAddress: '',
                attributes: {},
                metadata: {},
                createdAt: DateTime.now(),
                status: '',
                tags: [],
                likes: 0,
                views: 0,
              ),
            );
            
            return _buildAuctionCard(auction, nft, provider);
          },
        );
      },
    );
  }

  Widget _buildAuctionCard(NFTAuction auction, NFT nft, NFTMarketplaceProvider provider) {
    final isActive = auction.status == 'active';
    final isUpcoming = auction.status == 'upcoming';
    final timeLeft = auction.endTime.difference(DateTime.now());
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // NFT Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(nft.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nft.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Продавец: ${auction.sellerAddress.substring(0, 8)}...${auction.sellerAddress.substring(auction.sellerAddress.length - 6)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Стартовая цена: ',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${auction.startingPrice} ${auction.currency}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      if (auction.winningBid != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Текущая ставка: ',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              '${auction.winningBid} ${auction.currency}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Status and time
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getAuctionStatusColor(auction.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getAuctionStatusText(auction.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                if (isActive || isUpcoming)
                  Text(
                    isActive 
                        ? 'Осталось: ${timeLeft.inDays}d ${timeLeft.inHours % 24}h'
                        : 'Начинается: ${auction.startTime.difference(DateTime.now()).inDays}d ${auction.startTime.difference(DateTime.now()).inHours % 24}h',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Actions
            Row(
              children: [
                if (isActive)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showPlaceBidDialog(auction, provider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Сделать ставку'),
                    ),
                  ),
                if (isUpcoming)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Ожидание'),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _showAuctionDetails(auction, nft);
                    },
                    child: const Text('Детали аукциона'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getNFTStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'owned':
        return Colors.blue;
      case 'listed':
        return Colors.green;
      case 'auctioned':
        return Colors.orange;
      case 'sold':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getNFTStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'owned':
        return 'Владею';
      case 'listed':
        return 'Продается';
      case 'auctioned':
        return 'Аукцион';
      case 'sold':
        return 'Продано';
      default:
        return status;
    }
  }

  Color _getAuctionStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'ended':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getAuctionStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return 'Скоро';
      case 'active':
        return 'Активен';
      case 'ended':
        return 'Завершен';
      case 'cancelled':
        return 'Отменен';
      default:
        return status;
    }
  }

  // Dialog methods
  void _showCreateNFTDialog({String? collectionId}) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageUrlController = TextEditingController();
    String selectedCollectionId = collectionId ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать NFT'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название NFT',
                  hintText: 'Введите название...',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Введите описание...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL изображения',
                  hintText: 'https://example.com/image.jpg',
                ),
              ),
              const SizedBox(height: 16),
              Consumer<NFTMarketplaceProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<String>(
                    value: selectedCollectionId.isNotEmpty ? selectedCollectionId : null,
                    decoration: const InputDecoration(
                      labelText: 'Коллекция',
                    ),
                    items: provider.collections.map((collection) {
                      return DropdownMenuItem(
                        value: collection.id,
                        child: Text(collection.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedCollectionId = value!;
                    },
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  descriptionController.text.isNotEmpty && 
                  imageUrlController.text.isNotEmpty &&
                  selectedCollectionId.isNotEmpty) {
                context.read<NFTMarketplaceProvider>().createNFT(
                  name: nameController.text,
                  description: descriptionController.text,
                  imageUrl: imageUrlController.text,
                  collectionId: selectedCollectionId,
                  ownerAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
                  creatorAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
                  blockchain: 'ethereum',
                  contractAddress: '0x1234567890123456789012345678901234567890',
                  attributes: {
                    'rarity': 'common',
                    'background': 'white',
                  },
                  metadata: {
                    'external_url': 'https://rechain.com/nft',
                  },
                  tags: ['new', 'art'],
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showCollectionDetails(NFTCollection collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Коллекция: ${collection.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Описание: ${collection.description}'),
              Text('Создатель: ${collection.creatorAddress}'),
              Text('Блокчейн: ${collection.blockchain}'),
              Text('Контракт: ${collection.contractAddress}'),
              Text('Категория: ${collection.category}'),
              Text('Floor Price: ${collection.floorPrice} ETH'),
              Text('Общий объем: ${collection.totalVolume} ETH'),
              Text('NFT: ${collection.mintedCount}/${collection.totalSupply}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showNFTDetails(NFT nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('NFT: ${nft.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Описание: ${nft.description}'),
              Text('Владелец: ${nft.ownerAddress}'),
              Text('Создатель: ${nft.creatorAddress}'),
              Text('Блокчейн: ${nft.blockchain}'),
              Text('Token ID: ${nft.tokenId}'),
              Text('Статус: ${_getNFTStatusText(nft.status)}'),
              if (nft.listingPrice != null)
                Text('Цена: ${nft.listingPrice} ETH'),
              Text('Лайки: ${nft.likes}'),
              Text('Просмотры: ${nft.views}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showBuyNFTDialog(NFTListing listing, NFT nft, NFTMarketplaceProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Купить NFT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Вы уверены, что хотите купить "${nft.name}"?'),
            const SizedBox(height: 16),
            Text(
              'Цена: ${listing.price} ${listing.currency}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.buyNFT(listing.id, '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6');
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Купить'),
          ),
        ],
      ),
    );
  }

  void _showPlaceBidDialog(NFTAuction auction, NFTMarketplaceProvider provider) {
    final bidController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сделать ставку'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Текущая ставка: ${auction.winningBid ?? auction.startingPrice} ${auction.currency}'),
            const SizedBox(height: 16),
            TextField(
              controller: bidController,
              decoration: const InputDecoration(
                labelText: 'Ваша ставка',
                hintText: 'Введите сумму...',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (bidController.text.isNotEmpty) {
                final bid = double.tryParse(bidController.text);
                if (bid != null && bid > (auction.winningBid ?? auction.startingPrice)) {
                  provider.placeBid(auction.id, '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6', bid);
                  Navigator.of(context).pop();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Сделать ставку'),
          ),
        ],
      ),
    );
  }

  void _showAuctionDetails(NFTAuction auction, NFT nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Детали аукциона'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NFT: ${nft.name}'),
              Text('Продавец: ${auction.sellerAddress}'),
              Text('Стартовая цена: ${auction.startingPrice} ${auction.currency}'),
              if (auction.reservePrice != null)
                Text('Резервная цена: ${auction.reservePrice} ${auction.currency}'),
              Text('Начало: ${DateFormat('dd.MM.yyyy HH:mm').format(auction.startTime)}'),
              Text('Конец: ${DateFormat('dd.MM.yyyy HH:mm').format(auction.endTime)}'),
              Text('Статус: ${_getAuctionStatusText(auction.status)}'),
              if (auction.bids.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Ставки:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...auction.bids.map((bid) => Text(
                  '${bid.bidderAddress.substring(0, 8)}... - ${bid.amount} ${auction.currency} (${bid.status})',
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}
