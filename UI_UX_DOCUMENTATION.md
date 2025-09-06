# 🎨 REChain®️ VC Lab - UI/UX Документация

## 🎯 Обзор дизайн-системы

REChain®️ VC Lab использует современную дизайн-систему, основанную на Material Design 3 с кастомными элементами, адаптированными для венчурного инвестирования и Web3 технологий.

## 🏗️ Архитектура UI/UX

### 1. **Слои дизайна**
```
Design Tokens (Цвета, типографика, отступы)
    ↓
Component Library (Базовые компоненты)
    ↓
Screen Templates (Шаблоны экранов)
    ↓
Application Screens (Экраны приложения)
```

### 2. **Принципы дизайна**
- **Простота** - минималистичный и понятный интерфейс
- **Консистентность** - единообразие во всех элементах
- **Доступность** - поддержка различных устройств и пользователей
- **Инновационность** - современный дизайн для Web3 эпохи

## 🎨 Дизайн-токены

### 1. **Цветовая палитра**

#### Основные цвета
```dart
class AppTheme {
  // Основной цвет REChain
  static const Color primaryColor = Color(0xFF1E3A8A);
  
  // Вторичный цвет
  static const Color secondaryColor = Color(0xFF3B82F6);
  
  // Акцентный цвет
  static const Color accentColor = Color(0xFF10B981);
  
  // Цвет успеха
  static const Color successColor = Color(0xFF059669);
  
  // Цвет предупреждения
  static const Color warningColor = Color(0xFFD97706);
  
  // Цвет ошибки
  static const Color errorColor = Color(0xFFDC2626);
}
```

#### Градиенты
```dart
class AppTheme {
  // Основной градиент
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF3B82F6),
      Color(0xFF10B981),
    ],
  );
  
  // Градиент для карточек
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Color(0xFFF8FAFC),
    ],
  );
}
```

### 2. **Типографика**

#### Размеры шрифтов
```dart
class AppTypography {
  // Заголовки
  static const double h1 = 32.0;
  static const double h2 = 28.0;
  static const double h3 = 24.0;
  static const double h4 = 20.0;
  static const double h5 = 18.0;
  static const double h6 = 16.0;
  
  // Текст
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  
  // Кнопки
  static const double buttonLarge = 16.0;
  static const double buttonMedium = 14.0;
  static const double buttonSmall = 12.0;
}
```

#### Стили текста
```dart
class AppTextStyles {
  // Основной заголовок
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    height: 1.2,
  );
  
  // Подзаголовок
  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    height: 1.3,
  );
  
  // Основной текст
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
    height: 1.5,
  );
  
  // Вторичный текст
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
    height: 1.4,
  );
}
```

### 3. **Отступы и размеры**

#### Система отступов
```dart
class AppSpacing {
  // Базовые отступы
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  // Специальные отступы
  static const double screenPadding = 16.0;
  static const double cardPadding = 16.0;
  static const double buttonPadding = 12.0;
  static const double inputPadding = 12.0;
}
```

#### Размеры компонентов
```dart
class AppSizes {
  // Кнопки
  static const double buttonHeight = 48.0;
  static const double buttonMinWidth = 120.0;
  
  // Поля ввода
  static const double inputHeight = 48.0;
  static const double inputBorderRadius = 8.0;
  
  // Карточки
  static const double cardBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Аватары
  static const double avatarSmall = 32.0;
  static const double avatarMedium = 48.0;
  static const double avatarLarge = 64.0;
}
```

## 🧩 Библиотека компонентов

### 1. **Базовые компоненты**

#### Кнопки
```dart
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final IconData? icon;
  
  // Типы кнопок
  enum ButtonType {
    primary,    // Основная кнопка
    secondary,  // Вторичная кнопка
    outline,    // Контурная кнопка
    text,       // Текстовая кнопка
    danger,     // Опасная кнопка
  }
  
  // Размеры кнопок
  enum ButtonSize {
    small,      // Маленькая
    medium,     // Средняя
    large,      // Большая
  }
}
```

#### Поля ввода
```dart
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
}
```

#### Карточки
```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final double? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isInteractive;
}
```

### 2. **Специализированные компоненты**

#### Карточка проекта
```dart
class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  
  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок проекта
          Text(
            project.name,
            style: AppTextStyles.h3,
          ),
          
          // Описание
          Text(
            project.description,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Метрики
          _buildMetrics(project),
          
          // Действия
          _buildActions(),
        ],
      ),
    );
  }
}
```

#### Карточка NFT
```dart
class NFTCard extends StatelessWidget {
  final NFT nft;
  final VoidCallback? onTap;
  final VoidCallback? onBuy;
  final VoidCallback? onBid;
  
  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          // Изображение NFT
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
            child: Image.network(
              nft.metadata['image'] ?? '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          
          // Информация
          Padding(
            padding: EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nft.metadata['name'] ?? 'Unnamed NFT',
                  style: AppTextStyles.h4,
                ),
                Text(
                  nft.metadata['description'] ?? '',
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Цена и действия
                _buildPriceAndActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

#### График цен
```dart
class PriceChart extends StatelessWidget {
  final List<PricePoint> data;
  final String title;
  final Duration period;
  final VoidCallback? onPeriodChanged;
  
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок и период
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.h4),
              _buildPeriodSelector(),
            ],
          ),
          
          // График
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _convertToFlSpot(data),
                    isCurved: true,
                    color: AppTheme.primaryColor,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3. **Навигационные компоненты**

