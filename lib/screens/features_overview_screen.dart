import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/intro_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class FeaturesOverviewScreen extends StatefulWidget {
  const FeaturesOverviewScreen({super.key});

  @override
  State<FeaturesOverviewScreen> createState() => _FeaturesOverviewScreenState();
}

class _FeaturesOverviewScreenState extends State<FeaturesOverviewScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Обзор функций'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppTheme.primaryColor,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Основные'),
                Tab(text: 'Аналитика'),
                Tab(text: 'Блокчейн'),
                Tab(text: 'Специализированные'),
              ],
            ),
          ),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCoreFeaturesTab(),
                _buildAnalyticsTab(),
                _buildBlockchainTab(),
                _buildSpecializedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreFeaturesTab() {
    return _buildFeaturesTab([
      _buildFeatureCard(
        'Главная страница',
        'Центральная панель управления с обзором всех проектов и активностей',
        Icons.home,
        Colors.blue,
        ['Дашборд проектов', 'Быстрые действия', 'Уведомления', 'Статистика'],
      ),
      _buildFeatureCard(
        'Портфолио проектов',
        'Управление инвестиционным портфелем и отслеживание прогресса',
        Icons.work,
        Colors.green,
        ['Список проектов', 'Детали инвестиций', 'Прогресс', 'Документы'],
      ),
      _buildFeatureCard(
        'Инвестиционные раунды',
        'Управление раундами финансирования и привлечение инвесторов',
        Icons.trending_up,
        Colors.orange,
        ['Создание раундов', 'Привлечение инвесторов', 'Управление сделками', 'Отчеты'],
      ),
      _buildFeatureCard(
        'Менторство',
        'Система наставничества для развития проектов и команд',
        Icons.psychology,
        Colors.purple,
        ['Поиск менторов', 'Сессии', 'Планы развития', 'Отзывы'],
      ),
      _buildFeatureCard(
        'Обучение',
        'Образовательная платформа с курсами и материалами',
        Icons.school,
        Colors.teal,
        ['Курсы', 'Уроки', 'Тесты', 'Сертификаты'],
      ),
      _buildFeatureCard(
        'Хакатоны',
        'Организация и участие в хакатонах для развития проектов',
        Icons.event,
        Colors.red,
        ['Создание хакатонов', 'Регистрация', 'Участие', 'Результаты'],
      ),
      _buildFeatureCard(
        'Челленджи',
        'Система вызовов и соревнований для проектов',
        Icons.emoji_events,
        Colors.amber,
        ['Создание челленджей', 'Участие', 'Оценка', 'Награды'],
      ),
    ]);
  }

  Widget _buildAnalyticsTab() {
    return _buildFeaturesTab([
      _buildFeatureCard(
        'Аналитика проектов',
        'Подробная аналитика и отчеты по проектам и инвестициям',
        Icons.analytics,
        Colors.indigo,
        ['Метрики проектов', 'Финансовая аналитика', 'Прогнозы', 'Экспорт данных'],
      ),
      _buildFeatureCard(
        'Социальная сеть',
        'Социальная платформа для взаимодействия участников экосистемы',
        Icons.people,
        Colors.blue,
        ['Профили', 'Посты', 'Комментарии', 'Подписки'],
      ),
      _buildFeatureCard(
        'Метавселенная',
        'Виртуальное пространство для взаимодействия и презентации проектов',
        Icons.view_in_ar,
        Colors.deepPurple,
        ['Виртуальные пространства', 'Аватары', 'События', 'NFT галереи'],
      ),
      _buildFeatureCard(
        'AI/ML платформа',
        'Искусственный интеллект и машинное обучение для анализа проектов',
        Icons.smart_toy,
        Colors.cyan,
        ['AI ассистент', 'ML модели', 'Предиктивная аналитика', 'Автоматизация'],
      ),
    ]);
  }

  Widget _buildBlockchainTab() {
    return _buildFeaturesTab([
      _buildFeatureCard(
        'Блокчейн DeFi',
        'Децентрализованные финансы и блокчейн-технологии',
        Icons.account_balance_wallet,
        Colors.green,
        ['Кошельки', 'Токены', 'Смарт-контракты', 'Транзакции'],
      ),
      _buildFeatureCard(
        'NFT Marketplace',
        'Создание, покупка и продажа NFT токенов',
        Icons.image,
        Colors.pink,
        ['Создание NFT', 'Коллекции', 'Аукционы', 'Торговля'],
      ),
      _buildFeatureCard(
        'Cross-chain мосты',
        'Перевод активов между различными блокчейн-сетями',
        Icons.swap_horiz,
        Colors.blue,
        ['Поддерживаемые сети', 'Маршруты', 'Комиссии', 'История'],
      ),
      _buildFeatureCard(
        'Hardware кошельки',
        'Интеграция с аппаратными кошельками для безопасности',
        Icons.security,
        Colors.orange,
        ['Ledger', 'Trezor', 'Подключение', 'Подпись транзакций'],
      ),
      _buildFeatureCard(
        'DEX торговля',
        'Децентрализованная торговля токенами',
        Icons.swap_horiz,
        Colors.purple,
        ['Свапы', 'Ликвидность', 'Ордера', 'История'],
      ),
      _buildFeatureCard(
        'Yield Farming',
        'Управление доходностью и стейкингом',
        Icons.agriculture,
        Colors.teal,
        ['Пуллы', 'Стейкинг', 'Награды', 'Стратегии'],
      ),
      _buildFeatureCard(
        'DAO управление',
        'Децентрализованное автономное управление проектами',
        Icons.account_balance,
        Colors.indigo,
        ['Предложения', 'Голосование', 'Делегирование', 'Токеномика'],
      ),
    ]);
  }

  Widget _buildSpecializedTab() {
    return _buildFeaturesTab([
      _buildFeatureCard(
        'Web3 Identity',
        'Децентрализованная идентификация и репутация',
        Icons.verified_user,
        Colors.blue,
        ['DID', 'Верификация', 'Достижения', 'Репутация'],
      ),
      _buildFeatureCard(
        'Gaming & Play-to-Earn',
        'Игровая платформа с возможностью заработка',
        Icons.games,
        Colors.green,
        ['Игровые миры', 'Персонажи', 'Турниры', 'Награды'],
      ),
      _buildFeatureCard(
        'Образование',
        'Web3 образовательная платформа',
        Icons.school,
        Colors.orange,
        ['Курсы', 'Уроки', 'Тесты', 'Прогресс'],
      ),
      _buildFeatureCard(
        'Здравоохранение',
        'Web3 платформа для здравоохранения',
        Icons.medical_services,
        Colors.red,
        ['Врачи', 'Приемы', 'Записи', 'Страховки'],
      ),
    ]);
  }

  Widget _buildFeaturesTab(List<Widget> features) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: features,
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color,
    List<String> subFeatures,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: subFeatures.map((feature) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
