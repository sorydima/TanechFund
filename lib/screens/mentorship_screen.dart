import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/mentorship_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/widgets/mentor_card.dart';
import 'package:rechain_vc_lab/widgets/session_card.dart';
import 'package:rechain_vc_lab/widgets/development_plan_card.dart';
import 'package:rechain_vc_lab/widgets/feedback_card.dart';

class MentorshipScreen extends StatefulWidget {
  const MentorshipScreen({super.key});

  @override
  State<MentorshipScreen> createState() => _MentorshipScreenState();
}

class _MentorshipScreenState extends State<MentorshipScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _selectedExpertise = [];
  List<String> _selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MentorshipProvider>().initialize();
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
                      Icons.psychology,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Менторство и Наставничество',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Найдите своего ментора и развивайтесь',
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
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Поиск менторов, сессий, планов...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  style: const TextStyle(color: Colors.white),
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
                Tab(text: 'Менторы', icon: Icon(Icons.people)),
                Tab(text: 'Сессии', icon: Icon(Icons.schedule)),
                Tab(text: 'Планы развития', icon: Icon(Icons.trending_up)),
                Tab(text: 'Обратная связь', icon: Icon(Icons.feedback)),
              ],
            ),
          ),
          
          // Содержимое вкладок
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMentorsTab(),
                _buildSessionsTab(),
                _buildPlansTab(),
                _buildFeedbackTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Вкладка менторов
  Widget _buildMentorsTab() {
    return Consumer<MentorshipProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Mentor> filteredMentors = provider.searchMentors(
          _searchQuery,
          expertise: _selectedExpertise.isEmpty ? null : _selectedExpertise,
          languages: _selectedLanguages.isEmpty ? null : _selectedLanguages,
        );

        return Column(
          children: [
            // Фильтры
            if (_searchQuery.isNotEmpty || _selectedExpertise.isNotEmpty || _selectedLanguages.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_searchQuery.isNotEmpty)
                      Chip(
                        label: Text('Поиск: $_searchQuery'),
                        onDeleted: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      ),
                    ..._selectedExpertise.map((expertise) => Chip(
                      label: Text(expertise),
                      onDeleted: () {
                        setState(() {
                          _selectedExpertise.remove(expertise);
                        });
                      },
                      backgroundColor: Colors.blue.withOpacity(0.1),
                    )),
                    ..._selectedLanguages.map((language) => Chip(
                      label: Text(language),
                      onDeleted: () {
                        setState(() {
                          _selectedLanguages.remove(language);
                        });
                      },
                      backgroundColor: Colors.green.withOpacity(0.1),
                    )),
                  ],
                ),
              ),
            
            // Список менторов
            Expanded(
              child: filteredMentors.isEmpty
                  ? _buildEmptyState(
                      'Менторы не найдены',
                      'Попробуйте изменить параметры поиска',
                      Icons.search_off,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredMentors.length,
                      itemBuilder: (context, index) {
                        return MentorCard(
                          mentor: filteredMentors[index],
                          onTap: () => _showMentorDetails(filteredMentors[index]),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // Вкладка сессий
  Widget _buildSessionsTab() {
    return Consumer<MentorshipProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<MentorshipSession> filteredSessions = provider.sessions
            .where((session) => _searchQuery.isEmpty ||
                session.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                session.description.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        return Column(
          children: [
            // Статистика
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Всего сессий',
                      provider.sessions.length.toString(),
                      Icons.schedule,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Активные',
                      provider.activeSessions.length.toString(),
                      Icons.play_circle,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Завершенные',
                      provider.sessions
                          .where((s) => s.status == MentorshipStatus.completed)
                          .length
                          .toString(),
                      Icons.check_circle,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            
            // Список сессий
            Expanded(
              child: filteredSessions.isEmpty
                  ? _buildEmptyState(
                      'Сессии не найдены',
                      'Создайте новую сессию или измените параметры поиска',
                      Icons.schedule,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredSessions.length,
                      itemBuilder: (context, index) {
                        return SessionCard(
                          session: filteredSessions[index],
                          onTap: () => _showSessionDetails(filteredSessions[index]),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // Вкладка планов развития
  Widget _buildPlansTab() {
    return Consumer<MentorshipProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DevelopmentPlan> filteredPlans = provider.plans
            .where((plan) => _searchQuery.isEmpty ||
                plan.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                plan.description.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        return Column(
          children: [
            // Статистика
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Всего планов',
                      provider.plans.length.toString(),
                      Icons.trending_up,
                      Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Активные',
                      provider.activePlans.length.toString(),
                      Icons.play_circle,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Завершенные',
                      provider.plans
                          .where((p) => !p.isActive)
                          .length
                          .toString(),
                      Icons.check_circle,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            
            // Список планов
            Expanded(
              child: filteredPlans.isEmpty
                  ? _buildEmptyState(
                      'Планы развития не найдены',
                      'Создайте новый план или измените параметры поиска',
                      Icons.trending_up,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredPlans.length,
                      itemBuilder: (context, index) {
                        return DevelopmentPlanCard(
                          plan: filteredPlans[index],
                          onTap: () => _showPlanDetails(filteredPlans[index]),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // Вкладка обратной связи
  Widget _buildFeedbackTab() {
    return Consumer<MentorshipProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

                        List<MentorshipFeedback> filteredFeedbacks = provider.feedbacks
            .where((feedback) => _searchQuery.isEmpty ||
                feedback.comment.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                feedback.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase())))
            .toList();

        return Column(
          children: [
            // Статистика
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Всего отзывов',
                      provider.feedbacks.length.toString(),
                      Icons.feedback,
                      Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Отлично',
                      provider.feedbacks
                          .where((f) => f.rating == FeedbackRating.excellent)
                          .length
                          .toString(),
                      Icons.star,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Средний рейтинг',
                      (provider.feedbacks.fold(0.0, (sum, f) => sum + f.rating.index) /
                              provider.feedbacks.length)
                          .toStringAsFixed(1),
                      Icons.analytics,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            
            // Список отзывов
            Expanded(
              child: filteredFeedbacks.isEmpty
                  ? _buildEmptyState(
                      'Обратная связь не найдена',
                      'Создайте новый отзыв или измените параметры поиска',
                      Icons.feedback,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredFeedbacks.length,
                      itemBuilder: (context, index) {
                        return FeedbackCard(
                          feedback: filteredFeedbacks[index],
                          onTap: () => _showFeedbackDetails(filteredFeedbacks[index]),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // Вспомогательные виджеты
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

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
            style: TextStyle(
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

  // Диалоги
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Новый ментор'),
              onTap: () {
                Navigator.pop(context);
                _showAddMentorDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Новую сессию'),
              onTap: () {
                Navigator.pop(context);
                _showAddSessionDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Новый план развития'),
              onTap: () {
                Navigator.pop(context);
                _showAddPlanDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMentorDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddMentorDialog(),
    );
  }

  void _showAddSessionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddSessionDialog(),
    );
  }

  void _showAddPlanDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddPlanDialog(),
    );
  }

  void _showMentorDetails(Mentor mentor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MentorDetailsDialog(mentor: mentor),
    );
  }

  void _showSessionDetails(MentorshipSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SessionDetailsDialog(session: session),
    );
  }

  void _showPlanDetails(DevelopmentPlan plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PlanDetailsDialog(plan: plan),
    );
  }

  void _showFeedbackDetails(MentorshipFeedback feedback) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FeedbackDetailsDialog(feedback: feedback),
    );
  }
}

// Диалог добавления ментора
class _AddMentorDialog extends StatefulWidget {
  @override
  _AddMentorDialogState createState() => _AddMentorDialogState();
}

class _AddMentorDialogState extends State<_AddMentorDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();
  String _selectedExperience = 'junior';
  String _selectedAvailability = 'part-time';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _expertiseController.dispose();
    super.dispose();
  }

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
            child: Row(
              children: [
                const Text(
                  'Добавить ментора',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
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
                  // Имя
                  const Text(
                    'Имя',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите имя ментора',
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Email
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'email@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Опыт
                  const Text(
                    'Уровень опыта',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedExperience,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'junior', child: Text('Junior (1-3 года)')),
                      DropdownMenuItem(value: 'middle', child: Text('Middle (3-5 лет)')),
                      DropdownMenuItem(value: 'senior', child: Text('Senior (5+ лет)')),
                      DropdownMenuItem(value: 'lead', child: Text('Lead (7+ лет)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedExperience = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Доступность
                  const Text(
                    'Доступность',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedAvailability,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'part-time', child: Text('Частичная занятость')),
                      DropdownMenuItem(value: 'full-time', child: Text('Полная занятость')),
                      DropdownMenuItem(value: 'freelance', child: Text('Фриланс')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedAvailability = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Экспертиза
                  const Text(
                    'Экспертиза',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _expertiseController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Flutter, React, Blockchain, AI/ML...',
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Био
                  const Text(
                    'Биография',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _bioController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Расскажите о себе и своем опыте...',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Кнопка добавления
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addMentor,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Добавить ментора'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addMentor() {
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните обязательные поля')),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ментор добавлен!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// Диалог добавления сессии
class _AddSessionDialog extends StatefulWidget {
  @override
  _AddSessionDialogState createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends State<_AddSessionDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedType = 'consultation';
  String _selectedDuration = '60';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
            child: Row(
              children: [
                const Text(
                  'Добавить сессию',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
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
                  // Заголовок сессии
                  const Text(
                    'Заголовок',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите заголовок сессии',
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Тип сессии
                  const Text(
                    'Тип сессии',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'consultation', child: Text('Консультация')),
                      DropdownMenuItem(value: 'code-review', child: Text('Code Review')),
                      DropdownMenuItem(value: 'career-guidance', child: Text('Карьерное консультирование')),
                      DropdownMenuItem(value: 'technical-interview', child: Text('Техническое интервью')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Дата и время
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Дата',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: _selectDate,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today),
                                    const SizedBox(width: 8),
                                    Text(_formatDate(_selectedDate)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Время',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: _selectTime,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time),
                                    const SizedBox(width: 8),
                                    Text(_selectedTime.format(context)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Длительность
                  const Text(
                    'Длительность (минуты)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedDuration,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '30', child: Text('30 минут')),
                      DropdownMenuItem(value: '60', child: Text('1 час')),
                      DropdownMenuItem(value: '90', child: Text('1.5 часа')),
                      DropdownMenuItem(value: '120', child: Text('2 часа')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDuration = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Описание
                  const Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Опишите цели и задачи сессии...',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Кнопка добавления
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addSession,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Добавить сессию'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _addSession() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите заголовок сессии')),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Сессия добавлена!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// Диалог добавления плана
class _AddPlanDialog extends StatefulWidget {
  @override
  _AddPlanDialogState createState() => _AddPlanDialogState();
}

class _AddPlanDialogState extends State<_AddPlanDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedLevel = 'beginner';
  String _selectedDuration = '3';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
            child: Row(
              children: [
                const Text(
                  'Добавить план развития',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
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
                  // Заголовок плана
                  const Text(
                    'Заголовок',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите название плана развития',
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Уровень
                  const Text(
                    'Уровень',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedLevel,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'beginner', child: Text('Начинающий')),
                      DropdownMenuItem(value: 'intermediate', child: Text('Средний')),
                      DropdownMenuItem(value: 'advanced', child: Text('Продвинутый')),
                      DropdownMenuItem(value: 'expert', child: Text('Эксперт')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLevel = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Длительность
                  const Text(
                    'Длительность (месяцы)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedDuration,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('1 месяц')),
                      DropdownMenuItem(value: '3', child: Text('3 месяца')),
                      DropdownMenuItem(value: '6', child: Text('6 месяцев')),
                      DropdownMenuItem(value: '12', child: Text('12 месяцев')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDuration = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Описание
                  const Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Опишите цели, задачи и этапы плана развития...',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Кнопка добавления
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addPlan,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Добавить план'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addPlan() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите заголовок плана')),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('План развития добавлен!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// Диалог деталей ментора
class _MentorDetailsDialog extends StatelessWidget {
  final Mentor mentor;

  const _MentorDetailsDialog({required this.mentor});

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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(mentor.avatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mentor.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        mentor.title,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
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
                  // Био
                  if (mentor.bio.isNotEmpty) ...[
                    const Text(
                      'О менторе',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mentor.bio,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Экспертиза
                  const Text(
                    'Экспертиза',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: mentor.expertise.map((skill) => 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Статистика
                  const Text(
                    'Статистика',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Сессии', '${mentor.sessionsCount}'),
                      ),
                      Expanded(
                        child: _buildStatItem('Рейтинг', '${mentor.rating.toStringAsFixed(1)}'),
                      ),
                      Expanded(
                        child: _buildStatItem('Опыт', '${mentor.experienceYears} лет'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Доступность
                  const Text(
                    'Доступность',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mentor.availability,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          
          // Кнопки действий
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Функция записи на сессию в разработке')),
                      );
                    },
                    child: const Text('Записаться'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Диалог деталей сессии
class _SessionDetailsDialog extends StatelessWidget {
  final MentorshipSession session;

  const _SessionDetailsDialog({required this.session});

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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    session.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
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
                  // Описание
                  const Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    session.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Детали сессии
                  const Text(
                    'Детали сессии',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDetailRow('Тип', _getSessionTypeText(session.type), Icons.category),
                  _buildDetailRow('Дата', _formatDate(session.scheduledDate), Icons.calendar_today),
                  _buildDetailRow('Длительность', '${session.duration} минут', Icons.schedule),
                  _buildDetailRow('Статус', _getStatusText(session.status), Icons.info),
                  
                  if (session.mentor != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Ментор',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(session.mentor!.avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.mentor!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                session.mentor!.title,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Кнопки действий
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                ),
                if (session.status == SessionStatus.scheduled) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Функция отмены сессии в разработке')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Отменить'),
                    ),
                  ),
                ],
              ],
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

  String _getSessionTypeText(SessionType type) {
    switch (type) {
      case SessionType.individual:
        return 'Индивидуальная';
      case SessionType.group:
        return 'Групповая';
      case SessionType.workshop:
        return 'Воркшоп';
      case SessionType.review:
        return 'Ревью';
    }
  }

  String _getStatusText(SessionStatus status) {
    switch (status) {
      case SessionStatus.scheduled:
        return 'Запланирована';
      case SessionStatus.completed:
        return 'Завершена';
      case SessionStatus.cancelled:
        return 'Отменена';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Диалог деталей плана
class _PlanDetailsDialog extends StatelessWidget {
  final DevelopmentPlan plan;

  const _PlanDetailsDialog({required this.plan});

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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    plan.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
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
                  // Описание
                  const Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Детали плана
                  const Text(
                    'Детали плана',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDetailRow('Уровень', _getLevelText(plan.level), Icons.trending_up),
                  _buildDetailRow('Длительность', '${plan.duration} месяцев', Icons.schedule),
                  _buildDetailRow('Прогресс', '${plan.progress}%', Icons.analytics),
                  
                  const SizedBox(height: 24),
                  
                  // Прогресс-бар
                  const Text(
                    'Прогресс выполнения',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: plan.progress / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Цели
                  if (plan.goals.isNotEmpty) ...[
                    const Text(
                      'Цели',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...plan.goals.map((goal) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(goal)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Кнопки действий
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Функция редактирования плана в разработке')),
                      );
                    },
                    child: const Text('Редактировать'),
                  ),
                ),
              ],
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

  String _getLevelText(PlanLevel level) {
    switch (level) {
      case PlanLevel.beginner:
        return 'Начинающий';
      case PlanLevel.intermediate:
        return 'Средний';
      case PlanLevel.advanced:
        return 'Продвинутый';
      case PlanLevel.expert:
        return 'Эксперт';
    }
  }
}

// Диалог деталей отзыва
class _FeedbackDetailsDialog extends StatelessWidget {
  final MentorshipFeedback feedback;

  const _FeedbackDetailsDialog({required this.feedback});

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
            child: Row(
              children: [
                const Text(
                  'Отзыв о сессии',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
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
                  // Рейтинг
                  const Text(
                    'Рейтинг',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) => 
                      Icon(
                        index < feedback.rating.index ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Комментарий
                  const Text(
                    'Комментарий',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feedback.comment,
                    style: const TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Детали отзыва
                  const Text(
                    'Детали',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDetailRow('Дата', _formatDate(feedback.createdAt), Icons.calendar_today),
                  _buildDetailRow('Сессия', feedback.sessionTitle, Icons.event),
                  _buildDetailRow('Ментор', feedback.mentorName, Icons.person),
                ],
              ),
            ),
          ),
          
          // Кнопка закрытия
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
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
