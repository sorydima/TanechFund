import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

// Enums for social network
enum ProjectStatus {
  idea,
  development,
  launched,
  funding,
}

// Web3/Web4 модели для социальной сети
class Web3Profile {
  final String id;
  final String walletAddress;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? coverUrl;
  final String bio;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final bool isVerified;
  final int reputationScore;
  final List<String> nftCollections;
  final DateTime createdAt;
  final DateTime lastActive;
  final String userType; // 'startup', 'investor', 'developer', 'mentor'

  // Getters for compatibility
  String get name => displayName;
  int get projectsCount => 5; // Default value
  int get followersCount => 100; // Default value
  int get followingCount => 50; // Default value
  List<String> get skills => tags;
  List<String> get walletAddresses => [walletAddress];

  Web3Profile({
    required this.id,
    required this.walletAddress,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.coverUrl,
    required this.bio,
    required this.tags,
    required this.metadata,
    required this.isVerified,
    required this.reputationScore,
    required this.nftCollections,
    required this.createdAt,
    required this.lastActive,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'walletAddress': walletAddress,
    'username': username,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'coverUrl': coverUrl,
    'bio': bio,
    'tags': tags,
    'metadata': metadata,
    'isVerified': isVerified,
    'reputationScore': reputationScore,
    'nftCollections': nftCollections,
    'createdAt': createdAt.toIso8601String(),
    'lastActive': lastActive.toIso8601String(),
    'userType': userType,
  };

  factory Web3Profile.fromJson(Map<String, dynamic> json) => Web3Profile(
    id: json['id'],
    walletAddress: json['walletAddress'],
    username: json['username'],
    displayName: json['displayName'],
    avatarUrl: json['avatarUrl'],
    coverUrl: json['coverUrl'],
    bio: json['bio'],
    tags: List<String>.from(json['tags']),
    metadata: Map<String, dynamic>.from(json['metadata']),
    isVerified: json['isVerified'],
    reputationScore: json['reputationScore'],
    nftCollections: List<String>.from(json['nftCollections']),
    createdAt: DateTime.parse(json['createdAt']),
    lastActive: DateTime.parse(json['lastActive']),
    userType: json['userType'],
  );
}

class StartupProject {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> tags;
  final String stage; // 'idea', 'mvp', 'beta', 'launched', 'scaling'
  final String fundingStage; // 'pre-seed', 'seed', 'series-a', 'series-b'
  final double fundingGoal;
  final double currentFunding;
  final int teamSize;
  final List<String> teamMembers;
  final String blockchain; // 'ethereum', 'polygon', 'solana', 'binance'
  final bool hasToken;
  final String? tokenSymbol;
  final String? tokenContract;
  final List<String> images;
  final String? pitchDeckUrl;
  final String? websiteUrl;
  final String? whitepaperUrl;
  final Map<String, dynamic> metrics;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String status; // 'active', 'funded', 'completed', 'paused'

  // Getters for compatibility
  double get fundingRaised => currentFunding;
  List<String> get technologies => tags;

