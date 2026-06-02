import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Лента социальной сети — посты, обновления проектов, достижения
class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  bool _isLoading = false;
  String _activeFilter = 'all';

  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'type': 'project',
      'user': {
        'name': 'Алексей Петров',
        'avatar': 'https://i.pravatar.cc/150?img=1',
        'role': 'Developer',
      },
      'content': 'Запустили новый DeFi протокол! 🚀',
      'project': {
        'title': 'DeFi Swap Protocol',
        'category': 'DeFi',
        'image': 'https://example.com/defi.png',
      },
      'likes': 142,
      'comments': 23,
      'shares': 12,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isLiked': false,
    },
    {
      'id': '2',
      'type': 'achievement',
      'user': {
        'name': 'Мария Иванова',
        'avatar': 'https://i.pravatar.cc/150?img=2',
        'role': 'Investor',
      },
      'content': 'Получила достижение "Top Investor" за поддержку 10+ проектов! 🏆',
      'achievement': {
        'title': 'Top Investor',
        'icon': Icons.emoji_events,
        'color': Colors.amber,
      },
      'likes': 256,
      'comments': 45,
      'shares': 8,
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'isLiked': true,
    },
    {
      'id': '3',
      'type': 'update',
      'user': {
        'name': 'Blockchain Studio',
        'avatar': 'https://i.pravatar.cc/150?img=3',
        'role': 'Team',
      },
      'content': 'Обновление v2.0 уже доступно! Новые возможности для NFT маркетплейса.',
      'update': {
        'version': '2.0.0',
        'changes': ['NFT minting', 'Auction system', 'Royalties'],
      },
      'likes': 89,
      'comments': 15,
      'shares': 20,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isLiked': false,
    },
    {
      'id': '4',
      'type': 'milestone',
      'user': {
        'name': 'Crypto Gaming DAO',
        'avatar': 'https://i.pravatar.cc/150?img=4',
        'role': 'DAO',
      },
      'content': 'Достигли цели в \$1M! Спасибо всем инвесторам! 🎉',
      'milestone': {
        'title': 'Funding Goal',
        'amount': '\$1,000,000',
        'icon': Icons.flag,
        'color': Colors.green,
      },
      'likes': 512,
      'comments': 98,
      'shares': 67,
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лента'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshFeed,
            tooltip: 'Обновить',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Фильтр',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        color: AppTheme.primaryColor,
        child: CustomScrollView(
          slivers: [
            // Stories
            SliverToBoxAdapter(
              child: _buildStories(),
            ),
            
            // Filter tabs
            SliverToBoxAdapter(
              child: _buildFilterTabs(),
            ),
            
            // Posts list
            _isLoading
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final filteredPosts = _getFilteredPosts();
                        if (index >= filteredPosts.length) return null;
                        return _buildPostCard(filteredPosts[index], index);
                      },
                      childCount: _getFilteredPosts().length,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createPost(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.edit),
      ),
    );
  }

  // Stories
  Widget _buildStories() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 6,
        itemBuilder: (context, index) {
          final hasStory = index < 4;
          return Container(
            width: 70,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: hasStory
                            ? LinearGradient(
                                colors: [
                                  AppTheme.primaryColor,
                                  AppTheme.accentColor,
                                ],
                              )
                            : null,
                        border: hasStory
                            ? const Border.fromBorderSide(
                                BorderSide(color: AppTheme.primaryColor, width: 3),
                              )
                            : null,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: ClipOval(
                          child: Image.network(
                            'https://i.pravatar.cc/150?img=${index + 1}',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.person, color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index == 0)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  index == 0 ? 'Вы' : 'User ${index + 1}',
                  style: const TextStyle(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ).animate()
            .scale(delay: Duration(milliseconds: index * 50));
        },
      ),
    );
  }

  // Filter tabs
  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterTab('Все', 'all'),
            _buildFilterTab('Проекты', 'project'),
            _buildFilterTab('Достижения', 'achievement'),
            _buildFilterTab('Обновления', 'update'),
            _buildFilterTab('События', 'milestone'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, String value) {
    final isSelected = _activeFilter == value;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _activeFilter = value);
        },
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  // Post card
  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(post['user']['avatar']),
                    onBackgroundImageError: (_, __) {},
                    child: post['user']['avatar'].isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['user']['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              post['user']['role'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '• ${_formatTimestamp(post['timestamp'])}',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => _showPostOptions(post),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post['content'],
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),

            // Project/Attachment preview
            if (post.containsKey('project')) _buildProjectPreview(post['project']),
            if (post.containsKey('achievement')) _buildAchievementPreview(post['achievement']),
            if (post.containsKey('update')) _buildUpdatePreview(post['update']),
            if (post.containsKey('milestone')) _buildMilestonePreview(post['milestone']),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.favorite, size: 16, color: post['isLiked'] ? Colors.red : Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text('${post['likes']}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(width: 16),
                  Icon(Icons.comment, size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text('${post['comments']}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(width: 16),
                  Icon(Icons.share, size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text('${post['shares']}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),

            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    label: 'Нравится',
                    color: post['isLiked'] ? Colors.red : (Colors.grey[600] ?? Colors.grey),
                    onPressed: () => _toggleLike(post),
                  ),
                  _buildActionButton(
                    icon: Icons.comment_outlined,
                    label: 'Коммент',
                    color: Colors.grey[600] ?? Colors.grey,
                    onPressed: () => _showComments(post),
                  ),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: 'Поделиться',
                    color: Colors.grey[600] ?? Colors.grey,
                    onPressed: () => _sharePost(post),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 100))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildProjectPreview(Map<String, dynamic> project) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: AppTheme.primaryColor.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.business, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      project['category'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () => _openProject(project),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementPreview(Map<String, dynamic> achievement) {
    final color = achievement['color'] as Color;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement['icon'] as IconData,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Достижение',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  achievement['title'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatePreview(Map<String, dynamic> update) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.new_releases, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Версия ${update['version']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(update['changes'] as List).map((change) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text(change),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMilestonePreview(Map<String, dynamic> milestone) {
    final color = milestone['color'] as Color;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              milestone['icon'] as IconData,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  milestone['amount'] as String,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.celebration, size: 40, color: Colors.amber),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: color, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredPosts() {
    if (_activeFilter == 'all') return _posts;
    return _posts.where((post) => post['type'] == _activeFilter).toList();
  }

  Future<void> _refreshFeed() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  void _showFilterDialog() {
    AppLogger.info('Show filter dialog');
  }

  void _createPost() {
    AppLogger.info('Create new post');
  }

  void _toggleLike(Map<String, dynamic> post) {
    setState(() {
      post['isLiked'] = !post['isLiked'];
      post['likes'] = post['isLiked'] ? post['likes'] + 1 : post['likes'] - 1;
    });
  }

  void _showPostOptions(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Пожаловаться'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Заблокировать'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Поделиться'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showComments(Map<String, dynamic> post) {
    AppLogger.info('Show comments for post ${post['id']}');
  }

  void _sharePost(Map<String, dynamic> post) {
    AppLogger.info('Share post ${post['id']}');
  }

  void _openProject(Map<String, dynamic> project) {
    AppLogger.info('Open project ${project['title']}');
  }

  String _formatTimestamp(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inHours < 1) return '${diff.inMinutes}м';
    if (diff.inDays < 1) return '${diff.inHours}ч';
    if (diff.inDays < 7) return '${diff.inDays}д';
    return '${diff.inDays ~/ 7}н';
  }
}
