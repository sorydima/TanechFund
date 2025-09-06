import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum MessageType {
  text,
  image,
  file,
  code,
  system,
}

enum ChatType {
  direct,
  group,
  hackathon,
  challenge,
  support,
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? metadata;
  final String? replyToId;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.metadata,
    this.replyToId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'metadata': metadata,
      'replyToId': replyToId,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
      content: json['content'],
      type: MessageType.values[json['type']],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      metadata: json['metadata'],
      replyToId: json['replyToId'],
    );
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? metadata,
    String? replyToId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
      replyToId: replyToId ?? this.replyToId,
    );
  }
}

class ChatRoom {
  final String id;
  final String name;
  final ChatType type;
  final List<String> participantIds;
  final String? lastMessageId;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.name,
    required this.type,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.metadata,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'participantIds': participantIds,
      'lastMessageId': lastMessageId,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      type: ChatType.values[json['type']],
      participantIds: List<String>.from(json['participantIds']),
      lastMessageId: json['lastMessageId'],
      lastMessageTime: json['lastMessageTime'] != null 
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  ChatRoom copyWith({
    String? id,
    String? name,
    ChatType? type,
    List<String>? participantIds,
    String? lastMessageId,
    DateTime? lastMessageTime,
    int? unreadCount,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ChatProvider extends ChangeNotifier {
  List<ChatRoom> _chatRooms = [];
  Map<String, List<ChatMessage>> _messages = {};
  String? _currentChatId;
  bool _isLoading = false;
  String? _error;

  // Геттеры
  List<ChatRoom> get chatRooms => _chatRooms;
  Map<String, List<ChatMessage>> get messages => _messages;
  String? get currentChatId => _currentChatId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Получение сообщений для текущего чата
  List<ChatMessage> get currentMessages => 
      _currentChatId != null ? _messages[_currentChatId] ?? [] : [];

  // Получение текущего чата
  ChatRoom? get currentChat => 
      _currentChatId != null 
          ? _chatRooms.firstWhere((room) => room.id == _currentChatId)
          : null;

  ChatProvider() {
    _loadChatData();
    _createDemoChats();
  }

  // Загрузка данных чата
  Future<void> _loadChatData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Загрузка чат-комнат
      final roomsJson = prefs.getStringList('chat_rooms') ?? [];
      _chatRooms = roomsJson
          .map((json) => ChatRoom.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка сообщений
      final messagesJson = prefs.getString('chat_messages') ?? '{}';
      final messagesMap = jsonDecode(messagesJson) as Map<String, dynamic>;
      
      _messages = messagesMap.map((roomId, messagesList) {
        final messages = (messagesList as List)
            .map((json) => ChatMessage.fromJson(json))
            .toList();
        return MapEntry(roomId, messages);
      });
      
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки чата: $e';
      notifyListeners();
    }
  }

  // Сохранение данных чата
  Future<void> _saveChatData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Сохранение чат-комнат
      final roomsJson = _chatRooms
          .map((room) => jsonEncode(room.toJson()))
          .toList();
      await prefs.setStringList('chat_rooms', roomsJson);
      
      // Сохранение сообщений
      final messagesMap = _messages.map((roomId, messages) {
        final messagesJson = messages.map((msg) => msg.toJson()).toList();
        return MapEntry(roomId, messagesJson);
      });
      await prefs.setString('chat_messages', jsonEncode(messagesMap));
    } catch (e) {
      _error = 'Ошибка сохранения чата: $e';
      notifyListeners();
    }
  }

