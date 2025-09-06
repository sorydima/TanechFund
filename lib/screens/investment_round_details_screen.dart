import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/investment_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class InvestmentRoundDetailsScreen extends StatefulWidget {
  final InvestmentRound round;

  const InvestmentRoundDetailsScreen({
    super.key,
    required this.round,
  });

  @override
  State<InvestmentRoundDetailsScreen> createState() => _InvestmentRoundDetailsScreenState();
}

class _InvestmentRoundDetailsScreenState extends State<InvestmentRoundDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _investmentAmountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _investmentAmountController.text = widget.round.minimumInvestment.toString();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _investmentAmountController.dispose();
    _notesController.dispose();
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
                widget.round.startupName,
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
                        Icons.trending_up,
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
                          _buildStatusChip(widget.round.status),
                          const SizedBox(height: 16),
                          Text(
                            widget.round.description,
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
                Tab(text: 'Финансы'),
                Tab(text: 'Документы'),
                Tab(text: 'Инвестировать'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildFinanceTab(),
            _buildDocumentsTab(),
            _buildInvestTab(),
          ],
        ),
      ),
    );
  }

  // Вкладка обзора
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCard(),
          const SizedBox(height: 16),
          _buildDetailsCard(),
          const SizedBox(height: 16),
          _buildTagsCard(),
          const SizedBox(height: 16),
          _buildTimelineCard(),
        ],
      ),
    );
  }

  // Вкладка финансов
  Widget _buildFinanceTab() {
    final progress = widget.round.currentAmount / widget.round.targetAmount;
    final daysLeft = widget.round.endDate.difference(DateTime.now()).inDays;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFinanceOverviewCard(progress, daysLeft),
          const SizedBox(height: 16),
          _buildInvestmentTermsCard(),
          const SizedBox(height: 16),
          _buildValuationCard(),
          const SizedBox(height: 16),
          _buildProgressChart(progress),
        ],
      ),
    );
  }

  // Вкладка документов
  Widget _buildDocumentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.round.documents.length,
      itemBuilder: (context, index) {
        final document = widget.round.documents[index];
        return _buildDocumentCard(document, index)
            .animate()
            .fadeIn(delay: Duration(milliseconds: index * 100))
            .slideX(begin: 0.3, end: 0);
      },
    );
  }

  // Вкладка инвестирования
  Widget _buildInvestTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInvestmentForm(),
          const SizedBox(height: 24),
          _buildInvestmentTerms(),
          const SizedBox(height: 24),
          _buildRiskDisclosure(),
        ],
      ),
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
              'Описание проекта',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.round.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.block,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Блокчейн: ${widget.round.blockchain}',
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
                  Icons.category,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Тип: ${_getInvestmentTypeName(widget.round.type)}',
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

  // Карточка деталей
  Widget _buildDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Детали раунда',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Дата начала', _formatDate(widget.round.startDate)),
            _buildDetailRow('Дата окончания', _formatDate(widget.round.endDate)),
            _buildDetailRow('Создан', _formatDate(widget.round.createdAt)),
            _buildDetailRow('Обновлен', _formatDate(widget.round.updatedAt)),
          ],
        ),
      ),
    );
  }

  // Карточка тегов
  Widget _buildTagsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Теги и категории',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.round.tags.map((tag) => 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка временной шкалы
  Widget _buildTimelineCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Временная шкала',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              'Планирование',
              widget.round.startDate,
              Icons.schedule,
              Colors.blue,
            ),
            _buildTimelineItem(
              'Открытие раунда',
              widget.round.startDate,
              Icons.play_circle,
              Colors.green,
            ),
            _buildTimelineItem(
              'Закрытие раунда',
              widget.round.endDate,
              Icons.stop_circle,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Карточка финансового обзора
  Widget _buildFinanceOverviewCard(double progress, int daysLeft) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Финансовый обзор',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFinanceMetric(
                    'Целевая сумма',
                    _formatCurrency(widget.round.targetAmount),
                    Icons.flag,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildFinanceMetric(
                    'Собрано',
                    _formatCurrency(widget.round.currentAmount),
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
                  child: _buildFinanceMetric(
                    'Прогресс',
                    '${(progress * 100).toStringAsFixed(1)}%',
                    Icons.trending_up,
                    progress >= 1.0 ? Colors.green : AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildFinanceMetric(
                    'Осталось дней',
                    daysLeft.toString(),
                    Icons.schedule,
                    daysLeft < 7 ? Colors.red : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Карточка условий инвестирования
  Widget _buildInvestmentTermsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Условия инвестирования',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Минимальная инвестиция', _formatCurrency(widget.round.minimumInvestment)),
            _buildDetailRow('Максимальная инвестиция', _formatCurrency(widget.round.maximumInvestment)),
            _buildDetailRow('Предлагаемая доля', '${widget.round.equityOffered}%'),
            _buildDetailRow('Оценка компании', _formatCurrency(widget.round.valuation)),
          ],
        ),
      ),
    );
  }

  // Карточка оценки
  Widget _buildValuationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Оценка и структура',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Оценка компании'),
                      Text(
                        _formatCurrency(widget.round.valuation),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Предлагаемая доля'),
                      Text(
                        '${widget.round.equityOffered}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Стоимость доли'),
                      Text(
                        _formatCurrency(widget.round.targetAmount),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
    );
  }

  // График прогресса
  Widget _buildProgressChart(double progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Прогресс финансирования',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Прогресс',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0 ? Colors.green : AppTheme.primaryColor,
                  ),
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatCurrency(widget.round.currentAmount),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _formatCurrency(widget.round.targetAmount),
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

  // Карточка документа
  Widget _buildDocumentCard(String document, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getDocumentIcon(document),
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          _getDocumentName(document),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          _getDocumentType(document),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _downloadDocument(document),
        ),
      ),
    );
  }

  // Форма инвестирования
  Widget _buildInvestmentForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Инвестировать в проект',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _investmentAmountController,
              decoration: const InputDecoration(
                labelText: 'Сумма инвестиции (\$)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите сумму инвестиции';
                }
                final amount = double.tryParse(value);
                if (amount == null) {
                  return 'Введите корректную сумму';
                }
                if (amount < widget.round.minimumInvestment) {
                  return 'Минимальная сумма: ${_formatCurrency(widget.round.minimumInvestment)}';
                }
                if (amount > widget.round.maximumInvestment) {
                  return 'Максимальная сумма: ${_formatCurrency(widget.round.maximumInvestment)}';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Заметки (опционально)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitInvestment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Инвестировать',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Условия инвестирования
  Widget _buildInvestmentTerms() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Условия инвестирования',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTermItem(
              'Минимальная инвестиция',
              _formatCurrency(widget.round.minimumInvestment),
              Icons.arrow_upward,
            ),
            _buildTermItem(
              'Максимальная инвестиция',
              _formatCurrency(widget.round.maximumInvestment),
              Icons.arrow_downward,
            ),
            _buildTermItem(
              'Предлагаемая доля',
              '${widget.round.equityOffered}%',
              Icons.pie_chart,
            ),
            _buildTermItem(
              'Срок раунда',
              '${widget.round.endDate.difference(widget.round.startDate).inDays} дней',
              Icons.schedule,
            ),
          ],
        ),
      ),
    );
  }

  // Раскрытие рисков
  Widget _buildRiskDisclosure() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.orange[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Раскрытие рисков',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Инвестиции в стартапы связаны с высокими рисками. Возможна полная потеря вложенных средств. '
              'Перед инвестированием внимательно изучите все документы и проконсультируйтесь с финансовым советником.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.red,
              ),
            ),
          ],
        ),
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

  Widget _buildTimelineItem(String title, DateTime date, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceMetric(String label, String value, IconData icon, Color color) {
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

  Widget _buildTermItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
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
        text = 'Открыт для инвестиций';
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

  void _submitInvestment() {
    final amount = double.tryParse(_investmentAmountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите корректную сумму'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount < widget.round.minimumInvestment) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Минимальная сумма: ${_formatCurrency(widget.round.minimumInvestment)}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount > widget.round.maximumInvestment) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Максимальная сумма: ${_formatCurrency(widget.round.maximumInvestment)}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Реальная логика инвестирования
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Инвестиция на сумму ${_formatCurrency(amount)} отправлена на рассмотрение'),
        backgroundColor: Colors.green,
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

  String _getDocumentType(String document) {
    final extension = document.split('.').last.toUpperCase();
    switch (extension) {
      case 'PDF':
        return 'PDF документ';
      case 'XLSX':
      case 'XLS':
        return 'Excel таблица';
      case 'DOC':
      case 'DOCX':
        return 'Word документ';
      default:
        return 'Файл';
    }
  }
}
