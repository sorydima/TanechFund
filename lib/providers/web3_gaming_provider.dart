import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Game World Type
enum GameWorldType {
  rpg,
  strategy,
  action,
  simulation,
  puzzle,
  racing,
}

// Character Class
enum CharacterClass {
  warrior,
  mage,
  archer,
  healer,
  rogue,
  tank,
}

// Tournament Status
enum TournamentStatus {
  upcoming,
  active,
  completed,
  cancelled,
}

// Reward Type
enum RewardType {
  token,
  nft,
  experience,
  item,
  title,
}

// DeFi Integration Type
enum DeFiIntegrationType {
  staking,
  liquidity_providing,
  yield_farming,
  lending,
  borrowing,
}

// Game World
class GameWorld {
  final String id;
  final String name;
  final String description;
  final GameWorldType type;
  final String imageUrl;
  final int maxPlayers;
  final int currentPlayers;
  final double tokenPrice;
  final String tokenSymbol;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final bool isActive;

  GameWorld({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.imageUrl,
    required this.maxPlayers,
    required this.currentPlayers,
    required this.tokenPrice,
    required this.tokenSymbol,
    required this.metadata,
    required this.createdAt,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'imageUrl': imageUrl,
      'maxPlayers': maxPlayers,
      'currentPlayers': currentPlayers,
      'tokenPrice': tokenPrice,
      'tokenSymbol': tokenSymbol,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory GameWorld.fromJson(Map<String, dynamic> json) {
    return GameWorld(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: GameWorldType.values.firstWhere((e) => e.name == json['type']),
      imageUrl: json['imageUrl'],
      maxPlayers: json['maxPlayers'],
      currentPlayers: json['currentPlayers'],
      tokenPrice: json['tokenPrice'].toDouble(),
      tokenSymbol: json['tokenSymbol'],
      metadata: Map<String, dynamic>.from(json['metadata']),
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'],
    );
  }

  GameWorld copyWith({
    String? id,
    String? name,
    String? description,
    GameWorldType? type,
    String? imageUrl,
    int? maxPlayers,
    int? currentPlayers,
    double? tokenPrice,
    String? tokenSymbol,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return GameWorld(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      currentPlayers: currentPlayers ?? this.currentPlayers,
      tokenPrice: tokenPrice ?? this.tokenPrice,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Game Character
class GameCharacter {
  final String id;
  final String userId;
  final String worldId;
  final String name;
  final CharacterClass characterClass;
  final int level;
  final int experience;
  final int health;
  final int maxHealth;
  final int mana;
  final int maxMana;
  final int strength;
  final int agility;
  final int intelligence;
  final List<String> inventory;
  final List<String> skills;
  final Map<String, dynamic> stats;
  final DateTime createdAt;
  final DateTime? lastPlayed;

  GameCharacter({
    required this.id,
    required this.userId,
    required this.worldId,
    required this.name,
    required this.characterClass,
    required this.level,
    required this.experience,
    required this.health,
    required this.maxHealth,
    required this.mana,
    required this.maxMana,
    required this.strength,
    required this.agility,
    required this.intelligence,
    required this.inventory,
    required this.skills,
    required this.stats,
    required this.createdAt,
    this.lastPlayed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'worldId': worldId,
      'name': name,
      'characterClass': characterClass.name,
      'level': level,
      'experience': experience,
      'health': health,
      'maxHealth': maxHealth,
      'mana': mana,
      'maxMana': maxMana,
      'strength': strength,
      'agility': agility,
      'intelligence': intelligence,
      'inventory': inventory,
      'skills': skills,
      'stats': stats,
      'createdAt': createdAt.toIso8601String(),
      'lastPlayed': lastPlayed?.toIso8601String(),
    };
  }

  factory GameCharacter.fromJson(Map<String, dynamic> json) {
    return GameCharacter(
      id: json['id'],
      userId: json['userId'],
      worldId: json['worldId'],
      name: json['name'],
      characterClass: CharacterClass.values.firstWhere((e) => e.name == json['characterClass']),
      level: json['level'],
      experience: json['experience'],
      health: json['health'],
      maxHealth: json['maxHealth'],
      mana: json['mana'],
      maxMana: json['maxMana'],
      strength: json['strength'],
      agility: json['agility'],
      intelligence: json['intelligence'],
      inventory: List<String>.from(json['inventory']),
      skills: List<String>.from(json['skills']),
      stats: Map<String, dynamic>.from(json['stats']),
      createdAt: DateTime.parse(json['createdAt']),
      lastPlayed: json['lastPlayed'] != null ? DateTime.parse(json['lastPlayed']) : null,
    );
  }

  GameCharacter copyWith({
    String? id,
    String? userId,
    String? worldId,
    String? name,
    CharacterClass? characterClass,
    int? level,
    int? experience,
    int? health,
    int? maxHealth,
    int? mana,
    int? maxMana,
    int? strength,
    int? agility,
    int? intelligence,
    List<String>? inventory,
    List<String>? skills,
    Map<String, dynamic>? stats,
    DateTime? createdAt,
    DateTime? lastPlayed,
  }) {
    return GameCharacter(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      worldId: worldId ?? this.worldId,
      name: name ?? this.name,
      characterClass: characterClass ?? this.characterClass,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      mana: mana ?? this.mana,
      maxMana: maxMana ?? this.maxMana,
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      intelligence: intelligence ?? this.intelligence,
      inventory: inventory ?? this.inventory,
      skills: skills ?? this.skills,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }
}

// Tournament
class Tournament {
  final String id;
  final String worldId;
  final String name;
  final String description;
  final TournamentStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int maxParticipants;
  final List<String> participants;
  final List<String> winners;
  final Map<String, dynamic> rewards;
  final double entryFee;
  final String tokenSymbol;
  final Map<String, dynamic> metadata;

  Tournament({
    required this.id,
    required this.worldId,
    required this.name,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.participants,
    required this.winners,
    required this.rewards,
    required this.entryFee,
    required this.tokenSymbol,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'worldId': worldId,
      'name': name,
      'description': description,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'maxParticipants': maxParticipants,
      'participants': participants,
      'winners': winners,
      'rewards': rewards,
      'entryFee': entryFee,
      'tokenSymbol': tokenSymbol,
      'metadata': metadata,
    };
  }

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'],
      worldId: json['worldId'],
      name: json['name'],
      description: json['description'],
      status: TournamentStatus.values.firstWhere((e) => e.name == json['status']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxParticipants: json['maxParticipants'],
      participants: List<String>.from(json['participants']),
      winners: List<String>.from(json['winners']),
      rewards: Map<String, dynamic>.from(json['rewards']),
      entryFee: json['entryFee'].toDouble(),
      tokenSymbol: json['tokenSymbol'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Tournament copyWith({
    String? id,
    String? worldId,
    String? name,
    String? description,
    TournamentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? maxParticipants,
    List<String>? participants,
    List<String>? winners,
    Map<String, dynamic>? rewards,
    double? entryFee,
    String? tokenSymbol,
    Map<String, dynamic>? metadata,
  }) {
    return Tournament(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      participants: participants ?? this.participants,
      winners: winners ?? this.winners,
      rewards: rewards ?? this.rewards,
      entryFee: entryFee ?? this.entryFee,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Game Reward
class GameReward {
  final String id;
  final String userId;
  final String worldId;
  final String characterId;
  final RewardType type;
  final String name;
  final String description;
  final double amount;
  final String tokenSymbol;
  final String? nftId;
  final String? itemId;
  final DateTime earnedAt;
  final bool isClaimed;
  final Map<String, dynamic> metadata;

  GameReward({
    required this.id,
    required this.userId,
    required this.worldId,
    required this.characterId,
    required this.type,
    required this.name,
    required this.description,
    required this.amount,
    required this.tokenSymbol,
    this.nftId,
    this.itemId,
    required this.earnedAt,
    required this.isClaimed,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'worldId': worldId,
      'characterId': characterId,
      'type': type.name,
      'name': name,
      'description': description,
      'amount': amount,
      'tokenSymbol': tokenSymbol,
      'nftId': nftId,
      'itemId': itemId,
      'earnedAt': earnedAt.toIso8601String(),
      'isClaimed': isClaimed,
      'metadata': metadata,
    };
  }

  factory GameReward.fromJson(Map<String, dynamic> json) {
    return GameReward(
      id: json['id'],
      userId: json['userId'],
      worldId: json['worldId'],
      characterId: json['characterId'],
      type: RewardType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      tokenSymbol: json['tokenSymbol'],
      nftId: json['nftId'],
      itemId: json['itemId'],
      earnedAt: DateTime.parse(json['earnedAt']),
      isClaimed: json['isClaimed'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  GameReward copyWith({
    String? id,
    String? userId,
    String? worldId,
    String? characterId,
    RewardType? type,
    String? name,
    String? description,
    double? amount,
    String? tokenSymbol,
    String? nftId,
    String? itemId,
    DateTime? earnedAt,
    bool? isClaimed,
    Map<String, dynamic>? metadata,
  }) {
    return GameReward(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      worldId: worldId ?? this.worldId,
      characterId: characterId ?? this.characterId,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      nftId: nftId ?? this.nftId,
      itemId: itemId ?? this.itemId,
      earnedAt: earnedAt ?? this.earnedAt,
      isClaimed: isClaimed ?? this.isClaimed,
      metadata: metadata ?? this.metadata,
    );
  }
}

// DeFi Integration
class DeFiIntegration {
  final String id;
  final String worldId;
  final DeFiIntegrationType type;
  final String protocolName;
  final String contractAddress;
  final double apy;
  final double tvl;
  final double userStake;
  final double userRewards;
  final DateTime lastUpdated;
  final bool isActive;
  final Map<String, dynamic> metadata;

  DeFiIntegration({
    required this.id,
    required this.worldId,
    required this.type,
    required this.protocolName,
    required this.contractAddress,
    required this.apy,
    required this.tvl,
    required this.userStake,
    required this.userRewards,
    required this.lastUpdated,
    required this.isActive,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'worldId': worldId,
      'type': type.name,
      'protocolName': protocolName,
      'contractAddress': contractAddress,
      'apy': apy,
      'tvl': tvl,
      'userStake': userStake,
      'userRewards': userRewards,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory DeFiIntegration.fromJson(Map<String, dynamic> json) {
    return DeFiIntegration(
      id: json['id'],
      worldId: json['worldId'],
      type: DeFiIntegrationType.values.firstWhere((e) => e.name == json['type']),
      protocolName: json['protocolName'],
      contractAddress: json['contractAddress'],
      apy: json['apy'].toDouble(),
      tvl: json['tvl'].toDouble(),
      userStake: json['userStake'].toDouble(),
      userRewards: json['userRewards'].toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      isActive: json['isActive'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  DeFiIntegration copyWith({
    String? id,
    String? worldId,
    DeFiIntegrationType? type,
    String? protocolName,
    String? contractAddress,
    double? apy,
    double? tvl,
    double? userStake,
    double? userRewards,
    DateTime? lastUpdated,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return DeFiIntegration(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      type: type ?? this.type,
      protocolName: protocolName ?? this.protocolName,
      contractAddress: contractAddress ?? this.contractAddress,
      apy: apy ?? this.apy,
      tvl: tvl ?? this.tvl,
      userStake: userStake ?? this.userStake,
      userRewards: userRewards ?? this.userRewards,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Web3 Gaming Provider
class Web3GamingProvider extends ChangeNotifier {
  List<GameWorld> _gameWorlds = [];
  List<GameCharacter> _characters = [];
  List<Tournament> _tournaments = [];
  List<GameReward> _rewards = [];
  List<DeFiIntegration> _deFiIntegrations = [];
  String _currentUserId = 'current_user';

  // Getters
  List<GameWorld> get gameWorlds => _gameWorlds;
  List<GameCharacter> get characters => _characters;
  List<Tournament> get tournaments => _tournaments;
  List<GameReward> get rewards => _rewards;
  List<DeFiIntegration> get deFiIntegrations => _deFiIntegrations;
  String get currentUserId => _currentUserId;

  List<GameWorld> get activeGameWorlds => _gameWorlds.where((world) => world.isActive).toList();
  List<GameCharacter> get userCharacters => _characters.where((char) => char.userId == _currentUserId).toList();
  List<Tournament> get activeTournaments => _tournaments.where((tournament) => tournament.status == TournamentStatus.active).toList();
  List<GameReward> get userRewards => _rewards.where((reward) => reward.userId == _currentUserId).toList();
  List<GameReward> get unclaimedRewards => _rewards.where((reward) => reward.userId == _currentUserId && !reward.isClaimed).toList();

  // Initialize
  Future<void> initialize() async {
    await _loadData();
    if (_gameWorlds.isEmpty) {
      _createDemoData();
    }
    notifyListeners();
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final gameWorldsJson = prefs.getString('web3_gaming_worlds');
    if (gameWorldsJson != null) {
      final List<dynamic> decoded = jsonDecode(gameWorldsJson);
      _gameWorlds = decoded.map((item) => GameWorld.fromJson(item)).toList();
    }

    final charactersJson = prefs.getString('web3_gaming_characters');
    if (charactersJson != null) {
      final List<dynamic> decoded = jsonDecode(charactersJson);
      _characters = decoded.map((item) => GameCharacter.fromJson(item)).toList();
    }

    final tournamentsJson = prefs.getString('web3_gaming_tournaments');
    if (tournamentsJson != null) {
      final List<dynamic> decoded = jsonDecode(tournamentsJson);
      _tournaments = decoded.map((item) => Tournament.fromJson(item)).toList();
    }

    final rewardsJson = prefs.getString('web3_gaming_rewards');
    if (rewardsJson != null) {
      final List<dynamic> decoded = jsonDecode(rewardsJson);
      _rewards = decoded.map((item) => GameReward.fromJson(item)).toList();
    }

    final deFiJson = prefs.getString('web3_gaming_defi');
    if (deFiJson != null) {
      final List<dynamic> decoded = jsonDecode(deFiJson);
      _deFiIntegrations = decoded.map((item) => DeFiIntegration.fromJson(item)).toList();
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('web3_gaming_worlds', jsonEncode(_gameWorlds.map((e) => e.toJson()).toList()));
    await prefs.setString('web3_gaming_characters', jsonEncode(_characters.map((e) => e.toJson()).toList()));
    await prefs.setString('web3_gaming_tournaments', jsonEncode(_tournaments.map((e) => e.toJson()).toList()));
    await prefs.setString('web3_gaming_rewards', jsonEncode(_rewards.map((e) => e.toJson()).toList()));
    await prefs.setString('web3_gaming_defi', jsonEncode(_deFiIntegrations.map((e) => e.toJson()).toList()));
  }

  // Create demo data
  void _createDemoData() {
    // Demo Game Worlds
    _gameWorlds = [
      GameWorld(
        id: 'world_1',
        name: 'CryptoQuest RPG',
        description: 'Фэнтезийный мир с блокчейн-экономикой',
        type: GameWorldType.rpg,
        imageUrl: 'https://via.placeholder.com/300x200/4A90E2/FFFFFF?text=CryptoQuest',
        maxPlayers: 10000,
        currentPlayers: 3427,
        tokenPrice: 0.15,
        tokenSymbol: 'CQR',
        metadata: {
          'genre': 'Fantasy RPG',
          'blockchain': 'Ethereum',
          'developer': 'REChain Games',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
      ),
      GameWorld(
        id: 'world_2',
        name: 'DeFi Strategy',
        description: 'Стратегическая игра с DeFi механиками',
        type: GameWorldType.strategy,
        imageUrl: 'https://via.placeholder.com/300x200/50C878/FFFFFF?text=DeFi+Strategy',
        maxPlayers: 5000,
        currentPlayers: 1893,
        tokenPrice: 0.08,
        tokenSymbol: 'DFS',
        metadata: {
          'genre': 'Strategy',
          'blockchain': 'Polygon',
          'developer': 'REChain Games',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        isActive: true,
      ),
    ];

    // Demo Characters
    _characters = [
      GameCharacter(
        id: 'char_1',
        userId: _currentUserId,
        worldId: 'world_1',
        name: 'CryptoKnight',
        characterClass: CharacterClass.warrior,
        level: 15,
        experience: 12500,
        health: 180,
        maxHealth: 180,
        mana: 50,
        maxMana: 50,
        strength: 25,
        agility: 18,
        intelligence: 12,
        inventory: ['Sword of Truth', 'Health Potion x5', 'Magic Ring'],
        skills: ['Slash', 'Charge', 'Defend'],
        stats: {
          'critical_chance': 0.15,
          'dodge_chance': 0.12,
          'block_chance': 0.20,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        lastPlayed: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      GameCharacter(
        id: 'char_2',
        userId: _currentUserId,
        worldId: 'world_2',
        name: 'DeFiWizard',
        characterClass: CharacterClass.mage,
        level: 12,
        experience: 8900,
        health: 120,
        maxHealth: 120,
        mana: 200,
        maxMana: 200,
        strength: 8,
        agility: 15,
        intelligence: 28,
        inventory: ['Staff of Wisdom', 'Mana Crystal', 'Spell Book'],
        skills: ['Fireball', 'Teleport', 'Shield'],
        stats: {
          'spell_power': 0.25,
          'mana_regen': 0.18,
          'spell_critical': 0.20,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastPlayed: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    // Demo Tournaments
    _tournaments = [
      Tournament(
        id: 'tournament_1',
        worldId: 'world_1',
        name: 'Championship of Light',
        description: 'Еженедельный турнир для лучших воинов',
        status: TournamentStatus.active,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 6)),
        maxParticipants: 128,
        participants: ['char_1', 'char_2', 'char_3'],
        winners: [],
        rewards: {
          'first_place': {'tokens': 1000, 'nft': 'Champion\'s Crown'},
          'second_place': {'tokens': 500, 'nft': 'Runner-up Medal'},
          'third_place': {'tokens': 250, 'nft': 'Bronze Trophy'},
        },
        entryFee: 10.0,
        tokenSymbol: 'CQR',
        metadata: {
          'tournament_type': 'PvP',
          'bracket_size': 128,
          'registration_open': true,
        },
      ),
    ];

    // Demo Rewards
    _rewards = [
      GameReward(
        id: 'reward_1',
        userId: _currentUserId,
        worldId: 'world_1',
        characterId: 'char_1',
        type: RewardType.token,
        name: 'Quest Completion',
        description: 'Награда за выполнение главного квеста',
        amount: 150.0,
        tokenSymbol: 'CQR',
        earnedAt: DateTime.now().subtract(const Duration(hours: 3)),
        isClaimed: false,
        metadata: {
          'quest_id': 'main_quest_1',
          'difficulty': 'medium',
        },
      ),
      GameReward(
        id: 'reward_2',
        userId: _currentUserId,
        worldId: 'world_1',
        characterId: 'char_1',
        type: RewardType.nft,
        name: 'Rare Weapon',
        description: 'Редкое оружие за победу в бою',
        amount: 1.0,
        tokenSymbol: 'CQR',
        nftId: 'nft_weapon_1',
        earnedAt: DateTime.now().subtract(const Duration(hours: 1)),
        isClaimed: true,
        metadata: {
          'rarity': 'rare',
          'weapon_type': 'sword',
        },
      ),
    ];

    // Demo DeFi Integrations
    _deFiIntegrations = [
      DeFiIntegration(
        id: 'defi_1',
        worldId: 'world_1',
        type: DeFiIntegrationType.staking,
        protocolName: 'CryptoQuest Staking',
        contractAddress: '0x1234567890abcdef...',
        apy: 12.5,
        tvl: 2500000.0,
        userStake: 500.0,
        userRewards: 25.0,
        lastUpdated: DateTime.now(),
        isActive: true,
        metadata: {
          'lock_period': 30,
          'min_stake': 100.0,
          'reward_token': 'CQR',
        },
      ),
      DeFiIntegration(
        id: 'defi_2',
        worldId: 'world_1',
        type: DeFiIntegrationType.liquidity_providing,
        protocolName: 'CQR-ETH Pool',
        contractAddress: '0xabcdef1234567890...',
        apy: 18.2,
        tvl: 1500000.0,
        userStake: 200.0,
        userRewards: 15.0,
        lastUpdated: DateTime.now(),
        isActive: true,
        metadata: {
          'pair': 'CQR-ETH',
          'fee': 0.003,
          'impermanent_loss': 'low',
        },
      ),
    ];

    _saveData();
  }

  // Game World Management
  void createGameWorld(GameWorld world) {
    _gameWorlds.add(world);
    _saveData();
    notifyListeners();
  }

  void updateGameWorld(String worldId, GameWorld updatedWorld) {
    final index = _gameWorlds.indexWhere((world) => world.id == worldId);
    if (index != -1) {
      _gameWorlds[index] = updatedWorld;
      _saveData();
      notifyListeners();
    }
  }

  // Character Management
  void createCharacter(GameCharacter character) {
    _characters.add(character);
    _saveData();
    notifyListeners();
  }

  void updateCharacter(String characterId, GameCharacter updatedCharacter) {
    final index = _characters.indexWhere((char) => char.id == characterId);
    if (index != -1) {
      _characters[index] = updatedCharacter;
      _saveData();
      notifyListeners();
    }
  }

  void deleteCharacter(String characterId) {
    _characters.removeWhere((char) => char.id == characterId);
    _saveData();
    notifyListeners();
  }

  // Tournament Management
  void createTournament(Tournament tournament) {
    _tournaments.add(tournament);
    _saveData();
    notifyListeners();
  }

  void joinTournament(String tournamentId, String characterId) {
    final tournament = _tournaments.firstWhere((t) => t.id == tournamentId);
    if (!tournament.participants.contains(characterId)) {
      final updatedTournament = tournament.copyWith(
        participants: [...tournament.participants, characterId],
      );
      updateTournament(tournamentId, updatedTournament);
    }
  }

  void updateTournament(String tournamentId, Tournament updatedTournament) {
    final index = _tournaments.indexWhere((t) => t.id == tournamentId);
    if (index != -1) {
      _tournaments[index] = updatedTournament;
      _saveData();
      notifyListeners();
    }
  }

  // Reward Management
  void addReward(GameReward reward) {
    _rewards.add(reward);
    _saveData();
    notifyListeners();
  }

  void claimReward(String rewardId) {
    final index = _rewards.indexWhere((r) => r.id == rewardId);
    if (index != -1) {
      _rewards[index] = _rewards[index].copyWith(isClaimed: true);
      _saveData();
      notifyListeners();
    }
  }

  // DeFi Integration Management
  void addDeFiIntegration(DeFiIntegration integration) {
    _deFiIntegrations.add(integration);
    _saveData();
    notifyListeners();
  }

  void updateDeFiIntegration(String integrationId, DeFiIntegration updatedIntegration) {
    final index = _deFiIntegrations.indexWhere((i) => i.id == integrationId);
    if (index != -1) {
      _deFiIntegrations[index] = updatedIntegration;
      _saveData();
      notifyListeners();
    }
  }

  // Analytics
  double getUserTotalEarnings(String userId) {
    return _rewards
        .where((reward) => reward.userId == userId && reward.isClaimed)
        .fold(0.0, (sum, reward) => sum + reward.amount);
  }

  int getUserTotalCharacters(String userId) {
    return _characters.where((char) => char.userId == userId).length;
  }

  List<GameWorld> getTopGameWorlds() {
    final sorted = List<GameWorld>.from(_gameWorlds);
    sorted.sort((a, b) => b.currentPlayers.compareTo(a.currentPlayers));
    return sorted.take(5).toList();
  }

  List<Tournament> getUpcomingTournaments() {
    return _tournaments
        .where((tournament) => tournament.status == TournamentStatus.upcoming)
        .toList();
  }

  // Search
  List<GameWorld> searchGameWorlds(String query) {
    if (query.isEmpty) return _gameWorlds;
    
    return _gameWorlds.where((world) =>
        world.name.toLowerCase().contains(query.toLowerCase()) ||
        world.description.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<GameCharacter> searchCharacters(String query) {
    if (query.isEmpty) return _characters;
    
    return _characters.where((char) =>
        char.name.toLowerCase().contains(query.toLowerCase()) ||
        char.characterClass.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Utility Methods
  String getGameWorldTypeName(GameWorldType type) {
    switch (type) {
      case GameWorldType.rpg:
        return 'RPG';
      case GameWorldType.strategy:
        return 'Стратегия';
      case GameWorldType.action:
        return 'Экшен';
      case GameWorldType.simulation:
        return 'Симулятор';
      case GameWorldType.puzzle:
        return 'Головоломка';
      case GameWorldType.racing:
        return 'Гонки';
    }
  }

  String getCharacterClassName(CharacterClass characterClass) {
    switch (characterClass) {
      case CharacterClass.warrior:
        return 'Воин';
      case CharacterClass.mage:
        return 'Маг';
      case CharacterClass.archer:
        return 'Лучник';
      case CharacterClass.healer:
        return 'Лекарь';
      case CharacterClass.rogue:
        return 'Разбойник';
      case CharacterClass.tank:
        return 'Танк';
    }
  }

  String getTournamentStatusName(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.upcoming:
        return 'Скоро';
      case TournamentStatus.active:
        return 'Активен';
      case TournamentStatus.completed:
        return 'Завершен';
      case TournamentStatus.cancelled:
        return 'Отменен';
    }
  }

  String getRewardTypeName(RewardType type) {
    switch (type) {
      case RewardType.token:
        return 'Токены';
      case RewardType.nft:
        return 'NFT';
      case RewardType.experience:
        return 'Опыт';
      case RewardType.item:
        return 'Предмет';
      case RewardType.title:
        return 'Титул';
    }
  }

  String getDeFiIntegrationTypeName(DeFiIntegrationType type) {
    switch (type) {
      case DeFiIntegrationType.staking:
        return 'Стейкинг';
      case DeFiIntegrationType.liquidity_providing:
        return 'Ликвидность';
      case DeFiIntegrationType.yield_farming:
        return 'Фарминг';
      case DeFiIntegrationType.lending:
        return 'Кредитование';
      case DeFiIntegrationType.borrowing:
        return 'Заимствование';
    }
  }
}