  // Создание демо чатов
  void _createDemoChats() {
    if (_chatRooms.isEmpty) {
      final demoRooms = [
        ChatRoom(
          id: 'support_chat',
          name: 'Поддержка REChain',
          type: ChatType.support,
          participantIds: ['user_001', 'support_001'],
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ChatRoom(
          id: 'hackathon_chat',
          name: 'Solana Builders Hackathon',
          type: ChatType.hackathon,
          participantIds: ['user_001', 'hackathon_001', 'mentor_001'],
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        ChatRoom(
          id: 'challenge_chat',
          name: 'DeFi Protocol Challenge',
          type: ChatType.challenge,
          participantIds: ['user_001', 'challenge_001', 'judge_001'],
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];
      
      _chatRooms.addAll(demoRooms);
      
      // Создание демо сообщений
      _createDemoMessages();
      
      _saveChatData();
      notifyListeners();
    }
  }

  // Создание демо сообщений
  void _createDemoMessages() {
    // Сообщения поддержки
    _messages['support_chat'] = [
      ChatMessage(
        id: 'msg_1',
        senderId: 'support_001',
        senderName: 'Поддержка REChain',
        content: 'Добро пожаловать! Чем могу помочь?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_2',
        senderId: 'user_001',
        senderName: 'Вы',
        content: 'Здравствуйте! У меня вопрос по хакатону',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_3',
        senderId: 'support_001',
        senderName: 'Поддержка REChain',
        content: 'Конечно! Расскажите подробнее',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
    ];
    
    // Сообщения хакатона
    _messages['hackathon_chat'] = [
      ChatMessage(
        id: 'msg_4',
        senderId: 'hackathon_001',
        senderName: 'Организатор',
        content: 'Добро пожаловать на хакатон Solana Builders!',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_5',
        senderId: 'mentor_001',
        senderName: 'Ментор',
        content: 'Готов помочь с техническими вопросами',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_6',
        senderId: 'user_001',
        senderName: 'Вы',
        content: 'Спасибо! У меня есть вопрос по Rust',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
    ];
    
    // Сообщения челленджа
    _messages['challenge_chat'] = [
      ChatMessage(
        id: 'msg_7',
        senderId: 'challenge_001',
        senderName: 'Организатор',
        content: 'Челлендж DeFi Protocol начался!',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_8',
        senderId: 'judge_001',
        senderName: 'Судья',
        content: 'Критерии оценки: безопасность, инновационность, масштабируемость',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isRead: true,
      ),
    ];
    
    // Обновление счетчиков непрочитанных
    _updateUnreadCounts();
  }

  // Выбор чата
  void selectChat(String chatId) {
    _currentChatId = chatId;
    
    // Отметить все сообщения как прочитанные
    if (_messages[chatId] != null) {
      _messages[chatId] = _messages[chatId]!.map((msg) => 
          msg.copyWith(isRead: true)).toList();
      
      // Обновить счетчик в чат-комнате
      final roomIndex = _chatRooms.indexWhere((room) => room.id == chatId);
      if (roomIndex != -1) {
        _chatRooms[roomIndex] = _chatRooms[roomIndex].copyWith(unreadCount: 0);
      }
    }
    
    notifyListeners();
  }

  // Отправка сообщения
  Future<void> sendMessage({
    required String content,
    required MessageType type,
    String? replyToId,
    Map<String, dynamic>? metadata,
  }) async {
    if (_currentChatId == null) return;
    
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'user_001', // В реальном приложении из AuthProvider
      senderName: 'Вы',
      content: content,
      type: type,
      timestamp: DateTime.now(),
      replyToId: replyToId,
      metadata: metadata,
    );
    
    // Добавить сообщение
    if (_messages[_currentChatId!] == null) {
      _messages[_currentChatId!] = [];
    }
    _messages[_currentChatId!]!.add(message);
    
    // Обновить чат-комнату
    final roomIndex = _chatRooms.indexWhere((room) => room.id == _currentChatId);
    if (roomIndex != -1) {
      _chatRooms[roomIndex] = _chatRooms[roomIndex].copyWith(
        lastMessageId: message.id,
        lastMessageTime: message.timestamp,
      );
    }
    
    await _saveChatData();
    notifyListeners();
    
    // Имитация ответа (в реальном приложении - WebSocket)
    _simulateResponse();
  }

  // Имитация ответа
  void _simulateResponse() {
    if (_currentChatId == null) return;
    
    Future.delayed(const Duration(seconds: 2), () {
      String responseContent = '';
      String responderName = '';
      String responderId = '';
      
      switch (_currentChatId) {
        case 'support_chat':
          responseContent = 'Спасибо за вопрос! Обрабатываем...';
          responderName = 'Поддержка REChain';
          responderId = 'support_001';
          break;
        case 'hackathon_chat':
          responseContent = 'Отличный вопрос! Давайте разберем подробнее';
          responderName = 'Ментор';
          responderId = 'mentor_001';
          break;
        case 'challenge_chat':
          responseContent = 'Понятно! Продолжайте работу';
          responderName = 'Судья';
          responderId = 'judge_001';
          break;
      }
      
      if (responseContent.isNotEmpty) {
        final response = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: responderId,
          senderName: responderName,
          content: responseContent,
          type: MessageType.text,
          timestamp: DateTime.now(),
        );
        
        _messages[_currentChatId!]!.add(response);
        
        // Обновить счетчик непрочитанных
        final roomIndex = _chatRooms.indexWhere((room) => room.id == _currentChatId);
        if (roomIndex != -1) {
          _chatRooms[roomIndex] = _chatRooms[roomIndex].copyWith(
            lastMessageId: response.id,
            lastMessageTime: response.timestamp,
            unreadCount: _chatRooms[roomIndex].unreadCount + 1,
          );
        }
        
        _saveChatData();
        notifyListeners();
      }
    });
  }

  // Создание нового чата
  Future<void> createChat({
    required String name,
    required ChatType type,
    required List<String> participantIds,
    Map<String, dynamic>? metadata,
  }) async {
    final chatRoom = ChatRoom(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      participantIds: participantIds,
      createdAt: DateTime.now(),
      metadata: metadata,
    );
    
    _chatRooms.add(chatRoom);
    _messages[chatRoom.id] = [];
    
    await _saveChatData();
    notifyListeners();
  }

  // Удаление чата
  Future<void> deleteChat(String chatId) async {
    _chatRooms.removeWhere((room) => room.id == chatId);
    _messages.remove(chatId);
    
    if (_currentChatId == chatId) {
      _currentChatId = null;
    }
    
    await _saveChatData();
    notifyListeners();
  }

  // Поиск по сообщениям
  List<ChatMessage> searchMessages(String query) {
    if (query.isEmpty) return [];
    
    final allMessages = <ChatMessage>[];
    _messages.values.forEach((messages) => allMessages.addAll(messages));
    
    return allMessages.where((msg) =>
        msg.content.toLowerCase().contains(query.toLowerCase()) ||
        msg.senderName.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Получение чатов по типу
  List<ChatRoom> getChatsByType(ChatType type) {
    return _chatRooms.where((room) => room.type == type).toList();
  }

  // Обновление счетчиков непрочитанных
  void _updateUnreadCounts() {
    for (final room in _chatRooms) {
      final unreadCount = _messages[room.id]?.where((msg) => !msg.isRead).length ?? 0;
      final roomIndex = _chatRooms.indexWhere((r) => r.id == room.id);
      if (roomIndex != -1) {
        _chatRooms[roomIndex] = room.copyWith(unreadCount: unreadCount);
      }
    }
  }

  // Получение цвета для типа чата
  Color getChatTypeColor(ChatType type) {
    switch (type) {
      case ChatType.direct:
        return Colors.blue;
      case ChatType.group:
        return Colors.green;
      case ChatType.hackathon:
        return Colors.purple;
      case ChatType.challenge:
        return Colors.orange;
      case ChatType.support:
        return Colors.red;
    }
  }

  // Получение иконки для типа чата
  IconData getChatTypeIcon(ChatType type) {
    switch (type) {
      case ChatType.direct:
        return Icons.person;
      case ChatType.group:
        return Icons.group;
      case ChatType.hackathon:
        return Icons.event;
      case ChatType.challenge:
        return Icons.emoji_events;
      case ChatType.support:
        return Icons.support_agent;
    }
  }

  // Очистка ошибки
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
