import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Инвестиционный дашборд — отображение инвестиционных возможностей и статистики
class InvestmentDashboardScreen extends StatefulWidget {
  const InvestmentDashboardScreen({super.key});

  @override
  State<InvestmentDashboardScreen> createState() => _InvestmentDashboardScreenState();
}

class _InvestmentDashboardScreenState extends State<InvestmentDashboardScreen> {
  String _selectedFilter = 'all';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _investmentOpportunities = [
    {
      'id': '1',
      'title': 'DeFi Protocol Alpha',
      'category': 'DeFi',
      'raised': 750000.0,
      'target': 1000000.0,
      'investors': 142,
      'daysLeft': 15,
      'rating': 4.8,
      'minInvestment': 1000,
      'image': 'https://example.com/defi.png',
    },
    {
      'id': '2',
      'title': 'NFT Marketplace Pro',
      'category': 'NFT',
      'raised': 320000.0,
      'target': 500000.0,
      'investors': 89,
      'daysLeft': 22,
      'rating': 4.5,
      'minInvestment': 500,
      'image': 'https://example.com/nft.png',
    },
    {
      'id': '3',
      'title': 'Blockchain Gaming Studio',
      'category': 'Gaming',
      'raised': 1200000.0,
      'target': 2000000.0,
      'investors': 256,
      'daysLeft': 8,
      'rating': 4.9,
      'minInvestment': 2000,
      'image': 'https://example.com/gaming.png',
    },
    {
      'id': '4',
      'title': 'DAO Governance Tool',
      'category': 'DAO',
      'raised': 180000.0,
      'target': 300000.0,
      'investors': 67,
      'daysLeft': 30,
      'rating': 4.3,
      'minInvestment': 250,
      'image': 'https://example.com/dao.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Инвестиции'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(),
            tooltip: 'Уведомления',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
            tooltip: 'Фильтр',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPortfolioSummary(),
              const SizedBox(height: 24),
              _buildQuickStats(),
              const SizedBox(height: 24),
              _buildSectionHeader('Возможности', 'Инвестиционные раунды'),
              const SizedBox(height: 16),
              _buildOpportunitiesList(),
            ],
          ).animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.2, end: 0),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddInvestment(),
        icon: const Icon(Icons.add),
        label: const Text('Инвестировать'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // Портфолио саммари
  Widget _buildPortfolioSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.7),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Общий портфель',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '\$125,430.50',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.lightGreenAccent, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '+12.5%',
                      style: TextStyle(
                        color: Colors.lightGreenAccent.shade400,
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
                child: _buildPortfolioMetric('Инвестировано', '\$98,200', Icons.account_balance_wallet),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              Expanded(
                child: _buildPortfolioMetric('Прибыль', '\$27,230', Icons.savings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioMetric(String label, String value, IconData icon) {
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
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Быстрая статистика
  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Активные', '12', Icons.pie_chart, Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Завершённые', '8', Icons.check_circle, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('В ожидании', '3', Icons.schedule, Colors.orange)),
      ],
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

  // Заголовок секции
  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () => _showAllOpportunities(),
          child: const Text('Все'),
        ),
      ],
    );
  }

  // Список возможностей
  Widget _buildOpportunitiesList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final filtered = _selectedFilter == 'all'
        ? _investmentOpportunities
        : _investmentOpportunities.where((op) => op['category'] == _selectedFilter).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final opportunity = filtered[index];
        return _buildOpportunityCard(opportunity, index);
      },
    );
  }

  // Карточка возможности
  Widget _buildOpportunityCard(Map<String, dynamic> opportunity, int index) {
    final progress = (opportunity['raised'] as double) / (opportunity['target'] as double);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showOpportunityDetails(opportunity),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение и категория
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
                        _getCategoryColor(opportunity['category']),
                        _getCategoryColor(opportunity['category']).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(opportunity['category']),
                          size: 48,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          opportunity['category'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Бейдж рейтинга
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          opportunity['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Информация
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opportunity['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Прогресс бар
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getCategoryColor(opportunity['category']),
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Статистика
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOpportunityStat(
                        'Собрано',
                        '\$${(opportunity['raised'] / 1000).toStringAsFixed(0)}k',
                        Icons.attach_money,
                      ),
                      _buildOpportunityStat(
                        'Цель',
                        '\$${(opportunity['target'] / 1000).toStringAsFixed(0)}k',
                        Icons.flag,
                      ),
                      _buildOpportunityStat(
                        'Дней',
                        '${opportunity['daysLeft']}',
                        Icons.calendar_today,
                      ),
                      _buildOpportunityStat(
                        'Инвесторы',
                        '${opportunity['investors']}',
                        Icons.people,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Кнопка
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _investInOpportunity(opportunity),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getCategoryColor(opportunity['category']),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Инвестировать',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 100))
      .slideX(begin: 0.2, end: 0);
  }

  Widget _buildOpportunityStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Нет возможностей',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить фильтры',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Фильтр
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтр'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterChip('Все', 'all'),
            const SizedBox(height: 8),
            _buildFilterChip('DeFi', 'DeFi'),
            const SizedBox(height: 8),
            _buildFilterChip('NFT', 'NFT'),
            const SizedBox(height: 8),
            _buildFilterChip('Gaming', 'Gaming'),
            const SizedBox(height: 8),
            _buildFilterChip('DAO', 'DAO'),
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

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
        Navigator.pop(context);
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  // Уведомления
  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Уведомления'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // Показать все возможности
  void _showAllOpportunities() {
    AppLogger.info('Show all opportunities');
  }

  // Детали возможности
  void _showOpportunityDetails(Map<String, dynamic> opportunity) {
    AppLogger.info('Show details: ${opportunity['title']}');
  }

  // Инвестировать
  void _investInOpportunity(Map<String, dynamic> opportunity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Инвестирование в ${opportunity['title']}'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Добавить инвестицию
  void _showAddInvestment() {
    AppLogger.info('Add investment');
  }

  // Обновление данных
  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'DeFi':
        return Colors.green;
      case 'NFT':
        return Colors.purple;
      case 'Gaming':
        return Colors.blue;
      case 'DAO':
        return Colors.orange;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'DeFi':
        return Icons.account_balance;
      case 'NFT':
        return Icons.image;
      case 'Gaming':
        return Icons.sports_esports;
      case 'DAO':
        return Icons.groups;
      default:
        return Icons.business;
    }
  }
}
