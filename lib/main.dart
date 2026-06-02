import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/core/error_handler.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/network/network_manager.dart';
import 'package:rechain_vc_lab/core/storage/cache_service.dart';
import 'package:rechain_vc_lab/core/stability/health_check_service.dart';
import 'package:rechain_vc_lab/di/injection.dart';
import 'package:rechain_vc_lab/providers/theme_provider.dart';
import 'package:rechain_vc_lab/providers/app_provider_v2.dart';
import 'package:rechain_vc_lab/providers/auth_provider_v2.dart';
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
import 'package:rechain_vc_lab/services/storage_service.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  ErrorHandler.initialize();

  // Инициализация StorageService ДО DI контейнера
  final storageService = await StorageService.getInstance();
  AppLogger.info('StorageService initialized');

  // Регистрация StorageService в DI контейнере
  getIt.registerSingleton<StorageService>(storageService);
  
  // Инициализация DI
  configureDependencies();
  AppLogger.info('DI container initialized');

  // Инициализация CacheService
  final cacheService = getIt.get<CacheService>();
  final cacheInitResult = await cacheService.initialize();
  if (cacheInitResult.isFailure) {
    AppLogger.error('CacheService initialization failed', cacheInitResult.error);
  } else {
    AppLogger.info('CacheService initialized');
  }

  // Инициализация HealthCheckService с периодической проверкой
  final healthCheckService = getIt.get<HealthCheckService>();
  await healthCheckService.initialize(checkInterval: const Duration(minutes: 2));
  AppLogger.info('HealthCheckService initialized');

  // Инициализация NetworkManager
  await getIt.get<NetworkManager>().initialize();
  AppLogger.info('NetworkManager initialized');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  ErrorWidget.builder = ErrorHandler.buildErrorWidget;

  runApp(const REChainApp());
}

class REChainApp extends StatelessWidget {
  const REChainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // V2 провайдеры из DI контейнера
    final appProviderV2 = getIt.get<AppProviderV2>();
    final authProviderV2 = getIt.get<AuthProviderV2>();
    final web4Provider = getIt.get<Web4MovementProvider>();

    return MultiProvider(
      providers: [
        // Legacy провайдеры (пока остаются для обратной совместимости)
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
        ChangeNotifierProvider(create: (_) => Web5CreationProvider()),
        
        // V2 провайдеры из DI
        ChangeNotifierProvider<AppProviderV2>.value(value: appProviderV2),
        ChangeNotifierProvider<AuthProviderV2>.value(value: authProviderV2),
        ChangeNotifierProvider<Web4MovementProvider>.value(value: web4Provider),
      ],
      child: Consumer2<ThemeProvider, AppProviderV2>(
        builder: (context, themeProvider, appProvider, child) {
          return MaterialApp(
            title: 'REChain®️ VC Lab',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AppRouter(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/main': (context) => const MainScreen(),
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
    return Consumer<AppProviderV2>(
      builder: (context, appProvider, child) {
        if (!appProvider.isAppInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (appProvider.isFirstLaunch) {
          return const SplashScreen();
        }

        return Consumer<AuthProviderV2>(
          builder: (context, authProvider, child) {
            if (authProvider.isAuthenticated) {
              return Consumer<IntroProvider>(
                builder: (context, introProvider, child) {
                  if (!introProvider.isIntroCompleted) {
                    return const IntroScreen();
                  }
                  return const MainScreen();
                },
              );
            }
            return const LoginScreen();
          },
        );
      },
    );
  }
}
