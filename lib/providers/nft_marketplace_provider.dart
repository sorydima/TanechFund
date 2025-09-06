import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// NFT Model
class NFT {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String collectionId;
  final String ownerAddress;
  final String creatorAddress;
  final String blockchain;
  final String tokenId;
  final String contractAddress;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? listedAt;
  final double? listingPrice;
  final String status; // 'owned', 'listed', 'auctioned', 'sold'
  final List<String> tags;
  final int likes;
  final int views;

  NFT({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.collectionId,
    required this.ownerAddress,
    required this.creatorAddress,
    required this.blockchain,
    required this.tokenId,
    required this.contractAddress,
    required this.attributes,
    required this.metadata,
    required this.createdAt,
    this.listedAt,
    this.listingPrice,
    required this.status,
    required this.tags,
    required this.likes,
    required this.views,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'collectionId': collectionId,
      'ownerAddress': ownerAddress,
      'creatorAddress': creatorAddress,
      'blockchain': blockchain,
      'tokenId': tokenId,
      'contractAddress': contractAddress,
      'attributes': attributes,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'listedAt': listedAt?.toIso8601String(),
      'listingPrice': listingPrice,
      'status': status,
      'tags': tags,
      'likes': likes,
      'views': views,
    };
  }

  factory NFT.fromJson(Map<String, dynamic> json) {
    return NFT(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      collectionId: json['collectionId'],
      ownerAddress: json['ownerAddress'],
      creatorAddress: json['creatorAddress'],
      blockchain: json['blockchain'],
      tokenId: json['tokenId'],
      contractAddress: json['contractAddress'],
      attributes: Map<String, dynamic>.from(json['attributes']),
      metadata: Map<String, dynamic>.from(json['metadata']),
      createdAt: DateTime.parse(json['createdAt']),
      listedAt: json['listedAt'] != null ? DateTime.parse(json['listedAt']) : null,
      listingPrice: json['listingPrice']?.toDouble(),
      status: json['status'],
      tags: List<String>.from(json['tags']),
      likes: json['likes'],
      views: json['views'],
    );
  }

  NFT copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? collectionId,
    String? ownerAddress,
    String? creatorAddress,
    String? blockchain,
    String? tokenId,
    String? contractAddress,
    Map<String, dynamic>? attributes,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? listedAt,
    double? listingPrice,
    String? status,
    List<String>? tags,
    int? likes,
    int? views,
  }) {
    return NFT(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      collectionId: collectionId ?? this.collectionId,
      ownerAddress: ownerAddress ?? this.ownerAddress,
      creatorAddress: creatorAddress ?? this.creatorAddress,
      blockchain: blockchain ?? this.blockchain,
      tokenId: tokenId ?? this.tokenId,
      contractAddress: contractAddress ?? this.contractAddress,
      attributes: attributes ?? this.attributes,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      listedAt: listedAt ?? this.listedAt,
      listingPrice: listingPrice ?? this.listingPrice,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      views: views ?? this.views,
    );
  }
}

// NFT Collection Model
class NFTCollection {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String bannerUrl;
  final String creatorAddress;
  final String blockchain;
  final String contractAddress;
  final int totalSupply;
  final int mintedCount;
  final double floorPrice;
  final double totalVolume;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final bool isVerified;
  final String category; // 'art', 'gaming', 'music', 'photography', 'collectibles'
  final List<String> tags;

  NFTCollection({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.bannerUrl,
    required this.creatorAddress,
    required this.blockchain,
    required this.contractAddress,
    required this.totalSupply,
    required this.mintedCount,
    required this.floorPrice,
    required this.totalVolume,
    required this.metadata,
    required this.createdAt,
    required this.isVerified,
    required this.category,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'creatorAddress': creatorAddress,
      'blockchain': blockchain,
      'contractAddress': contractAddress,
      'totalSupply': totalSupply,
      'mintedCount': mintedCount,
      'floorPrice': floorPrice,
      'totalVolume': totalVolume,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'category': category,
      'tags': tags,
    };
  }

  factory NFTCollection.fromJson(Map<String, dynamic> json) {
    return NFTCollection(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      bannerUrl: json['bannerUrl'],
      creatorAddress: json['creatorAddress'],
      blockchain: json['blockchain'],
      contractAddress: json['contractAddress'],
      totalSupply: json['totalSupply'],
      mintedCount: json['mintedCount'],
      floorPrice: json['floorPrice'].toDouble(),
      totalVolume: json['totalVolume'].toDouble(),
      metadata: Map<String, dynamic>.from(json['metadata']),
      createdAt: DateTime.parse(json['createdAt']),
      isVerified: json['isVerified'],
      category: json['category'],
      tags: List<String>.from(json['tags']),
    );
  }
}

