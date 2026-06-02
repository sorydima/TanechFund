# 📱 UI Screens Guide — REChain®️ VC Lab

## 🎨 Созданные экраны

### 1. **PortfolioScreen** — Портфолио проектов

**Путь:** `lib/screens/portfolio_screen.dart`

**Функционал:**
- ✅ 3 вкладки: Все проекты / Мои / Популярные
- ✅ Поиск по названию, описанию, технологиям
- ✅ Фильтры по категории и статусу
- ✅ Pull-to-refresh для обновления
- ✅ Добавление нового проекта через диалог
- ✅ Детали проекта с переходом
- ✅ Лайки проектов с обратной связью
- ✅ Анимации появления карточек
- ✅ Красивые пустые состояния

**Особенности:**
```dart
// Result pattern для обработки ошибок
final result = await provider.addProject(project);
if (result.isSuccess) {
  showSuccessSnackBar('Проект создан!');
} else {
  showErrorSnackBar(result.error?.message);
}
```

**Компоненты:**
- Карточка проекта с изображением
- Бейджи статуса и категории
- Рейтинг со звёздами
- Технологии в виде чипов
- Статистика (лайки, просмотры)
- Кнопки GitHub/Live Demo

---

### 2. **InvestmentDashboardScreen** — Инвестиционный дашборд

**Путь:** `lib/screens/investment_dashboard_screen.dart`

**Функционал:**
- ✅ Портфолио саммари с градиентом
- ✅ Общая статистика (инвестировано, прибыль)
- ✅ Быстрые карточки: Активные/Завершённые/В ожидании
- ✅ Список инвестиционных возможностей
- ✅ Прогресс бары сбора средств
- ✅ Фильтр по категориям (DeFi, NFT, Gaming, DAO)
- ✅ Рейтинг проектов
- ✅ Кнопка инвестирования

**Дизайн:**
```dart
// Градиентная карточка портфолио
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryColor, primaryColor.withOpacity(0.7)],
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [/* тень */],
  ),
)
```

**Метрики:**
- Собрано / Цель
- Количество инвесторов
- Дней осталось
- Минимальная инвестиция

---

### 3. **SocialFeedScreen** — Социальная лента

**Путь:** `lib/screens/social_feed_screen.dart`

**Функционал:**
- ✅ Stories как в Instagram
- ✅ Фильтры: Все / Проекты / Достижения / Обновления / События
- ✅ 4 типа постов:
  - **Project** — запуск проекта
  - **Achievement** — достижения пользователей
  - **Update** — обновления версий
  - **Milestone** — важные события
- ✅ Лайки, комментарии, шеры
- ✅ Вложенный контент (превью проектов, достижений)
- ✅ Bottom sheet с опциями поста
- ✅ FAB для создания поста

**Типы контента:**

1. **Project Preview:**
   - Название проекта
   - Категория
   - Кнопка перехода

2. **Achievement Preview:**
   - Иконка достижения
   - Название
   - Цветовая схема

3. **Update Preview:**
   - Версия
   - Список изменений
   - Checklist

4. **Milestone Preview:**
   - Название события
   - Сумма/значение
   - Иконка праздника

---

## 🎨 Общие паттерны дизайна

### Цветовая схема
```dart
// Основной цвет
AppTheme.primaryColor    // Синий/фиолетовый

// Акцентный цвет
AppTheme.accentColor     // Оранжевый/розовый

// Статусы
Colors.green    // Успех, DeFi
Colors.purple   // NFT
Colors.blue     // Gaming
Colors.orange   // DAO
Colors.red      // Ошибка, отменён
```

### Анимации
```dart
.animate()
  .fadeIn(delay: Duration(milliseconds: index * 50))
  .slideX(begin: 0.3, end: 0)
  .scale(begin: Offset(0.9, 0.9), end: Offset(1.0, 1.0))
```

### Карточки
```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: // контент
)
```

### Пустые состояния
```dart
_buildEmptyState(
  'Заголовок',
  'Подзаголовок',
  icon: Icons.work_outline,
  actionButton: ElevatedButton(...),
)
```

---

## 🔄 State Management

### Provider Pattern
```dart
Consumer<PortfolioProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }
    return ListView.builder(...);
  },
)
```

### Result Pattern
```dart
Future<void> _likeProject(ProjectModel project, provider) async {
  final result = await provider.likeProject(project.id);
  if (mounted) {
    if (result.isSuccess) {
      showSuccessSnackBar('Лайк поставлен!');
    } else {
      showErrorSnackBar(result.error?.message);
    }
  }
}
```

---

## 📊 Метрики экранов

| Экран | Строк кода | Виджетов | Анимаций | State |
|-------|-----------|----------|----------|-------|
| PortfolioScreen | ~600 | 25+ | 10+ | StatefulWidget |
| InvestmentDashboard | ~450 | 20+ | 8+ | StatefulWidget |
| SocialFeedScreen | ~550 | 30+ | 12+ | StatefulWidget |

---

## 🎯 UX улучшения

### 1. Обратная связь
- ✅ SnackBar при действиях
- ✅ Индикаторы загрузки
- ✅ Pull-to-refresh
- ✅ Анимации переходов

### 2. Доступность
- ✅ Tooltip для иконок
- ✅ Контрастные цвета
- ✅ Крупные tap targets (48x48)
- ✅ Семантические лейблы

### 3. Производительность
- ✅ ListView.builder для ленивой загрузки
- ✅ const виджеты где возможно
- ✅ Избегание rebuild через Consumer
- ✅ Оптимизированные анимации

---

## 🚀 Следующие улучшения

### Краткосрочные
- [ ] Добавить skeleton loaders
- [ ] Infinite scroll для лент
- [ ] Кэширование изображений
- [ ] Offline режим

### Среднесрочные
- [ ] Dark theme поддержка
- [ ] Адаптация под планшеты
- [ ] Custom scroll physics
- [ ] Hero анимации между экранами

### Долгосрочные
- [ ] Lottie анимации
- [ ] 3D трансформации
- [ ] AR превью проектов
- [ ] Video backgrounds

---

## 📱 Навигация

### Добавление в MainScreen
```dart
// lib/screens/main_screen.dart
_navItems.add(_NavItem(
  icon: Icons.account_balance_wallet,
  label: 'Инвестиции',
  screen: const InvestmentDashboardScreen(),
));

_navItems.add(_NavItem(
  icon: Icons.people,
  label: 'Сообщество',
  screen: const SocialFeedScreen(),
));
```

### Роутинг
```dart
// lib/routes.dart
'portfolio': (context) => const PortfolioScreen(),
'investments': (context) => const InvestmentDashboardScreen(),
'social': (context) => const SocialFeedScreen(),
```

---

## 🧪 Тестирование

### Widget тесты
```dart
testWidgets('PortfolioScreen displays projects', (tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => PortfolioProvider(),
      child: const MaterialApp(home: PortfolioScreen()),
    ),
  );
  
  expect(find.text('Портфолио'), findsOneWidget);
  expect(find.byType(Card), findsWidgets);
});
```

### Integration тесты
```dart
testWidgets('Like project updates UI', (tester) async {
  // ... setup ...
  await tester.tap(find.byIcon(Icons.favorite_border));
  await tester.pumpAndSettle();
  expect(find.byIcon(Icons.favorite), findsOneWidget);
});
```

---

## 📚 Ресурсы

- [Flutter Material Design](https://material.io/develop/flutter)
- [Flutter Animate](https://pub.dev/packages/flutter_animate)
- [Provider Package](https://pub.dev/packages/provider)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

---

**REChain®️ VC Lab** — Современные UI паттерны для Web3 приложений
