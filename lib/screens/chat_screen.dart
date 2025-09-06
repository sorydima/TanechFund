import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/chat_provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чаты'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateChatDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Все'),
            Tab(text: 'Хакатоны'),
            Tab(text: 'Поддержка'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatsList(ChatType.values),
          _buildChatsList([ChatType.hackathon]),
          _buildChatsList([ChatType.support]),
        ],
      ),
    );
  }

  Widget _buildChatsList(List<ChatType> types) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final filteredRooms = chatProvider.chatRooms
            .where((room) => types.contains(room.type))
            .toList()
          ..sort((a, b) => (b.lastMessageTime ?? b.createdAt)
              .compareTo(a.lastMessageTime ?? a.createdAt));

        if (filteredRooms.isEmpty) {
          return _buildEmptyState(types.first);
        }

        return ListView.builder(
          itemCount: filteredRooms.length,
          itemBuilder: (context, index) {
            final room = filteredRooms[index];
            return _buildChatRoomTile(room, chatProvider);
          },
        );
      },
    );
  }

  Widget _buildChatRoomTile(ChatRoom room, ChatProvider chatProvider) {
    final lastMessage = room.lastMessageId != null
        ? chatProvider.messages[room.id]?.firstWhere(
            (msg) => msg.id == room.lastMessageId,
            orElse: () => ChatMessage(
              id: '',
              senderId: '',
              senderName: '',
              content: '',
              type: MessageType.text,
              timestamp: DateTime.now(),
            ),
          )
        : null;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: chatProvider.getChatTypeColor(room.type),
        child: Icon(
          chatProvider.getChatTypeIcon(room.type),
          color: Colors.white,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              room.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (room.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                room.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lastMessage != null)
            Text(
              '${lastMessage.senderName}: ${lastMessage.content}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            _formatTime(room.lastMessageTime ?? room.createdAt),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: () => _openChat(room),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleChatAction(value, room),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'pin',
            child: Row(
              children: [
                Icon(Icons.push_pin),
                SizedBox(width: 8),
                Text('Закрепить'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'mute',
            child: Row(
              children: [
                Icon(Icons.notifications_off),
                SizedBox(width: 8),
                Text('Отключить уведомления'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Удалить', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ChatType type) {
    String message;
    IconData icon;
    
    switch (type) {
      case ChatType.hackathon:
        message = 'У вас пока нет чатов по хакатонам';
        icon = Icons.event;
        break;
      case ChatType.support:
        message = 'Обратитесь в поддержку для создания чата';
        icon = Icons.support_agent;
        break;
      default:
        message = 'У вас пока нет чатов';
        icon = Icons.chat_bubble_outline;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _openChat(ChatRoom room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(chatRoom: room),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поиск по сообщениям'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Введите текст для поиска...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (query) {
            // Поиск будет реализован в ChatProvider
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              // Выполнить поиск
              Navigator.pop(context);
            },
            child: const Text('Найти'),
          ),
        ],
      ),
    );
  }

  void _showCreateChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать новый чат'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Название чата',
                hintText: 'Введите название...',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ChatType>(
              decoration: const InputDecoration(
                labelText: 'Тип чата',
              ),
              items: ChatType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getChatTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              // Создать чат
              Navigator.pop(context);
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _handleChatAction(String action, ChatRoom room) {
    switch (action) {
      case 'pin':
        // Закрепить чат
        break;
      case 'mute':
        // Отключить уведомления
        break;
      case 'delete':
        _showDeleteConfirmation(room);
        break;
    }
  }

  void _showDeleteConfirmation(ChatRoom room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить чат'),
        content: Text('Вы уверены, что хотите удалить чат "${room.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ChatProvider>().deleteChat(room.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return DateFormat('dd.MM').format(time);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}ч назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}м назад';
    } else {
      return 'Только что';
    }
  }

  String _getChatTypeName(ChatType type) {
    switch (type) {
      case ChatType.direct:
        return 'Личный';
      case ChatType.group:
        return 'Групповой';
      case ChatType.hackathon:
        return 'Хакатон';
      case ChatType.challenge:
        return 'Челлендж';
      case ChatType.support:
        return 'Поддержка';
    }
  }
}

class ChatRoomScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatRoomScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Выбрать чат в провайдере
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().selectChat(widget.chatRoom.id);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatRoom.name),
            Text(
              _getChatTypeSubtitle(widget.chatRoom.type),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showChatInfo(),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showChatOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages = chatProvider.currentMessages;
                
                if (messages.isEmpty) {
                  return _buildEmptyChat();
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return _buildMessageTile(message, chatProvider);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Начните разговор!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(ChatMessage message, ChatProvider chatProvider) {
    final isMe = message.senderId == 'user_001';
    final showAvatar = !isMe;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ] else
            const SizedBox(width: 56),
          Expanded(
            child: Column(
              crossAxisAlignment: isMe 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isMe 
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatMessageTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => _showAttachmentOptions(),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Введите сообщение...',
                border: InputBorder.none,
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onChanged: (value) {
                setState(() {
                  _isTyping = value.isNotEmpty;
                });
              },
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          if (_isTyping)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              color: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    context.read<ChatProvider>().sendMessage(
      content: content,
      type: MessageType.text,
    );

    _messageController.clear();
    setState(() {
      _isTyping = false;
    });

    // Прокрутить к последнему сообщению
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Фото'),
              onTap: () {
                Navigator.pop(context);
                // Добавить функционал для фото
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present),
              title: const Text('Файл'),
              onTap: () {
                Navigator.pop(context);
                // Добавить функционал для файлов
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Код'),
              onTap: () {
                Navigator.pop(context);
                // Добавить функционал для кода
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Информация о чате'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Название: ${widget.chatRoom.name}'),
            Text('Тип: ${_getChatTypeName(widget.chatRoom.type)}'),
            Text('Участников: ${widget.chatRoom.participantIds.length}'),
            Text('Создан: ${DateFormat('dd.MM.yyyy').format(widget.chatRoom.createdAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Поиск в чате'),
              onTap: () {
                Navigator.pop(context);
                // Добавить поиск в чате
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off),
              title: const Text('Отключить уведомления'),
              onTap: () {
                Navigator.pop(context);
                // Отключить уведомления
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Удалить чат', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить чат'),
        content: Text('Вы уверены, что хотите удалить чат "${widget.chatRoom.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ChatProvider>().deleteChat(widget.chatRoom.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return DateFormat('dd.MM HH:mm').format(time);
    } else if (difference.inHours > 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}м назад';
    } else {
      return 'Только что';
    }
  }

  String _getChatTypeSubtitle(ChatType type) {
    switch (type) {
      case ChatType.direct:
        return 'Личный чат';
      case ChatType.group:
        return 'Групповой чат';
      case ChatType.hackathon:
        return 'Чат хакатона';
      case ChatType.challenge:
        return 'Чат челленджа';
      case ChatType.support:
        return 'Поддержка';
    }
  }

  String _getChatTypeName(ChatType type) {
    switch (type) {
      case ChatType.direct:
        return 'Личный';
      case ChatType.group:
        return 'Групповой';
      case ChatType.hackathon:
        return 'Хакатон';
      case ChatType.challenge:
        return 'Челлендж';
      case ChatType.support:
        return 'Поддержка';
    }
  }
}
