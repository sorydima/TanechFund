import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/investment_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/screens/investment_round_details_screen.dart';
import 'package:rechain_vc_lab/screens/syndicate_details_screen.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvestmentProvider>().loadData();
      context.read<InvestmentProvider>().createDemoData();
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
      appBar: AppBar(
        title: const Text('Инвестиции & Синдикаты'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Инвестиционные Раунды'),
            Tab(text: 'Синдикаты'),
            Tab(text: 'Аналитика'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInvestmentRoundsTab(),
          _buildSyndicatesTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  // Вкладка инвестиционных раундов
  Widget _buildInvestmentRoundsTab() {
    return Consumer<InvestmentProvider>(
      builder: (context, investmentProvider, child) {
        if (investmentProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredRounds = investmentProvider.investmentRounds;
        if (_searchQuery.isNotEmpty) {
          filteredRounds = investmentProvider.searchRounds(_searchQuery);
        }

        if (filteredRounds.isEmpty) {
          return _buildEmptyState(
            'Раунды не найдены',
            'Попробуйте изменить поиск или создать новый раунд',
            Icons.trending_up,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredRounds.length,
          itemBuilder: (context, index) {
            final round = filteredRounds[index];
            return _buildInvestmentRoundCard(round)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Вкладка синдикатов
  Widget _buildSyndicatesTab() {
    return Consumer<InvestmentProvider>(
      builder: (context, investmentProvider, child) {
        if (investmentProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredSyndicates = investmentProvider.syndicates;
        if (_searchQuery.isNotEmpty) {
          filteredSyndicates = investmentProvider.searchSyndicates(_searchQuery);
        }

        if (filteredSyndicates.isEmpty) {
          return _buildEmptyState(
            'Синдикаты не найдены',
            'Попробуйте изменить поиск или создать новый синдикат',
            Icons.group_work,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredSyndicates.length,
          itemBuilder: (context, index) {
            final syndicate = filteredSyndicates[index];
            return _buildSyndicateCard(syndicate)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Вкладка аналитики
  Widget _buildAnalyticsTab() {
    return Consumer<InvestmentProvider>(
      builder: (context, investmentProvider, child) {
        if (investmentProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnalyticsHeader(),
              const SizedBox(height: 24),
              _buildMetricsGrid(investmentProvider),
              const SizedBox(height: 24),
              _buildStatusDistribution(investmentProvider),
              const SizedBox(height: 24),
              _buildTopInvestments(investmentProvider),
            ],
          ),
        );
      },
    );
  }

  // Карточка инвестиционного раунда
  Widget _buildInvestmentRoundCard(InvestmentRound round) {
    final progress = round.currentAmount / round.targetAmount;
    final daysLeft = round.endDate.difference(DateTime.now()).inDays;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestmentRoundDetailsScreen(round: round),
          ),
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
                      round.startupName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(round.status),
                ],
              ),
              const SizedBox(height: 8),
              
              // Описание
              Text(
                round.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              
              // Прогресс финансирования
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Прогресс финансирования',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0 ? Colors.green : AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatCurrency(round.currentAmount)} / ${_formatCurrency(round.targetAmount)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Осталось ${daysLeft} дн.',
                        style: TextStyle(
                          fontSize: 12,
                          color: daysLeft < 7 ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Детали раунда
              Row(
                children: [
                  _buildDetailChip(
                    _getInvestmentTypeName(round.type),
                    Icons.category,
                  ),
                  const SizedBox(width: 8),
                  _buildDetailChip(
                    round.blockchain,
                    Icons.block,
                  ),
                  const SizedBox(width: 8),
                  _buildDetailChip(
                    '${round.equityOffered}%',
                    Icons.pie_chart,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Теги
              Wrap(
                spacing: 4,
                children: round.tags.take(3).map((tag) => 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Карточка синдиката
  Widget _buildSyndicateCard(Syndicate syndicate) {
    final commitmentRate = syndicate.committedCapital / syndicate.totalCapital;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SyndicateDetailsScreen(syndicate: syndicate),
          ),
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
                      syndicate.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSyndicateStatusChip(syndicate.status),
                ],
              ),
              const SizedBox(height: 8),
              
              // Описание
              Text(
                syndicate.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              
              // Лид-инвестор
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Лид: ${syndicate.leadInvestor}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Капитал
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Капитал синдиката',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${(commitmentRate * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: commitmentRate,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      commitmentRate >= 0.8 ? Colors.green : AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatCurrency(syndicate.committedCapital)} / ${_formatCurrency(syndicate.totalCapital)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${syndicate.members.length} участников',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Дата формирования
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Сформирован: ${_formatDate(syndicate.formationDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Заголовок аналитики
  Widget _buildAnalyticsHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Инвестиционная Аналитика',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Обзор портфеля и метрик',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Сетка метрик
  Widget _buildMetricsGrid(InvestmentProvider provider) {
    final totalRounds = provider.investmentRounds.length;
    final activeRounds = provider.getRoundsByStatus(InvestmentRoundStatus.open).length;
    final totalSyndicates = provider.syndicates.length;
    final totalInvestments = provider.investments.length;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          'Всего раундов',
          totalRounds.toString(),
          Icons.trending_up,
          Colors.blue,
        ),
        _buildMetricCard(
          'Активных раундов',
          activeRounds.toString(),
          Icons.play_circle,
          Colors.green,
        ),
        _buildMetricCard(
          'Синдикатов',
          totalSyndicates.toString(),
          Icons.group_work,
          Colors.orange,
        ),
        _buildMetricCard(
          'Инвестиций',
          totalInvestments.toString(),
          Icons.attach_money,
          Colors.purple,
        ),
      ],
    );
  }

  // Карточка метрики
  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Распределение по статусам
  Widget _buildStatusDistribution(InvestmentProvider provider) {
    final statusCounts = <InvestmentRoundStatus, int>{};
    for (final status in InvestmentRoundStatus.values) {
      statusCounts[status] = provider.getRoundsByStatus(status).length;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Распределение по статусам',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...statusCounts.entries.map((entry) {
            if (entry.value == 0) return const SizedBox.shrink();
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _getStatusName(entry.key),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Топ инвестиций
  Widget _buildTopInvestments(InvestmentProvider provider) {
    final sortedInvestments = List.from(provider.investments)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    
    final topInvestments = sortedInvestments.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Топ инвестиций',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...topInvestments.asMap().entries.map((entry) {
            final index = entry.key;
            final investment = entry.value;
            
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                _formatCurrency(investment.amount),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${_formatDate(investment.date)} • ${investment.status}',
                style: TextStyle(fontSize: 12),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Статус раунда
  Widget _buildStatusChip(InvestmentRoundStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case InvestmentRoundStatus.planning:
        color = Colors.grey;
        text = 'Планирование';
        break;
      case InvestmentRoundStatus.open:
        color = Colors.green;
        text = 'Открыт';
        break;
      case InvestmentRoundStatus.dueDiligence:
        color = Colors.orange;
        text = 'Due Diligence';
        break;
      case InvestmentRoundStatus.closed:
        color = Colors.red;
        text = 'Закрыт';
        break;
      case InvestmentRoundStatus.funded:
        color = Colors.blue;
        text = 'Финансирован';
        break;
      case InvestmentRoundStatus.completed:
        color = Colors.purple;
        text = 'Завершен';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Статус синдиката
  Widget _buildSyndicateStatusChip(SyndicateStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case SyndicateStatus.forming:
        color = Colors.orange;
        text = 'Формируется';
        break;
      case SyndicateStatus.active:
        color = Colors.green;
        text = 'Активен';
        break;
      case SyndicateStatus.closed:
        color = Colors.red;
        text = 'Закрыт';
        break;
      case SyndicateStatus.dissolved:
        color = Colors.grey;
        text = 'Распущен';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Детальная информация
  Widget _buildDetailChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Пустое состояние
  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Диалог поиска
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поиск'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Поиск по названию, описанию или тегам',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Найти'),
          ),
        ],
      ),
    );
  }

  // Диалог добавления
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Инвестиционный раунд'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Навигация к созданию раунда
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Функция создания раунда будет реализована позже'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_work),
              title: const Text('Синдикат'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Навигация к созданию синдиката
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Функция создания синдиката будет реализована позже'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  // Вспомогательные методы
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${amount.toStringAsFixed(0)}';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} нед. назад';
    } else {
      return '${(difference.inDays / 30).floor()} мес. назад';
    }
  }

  String _getInvestmentTypeName(InvestmentType type) {
    switch (type) {
      case InvestmentType.seed:
        return 'Seed';
      case InvestmentType.seriesA:
        return 'Series A';
      case InvestmentType.seriesB:
        return 'Series B';
      case InvestmentType.seriesC:
        return 'Series C';
      case InvestmentType.growth:
        return 'Growth';
      case InvestmentType.bridge:
        return 'Bridge';
      case InvestmentType.strategic:
        return 'Стратегическая';
    }
  }

  String _getStatusName(InvestmentRoundStatus status) {
    switch (status) {
      case InvestmentRoundStatus.planning:
        return 'Планирование';
      case InvestmentRoundStatus.open:
        return 'Открыт для инвестиций';
      case InvestmentRoundStatus.dueDiligence:
        return 'Due Diligence';
      case InvestmentRoundStatus.closed:
        return 'Закрыт';
      case InvestmentRoundStatus.funded:
        return 'Финансирован';
      case InvestmentRoundStatus.completed:
        return 'Завершен';
    }
  }
}
