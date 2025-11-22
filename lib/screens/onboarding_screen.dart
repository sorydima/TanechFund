import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/app_provider.dart';
import 'package:rechain_vc_lab/screens/main_screen.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Venture Builder',
      subtitle: 'Создаем венчурные проекты с нуля',
      description: 'Мы помогаем предпринимателям создавать инновационные стартапы в сфере блокчейна и Web3',
      icon: Icons.rocket_launch,
      color: AppTheme.primaryColor,
    ),
    OnboardingPage(
      title: 'Incubator',
      subtitle: 'Инкубируем перспективные стартапы',
      description: 'Предоставляем ресурсы, наставничество и поддержку для развития вашего проекта',
      icon: Icons.egg_alt,
      color: AppTheme.secondaryColor,
    ),
    OnboardingPage(
      title: 'Startup Studio',
      subtitle: 'Студия стартапов нового поколения',
      description: 'Создаем экосистему для быстрого запуска и масштабирования блокчейн-проектов',
      icon: Icons.business,
      color: AppTheme.accentColor,
    ),
    OnboardingPage(
      title: 'Investment Syndicate',
      subtitle: 'Глобальный доступ к инвестициям',
      description: 'Объединяем инвесторов со всего мира для финансирования перспективных проектов',
      icon: Icons.trending_up,
      color: AppTheme.successColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Пропустить кнопка
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _completeOnboarding(),
                child: const Text(
                  'Пропустить',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            
            // PageView для слайдов
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            
            // Индикаторы страниц
            SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Точки
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? _pages[index].color
                                : AppTheme.borderColor,
                          ),
                        ).animate().scale(
                          duration: 200.ms,
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                    
                    // Кнопка Далее/Начать
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      child: Text(
                        _currentPage < _pages.length - 1 ? 'Далее' : 'Начать',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Иконка
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          )
              .animate()
              .scale(duration: 600.ms)
              .then()
              .shake(duration: 400.ms),
          
          const SizedBox(height: 40),
          
          // Заголовок
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 16),
          
          // Подзаголовок
          Text(
            page.subtitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: page.color,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 24),
          
          // Описание
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondaryColor,
              fontFamily: 'Inter',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  void _completeOnboarding() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.setFirstLaunchComplete();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}
