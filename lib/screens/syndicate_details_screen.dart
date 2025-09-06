import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/investment_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class SyndicateDetailsScreen extends StatefulWidget {
  final Syndicate syndicate;

  const SyndicateDetailsScreen({
    super.key,
    required this.syndicate,
  });

  @override
  State<SyndicateDetailsScreen> createState() => _SyndicateDetailsScreenState();
}

class _SyndicateDetailsScreenState extends State<SyndicateDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.syndicate.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Icon(
                        Icons.group_work,
                        size: 200,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          _buildStatusChip(widget.syndicate.status),
                          const SizedBox(height: 16),
                          Text(
                            widget.syndicate.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () => _showShareDialog(),
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () => _toggleFavorite(),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Обзор'),
                Tab(text: 'Участники'),
                Tab(text: 'Инвестиции'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildMembersTab(),
            _buildInvestmentsTab(),
          ],
        ),
      ),
    );
  }

  // Вкладка обзора
  Widget _buildOverviewTab() {
    final commitmentRate = widget.syndicate.committedCapital / widget.syndicate.totalCapital;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCard(),
          const SizedBox(height: 16),
          _buildCapitalCard(commitmentRate),
          const SizedBox(height: 16),
          _buildDetailsCard(),
          const SizedBox(height: 16),
          _buildDocumentsCard(),
        ],
      ),
    );
  }

  // Вкладка участников
  Widget _buildMembersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.syndicate.members.length + 1, // +1 для лид-инвестора
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildLeadInvestorCard()
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 100))
              .slideX(begin: 0.3, end: 0);
        } else {
          final member = widget.syndicate.members[index - 1];
          return _buildMemberCard(member, index - 1)
              .animate()
              .fadeIn(delay: Duration(milliseconds: (index + 1) * 100))
              .slideX(begin: 0.3, end: 0);
        }
      },
    );
  }

  // Вкладка инвестиций
  Widget _buildInvestmentsTab() {
    return Consumer<InvestmentProvider>(
      builder: (context, investmentProvider, child) {
        final syndicateRounds = investmentProvider.investmentRounds
            .where((round) => widget.syndicate.investmentRounds.contains(round.id))
            .toList();

        if (syndicateRounds.isEmpty) {
          return _buildEmptyState(
            'Инвестиционные раунды не найдены',
            'Синдикат пока не участвует в инвестиционных раундах',
            Icons.trending_up,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: syndicateRounds.length,
          itemBuilder: (context, index) {
            final round = syndicateRounds[index];
            return _buildInvestmentRoundCard(round, index)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Карточка обзора
  Widget _buildOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Описание синдиката',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.syndicate.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Лид-инвестор: ${widget.syndicate.leadInvestor}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Участников: ${widget.syndicate.members.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Карточка капитала
  Widget _buildCapitalCard(double commitmentRate) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Капитал синдиката',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCapitalMetric(
                    'Общий капитал',
                    _formatCurrency(widget.syndicate.totalCapital),
                    Icons.account_balance_wallet,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildCapitalMetric(
                    'Собранный капитал',
                    _formatCurrency(widget.syndicate.committedCapital),
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCapitalMetric(
                    'Процент сбора',
                    '${(commitmentRate * 100).toStringAsFixed(1)}%',
                    Icons.trending_up,
                    commitmentRate >= 0.8 ? Colors.green : AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildCapitalMetric(
                    'Осталось собрать',
                    _formatCurrency(widget.syndicate.totalCapital - widget.syndicate.committedCapital),
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Прогресс сбора капитала',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${(commitmentRate * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: commitmentRate,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    commitmentRate >= 0.8 ? Colors.green : AppTheme.primaryColor,
                  ),
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatCurrency(widget.syndicate.committedCapital),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _formatCurrency(widget.syndicate.totalCapital),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Карточка деталей
  Widget _buildDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Детали синдиката',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Дата формирования', _formatDate(widget.syndicate.formationDate)),
            if (widget.syndicate.closingDate != null)
              _buildDetailRow('Дата закрытия', _formatDate(widget.syndicate.closingDate!)),
            _buildDetailRow('Статус', _getStatusName(widget.syndicate.status)),
            _buildDetailRow('Инвестиционных раундов', widget.syndicate.investmentRounds.length.toString()),
            _buildDetailRow('Документов', widget.syndicate.documents.length.toString()),
          ],
        ),
      ),
    );
  }

  // Карточка документов
  Widget _buildDocumentsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Документы синдиката',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...widget.syndicate.documents.map((document) => 
              _buildDocumentItem(document),
            ).toList(),
          ],
        ),
      ),
    );
  }

  // Карточка лид-инвестора
  Widget _buildLeadInvestorCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.star,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Лид-инвестор',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.syndicate.leadInvestor,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Управляет синдикатом и принимает ключевые решения',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.contact_mail),
              onPressed: () => _contactLeadInvestor(),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка участника
  Widget _buildMemberCard(String member, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Text(
            (index + 1).toString(),
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          member,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Участник синдиката',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => _viewMemberProfile(member),
            ),
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () => _messageMember(member),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка инвестиционного раунда
  Widget _buildInvestmentRoundCard(InvestmentRound round, int index) {
    final progress = round.currentAmount / round.targetAmount;
    final daysLeft = round.endDate.difference(DateTime.now()).inDays;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                _buildRoundStatusChip(round.status),
              ],
            ),
            const SizedBox(height: 8),
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
            Row(
              children: [
                Expanded(
                  child: _buildRoundMetric(
                    'Цель',
                    _formatCurrency(round.targetAmount),
                    Icons.flag,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildRoundMetric(
                    'Собрано',
                    _formatCurrency(round.currentAmount),
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildRoundMetric(
                    'Прогресс',
                    '${(progress * 100).toStringAsFixed(1)}%',
                    Icons.trending_up,
                    progress >= 1.0 ? Colors.green : AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Осталось ${daysLeft} дн.',
                  style: TextStyle(
                    fontSize: 12,
                    color: daysLeft < 7 ? Colors.red : Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  '${_getInvestmentTypeName(round.type)} • ${round.blockchain}',
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

  // Вспомогательные виджеты
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapitalMetric(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
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

  Widget _buildRoundMetric(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String document) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            _getDocumentIcon(document),
            size: 20,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getDocumentName(document),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadDocument(document),
          ),
        ],
      ),
    );
  }

  // Статус синдиката
  Widget _buildStatusChip(SyndicateStatus status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Статус раунда
  Widget _buildRoundStatusChip(InvestmentRoundStatus status) {
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

  // Методы
  void _showShareDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция поделиться будет реализована позже'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _toggleFavorite() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Добавлено в избранное'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _contactLeadInvestor() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Отправка сообщения ${widget.syndicate.leadInvestor}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _viewMemberProfile(String member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Просмотр профиля $member'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _messageMember(String member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Отправка сообщения $member'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _downloadDocument(String document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Загрузка документа: $document'),
        backgroundColor: Colors.blue,
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
    return '${date.day}.${date.month}.${date.year}';
  }

  String _getStatusName(SyndicateStatus status) {
    switch (status) {
      case SyndicateStatus.forming:
        return 'Формируется';
      case SyndicateStatus.active:
        return 'Активен';
      case SyndicateStatus.closed:
        return 'Закрыт';
      case SyndicateStatus.dissolved:
        return 'Распущен';
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

  IconData _getDocumentIcon(String document) {
    if (document.contains('.pdf')) return Icons.picture_as_pdf;
    if (document.contains('.xlsx') || document.contains('.xls')) return Icons.table_chart;
    if (document.contains('.doc') || document.contains('.docx')) return Icons.description;
    return Icons.insert_drive_file;
  }

  String _getDocumentName(String document) {
    return document.replaceAll('_', ' ').replaceAll('.', ' ').trim();
  }
}
