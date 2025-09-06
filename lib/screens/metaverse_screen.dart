import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/metaverse_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:intl/intl.dart';

class MetaverseScreen extends StatefulWidget {
  const MetaverseScreen({super.key});

  @override
  State<MetaverseScreen> createState() => _MetaverseScreenState();
}

class _MetaverseScreenState extends State<MetaverseScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MetaverseProvider>().initialize();
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
      body: Column(
        children: [
          // Заголовок
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.view_in_ar,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Web4 Метавселенная',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Виртуальные пространства и события',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Поиск
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Поиск пространств, событий, аватаров...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Вкладки
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'Пространства', icon: Icon(Icons.space_dashboard)),
                Tab(text: 'Аватары', icon: Icon(Icons.person)),
                Tab(text: 'События', icon: Icon(Icons.event)),
                Tab(text: 'Галереи', icon: Icon(Icons.photo_library)),
              ],
            ),
          ),
          
          // Содержимое вкладок
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSpacesTab(),
                _buildAvatarsTab(),
                _buildEventsTab(),
                _buildGalleriesTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSpaceDialog(),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Вкладка виртуальных пространств
  Widget _buildSpacesTab() {
    return Consumer<MetaverseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final spaces = _searchQuery.isEmpty
            ? provider.spaces
            : provider.searchSpaces(_searchQuery);

        if (spaces.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.space_dashboard,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty ? 'Нет пространств' : 'Пространства не найдены',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: spaces.length,
          itemBuilder: (context, index) {
            final space = spaces[index];
            return _buildSpaceCard(space, provider);
          },
        );
      },
    );
  }

  // Вкладка аватаров
  Widget _buildAvatarsTab() {
    return Consumer<MetaverseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final avatars = provider.avatars;

        if (avatars.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Нет аватаров',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            final avatar = avatars[index];
            return _buildAvatarCard(avatar);
          },
        );
      },
    );
  }

  // Вкладка событий
  Widget _buildEventsTab() {
    return Consumer<MetaverseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = provider.getUpcomingEvents();

        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Нет предстоящих событий',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventCard(event, provider);
          },
        );
      },
    );
  }

  // Вкладка галерей
  Widget _buildGalleriesTab() {
    return Consumer<MetaverseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final galleries = provider.galleries;

        if (galleries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Нет галерей',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: galleries.length,
          itemBuilder: (context, index) {
            final gallery = galleries[index];
            return _buildGalleryCard(gallery, provider);
          },
        );
      },
    );
  }

  // Построение карточки пространства
  Widget _buildSpaceCard(VirtualSpace space, MetaverseProvider provider) {
    final isCurrentSpace = provider.currentSpaceId == space.id;
    final occupancyRate = space.currentUsers / space.maxCapacity;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение пространства
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.grey[100],
            ),
            child: space.imageUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      space.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : Center(
                    child: Icon(
                      _getSpaceTypeIcon(space.spaceType),
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и статус
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        space.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(space.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        space.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(space.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Описание
                Text(
                  space.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Теги
                Wrap(
                  spacing: 8,
                  children: space.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Заполненность
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Заполненность',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '${(occupancyRate * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: occupancyRate,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${space.currentUsers} / ${space.maxCapacity} пользователей',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Кнопки действий
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isCurrentSpace ? null : () {
                          provider.enterSpace(space.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Вы вошли в ${space.name}')),
                          );
                        },
                        icon: Icon(
                          isCurrentSpace ? Icons.check : Icons.login,
                          size: 18,
                        ),
                        label: Text(
                          isCurrentSpace ? 'Вы здесь' : 'Войти',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCurrentSpace ? Colors.green : AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showSpaceDetails(space),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('Подробнее'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                        ),
                      ),
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

  // Построение карточки аватара
  Widget _buildAvatarCard(Avatar avatar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Аватар
            CircleAvatar(
              radius: 40,
              backgroundImage: avatar.avatarUrl != null
                  ? NetworkImage(avatar.avatarUrl!)
                  : null,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              child: avatar.avatarUrl == null
                  ? Text(
                      avatar.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    avatar.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Опыт: ${avatar.stats['experience']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Репутация: ${avatar.stats['reputation']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: avatar.accessories.take(3).map((accessory) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        accessory,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
            
            IconButton(
              onPressed: () => _showAvatarDetails(avatar),
              icon: Icon(
                Icons.edit,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Построение карточки события
  Widget _buildEventCard(MetaverseEvent event, MetaverseProvider provider) {
    final space = provider.getSpaceById(event.spaceId);
    final isAttending = event.attendees.contains(provider.currentUserId);
    final timeUntilStart = event.startTime.difference(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статус
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getEventStatusColor(event.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    event.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getEventStatusColor(event.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Описание
            Text(
              event.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Время и место
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(event.startTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  space?.name ?? 'Неизвестное место',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Участники
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${event.currentAttendees}/${event.maxAttendees} участников',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Теги
            Wrap(
              spacing: 8,
              children: event.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isAttending ? null : () {
                      // TODO: Реализовать регистрацию на событие
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Регистрация будет реализована')),
                      );
                    },
                    icon: Icon(
                      isAttending ? Icons.check : Icons.event_available,
                      size: 18,
                    ),
                    label: Text(
                      isAttending ? 'Зарегистрированы' : 'Зарегистрироваться',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAttending ? Colors.green : AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showEventDetails(event),
                    icon: const Icon(Icons.info, size: 18),
                    label: const Text('Подробнее'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Построение карточки галереи
  Widget _buildGalleryCard(NFTGallery gallery, MetaverseProvider provider) {
    final space = provider.getSpaceById(gallery.spaceId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статус
            Row(
              children: [
                Expanded(
                  child: Text(
                    gallery.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getGalleryStatusColor(gallery.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    gallery.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getGalleryStatusColor(gallery.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Описание
            Text(
              gallery.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Местоположение
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  space?.name ?? 'Неизвестное место',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Коллекции
            Row(
              children: [
                Icon(Icons.collections, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${gallery.nftCollections.length} коллекций',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Реализовать вход в галерею
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Вход в галерею будет реализован')),
                      );
                    },
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: const Text('Посетить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showGalleryDetails(gallery),
                    icon: const Icon(Icons.info, size: 18),
                    label: const Text('Подробнее'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательные методы
  IconData _getSpaceTypeIcon(String spaceType) {
    switch (spaceType) {
      case 'conference':
        return Icons.meeting_room;
      case 'exhibition':
        return Icons.explore;
      case 'networking':
        return Icons.people;
      case 'workshop':
        return Icons.build;
      case 'showcase':
        return Icons.show_chart;
      default:
        return Icons.space_dashboard;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'private':
        return Colors.orange;
      case 'maintenance':
        return Colors.red;
      case 'full':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getEventStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'live':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getGalleryStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'maintenance':
        return Colors.orange;
      case 'private':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Диалоги (заглушки)
  void _showCreateSpaceDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Создание пространства будет реализовано')),
    );
  }

  void _showSpaceDetails(VirtualSpace space) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Детали пространства ${space.name} будут реализованы')),
    );
  }

  void _showAvatarDetails(Avatar avatar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Редактирование аватара ${avatar.name} будет реализовано')),
    );
  }

  void _showEventDetails(MetaverseEvent event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Детали события ${event.name} будут реализованы')),
    );
  }

  void _showGalleryDetails(NFTGallery gallery) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Детали галереи ${gallery.name} будут реализованы')),
    );
  }
}