  StartupProject({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tags,
    required this.stage,
    required this.fundingStage,
    required this.fundingGoal,
    required this.currentFunding,
    required this.teamSize,
    required this.teamMembers,
    required this.blockchain,
    required this.hasToken,
    this.tokenSymbol,
    this.tokenContract,
    required this.images,
    this.pitchDeckUrl,
    this.websiteUrl,
    this.whitepaperUrl,
    required this.metrics,
    required this.createdAt,
    required this.lastUpdated,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'category': category,
    'tags': tags,
    'stage': stage,
    'fundingStage': fundingStage,
    'fundingGoal': fundingGoal,
    'currentFunding': currentFunding,
    'teamSize': teamSize,
    'teamMembers': teamMembers,
    'blockchain': blockchain,
    'hasToken': hasToken,
    'tokenSymbol': tokenSymbol,
    'tokenContract': tokenContract,
    'images': images,
    'pitchDeckUrl': pitchDeckUrl,
    'websiteUrl': websiteUrl,
    'whitepaperUrl': whitepaperUrl,
    'metrics': metrics,
    'createdAt': createdAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'status': status,
  };

  factory StartupProject.fromJson(Map<String, dynamic> json) => StartupProject(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    category: json['category'],
    tags: List<String>.from(json['tags']),
    stage: json['stage'],
    fundingStage: json['fundingStage'],
    fundingGoal: json['fundingGoal'].toDouble(),
    currentFunding: json['currentFunding'].toDouble(),
    teamSize: json['teamSize'],
    teamMembers: List<String>.from(json['teamMembers']),
    blockchain: json['blockchain'],
    hasToken: json['hasToken'],
    tokenSymbol: json['tokenSymbol'],
    tokenContract: json['tokenContract'],
    images: List<String>.from(json['images']),
    pitchDeckUrl: json['pitchDeckUrl'],
    websiteUrl: json['websiteUrl'],
    whitepaperUrl: json['whitepaperUrl'],
    metrics: Map<String, dynamic>.from(json['metrics']),
    createdAt: DateTime.parse(json['createdAt']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
    status: json['status'],
  );
}

class SocialPost {
  final String id;
  final String authorId;
  final String authorUsername;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final String content;
  final List<String> images;
  final List<String> tags;
  final String postType; // 'update', 'milestone', 'funding', 'team', 'product'
  final String? relatedProjectId;
  final Map<String, dynamic> metadata;
  int likes;
  int comments;
  int shares;
  int views;
  List<String> likedBy;
  List<String> commentedBy;
  List<String> sharedBy;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isPinned;
  final String visibility; // 'public', 'followers', 'private'

  SocialPost({
    required this.id,
    required this.authorId,
    required this.authorUsername,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    required this.content,
    required this.images,
    required this.tags,
    required this.postType,
    this.relatedProjectId,
    required this.metadata,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.views,
    required this.likedBy,
    required this.commentedBy,
    required this.sharedBy,
    required this.createdAt,
    required this.lastUpdated,
    required this.isPinned,
    required this.visibility,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'authorId': authorId,
    'authorUsername': authorUsername,
    'authorDisplayName': authorDisplayName,
    'authorAvatarUrl': authorAvatarUrl,
    'content': content,
    'images': images,
    'tags': tags,
    'postType': postType,
    'relatedProjectId': relatedProjectId,
    'metadata': metadata,
    'likes': likes,
    'comments': comments,
    'shares': shares,
    'views': views,
    'likedBy': likedBy,
    'commentedBy': commentedBy,
    'sharedBy': sharedBy,
    'createdAt': createdAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'isPinned': isPinned,
    'visibility': visibility,
  };

  factory SocialPost.fromJson(Map<String, dynamic> json) => SocialPost(
    id: json['id'],
    authorId: json['authorId'],
    authorUsername: json['authorUsername'],
    authorDisplayName: json['authorDisplayName'],
    authorAvatarUrl: json['authorAvatarUrl'],
    content: json['content'],
    images: List<String>.from(json['images']),
    tags: List<String>.from(json['tags']),
    postType: json['postType'],
    relatedProjectId: json['relatedProjectId'],
    metadata: Map<String, dynamic>.from(json['metadata']),
    likes: json['likes'],
    comments: json['comments'],
    shares: json['shares'],
    views: json['views'],
    likedBy: List<String>.from(json['likedBy']),
    commentedBy: List<String>.from(json['commentedBy']),
    sharedBy: List<String>.from(json['sharedBy']),
    createdAt: DateTime.parse(json['createdAt']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
    isPinned: json['isPinned'],
    visibility: json['visibility'],
  );
}

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorUsername;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final String content;
  final List<String> images;
  final String? parentCommentId;
  final List<String> replies;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isEdited;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorUsername,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    required this.content,
    required this.images,
    this.parentCommentId,
    required this.replies,
    required this.likes,
    required this.likedBy,
    required this.createdAt,
    required this.lastUpdated,
    required this.isEdited,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'postId': postId,
    'authorId': authorId,
    'authorUsername': authorUsername,
    'authorDisplayName': authorDisplayName,
    'authorAvatarUrl': authorAvatarUrl,
    'content': content,
    'images': images,
    'parentCommentId': parentCommentId,
    'replies': replies,
    'likes': likes,
    'likedBy': likedBy,
    'createdAt': createdAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'isEdited': isEdited,
  };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'],
    postId: json['postId'],
    authorId: json['authorId'],
    authorUsername: json['authorUsername'],
    authorDisplayName: json['authorDisplayName'],
    authorAvatarUrl: json['authorAvatarUrl'],
    content: json['content'],
    images: List<String>.from(json['images']),
    parentCommentId: json['parentCommentId'],
    replies: List<String>.from(json['replies']),
    likes: json['likes'],
    likedBy: List<String>.from(json['likedBy']),
    createdAt: DateTime.parse(json['createdAt']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
    isEdited: json['isEdited'],
  );
}

class NFTCollection {
  final String id;
  final String name;
  final String description;
  final String symbol;
  final String contractAddress;
  final String blockchain;
  final String? imageUrl;
  final int totalSupply;
  final int mintedSupply;
  final double floorPrice;
  final double totalVolume;
  final String creatorAddress;
  final DateTime createdAt;
  final List<String> traits;
  final Map<String, dynamic> metadata;

  // Getters for compatibility
  int get ownersCount => mintedSupply; // Approximate
  double get volume => totalVolume;

  NFTCollection({
    required this.id,
    required this.name,
    required this.description,
    required this.symbol,
    required this.contractAddress,
    required this.blockchain,
    this.imageUrl,
    required this.totalSupply,
    required this.mintedSupply,
    required this.floorPrice,
    required this.totalVolume,
    required this.creatorAddress,
    required this.createdAt,
    required this.traits,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'symbol': symbol,
    'contractAddress': contractAddress,
    'blockchain': blockchain,
    'imageUrl': imageUrl,
    'totalSupply': totalSupply,
    'mintedSupply': mintedSupply,
    'floorPrice': floorPrice,
    'totalVolume': totalVolume,
    'creatorAddress': creatorAddress,
    'createdAt': createdAt.toIso8601String(),
    'traits': traits,
    'metadata': metadata,
  };

  factory NFTCollection.fromJson(Map<String, dynamic> json) => NFTCollection(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    symbol: json['symbol'],
    contractAddress: json['contractAddress'],
    blockchain: json['blockchain'],
    imageUrl: json['imageUrl'],
    totalSupply: json['totalSupply'],
    mintedSupply: json['mintedSupply'],
    floorPrice: json['floorPrice'].toDouble(),
    totalVolume: json['totalVolume'].toDouble(),
    creatorAddress: json['creatorAddress'],
    createdAt: DateTime.parse(json['createdAt']),
    traits: List<String>.from(json['traits']),
    metadata: Map<String, dynamic>.from(json['metadata']),
  );
}

class SocialNetworkProvider extends ChangeNotifier {
  List<Web3Profile> _profiles = [];
  List<StartupProject> _projects = [];
  List<SocialPost> _posts = [];
  List<Comment> _comments = [];
  List<NFTCollection> _nftCollections = [];
  List<String> _followedUsers = [];
  List<String> _followedProjects = [];
  bool _isLoading = false;

  // Геттеры
  List<Web3Profile> get profiles => _profiles;
  List<StartupProject> get projects => _projects;
  List<SocialPost> get posts => _posts;
  List<Comment> get comments => _comments;
  List<NFTCollection> get nftCollections => _nftCollections;
  List<String> get followedUsers => _followedUsers;
  List<String> get followedProjects => _followedProjects;
  bool get isLoading => _isLoading;

  // Инициализация
  Future<void> initialize() async {
    await _loadData();
    if (_profiles.isEmpty) {
      _createDemoData();
    }
  }

  // Загрузка данных
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Загрузка профилей
      final profilesJson = prefs.getStringList('web3_profiles') ?? [];
      _profiles = profilesJson
          .map((json) => Web3Profile.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка проектов
      final projectsJson = prefs.getStringList('startup_projects') ?? [];
      _projects = projectsJson
          .map((json) => StartupProject.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка постов
      final postsJson = prefs.getStringList('social_posts') ?? [];
      _posts = postsJson
          .map((json) => SocialPost.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка комментариев
      final commentsJson = prefs.getStringList('comments') ?? [];
      _comments = commentsJson
          .map((json) => Comment.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка NFT коллекций
      final nftJson = prefs.getStringList('nft_collections') ?? [];
      _nftCollections = nftJson
          .map((json) => NFTCollection.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка подписок
      _followedUsers = prefs.getStringList('followed_users') ?? [];
      _followedProjects = prefs.getStringList('followed_projects') ?? [];
    } catch (e) {
      debugPrint('Ошибка загрузки данных социальной сети: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Сохранение данных
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Сохранение профилей
      final profilesJson = _profiles
          .map((p) => jsonEncode(p.toJson()))
          .toList();
      await prefs.setStringList('web3_profiles', profilesJson);
      
      // Сохранение проектов
      final projectsJson = _projects
          .map((p) => jsonEncode(p.toJson()))
          .toList();
      await prefs.setStringList('startup_projects', projectsJson);
      
      // Сохранение постов
      final postsJson = _posts
          .map((p) => jsonEncode(p.toJson()))
          .toList();
      await prefs.setStringList('social_posts', postsJson);
      
      // Сохранение комментариев
      final commentsJson = _comments
          .map((c) => jsonEncode(c.toJson()))
          .toList();
      await prefs.setStringList('comments', commentsJson);
      
      // Сохранение NFT коллекций
      final nftJson = _nftCollections
          .map((n) => jsonEncode(n.toJson()))
          .toList();
      await prefs.setStringList('nft_collections', nftJson);
      
      // Сохранение подписок
      await prefs.setStringList('followed_users', _followedUsers);
      await prefs.setStringList('followed_projects', _followedProjects);
    } catch (e) {
      debugPrint('Ошибка сохранения данных социальной сети: $e');
    }
  }

  // Создание демо-данных
  void _createDemoData() {
    // Демо-профили
    _profiles = [
      Web3Profile(
        id: '1',
        walletAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        username: 'crypto_startup',
        displayName: 'Crypto Startup Lab',
        avatarUrl: 'https://via.placeholder.com/150/6366f1/ffffff?text=CSL',
        bio: 'Building the future of decentralized finance and Web3 infrastructure',
        tags: ['DeFi', 'Web3', 'Blockchain', 'FinTech'],
        metadata: {
          'location': 'San Francisco, CA',
          'experience': '5+ years',
          'specialization': 'DeFi Protocols',
        },
        isVerified: true,
        reputationScore: 95,
        nftCollections: ['startup_badges', 'achievement_tokens'],
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastActive: DateTime.now(),
        userType: 'startup',
      ),
      Web3Profile(
        id: '2',
        walletAddress: '0x8ba1f109551bD432803012645Hac136c772c3c7b',
        username: 'web3_investor',
        displayName: 'Web3 Venture Capital',
        avatarUrl: 'https://via.placeholder.com/150/10b981/ffffff?text=W3V',
        bio: 'Investing in the next generation of Web3 and blockchain startups',
        tags: ['Investment', 'Web3', 'Venture Capital', 'Blockchain'],
        metadata: {
          'location': 'New York, NY',
          'portfolio_size': '50+ companies',
          'investment_focus': 'Seed to Series A',
        },
        isVerified: true,
        reputationScore: 98,
        nftCollections: ['investor_badges', 'portfolio_tokens'],
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastActive: DateTime.now(),
        userType: 'investor',
      ),
    ];

    // Демо-проекты
    _projects = [
      StartupProject(
        id: '1',
        name: 'DeFi Protocol Alpha',
        description: 'Revolutionary decentralized lending protocol with AI-powered risk assessment',
        category: 'DeFi',
        tags: ['Lending', 'AI', 'Risk Management', 'Yield Farming'],
        stage: 'beta',
        fundingStage: 'series-a',
        fundingGoal: 5000000.0,
        currentFunding: 3500000.0,
        teamSize: 12,
        teamMembers: ['0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6'],
        blockchain: 'ethereum',
        hasToken: true,
        tokenSymbol: 'ALPHA',
        tokenContract: '0x1234567890abcdef1234567890abcdef12345678',
        images: [
          'https://via.placeholder.com/400/6366f1/ffffff?text=DeFi+Alpha',
          'https://via.placeholder.com/400/8b5cf6/ffffff?text=Protocol',
        ],
        metrics: {
          'tvl': 25000000.0,
          'users': 15000,
          'transactions': 500000,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        lastUpdated: DateTime.now(),
        status: 'active',
      ),
      StartupProject(
        id: '2',
        name: 'NFT Marketplace Pro',
        description: 'Professional NFT marketplace with advanced trading features and analytics',
        category: 'NFT',
        tags: ['Marketplace', 'Trading', 'Analytics', 'Gaming'],
        stage: 'launched',
        fundingStage: 'seed',
        fundingGoal: 2000000.0,
        currentFunding: 2000000.0,
        teamSize: 8,
        teamMembers: ['0x8ba1f109551bD432803012645Hac136c772c3c7b'],
        blockchain: 'polygon',
        hasToken: true,
        tokenSymbol: 'NMP',
        tokenContract: '0xabcdef1234567890abcdef1234567890abcdef12',
        images: [
          'https://via.placeholder.com/400/10b981/ffffff?text=NFT+Pro',
          'https://via.placeholder.com/400/f59e0b/ffffff?text=Marketplace',
        ],
        metrics: {
          'volume': 5000000.0,
          'users': 25000,
          'collections': 500,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        lastUpdated: DateTime.now(),
        status: 'funded',
      ),
    ];

    // Демо-посты
    _posts = [
      SocialPost(
        id: '1',
        authorId: '1',
        authorUsername: 'crypto_startup',
        authorDisplayName: 'Crypto Startup Lab',
        authorAvatarUrl: 'https://via.placeholder.com/150/6366f1/ffffff?text=CSL',
        content: '🚀 Excited to announce our new DeFi protocol is now in beta! We\'ve been working hard on AI-powered risk assessment and we can\'t wait to see how the community responds. #DeFi #Web3 #Innovation',
        images: ['https://via.placeholder.com/400/6366f1/ffffff?text=Beta+Launch'],
        tags: ['DeFi', 'Web3', 'Beta', 'Launch'],
        postType: 'milestone',
        relatedProjectId: '1',
        metadata: {
          'milestone': 'Beta Launch',
          'achievement': 'AI Integration Complete',
        },
        likes: 156,
        comments: 23,
        shares: 45,
        views: 1200,
        likedBy: [],
        commentedBy: [],
        sharedBy: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        isPinned: false,
        visibility: 'public',
      ),
      SocialPost(
        id: '2',
        authorId: '2',
        authorUsername: 'web3_investor',
        authorDisplayName: 'Web3 Venture Capital',
        authorAvatarUrl: 'https://via.placeholder.com/150/10b981/ffffff?text=W3V',
        content: '💡 The future of Web3 is here! We\'re seeing incredible innovation in DeFi, NFTs, and blockchain infrastructure. What projects are you most excited about? #Web3 #Innovation #Future',
        images: [],
        tags: ['Web3', 'Innovation', 'Future', 'Discussion'],
        postType: 'update',
        metadata: {
          'engagement': 'high',
          'topic': 'Web3 Trends',
        },
        likes: 89,
        comments: 34,
        shares: 12,
        views: 800,
        likedBy: [],
        commentedBy: [],
        sharedBy: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
        isPinned: true,
        visibility: 'public',
      ),
    ];

    // Демо-комментарии
    _comments = [
      Comment(
        id: '1',
        postId: '1',
        authorId: '2',
        authorUsername: 'web3_investor',
        authorDisplayName: 'Web3 Venture Capital',
        authorAvatarUrl: 'https://via.placeholder.com/150/10b981/ffffff?text=W3V',
        content: 'This looks promising! The AI integration for risk assessment is exactly what DeFi needs. Looking forward to seeing the results! 🚀',
        images: [],
        parentCommentId: null,
        replies: [],
        likes: 12,
        likedBy: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        isEdited: false,
      ),
    ];

    // Демо-NFT коллекции
    _nftCollections = [
      NFTCollection(
        id: '1',
        name: 'Startup Achievement Badges',
        description: 'Exclusive badges for startup milestones and achievements',
        symbol: 'SAB',
        contractAddress: '0xbadge1234567890abcdef1234567890abcdef1234',
        blockchain: 'ethereum',
        imageUrl: 'https://via.placeholder.com/400/6366f1/ffffff?text=Badges',
        totalSupply: 1000,
        mintedSupply: 150,
        floorPrice: 0.1,
        totalVolume: 15000.0,
        creatorAddress: '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        traits: ['Milestone', 'Achievement', 'Exclusive'],
        metadata: {
          'rarity': 'rare',
          'utility': 'governance',
        },
      ),
    ];

    _saveData();
  }

  // Методы для профилей
  Future<void> createProfile(Web3Profile profile) async {
    _profiles.add(profile);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateProfile(Web3Profile profile) async {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
      await _saveData();
      notifyListeners();
    }
  }

  Web3Profile? getProfileById(String id) {
    try {
      return _profiles.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Методы для проектов
  Future<void> createProject(StartupProject project) async {
    _projects.add(project);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateProject(StartupProject project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      await _saveData();
      notifyListeners();
    }
  }

  List<StartupProject> getProjectsByCategory(String category) {
    return _projects.where((p) => p.category == category).toList();
  }

  List<StartupProject> getProjectsByBlockchain(String blockchain) {
    return _projects.where((p) => p.blockchain == blockchain).toList();
  }

  // Методы для постов
  Future<void> createPost(SocialPost post) async {
    _posts.insert(0, post);
    await _saveData();
    notifyListeners();
  }

  Future<void> likePost(String postId, String userId) async {
    final post = _posts.firstWhere((p) => p.id == postId);
    if (!post.likedBy.contains(userId)) {
      post.likedBy.add(userId);
      post.likes++;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    final post = _posts.firstWhere((p) => p.id == postId);
    if (post.likedBy.contains(userId)) {
      post.likedBy.remove(userId);
      post.likes--;
      await _saveData();
      notifyListeners();
    }
  }

  List<SocialPost> getFeedForUser(String userId) {
    final followedUsers = _followedUsers;
    final followedProjects = _followedProjects;
    
    return _posts.where((post) {
      return followedUsers.contains(post.authorId) ||
             (post.relatedProjectId != null && followedProjects.contains(post.relatedProjectId)) ||
             post.visibility == 'public';
    }).toList();
  }

  // Методы для комментариев
  Future<void> addComment(Comment comment) async {
    _comments.add(comment);
    
    // Обновляем счетчик комментариев в посте
    final post = _posts.firstWhere((p) => p.id == comment.postId);
    post.comments++;
    
    await _saveData();
    notifyListeners();
  }

  List<Comment> getCommentsForPost(String postId) {
    return _comments.where((c) => c.postId == postId).toList();
  }

  // Методы для подписок
  Future<void> followUser(String userId) async {
    if (!_followedUsers.contains(userId)) {
      _followedUsers.add(userId);
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> unfollowUser(String userId) async {
    _followedUsers.remove(userId);
    await _saveData();
    notifyListeners();
  }

  Future<void> followProject(String projectId) async {
    if (!_followedProjects.contains(projectId)) {
      _followedProjects.add(projectId);
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> unfollowProject(String projectId) async {
    _followedProjects.remove(projectId);
    await _saveData();
    notifyListeners();
  }

  // Методы для поиска
  List<Web3Profile> searchProfiles(String query) {
    return _profiles.where((profile) {
      return profile.username.toLowerCase().contains(query.toLowerCase()) ||
             profile.displayName.toLowerCase().contains(query.toLowerCase()) ||
             profile.bio.toLowerCase().contains(query.toLowerCase()) ||
             profile.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  List<StartupProject> searchProjects(String query) {
    return _projects.where((project) {
      return project.name.toLowerCase().contains(query.toLowerCase()) ||
             project.description.toLowerCase().contains(query.toLowerCase()) ||
             project.category.toLowerCase().contains(query.toLowerCase()) ||
             project.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Методы для NFT
  List<NFTCollection> getNFTCollectionsByCreator(String creatorAddress) {
    return _nftCollections.where((collection) => 
      collection.creatorAddress.toLowerCase() == creatorAddress.toLowerCase()
    ).toList();
  }

  List<NFTCollection> getNFTCollectionsByBlockchain(String blockchain) {
    return _nftCollections.where((collection) => 
      collection.blockchain.toLowerCase() == blockchain.toLowerCase()
    ).toList();
  }
}
