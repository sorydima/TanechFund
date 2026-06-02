import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Экран проектов хакатона — список, фильтрация, голосование
class HackathonProjectsScreen extends StatefulWidget {
  const HackathonProjectsScreen({super.key});

  @override
  State<HackathonProjectsScreen> createState() => _HackathonProjectsScreenState();
}

class _HackathonProjectsScreenState extends State<HackathonProjectsScreen> {
  String _selectedTrack = 'all';
  String _sortBy = 'popular';
  bool _showVotedOnly = false;

  final List<Map<String, dynamic>> _projects = [
    {
      'id': '1',
      'title': 'DeFi Lending Protocol',
      'team': 'CryptoBuilders',
      'track': 'defi',
      'description': 'Децентрализованный протокол кредитования с алгоритмическими ставками',
      'members': 4,
      'votes': 342,
      'rank': 1,
      'technologies': ['Solidity', 'React', 'Node.js'],
      'hasVideo': true,
      'hasDemo': true,
      'voted': false,
      'images': ['https://example.com/project1.png'],
    },
    {
      'id': '2',
      'title': 'NFT Marketplace Pro',
      'team': 'ArtChain',
      'track': 'nft',
      'description': 'Мультичейн NFT маркетплейс с поддержкой редких токенов',
      'members': 3,
      'votes': 289,
      'rank': 2,
      'technologies': ['Rust', 'Next.js', 'IPFS'],
      'hasVideo': true,
      'hasDemo': true,
      'voted': true,
      'images': ['https://example.com/project2.png'],
    },
    {
      'id': '3',
      'title': 'DAO Governance Tool',
      'team': 'DecentraTeam',
      'track': 'dao',
      'description': 'Инструмент для управления DAO с квадратным голосованием',
      'members': 5,
      'votes': 256,
      'rank': 3,
      'technologies': ['TypeScript', 'GraphQL', 'PostgreSQL'],
      'hasVideo': false,
      'hasDemo': true,
      'voted': false,
      'images': [],
    },
    {
      'id': '4',
      'title': 'GameFi Platform',
      'team': 'GameChain',
      'track': 'gaming',
      'description': 'Платформа для Play-to-Earn игр с кросс-чейн активами',
      'members': 6,
      'votes': 198,
      'rank': 4,
      'technologies': ['Unity', 'C#', 'Blockchain'],
      'hasVideo': true,
      'hasDemo': false,
      'voted': false,
      'images': ['https://example.com/project4.png'],
    },
    {
      'id': '5',
      'title': 'Cross-Chain Bridge',
      'team': 'BridgeLabs',
      'track': 'infrastructure',
      'description': 'Безопасный мост между Ethereum и Solana',
      'members': 4,
      'votes': 167,
      'rank': 5,
      'technologies': ['Rust', 'Go', 'Solidity'],
      'hasVideo': true,
      'hasDemo': true,
      'voted': true,
      'images': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Хакатон'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => _showLeaderboard(),
            tooltip: 'Лидерборд',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showHackathonInfo(),
            tooltip: 'О хакатоне',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Hero section
          SliverToBoxAdapter(
            child: _buildHeroSection(),
          ),

          // Stats
          SliverToBoxAdapter(
            child: _buildHackathonStats(),
          ),

          // Filters
          SliverToBoxAdapter(
            child: _buildFilters(),
          ),

          // Projects list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildProjectsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _submitProject(),
        icon: const Icon(Icons.add),
        label: const Text('Подать проект'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // Hero section
  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.code, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Web3 Hackathon 2024',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Строим будущее DeFi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHeroStat('15 дней', 'До конца', Icons.timer_outlined),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              Expanded(
                child: _buildHeroStat('50+', 'Проектов', Icons.folder_outlined),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              Expanded(
                child: _buildHeroStat('\$100K', 'Призовой', Icons.emoji_events),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildHeroStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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
      ],
    );
  }

  // Hackathon stats
  Widget _buildHackathonStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Подано', '52', Icons.send, Colors.blue)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Голосов', '1.2K', Icons.how_to_vote, Colors.green)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Участников', '215', Icons.people, Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Filters
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Track filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTrackChip('Все треки', 'all'),
                const SizedBox(width: 8),
                _buildTrackChip('DeFi', 'defi'),
                const SizedBox(width: 8),
                _buildTrackChip('NFT', 'nft'),
                const SizedBox(width: 8),
                _buildTrackChip('DAO', 'dao'),
                const SizedBox(width: 8),
                _buildTrackChip('Gaming', 'gaming'),
                const SizedBox(width: 8),
                _buildTrackChip('Инфраструктура', 'infrastructure'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Sort and filter
          Row(
            children: [
              Expanded(
                child: PopupMenuButton<String>(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sort, size: 20),
                        const SizedBox(width: 8),
                        Text(_getSortText()),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  onSelected: (value) => setState(() => _sortBy = value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'popular', child: Text('Популярные')),
                    const PopupMenuItem(value: 'votes', child: Text('По голосам')),
                    const PopupMenuItem(value: 'recent', child: Text('Новые')),
                    const PopupMenuItem(value: 'members', child: Text('По команде')),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(
                  _showVotedOnly ? Icons.check_circle : Icons.filter_list,
                ),
                onPressed: () => setState(() => _showVotedOnly = !_showVotedOnly),
                tooltip: 'Только проголосованные',
                color: _showVotedOnly ? Colors.green : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackChip(String label, String value) {
    final isSelected = _selectedTrack == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedTrack = value);
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  String _getSortText() {
    switch (_sortBy) {
      case 'popular':
        return 'Популярные';
      case 'votes':
        return 'По голосам';
      case 'recent':
        return 'Новые';
      case 'members':
        return 'По команде';
      default:
        return 'Сортировка';
    }
  }

  // Projects list
  Widget _buildProjectsList() {
    var filtered = _projects;

    if (_selectedTrack != 'all') {
      filtered = filtered.where((p) => p['track'] == _selectedTrack).toList();
    }

    if (_showVotedOnly) {
      filtered = filtered.where((p) => p['voted'] as bool).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'votes':
        filtered.sort((a, b) => (b['votes'] as int).compareTo(a['votes'] as int));
        break;
      case 'recent':
        filtered.sort((a, b) => (b['id'] as String).compareTo(a['id'] as String));
        break;
      case 'members':
        filtered.sort((a, b) => (b['members'] as int).compareTo(a['members'] as int));
        break;
      default:
        filtered.sort((a, b) => (b['rank'] as int).compareTo(a['rank'] as int));
    }

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildProjectCard(filtered[index], index),
        childCount: filtered.length,
      ),
    );
  }

  // Project card
  Widget _buildProjectCard(Map<String, dynamic> project, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showProjectDetails(project),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with rank
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        _getTrackColor(project['track']),
                        _getTrackColor(project['track']).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: project['images'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            project['images'].first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildTrackIcon(project['track']),
                          ),
                        )
                      : _buildTrackIcon(project['track']),
                ),
                // Rank badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: project['rank'] <= 3
                          ? Colors.amber
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '#${project['rank']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: project['rank'] <= 3 ? Colors.white : AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                // Video/Demo badges
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      if (project['hasVideo'])
                        _buildBadge(Icons.videocam, 'Видео'),
                      if (project['hasDemo']) ...[
                        if (project['hasVideo']) const SizedBox(width: 8),
                        _buildBadge(Icons.link, 'Демо'),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and team
                  Text(
                    project['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${project['team']} • ${project['members']} чел.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    project['description'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Technologies
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (project['technologies'] as List).take(4).map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tech as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Vote section
                  Row(
                    children: [
                      // Vote count
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.how_to_vote, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${project['votes']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Vote button
                      ElevatedButton.icon(
                        onPressed: () => _voteForProject(project),
                        icon: Icon(
                          project['voted'] ? Icons.check_circle : Icons.add,
                        ),
                        label: Text(project['voted'] ? 'Голос отдан' : 'Голосовать'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: project['voted']
                              ? Colors.green
                              : AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
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
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 80))
      .slideX(begin: 0.2, end: 0);
  }

  Widget _buildTrackIcon(String track) {
    return Center(
      child: Icon(
        _getTrackIcon(track),
        size: 48,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Проекты не найдены',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Измените фильтры',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    AppLogger.info('Show project: ${project['title']}');
  }

  void _voteForProject(Map<String, dynamic> project) {
    if (project['voted'] as bool) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Вы уже проголосовали за этот проект'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      project['voted'] = true;
      project['votes'] = (project['votes'] as int) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Голос за "${project['title']}" учтён!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLeaderboard() {
    AppLogger.info('Show leaderboard');
  }

  void _showHackathonInfo() {
    AppLogger.info('Show hackathon info');
  }

  void _submitProject() {
    AppLogger.info('Submit project');
  }

  Color _getTrackColor(String track) {
    switch (track) {
      case 'defi':
        return Colors.green;
      case 'nft':
        return Colors.purple;
      case 'dao':
        return Colors.orange;
      case 'gaming':
        return Colors.blue;
      case 'infrastructure':
        return Colors.indigo;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getTrackIcon(String track) {
    switch (track) {
      case 'defi':
        return Icons.account_balance;
      case 'nft':
        return Icons.image;
      case 'dao':
        return Icons.groups;
      case 'gaming':
        return Icons.sports_esports;
      case 'infrastructure':
        return Icons.dns;
      default:
        return Icons.code;
    }
  }
}
