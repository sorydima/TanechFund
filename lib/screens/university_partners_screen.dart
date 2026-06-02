import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// University Partners — партнёрские программы с университетами
class UniversityPartnersScreen extends StatefulWidget {
  const UniversityPartnersScreen({super.key});

  @override
  State<UniversityPartnersScreen> createState() => _UniversityPartnersScreenState();
}

class _UniversityPartnersScreenState extends State<UniversityPartnersScreen> {
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _universities = [
    {'name': 'Harvard University', 'logo': 'H', 'color': Colors.red, 'country': 'USA', 'students': 23000, 'programs': 12},
    {'name': 'Cambridge University', 'logo': 'C', 'color': Colors.blue, 'country': 'UK', 'students': 24000, 'programs': 10},
    {'name': 'Brown University', 'logo': 'B', 'color': Colors.brown, 'country': 'USA', 'students': 10500, 'programs': 8},
    {'name': 'Dartmouth College', 'logo': 'D', 'color': Colors.green, 'country': 'USA', 'students': 6700, 'programs': 6},
    {'name': 'Yale University', 'logo': 'Y', 'color': Colors.indigo, 'country': 'USA', 'students': 14500, 'programs': 11},
    {'name': 'University of Oxford', 'logo': 'O', 'color': Colors.orange, 'country': 'UK', 'students': 26000, 'programs': 14},
    {'name': 'MIT', 'logo': 'M', 'color': Colors.grey, 'country': 'USA', 'students': 11900, 'programs': 15},
    {'name': 'Princeton University', 'logo': 'P', 'color': Colors.orange.shade800, 'country': 'USA', 'students': 8500, 'programs': 9},
  ];

  final List<Map<String, dynamic>> _programs = [
    {'name': 'Blockchain Research', 'universities': 8, 'funding': '\$5M', 'icon': Icons.science},
    {'name': 'Student Internships', 'universities': 6, 'funding': '\$2M', 'icon': Icons.work},
    {'name': 'Hackathons', 'universities': 8, 'funding': '\$1M', 'icon': Icons.code},
    {'name': 'Online Courses', 'universities': 5, 'funding': '\$3M', 'icon': Icons.school},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Университетские партнёры'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.mail), onPressed: _contactPartnerships, tooltip: 'Связаться'),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildFilterChips()),
          SliverToBoxAdapter(child: _buildStatistics()),
          SliverToBoxAdapter(child: _buildSectionHeader('Партнёры', Icons.school)),
          SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildUniversitiesGrid()),
          SliverToBoxAdapter(child: _buildSectionHeader('Программы', Icons.menu_book)),
          SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildProgramsList()),
          SliverToBoxAdapter(child: _buildSectionHeader('Отзывы', Icons.reviews)),
          SliverPadding(padding: const EdgeInsets.all(16), sliver: _buildTestimonials()),
          SliverToBoxAdapter(child: _buildCTA()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.accentColor]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.school, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Education', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text('Университетские партнёры', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Сотрудничаем с ведущими университетами для создания инновационных образовательных программ по блокчейну и Web3',
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildFilterChips() {
    final filters = [
      {'id': 'all', 'label': 'Все', 'icon': Icons.view_agenda},
      {'id': 'usa', 'label': 'USA', 'icon': Icons.flag},
      {'id': 'uk', 'label': 'UK', 'icon': Icons.flag},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: Icon(f['icon'] as IconData, size: 16),
              label: Text(f['label'] as String),
              selected: _selectedFilter == f['id'],
              onSelected: (s) => setState(() => _selectedFilter = f['id'] as String),
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('8', 'Университетов', Icons.school, AppTheme.primaryColor),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildStatItem('1M+', 'Студентов', Icons.people, AppTheme.secondaryColor),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildStatItem('50+', 'Хакатонов', Icons.event, AppTheme.accentColor),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildUniversitiesGrid() {
    var filtered = _universities;
    if (_selectedFilter != 'all') {
      filtered = _universities.where((u) => u['country'].toString().toLowerCase() == _selectedFilter).toList();
    }
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate((context, index) => _buildUniversityCard(filtered[index], index), childCount: filtered.length),
    );
  }

  Widget _buildUniversityCard(Map<String, dynamic> uni, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [(uni['color'] as Color).withOpacity(0.1), (uni['color'] as Color).withOpacity(0.05)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (uni['color'] as Color).withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: (uni['color'] as Color).withOpacity(0.5), width: 2),
              ),
              child: Center(child: Text(uni['logo'] as String, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: uni['color']))),
            ),
            const SizedBox(height: 12),
            Text(uni['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 10, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${(uni['students'] as int) ~/ 1000}K', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildProgramsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) => _buildProgramCard(_programs[index], index), childCount: _programs.length),
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(program['icon'] as IconData, color: AppTheme.primaryColor, size: 24),
        ),
        title: Text(program['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${program['universities']} университетов'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(program['funding'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            Text('финансирование', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideX(begin: 0.2, end: 0);
  }

  Widget _buildTestimonials() {
    final testimonials = [
      {'name': 'Jeremy', 'university': 'Harvard University', 'text': 'On behalf of the entire team here, we wanted to extend a sincere thank you for all of your support during the earliest stages of the Lockbox.', 'icon': Icons.school},
      {'name': 'Vivian', 'university': 'MIT', 'text': 'Thanks for the incredible event to bring together people from different backgrounds and provide a platform for stimulating discussions and ideas! 🙌', 'icon': Icons.science},
      {'name': 'Kashyab', 'university': 'Northeastern University', 'text': 'It all started with an TanechFund Hackathon', 'icon': Icons.engineering},
    ];
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) => _buildTestimonialCard(testimonials[index], index), childCount: testimonials.length),
    );
  }

  Widget _buildTestimonialCard(Map<String, dynamic> t, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(t['icon'] as IconData, color: AppTheme.primaryColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(t['university'] as String, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(t['text'] as String, style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey[800])),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideY(begin: 0.1, end: 0);
  }

  Widget _buildCTA() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.accentColor]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.download, color: Colors.white, size: 40),
          const SizedBox(height: 16),
          const Text('Более 29M загрузок', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Приложения доступны в App Store, Google Play и REChain.Store', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: _downloadApp, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.primaryColor, padding: const EdgeInsets.symmetric(vertical: 12)), child: const Text('Скачать'))),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  void _contactPartnerships() => AppLogger.info('Contact partnerships');
  void _downloadApp() => AppLogger.info('Download app');
}
