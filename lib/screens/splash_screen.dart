import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/app_provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/screens/main_screen.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Ждем 3 секунды для показа анимации
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Если это первый запуск, показываем интро
      if (appProvider.isFirstLaunch) {
        Navigator.of(context).pushReplacementNamed('/intro');
      }
      // Если пользователь уже аутентифицирован, показываем главный экран
      else if (authProvider.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
      // Иначе показываем экран входа
      else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Логотип REChain
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  size: 60,
                  color: AppTheme.primaryColor,
                ),
              )
                  .animate()
                  .scale(duration: 600.ms)
                  .then()
                  .shake(duration: 400.ms),
              
              const SizedBox(height: 40),
              
              // Название приложения
              Text(
                'REChain®️',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 16),
              
              Text(
                'VC Group Lab',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  fontFamily: 'Inter',
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 8),
              
              Text(
                'Venture Builder • Incubator • Startup Studio',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white60,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 80),
              
              // Индикатор загрузки
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              )
                  .animate()
                  .fadeIn(delay: 1200.ms, duration: 600.ms),
              
              const SizedBox(height: 40),
              
              // Подзаголовок
              Text(
                'Building the future of Web3',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.5),
                  fontFamily: 'Inter',
                ),
              )
                  .animate()
                  .fadeIn(delay: 1500.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
