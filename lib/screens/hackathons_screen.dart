import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/widgets/hackathon_card.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class HackathonsScreen extends StatefulWidget {
  const HackathonsScreen({super.key});

  @override
  State<HackathonsScreen> createState() => _HackathonsScreenState();
}

class _HackathonsScreenState extends State<HackathonsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  final List<HackathonData> _hackathons = [
    HackathonData(
      title: 'TanechFund x Stacks Bitcoin Hackathon II',
      location: 'Harvard, USA',
      startDate: DateTime(2024, 11, 9),
      endDate: DateTime(2024, 11, 10),
      duration: '36 hours',
      prize: '\$25,000 USD',
      attendees: 350,
      status: HackathonStatus.upcoming,
      closesIn: '1 day',
      description: 'Build innovative Bitcoin applications using Stacks technology',
      partners: ['Stacks', 'Harvard University'],
      categories: ['Bitcoin', 'Stacks', 'DeFi'],
      registrationOpen: true,
    ),
    HackathonData(
      title: 'TanechFund x Stellar Meridian Hackathon',
      location: 'London, UK',
      startDate: DateTime(2024, 10, 12),
      endDate: DateTime(2024, 10, 13),
      duration: '36 hours',
      prize: '\$50,000 USD',
      attendees: 0,
      status: HackathonStatus.upcoming,
      closesIn: '1 day',
      description: 'Create cross-border payment solutions with Stellar',
      partners: ['Stellar', 'Meridian'],
      categories: ['Payments', 'Stellar', 'Cross-border'],
      registrationOpen: true,
    ),
    HackathonData(
      title: 'TanechFund x VeChain Singapore Hackathon',
      location: 'Singapore',
      startDate: DateTime(2024, 9, 14),
      endDate: DateTime(2024, 9, 15),
      duration: '36 hours',
      prize: '\$30,000 USD',
      attendees: 0,
      status: HackathonStatus.upcoming,
      closesIn: '1 day',
      description: 'Build supply chain and sustainability solutions',
      partners: ['VeChain', 'Singapore Tech'],
      categories: ['Supply Chain', 'VeChain', 'Sustainability'],
      registrationOpen: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Хакатоны'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Предстоящие'),
            Tab(text: 'Прошедшие'),
            Tab(text: 'Мои'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Фильтры
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Все', 'all'),
                  _buildFilterChip('Bitcoin', 'bitcoin'),
                  _buildFilterChip('Stellar', 'stellar'),
                  _buildFilterChip('VeChain', 'vechain'),
                  _buildFilterChip('DeFi', 'defi'),
                  _buildFilterChip('Payments', 'payments'),
                ],
              ),
            ),
          ),
          
          // Список хакатонов
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHackathonsList(_getUpcomingHackathons()),
                _buildHackathonsList(_getPastHackathons()),
                _buildHackathonsList(_getMyHackathons()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateHackathonDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Создать'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? value : 'all';
          });
        },
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildHackathonsList(List<HackathonData> hackathons) {
    if (hackathons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Хакатоны не найдены',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hackathons.length,
      itemBuilder: (context, index) {
        return HackathonCard(
          hackathon: hackathons[index],
          onTap: () => _showHackathonDetails(context, hackathons[index]),
          onRegister: () => _registerForHackathon(hackathons[index]),
        );
      },
    );
  }

  List<HackathonData> _getUpcomingHackathons() {
    return _hackathons.where((h) => h.status == HackathonStatus.upcoming).toList();
  }

  List<HackathonData> _getPastHackathons() {
    return _hackathons.where((h) => h.status == HackathonStatus.past).toList();
  }

  List<HackathonData> _getMyHackathons() {
    // Здесь будет логика для получения хакатонов пользователя
    return [];
  }

  void _showHackathonDetails(BuildContext context, HackathonData hackathon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HackathonDetailsSheet(hackathon: hackathon),
    );
  }

  void _registerForHackathon(HackathonData hackathon) {
    // Логика регистрации
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Регистрация на ${hackathon.title}'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _showCreateHackathonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _CreateHackathonDialog(),
    );
  }
}

class HackathonData {
  final String title;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String duration;
  final String prize;
  final int attendees;
  final HackathonStatus status;
  final String closesIn;
  final String description;
  final List<String> partners;
  final List<String> categories;
  final bool registrationOpen;

  HackathonData({
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.prize,
    required this.attendees,
    required this.status,
    required this.closesIn,
    required this.description,
    required this.partners,
    required this.categories,
    required this.registrationOpen,
  });
}

enum HackathonStatus {
  upcoming,
  ongoing,
  past,
}

class _HackathonDetailsSheet extends StatelessWidget {
  final HackathonData hackathon;

  const _HackathonDetailsSheet({required this.hackathon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Заголовок
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hackathon.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hackathon.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Место', hackathon.location, Icons.location_on),
                  _buildDetailRow('Дата', '${_formatDate(hackathon.startDate)} - ${_formatDate(hackathon.endDate)}', Icons.calendar_today),
                  _buildDetailRow('Длительность', hackathon.duration, Icons.schedule),
                  _buildDetailRow('Призовой фонд', hackathon.prize, Icons.attach_money),
                  _buildDetailRow('Участники', '${hackathon.attendees}', Icons.people),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    'Партнеры',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: hackathon.partners.map((partner) => 
                      Chip(label: Text(partner))
                    ).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    'Категории',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: hackathon.categories.map((category) => 
                      Chip(
                        label: Text(category),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      )
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          // Кнопка регистрации
          if (hackathon.registrationOpen)
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Логика регистрации
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Зарегистрироваться'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

class _CreateHackathonDialog extends StatelessWidget {
  const _CreateHackathonDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать хакатон'),
      content: const Text('Функция создания хакатонов будет доступна в следующем обновлении.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
