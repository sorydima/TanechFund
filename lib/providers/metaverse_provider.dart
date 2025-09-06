import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

// Web4 Метавселенная модели
class VirtualSpace {
  final String id;
  final String name;
  final String description;
  final String spaceType; // 'conference', 'exhibition', 'networking', 'workshop', 'showcase'
  final String? imageUrl;
  final String? backgroundUrl;
  final int maxCapacity;
  final int currentUsers;
  final List<String> tags;
  final Map<String, dynamic> settings;
  final List<String> connectedSpaces;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isActive;
  final String status; // 'open', 'private', 'maintenance', 'full'

  VirtualSpace({
    required this.id,
    required this.name,
    required this.description,
    required this.spaceType,
    this.imageUrl,
    this.backgroundUrl,
    required this.maxCapacity,
    required this.currentUsers,
    required this.tags,
    required this.settings,
    required this.connectedSpaces,
    required this.createdAt,
    required this.lastUpdated,
    required this.isActive,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'spaceType': spaceType,
    'imageUrl': imageUrl,
    'backgroundUrl': backgroundUrl,
    'maxCapacity': maxCapacity,
    'currentUsers': currentUsers,
    'tags': tags,
    'settings': settings,
    'connectedSpaces': connectedSpaces,
    'createdAt': createdAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'isActive': isActive,
    'status': status,
  };

  factory VirtualSpace.fromJson(Map<String, dynamic> json) => VirtualSpace(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    spaceType: json['spaceType'],
    imageUrl: json['imageUrl'],
    backgroundUrl: json['backgroundUrl'],
    maxCapacity: json['maxCapacity'],
    currentUsers: json['currentUsers'],
    tags: List<String>.from(json['tags']),
    settings: Map<String, dynamic>.from(json['settings']),
    connectedSpaces: List<String>.from(json['connectedSpaces']),
    createdAt: DateTime.parse(json['createdAt']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
    isActive: json['isActive'],
    status: json['status'],
  );
}

class Avatar {
  final String id;
  final String userId;
  final String name;
  final String? avatarUrl;
  final String? modelUrl;
  final Map<String, dynamic> appearance;
  final List<String> accessories;
  final List<String> animations;
  final Map<String, dynamic> stats;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isCustomized;

  Avatar({
    required this.id,
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.modelUrl,
    required this.appearance,
    required this.accessories,
    required this.animations,
    required this.stats,
    required this.createdAt,
    required this.lastUpdated,
    required this.isCustomized,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'avatarUrl': avatarUrl,
    'modelUrl': modelUrl,
    'appearance': appearance,
    'accessories': accessories,
    'animations': animations,
    'stats': stats,
    'createdAt': createdAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'isCustomized': isCustomized,
  };

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    avatarUrl: json['avatarUrl'],
    modelUrl: json['modelUrl'],
    appearance: Map<String, dynamic>.from(json['appearance']),
    accessories: List<String>.from(json['accessories']),
    animations: List<String>.from(json['animations']),
    stats: Map<String, dynamic>.from(json['stats']),
    createdAt: DateTime.parse(json['createdAt']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
    isCustomized: json['isCustomized'],
  );
}

class MetaverseEvent {
  final String id;
  final String name;
  final String description;
  final String eventType; // 'conference', 'workshop', 'networking', 'exhibition', 'pitch'
  final String spaceId;
  final DateTime startTime;
  final DateTime endTime;
  final int maxAttendees;
  final int currentAttendees;
  final List<String> speakers;
  final List<String> attendees;
  final Map<String, dynamic> agenda;
  final List<String> tags;
  final String status; // 'upcoming', 'live', 'completed', 'cancelled'
  final bool isPrivate;
  final String? recordingUrl;
  final Map<String, dynamic> metadata;

  MetaverseEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.eventType,
    required this.spaceId,
    required this.startTime,
    required this.endTime,
    required this.maxAttendees,
    required this.currentAttendees,
    required this.speakers,
    required this.attendees,
    required this.agenda,
    required this.tags,
    required this.status,
    required this.isPrivate,
    this.recordingUrl,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'eventType': eventType,
    'spaceId': spaceId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'maxAttendees': maxAttendees,
    'currentAttendees': currentAttendees,
    'speakers': speakers,
    'attendees': attendees,
    'agenda': agenda,
    'tags': tags,
    'status': status,
    'isPrivate': isPrivate,
    'recordingUrl': recordingUrl,
    'metadata': metadata,
  };

  factory MetaverseEvent.fromJson(Map<String, dynamic> json) => MetaverseEvent(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    eventType: json['eventType'],
    spaceId: json['spaceId'],
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    maxAttendees: json['maxAttendees'],
    currentAttendees: json['currentAttendees'],
    speakers: List<String>.from(json['speakers']),
    attendees: List<String>.from(json['attendees']),
    agenda: Map<String, dynamic>.from(json['agenda']),
    tags: List<String>.from(json['tags']),
    status: json['status'],
    isPrivate: json['isPrivate'],
    recordingUrl: json['recordingUrl'],
    metadata: Map<String, dynamic>.from(json['metadata']),
  );
}

class NFTGallery {
  final String id;
  final String name;
  final String description;
  final String spaceId;
  final List<String> nftCollections;
  final List<String> featuredNFTs;
  final Map<String, dynamic> layout;
  final List<String> curators;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isPublic;
  final String status; // 'active', 'maintenance', 'private'

  NFTGallery({
    required this.id,
    required this.name,
    required this.description,
    required this.spaceId,
    required this.nftCollections,
    required this.featuredNFTs,
    required this.layout,
    required this.curators,
    required this.createdAt,
    required this.lastUpdated,
    required this.isPublic,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'spaceId': spaceId,
    'nftCollections': nftCollections,
    'featuredNFTs': featuredNFTs,
    'layout': layout,
    'curators': curators,
    'createdAt': createdAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'isPublic': isPublic,
    'status': status,
  };

  factory NFTGallery.fromJson(Map<String, dynamic> json) => NFTGallery(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    spaceId: json['spaceId'],
    nftCollections: List<String>.from(json['nftCollections']),
    featuredNFTs: List<String>.from(json['featuredNFTs']),
    layout: Map<String, dynamic>.from(json['layout']),
    curators: List<String>.from(json['curators']),
    createdAt: DateTime.parse(json['createdAt']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
    isPublic: json['isPublic'],
    status: json['status'],
  );
}

class MetaverseProvider extends ChangeNotifier {
  List<VirtualSpace> _spaces = [];
  List<Avatar> _avatars = [];
  List<MetaverseEvent> _events = [];
  List<NFTGallery> _galleries = [];
  String? _currentUserId;
  String? _currentSpaceId;
  bool _isLoading = false;

  // Геттеры
  List<VirtualSpace> get spaces => _spaces;
  List<Avatar> get avatars => _avatars;
  List<MetaverseEvent> get events => _events;
  List<NFTGallery> get galleries => _galleries;
  String? get currentUserId => _currentUserId;
  String? get currentSpaceId => _currentSpaceId;
  bool get isLoading => _isLoading;

  // Инициализация
  Future<void> initialize() async {
    await _loadData();
    if (_spaces.isEmpty) {
      _createDemoData();
    }
  }

  // Загрузка данных
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Загрузка виртуальных пространств
      final spacesJson = prefs.getStringList('virtual_spaces') ?? [];
      _spaces = spacesJson
          .map((json) => VirtualSpace.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка аватаров
      final avatarsJson = prefs.getStringList('avatars') ?? [];
      _avatars = avatarsJson
          .map((json) => Avatar.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка событий
      final eventsJson = prefs.getStringList('metaverse_events') ?? [];
      _events = eventsJson
          .map((json) => MetaverseEvent.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка галерей
      final galleriesJson = prefs.getStringList('nft_galleries') ?? [];
      _galleries = galleriesJson
          .map((json) => NFTGallery.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка текущего состояния
      _currentUserId = prefs.getString('current_user_id');
      _currentSpaceId = prefs.getString('current_space_id');
    } catch (e) {
      debugPrint('Ошибка загрузки данных метавселенной: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Сохранение данных
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Сохранение виртуальных пространств
      final spacesJson = _spaces
          .map((s) => jsonEncode(s.toJson()))
          .toList();
      await prefs.setStringList('virtual_spaces', spacesJson);
      
      // Сохранение аватаров
      final avatarsJson = _avatars
          .map((a) => jsonEncode(a.toJson()))
          .toList();
      await prefs.setStringList('avatars', avatarsJson);
      
      // Сохранение событий
      final eventsJson = _events
          .map((e) => jsonEncode(e.toJson()))
          .toList();
      await prefs.setStringList('metaverse_events', eventsJson);
      
      // Сохранение галерей
      final galleriesJson = _galleries
          .map((g) => jsonEncode(g.toJson()))
          .toList();
      await prefs.setStringList('nft_galleries', galleriesJson);
      
      // Сохранение текущего состояния
      if (_currentUserId != null) {
        await prefs.setString('current_user_id', _currentUserId!);
      }
      if (_currentSpaceId != null) {
        await prefs.setString('current_space_id', _currentSpaceId!);
      }
    } catch (e) {
      debugPrint('Ошибка сохранения данных метавселенной: $e');
    }
  }

  // Создание демо-данных
  void _createDemoData() {
    // Демо-виртуальные пространства
    _spaces = [
      VirtualSpace(
        id: '1',
        name: 'REChain Conference Hall',
        description: 'Главный зал для конференций и презентаций стартапов',
        spaceType: 'conference',
        imageUrl: 'https://via.placeholder.com/400/6366f1/ffffff?text=Conference+Hall',
        maxCapacity: 500,
        currentUsers: 127,
        tags: ['Conference', 'Presentations', 'Networking'],
        settings: {
          'audio': true,
          'video': true,
          'chat': true,
          'screen_sharing': true,
        },
        connectedSpaces: ['2', '3'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastUpdated: DateTime.now(),
        isActive: true,
        status: 'open',
      ),
      VirtualSpace(
        id: '2',
        name: 'Startup Exhibition Center',
        description: 'Виртуальная выставка проектов и демо-стенды',
        spaceType: 'exhibition',
        imageUrl: 'https://via.placeholder.com/400/10b981/ffffff?text=Exhibition+Center',
        maxCapacity: 200,
        currentUsers: 89,
        tags: ['Exhibition', 'Demo', 'Showcase'],
        settings: {
          'audio': true,
          'video': false,
          'chat': true,
          'interactive': true,
        },
        connectedSpaces: ['1', '4'],
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        lastUpdated: DateTime.now(),
        isActive: true,
        status: 'open',
      ),
      VirtualSpace(
        id: '3',
        name: 'Investor Networking Lounge',
        description: 'Приватная зона для общения инвесторов и стартапов',
        spaceType: 'networking',
        imageUrl: 'https://via.placeholder.com/400/f59e0b/ffffff?text=Networking+Lounge',
        maxCapacity: 50,
        currentUsers: 23,
        tags: ['Networking', 'Private', 'Investors'],
        settings: {
          'audio': true,
          'video': true,
          'chat': true,
          'private_rooms': true,
        },
        connectedSpaces: ['1'],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastUpdated: DateTime.now(),
        isActive: true,
        status: 'open',
      ),
    ];

    // Демо-аватары
    _avatars = [
      Avatar(
        id: '1',
        userId: 'user_1',
        name: 'Crypto Explorer',
        avatarUrl: 'https://via.placeholder.com/150/6366f1/ffffff?text=CE',
        appearance: {
          'hair_color': 'brown',
          'eye_color': 'blue',
          'height': '180',
          'build': 'athletic',
        },
        accessories: ['VR Headset', 'Smart Watch', 'Crypto Badge'],
        animations: ['wave', 'point', 'clap'],
        stats: {
          'experience': 150,
          'reputation': 95,
          'events_attended': 25,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        lastUpdated: DateTime.now(),
        isCustomized: true,
      ),
      Avatar(
        id: '2',
        userId: 'user_2',
        name: 'Web3 Investor',
        avatarUrl: 'https://via.placeholder.com/150/10b981/ffffff?text=WI',
        appearance: {
          'hair_color': 'black',
          'eye_color': 'green',
          'height': '175',
          'build': 'slim',
        },
        accessories: ['Business Suit', 'Portfolio', 'Investor Badge'],
        animations: ['handshake', 'present', 'think'],
        stats: {
          'experience': 300,
          'reputation': 98,
          'events_attended': 45,
        },
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        lastUpdated: DateTime.now(),
        isCustomized: true,
      ),
    ];

    // Демо-события
    _events = [
      MetaverseEvent(
        id: '1',
        name: 'Web3 Startup Pitch Day',
        description: 'Ежедневные питчи стартапов перед инвесторами',
        eventType: 'pitch',
        spaceId: '1',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 4)),
        maxAttendees: 200,
        currentAttendees: 156,
        speakers: ['speaker_1', 'speaker_2'],
        attendees: ['user_1', 'user_2', 'user_3'],
        agenda: {
          '14:00': 'Opening Remarks',
          '14:15': 'Startup Pitches',
          '15:30': 'Q&A Session',
          '16:00': 'Networking',
        },
        tags: ['Pitch', 'Investment', 'Startups'],
        status: 'upcoming',
        isPrivate: false,
        metadata: {
          'category': 'investment',
          'difficulty': 'intermediate',
        },
      ),
      MetaverseEvent(
        id: '2',
        name: 'NFT Art Gallery Opening',
        description: 'Открытие виртуальной галереи NFT искусства',
        eventType: 'exhibition',
        spaceId: '2',
        startTime: DateTime.now().add(const Duration(days: 1)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        maxAttendees: 100,
        currentAttendees: 67,
        speakers: ['artist_1', 'curator_1'],
        attendees: ['user_1', 'user_4', 'user_5'],
        agenda: {
          '18:00': 'Gallery Opening',
          '18:30': 'Artist Presentations',
          '19:30': 'Virtual Tour',
          '20:00': 'Auction Preview',
        },
        tags: ['NFT', 'Art', 'Gallery'],
        status: 'upcoming',
        isPrivate: false,
        metadata: {
          'category': 'art',
          'difficulty': 'beginner',
        },
      ),
    ];

    // Демо-галереи
    _galleries = [
      NFTGallery(
        id: '1',
        name: 'Startup Achievement Gallery',
        description: 'Коллекция NFT достижений и наград стартапов',
        spaceId: '2',
        nftCollections: ['startup_badges', 'achievement_tokens'],
        featuredNFTs: ['nft_1', 'nft_2', 'nft_3'],
        layout: {
          'style': 'modern',
          'lighting': 'dynamic',
          'interactive': true,
        },
        curators: ['curator_1', 'curator_2'],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastUpdated: DateTime.now(),
        isPublic: true,
        status: 'active',
      ),
    ];

    _saveData();
  }

  // Методы для пространств
  Future<void> createSpace(VirtualSpace space) async {
    _spaces.add(space);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateSpace(VirtualSpace space) async {
    final index = _spaces.indexWhere((s) => s.id == space.id);
    if (index != -1) {
      _spaces[index] = space;
      await _saveData();
      notifyListeners();
    }
  }

  VirtualSpace? getSpaceById(String id) {
    try {
      return _spaces.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  List<VirtualSpace> getSpacesByType(String type) {
    return _spaces.where((s) => s.spaceType == type).toList();
  }

  // Методы для аватаров
  Future<void> createAvatar(Avatar avatar) async {
    _avatars.add(avatar);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateAvatar(Avatar avatar) async {
    final index = _avatars.indexWhere((a) => a.id == avatar.id);
    if (index != -1) {
      _avatars[index] = avatar;
      await _saveData();
      notifyListeners();
    }
  }

  Avatar? getAvatarByUserId(String userId) {
    try {
      return _avatars.firstWhere((a) => a.userId == userId);
    } catch (e) {
      return null;
    }
  }

  // Методы для событий
  Future<void> createEvent(MetaverseEvent event) async {
    _events.add(event);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateEvent(MetaverseEvent event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      await _saveData();
      notifyListeners();
    }
  }

  List<MetaverseEvent> getEventsBySpace(String spaceId) {
    return _events.where((e) => e.spaceId == spaceId).toList();
  }

  List<MetaverseEvent> getUpcomingEvents() {
    return _events.where((e) => e.startTime.isAfter(DateTime.now())).toList();
  }

  // Методы для галерей
  Future<void> createGallery(NFTGallery gallery) async {
    _galleries.add(gallery);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateGallery(NFTGallery gallery) async {
    final index = _galleries.indexWhere((g) => g.id == gallery.id);
    if (index != -1) {
      _galleries[index] = gallery;
      await _saveData();
      notifyListeners();
    }
  }

  NFTGallery? getGalleryById(String id) {
    try {
      return _galleries.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  // Методы для навигации
  Future<void> enterSpace(String spaceId) async {
    _currentSpaceId = spaceId;
    await _saveData();
    notifyListeners();
  }

  Future<void> exitSpace() async {
    _currentSpaceId = null;
    await _saveData();
    notifyListeners();
  }

  Future<void> setCurrentUser(String userId) async {
    _currentUserId = userId;
    await _saveData();
    notifyListeners();
  }

  // Методы для поиска
  List<VirtualSpace> searchSpaces(String query) {
    return _spaces.where((space) {
      return space.name.toLowerCase().contains(query.toLowerCase()) ||
             space.description.toLowerCase().contains(query.toLowerCase()) ||
             space.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  List<MetaverseEvent> searchEvents(String query) {
    return _events.where((event) {
      return event.name.toLowerCase().contains(query.toLowerCase()) ||
             event.description.toLowerCase().contains(query.toLowerCase()) ||
             event.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
}