#### Горизонтальная навигация
```dart
class HorizontalNavigationBar extends StatelessWidget {
  final List<NavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool showIndicator;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;
          
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                item.title,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

#### Боковая навигация
```dart
class SideNavigation extends StatelessWidget {
  final List<NavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isCollapsed;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 64 : 240,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          // Логотип
          _buildLogo(),
          
          // Навигационные элементы
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == currentIndex;
                
                return _buildNavigationItem(item, index, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## 📱 Шаблоны экранов

### 1. **Основные шаблоны**

#### Шаблон списка
```dart
class ListScreenTemplate extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? floatingActionButton;
  final Widget? searchBar;
  final List<Widget>? actions;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Column(
        children: [
          // Поиск
          if (searchBar != null) searchBar!,
          
          // Список
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              children: children,
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
```

#### Шаблон с вкладками
```dart
class TabScreenTemplate extends StatefulWidget {
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final String title;
  final List<Widget>? actions;
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions,
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: tabViews,
        ),
      ),
    );
  }
}
```

### 2. **Специализированные шаблоны**

#### Шаблон деталей
```dart
class DetailScreenTemplate extends StatelessWidget {
  final String title;
  final Widget header;
  final List<Widget> sections;
  final List<Widget> actions;
  final bool showBackButton;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton ? BackButton() : null,
        actions: actions,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            header,
            
            // Секции
            ...sections.map((section) => Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              child: section,
            )),
          ],
        ),
      ),
    );
  }
}
```

#### Шаблон формы
```dart
class FormScreenTemplate extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> formFields;
  final List<Widget> actions;
  final VoidCallback? onSave;
  final bool isLoading;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            // Поля формы
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  children: formFields,
                ),
              ),
            ),
            
            // Действия
            Container(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: actions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🔄 Анимации и переходы

### 1. **Базовые анимации**

#### Fade анимация
```dart
class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}
```

#### Slide анимация
```dart
class SlideInWidget extends StatefulWidget {
  final Widget child;
  final Offset begin;
  final Offset end;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: this.child,
    );
  }
}
```

### 2. **Специализированные анимации**

#### Анимация загрузки
```dart
class LoadingAnimation extends StatefulWidget {
  final Color color;
  final double size;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 3,
      ),
    );
  }
}
```

#### Анимация прогресса
```dart
class ProgressAnimation extends StatefulWidget {
  final double progress;
  final Color color;
  final double height;
  
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: height,
        );
      },
    );
  }
}
```

## 📱 Адаптивность

### 1. **Responsive дизайн**

#### Адаптивные размеры
```dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

#### Адаптивные отступы
```dart
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        EdgeInsets padding;
        
        if (constraints.maxWidth >= 1200) {
          padding = desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600) {
          padding = tablet ?? mobile;
        } else {
          padding = mobile;
        }
        
        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }
}
```

### 2. **Платформо-специфичные элементы**

#### iOS элементы
```dart
class IOSStyleButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? color;
  
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: color ?? CupertinoColors.activeBlue,
        child: Text(title),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      );
    }
  }
}
```

#### Android элементы
```dart
class AndroidStyleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: child,
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    }
  }
}
```

## 🎯 Доступность

### 1. **Семантические элементы**

#### Семантические метки
```dart
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? hint;
  final VoidCallback? onPressed;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      child: GestureDetector(
        onTap: onPressed,
        child: child,
      ),
    );
  }
}
```

#### Семантические заголовки
```dart
class AccessibleHeading extends StatelessWidget {
  final String text;
  final int level;
  final TextStyle? style;
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
```

### 2. **Навигация по клавиатуре**

#### Фокус навигация
```dart
class FocusableList extends StatelessWidget {
  final List<Widget> children;
  
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Column(
        children: children.map((child) {
          return Focus(
            child: child,
          );
        }).toList(),
      ),
    );
  }
}
```

## 📊 Тестирование UI

### 1. **Widget тесты**

#### Тест компонента
```dart
void main() {
  group('AppButton Tests', () {
    testWidgets('should display text correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppButton(
            text: 'Test Button',
            onPressed: () {},
          ),
        ),
      );
      
      expect(find.text('Test Button'), findsOneWidget);
    });
    
    testWidgets('should call onPressed when tapped', (tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: AppButton(
            text: 'Test Button',
            onPressed: () => wasPressed = true,
          ),
        ),
      );
      
      await tester.tap(find.byType(AppButton));
      expect(wasPressed, true);
    });
  });
}
```

#### Тест экрана
```dart
void main() {
  group('ProjectListScreen Tests', () {
    testWidgets('should display projects correctly', (tester) async {
      final mockProjects = [
        Project(id: '1', name: 'Project 1'),
        Project(id: '2', name: 'Project 2'),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: ProjectListScreen(projects: mockProjects),
        ),
      );
      
      expect(find.text('Project 1'), findsOneWidget);
      expect(find.text('Project 2'), findsOneWidget);
    });
  });
}
```

---

*Документация создана: ${DateTime.now().toString()}*  
*Версия: 1.0*  
*Статус: В разработке 🔄*