// NFT Listing Model
class NFTListing {
  final String id;
  final String nftId;
  final String sellerAddress;
  final double price;
  final String currency; // 'ETH', 'USDC', 'MATIC', etc.
  final DateTime listedAt;
  final DateTime? expiresAt;
  final String status; // 'active', 'sold', 'cancelled', 'expired'
  final Map<String, dynamic> metadata;

  NFTListing({
    required this.id,
    required this.nftId,
    required this.sellerAddress,
    required this.price,
    required this.currency,
    required this.listedAt,
    this.expiresAt,
    required this.status,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nftId': nftId,
      'sellerAddress': sellerAddress,
      'price': price,
      'currency': currency,
      'listedAt': listedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'status': status,
      'metadata': metadata,
    };
  }

  factory NFTListing.fromJson(Map<String, dynamic> json) {
    return NFTListing(
      id: json['id'],
      nftId: json['nftId'],
      sellerAddress: json['sellerAddress'],
      price: json['price'].toDouble(),
      currency: json['currency'],
      listedAt: DateTime.parse(json['listedAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      status: json['status'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  NFTListing copyWith({
    String? id,
    String? nftId,
    String? sellerAddress,
    double? price,
    String? currency,
    DateTime? listedAt,
    DateTime? expiresAt,
    String? status,
    Map<String, dynamic>? metadata,
  }) {
    return NFTListing(
      id: id ?? this.id,
      nftId: nftId ?? this.nftId,
      sellerAddress: sellerAddress ?? this.sellerAddress,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      listedAt: listedAt ?? this.listedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }
}

// NFT Auction Model
class NFTAuction {
  final String id;
  final String nftId;
  final String sellerAddress;
  final double startingPrice;
  final double? reservePrice;
  final String currency;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'upcoming', 'active', 'ended', 'cancelled'
  final List<AuctionBid> bids;
  double? winningBid;
  String? winnerAddress;

  NFTAuction({
    required this.id,
    required this.nftId,
    required this.sellerAddress,
    required this.startingPrice,
    this.reservePrice,
    required this.currency,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.bids,
    this.winningBid,
    this.winnerAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nftId': nftId,
      'sellerAddress': sellerAddress,
      'startingPrice': startingPrice,
      'reservePrice': reservePrice,
      'currency': currency,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'bids': bids.map((bid) => bid.toJson()).toList(),
      'winningBid': winningBid,
      'winnerAddress': winnerAddress,
    };
  }

  factory NFTAuction.fromJson(Map<String, dynamic> json) {
    return NFTAuction(
      id: json['id'],
      nftId: json['nftId'],
      sellerAddress: json['sellerAddress'],
      startingPrice: json['startingPrice'].toDouble(),
      reservePrice: json['reservePrice']?.toDouble(),
      currency: json['currency'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
      bids: (json['bids'] as List).map((bid) => AuctionBid.fromJson(bid)).toList(),
      winningBid: json['winningBid']?.toDouble(),
      winnerAddress: json['winnerAddress'],
    );
  }
}

// Auction Bid Model
class AuctionBid {
  final String id;
  final String auctionId;
  final String bidderAddress;
  final double amount;
  final DateTime timestamp;
  final String status; // 'active', 'outbid', 'won', 'cancelled'

  AuctionBid({
    required this.id,
    required this.auctionId,
    required this.bidderAddress,
    required this.amount,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auctionId': auctionId,
      'bidderAddress': bidderAddress,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory AuctionBid.fromJson(Map<String, dynamic> json) {
    return AuctionBid(
      id: json['id'],
      auctionId: json['auctionId'],
      bidderAddress: json['bidderAddress'],
      amount: json['amount'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
    );
  }

  AuctionBid copyWith({
    String? id,
    String? auctionId,
    String? bidderAddress,
    double? amount,
    DateTime? timestamp,
    String? status,
  }) {
    return AuctionBid(
      id: id ?? this.id,
      auctionId: auctionId ?? this.auctionId,
      bidderAddress: bidderAddress ?? this.bidderAddress,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

// NFT Marketplace Provider
class NFTMarketplaceProvider extends ChangeNotifier {
  List<NFT> _nfts = [];
  List<NFTCollection> _collections = [];
  List<NFTListing> _listings = [];
  List<NFTAuction> _auctions = [];
  String _currentUserId = 'current_user';

  // Getters
  List<NFT> get nfts => _nfts;
  List<NFTCollection> get collections => _collections;
  List<NFTListing> get listings => _listings;
  List<NFTAuction> get auctions => _auctions;

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_nfts.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final nftsJson = prefs.getStringList('nft_marketplace_nfts') ?? [];
      _nfts = nftsJson
          .map((json) => NFT.fromJson(jsonDecode(json)))
          .toList();

      final collectionsJson = prefs.getStringList('nft_marketplace_collections') ?? [];
      _collections = collectionsJson
          .map((json) => NFTCollection.fromJson(jsonDecode(json)))
          .toList();

      final listingsJson = prefs.getStringList('nft_marketplace_listings') ?? [];
      _listings = listingsJson
          .map((json) => NFTListing.fromJson(jsonDecode(json)))
          .toList();

      final auctionsJson = prefs.getStringList('nft_marketplace_auctions') ?? [];
      _auctions = auctionsJson
          .map((json) => NFTAuction.fromJson(jsonDecode(json)))
          .toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading NFT Marketplace data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setStringList('nft_marketplace_nfts', 
          _nfts.map((nft) => jsonEncode(nft.toJson())).toList());
      
      await prefs.setStringList('nft_marketplace_collections', 
          _collections.map((collection) => jsonEncode(collection.toJson())).toList());
      
      await prefs.setStringList('nft_marketplace_listings', 
          _listings.map((listing) => jsonEncode(listing.toJson())).toList());
      
      await prefs.setStringList('nft_marketplace_auctions', 
          _auctions.map((auction) => jsonEncode(auction.toJson())).toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving NFT Marketplace data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create sample collections
    _collections = [
      NFTCollection(
        id: '1',
        name: 'REChain Genesis Collection',
        description: 'Первая коллекция NFT от REChain VC Lab',
        imageUrl: 'https://via.placeholder.com/300x300/6366f1/ffffff?text=REChain',
        bannerUrl: 'https://via.placeholder.com/1200x300/6366f1/ffffff?text=REChain+Genesis',
        creatorAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        blockchain: 'ethereum',
        contractAddress: '0x1234567890123456789012345678901234567890',
        totalSupply: 1000,
        mintedCount: 150,
        floorPrice: 0.5,
        totalVolume: 250.0,
        metadata: {
          'website': 'https://rechain.com',
          'discord': 'https://discord.gg/rechain',
          'twitter': '@REChainVC',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        isVerified: true,
        category: 'art',
        tags: ['blockchain', 'venture', 'startup', 'innovation'],
      ),
      NFTCollection(
        id: '2',
        name: 'Crypto Punks Clone',
        description: 'Коллекция уникальных пиксельных персонажей',
        imageUrl: 'https://via.placeholder.com/300x300/10b981/ffffff?text=CryptoPunks',
        bannerUrl: 'https://via.placeholder.com/1200x300/10b981/ffffff?text=Crypto+Punks+Clone',
        creatorAddress: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        blockchain: 'ethereum',
        contractAddress: '0x2345678901234567890123456789012345678901',
        totalSupply: 10000,
        mintedCount: 10000,
        floorPrice: 2.5,
        totalVolume: 15000.0,
        metadata: {
          'website': 'https://cryptopunks.com',
          'discord': 'https://discord.gg/cryptopunks',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        isVerified: true,
        category: 'collectibles',
        tags: ['pixel', 'art', 'collectibles', 'classic'],
      ),
    ];

    // Create sample NFTs
    _nfts = [
      NFT(
        id: '1',
        name: 'REChain Founder #001',
        description: 'Эксклюзивный NFT для основателей REChain',
        imageUrl: 'https://via.placeholder.com/400x400/6366f1/ffffff?text=Founder+001',
        collectionId: '1',
        ownerAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        creatorAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        blockchain: 'ethereum',
        tokenId: '1',
        contractAddress: '0x1234567890123456789012345678901234567890',
        attributes: {
          'rarity': 'legendary',
          'background': 'gold',
          'accessory': 'crown',
          'power_level': '100',
        },
        metadata: {
          'external_url': 'https://rechain.com/nft/1',
          'animation_url': 'https://rechain.com/nft/1/animation',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        status: 'owned',
        tags: ['founder', 'legendary', 'gold'],
        likes: 45,
        views: 1200,
      ),
      NFT(
        id: '2',
        name: 'Crypto Punk #1337',
        description: 'Редкий пиксельный персонаж с уникальными чертами',
        imageUrl: 'https://via.placeholder.com/400x400/10b981/ffffff?text=Punk+1337',
        collectionId: '2',
        ownerAddress: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        creatorAddress: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        blockchain: 'ethereum',
        tokenId: '1337',
        contractAddress: '0x2345678901234567890123456789012345678901',
        attributes: {
          'rarity': 'epic',
          'hat': 'cowboy',
          'eyes': 'laser',
          'mouth': 'smile',
        },
        metadata: {
          'external_url': 'https://cryptopunks.com/punk/1337',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        listedAt: DateTime.now().subtract(const Duration(days: 30)),
        listingPrice: 3.5,
        status: 'listed',
        tags: ['punk', 'cowboy', 'laser'],
        likes: 89,
        views: 3400,
      ),
    ];

    // Create sample listings
    _listings = [
      NFTListing(
        id: '1',
        nftId: '2',
        sellerAddress: '0x8ba1f109551bA432bdf5c3c92Ed49B1b8C263c2e',
        price: 3.5,
        currency: 'ETH',
        listedAt: DateTime.now().subtract(const Duration(days: 30)),
        status: 'active',
        metadata: {
          'expires_in_days': 30,
          'accepts_offers': true,
        },
      ),
    ];

    // Create sample auctions
    _auctions = [
      NFTAuction(
        id: '1',
        nftId: '1',
        sellerAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        startingPrice: 1.0,
        reservePrice: 2.0,
        currency: 'ETH',
        startTime: DateTime.now().add(const Duration(days: 1)),
        endTime: DateTime.now().add(const Duration(days: 7)),
        status: 'upcoming',
        bids: [],
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // NFT methods
  Future<void> createNFT({
    required String name,
    required String description,
    required String imageUrl,
    required String collectionId,
    required String ownerAddress,
    required String creatorAddress,
    required String blockchain,
    required String contractAddress,
    required Map<String, dynamic> attributes,
    required Map<String, dynamic> metadata,
    required List<String> tags,
  }) async {
    final nft = NFT(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      imageUrl: imageUrl,
      collectionId: collectionId,
      ownerAddress: ownerAddress,
      creatorAddress: creatorAddress,
      blockchain: blockchain,
      tokenId: (_nfts.length + 1).toString(),
      contractAddress: contractAddress,
      attributes: attributes,
      metadata: metadata,
      createdAt: DateTime.now(),
      status: 'owned',
      tags: tags,
      likes: 0,
      views: 0,
    );

    _nfts.add(nft);
    await _saveData();
    notifyListeners();
  }

  Future<void> listNFT(String nftId, double price, String currency) async {
    final nftIndex = _nfts.indexWhere((nft) => nft.id == nftId);
    if (nftIndex == -1) return;

    // Update NFT status
    _nfts[nftIndex] = _nfts[nftIndex].copyWith(
      status: 'listed',
      listedAt: DateTime.now(),
      listingPrice: price,
    );

    // Create listing
    final listing = NFTListing(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nftId: nftId,
      sellerAddress: _nfts[nftIndex].ownerAddress,
      price: price,
      currency: currency,
      listedAt: DateTime.now(),
      status: 'active',
      metadata: {
        'expires_in_days': 30,
        'accepts_offers': true,
      },
    );

    _listings.add(listing);
    await _saveData();
    notifyListeners();
  }

  Future<void> cancelListing(String listingId) async {
    final listingIndex = _listings.indexWhere((listing) => listing.id == listingId);
    if (listingIndex == -1) return;

    final listing = _listings[listingIndex];
    
    // Update NFT status
    final nftIndex = _nfts.indexWhere((nft) => nft.id == listing.nftId);
    if (nftIndex != -1) {
      _nfts[nftIndex] = _nfts[nftIndex].copyWith(
        status: 'owned',
        listedAt: null,
        listingPrice: null,
      );
    }

    // Remove listing
    _listings.removeAt(listingIndex);
    await _saveData();
    notifyListeners();
  }

  Future<void> buyNFT(String listingId, String buyerAddress) async {
    final listingIndex = _listings.indexWhere((listing) => listing.id == listingId);
    if (listingIndex == -1) return;

    final listing = _listings[listingIndex];
    
    // Update NFT owner and status
    final nftIndex = _nfts.indexWhere((nft) => nft.id == listing.nftId);
    if (nftIndex != -1) {
      _nfts[nftIndex] = _nfts[nftIndex].copyWith(
        ownerAddress: buyerAddress,
        status: 'owned',
        listedAt: null,
        listingPrice: null,
      );
    }

    // Update listing status
    _listings[listingIndex] = listing.copyWith(status: 'sold');
    
    // Add to user's owned NFTs
    await _saveData();
    notifyListeners();
  }

  // Collection methods
  Future<void> createCollection({
    required String name,
    required String description,
    required String imageUrl,
    required String bannerUrl,
    required String creatorAddress,
    required String blockchain,
    required String contractAddress,
    required int totalSupply,
    required String category,
    required List<String> tags,
    required Map<String, dynamic> metadata,
  }) async {
    final collection = NFTCollection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      imageUrl: imageUrl,
      bannerUrl: bannerUrl,
      creatorAddress: creatorAddress,
      blockchain: blockchain,
      contractAddress: contractAddress,
      totalSupply: totalSupply,
      mintedCount: 0,
      floorPrice: 0.0,
      totalVolume: 0.0,
      metadata: metadata,
      createdAt: DateTime.now(),
      isVerified: false,
      category: category,
      tags: tags,
    );

    _collections.add(collection);
    await _saveData();
    notifyListeners();
  }

  // Auction methods
  Future<void> createAuction({
    required String nftId,
    required String sellerAddress,
    required double startingPrice,
    double? reservePrice,
    required String currency,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final auction = NFTAuction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nftId: nftId,
      sellerAddress: sellerAddress,
      startingPrice: startingPrice,
      reservePrice: reservePrice,
      currency: currency,
      startTime: startTime,
      endTime: endTime,
      status: 'upcoming',
      bids: [],
    );

    _auctions.add(auction);
    await _saveData();
    notifyListeners();
  }

  Future<void> placeBid(String auctionId, String bidderAddress, double amount) async {
    final auctionIndex = _auctions.indexWhere((auction) => auction.id == auctionId);
    if (auctionIndex == -1) return;

    final auction = _auctions[auctionIndex];
    
    // Check if auction is active
    if (auction.status != 'active') return;
    
    // Check if bid is higher than current highest
    if (auction.bids.isNotEmpty && amount <= auction.bids.last.amount) return;

    final bid = AuctionBid(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      auctionId: auctionId,
      bidderAddress: bidderAddress,
      amount: amount,
      timestamp: DateTime.now(),
      status: 'active',
    );

    // Update previous bids to outbid
    for (int i = 0; i < auction.bids.length; i++) {
      auction.bids[i] = auction.bids[i].copyWith(status: 'outbid');
    }

    auction.bids.add(bid);
    auction.winningBid = amount;
    auction.winnerAddress = bidderAddress;

    _auctions[auctionIndex] = auction;
    await _saveData();
    notifyListeners();
  }

  // Search methods
  List<NFT> searchNFTs(String query) {
    if (query.isEmpty) return _nfts;
    
    return _nfts.where((nft) =>
        nft.name.toLowerCase().contains(query.toLowerCase()) ||
        nft.description.toLowerCase().contains(query.toLowerCase()) ||
        nft.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
        nft.collectionId.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<NFTCollection> searchCollections(String query) {
    if (query.isEmpty) return _collections;
    
    return _collections.where((collection) =>
        collection.name.toLowerCase().contains(query.toLowerCase()) ||
        collection.description.toLowerCase().contains(query.toLowerCase()) ||
        collection.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
        collection.category.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<NFT> getNFTsByCollection(String collectionId) {
    return _nfts.where((nft) => nft.collectionId == collectionId).toList();
  }

  List<NFT> getNFTsByOwner(String ownerAddress) {
    return _nfts.where((nft) => nft.ownerAddress.toLowerCase() == ownerAddress.toLowerCase()).toList();
  }

  List<NFTListing> getActiveListings() {
    return _listings.where((listing) => listing.status == 'active').toList();
  }

  List<NFTAuction> getActiveAuctions() {
    return _auctions.where((auction) => auction.status == 'active').toList();
  }

  // Analytics methods
  double getTotalMarketVolume() {
    double total = 0.0;
    for (final listing in _listings) {
      if (listing.status == 'sold') {
        total += listing.price;
      }
    }
    return total;
  }

  int getTotalNFTsListed() {
    return _nfts.where((nft) => nft.status == 'listed').length;
  }

  double getAverageListingPrice() {
    final listedNFTs = _nfts.where((nft) => nft.listingPrice != null).toList();
    if (listedNFTs.isEmpty) return 0.0;
    
    double total = 0.0;
    for (final nft in listedNFTs) {
      total += nft.listingPrice!;
    }
    return total / listedNFTs.length;
  }

  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }
}
