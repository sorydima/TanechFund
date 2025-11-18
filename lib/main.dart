import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/app_provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/providers/notification_provider.dart';
import 'package:rechain_vc_lab/providers/chat_provider.dart';
import 'package:rechain_vc_lab/providers/payment_provider.dart';
import 'package:rechain_vc_lab/providers/learning_provider.dart';
import 'package:rechain_vc_lab/providers/portfolio_provider.dart';
import 'package:rechain_vc_lab/providers/compiler_provider.dart';
import 'package:rechain_vc_lab/providers/investment_provider.dart';
import 'package:rechain_vc_lab/providers/mentorship_provider.dart';
import 'package:rechain_vc_lab/providers/analytics_provider.dart';
import 'package:rechain_vc_lab/providers/social_network_provider.dart';
import 'package:rechain_vc_lab/providers/metaverse_provider.dart';
import 'package:rechain_vc_lab/providers/ai_ml_provider.dart';
import 'package:rechain_vc_lab/providers/achievements_provider.dart';
import 'package:rechain_vc_lab/providers/reputation_provider.dart';
import 'package:rechain_vc_lab/providers/realtime_notifications_provider.dart';
import 'package:rechain_vc_lab/providers/intro_provider.dart';
import 'package:rechain_vc_lab/providers/web4_movement_provider.dart';
import 'package:rechain_vc_lab/providers/web5_creation_provider.dart';
import 'package:rechain_vc_lab/screens/splash_screen.dart';
import 'package:rechain_vc_lab/screens/intro_screen.dart';
import 'package:rechain_vc_lab/screens/features_overview_screen.dart';
import 'package:rechain_vc_lab/screens/navigation_guide_screen.dart';
import 'package:rechain_vc_lab/screens/login_screen.dart';
import 'package:rechain_vc_lab/screens/main_screen.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Настройка системного UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Предотвращение поворота экрана
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const REChainApp());
}

class REChainApp extends StatelessWidget {
  const REChainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => LearningProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => CompilerProvider()),
        ChangeNotifierProvider(create: (_) => InvestmentProvider()),
        ChangeNotifierProvider(create: (_) => MentorshipProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => SocialNetworkProvider()),
        ChangeNotifierProvider(create: (_) => MetaverseProvider()),
        ChangeNotifierProvider(create: (_) => AIMLProvider()),
        ChangeNotifierProvider(create: (_) => AchievementsProvider()),
        ChangeNotifierProvider(create: (_) => ReputationProvider()),
        ChangeNotifierProvider(create: (_) => RealtimeNotificationsProvider()),
        ChangeNotifierProvider(create: (_) => IntroProvider()),
        ChangeNotifierProvider(create: (_) => Web4MovementProvider()),
        ChangeNotifierProvider(create: (_) => Web5CreationProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'REChain®️ VC Lab',
            debugShowCheckedModeBanner: false,
            theme: appProvider.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: const AppRouter(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/main': (context) => MainScreen(),
              '/intro': (context) => const IntroScreen(),
              '/features-overview': (context) => const FeaturesOverviewScreen(),
              '/navigation-guide': (context) => const NavigationGuideScreen(),
            },
          );
        },
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        // Если это первый запуск, показываем splash screen
        if (appProvider.isFirstLaunch) {
          return const SplashScreen();
        }
        
        // Если не первый запуск, проверяем аутентификацию
        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Если пользователь аутентифицирован, показываем главный экран или интро
            if (authProvider.isAuthenticated) {
              return Consumer<IntroProvider>(
                builder: (context, introProvider, child) {
                  // Show intro if not completed
                  if (!introProvider.isIntroCompleted) {
                    return const IntroScreen();
                  }
                  
                  return MainScreen();
                },
              );
            }
            
            // Иначе показываем экран входа
            return const LoginScreen();
          },
        );
      },
    );
  }
}
