import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/notification_provider.dart';
import 'package:rechain_vc_lab/screens/home_screen.dart';
import 'package:rechain_vc_lab/screens/hackathons_screen.dart';
import 'package:rechain_vc_lab/screens/challenges_screen.dart';
import 'package:rechain_vc_lab/screens/portfolio_screen.dart';
import 'package:rechain_vc_lab/screens/profile_screen.dart';
import 'package:rechain_vc_lab/screens/platform_compiler_screen.dart';
import 'package:rechain_vc_lab/screens/notifications_screen.dart';
import 'package:rechain_vc_lab/screens/chat_screen.dart';
import 'package:rechain_vc_lab/screens/learning_screen.dart';
import 'package:rechain_vc_lab/screens/compiler_screen.dart';
import 'package:rechain_vc_lab/screens/investments_screen.dart';
import 'package:rechain_vc_lab/screens/mentorship_screen.dart';
import 'package:rechain_vc_lab/screens/analytics_screen.dart';
import 'package:rechain_vc_lab/screens/social_network_screen.dart';
import 'package:rechain_vc_lab/screens/metaverse_screen.dart';
import 'package:rechain_vc_lab/screens/ai_ml_screen.dart';
import 'package:rechain_vc_lab/screens/blockchain_defi_screen.dart';
import 'package:rechain_vc_lab/screens/cross_chain_bridge_screen.dart';
import 'package:rechain_vc_lab/screens/nft_marketplace_screen.dart';
import 'package:rechain_vc_lab/screens/defi_analytics_screen.dart';
import 'package:rechain_vc_lab/screens/hardware_wallet_screen.dart';
import 'package:rechain_vc_lab/screens/dex_trading_screen.dart';
import 'package:rechain_vc_lab/screens/yield_farming_screen.dart';
import 'package:rechain_vc_lab/screens/governance_dao_screen.dart';
import 'package:rechain_vc_lab/screens/web3_identity_screen.dart';
import 'package:rechain_vc_lab/screens/web3_gaming_screen.dart';
import 'package:rechain_vc_lab/screens/web3_education_screen.dart';
import 'package:rechain_vc_lab/screens/web3_healthcare_screen.dart';
import 'package:rechain_vc_lab/screens/achievements_screen.dart';
import 'package:rechain_vc_lab/screens/reputation_screen.dart';
import 'package:rechain_vc_lab/screens/web4_movement_screen.dart';
import 'package:rechain_vc_lab/screens/web5_creation_screen.dart';
import 'package:rechain_vc_lab/providers/achievements_provider.dart';
import 'package:rechain_vc_lab/providers/reputation_provider.dart';
import 'package:rechain_vc_lab/providers/realtime_notifications_provider.dart';
import 'package:rechain_vc_lab/widgets/realtime_notification_widget.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<_NavItem> _navItems;
  
  _MainScreenState() : _navItems = const [
    _NavItem(HomeScreen(), Icons.home, 'Главная'),
    _NavItem(HackathonsScreen(), Icons.event, 'Хакатоны'),
    _NavItem(ChallengesScreen(), Icons.emoji_events, 'Челленджи'),
    _NavItem(ChatScreen(), Icons.chat, 'Чаты'),
    _NavItem(LearningScreen(), Icons.school, 'Обучение'),
    _NavItem(PortfolioScreen(), Icons.work, 'Портфолио'),
    _NavItem(CompilerScreen(), Icons.build, 'Компилятор'),
    _NavItem(InvestmentsScreen(), Icons.trending_up, 'Инвестиции'),
    _NavItem(MentorshipScreen(), Icons.psychology, 'Менторство'),
    _NavItem(AnalyticsScreen(), Icons.analytics, 'Аналитика'),
    _NavItem(SocialNetworkScreen(), Icons.people, 'Соцсеть'),
    _NavItem(MetaverseScreen(), Icons.view_in_ar, 'Метавселенная'),
    _NavItem(AIMLScreen(), Icons.smart_toy, 'ИИ/ML'),
    _NavItem(BlockchainDeFiScreen(), Icons.account_balance_wallet, 'Блокчейн'),
    _NavItem(NFTMarketplaceScreen(), Icons.image, 'NFT'),
    _NavItem(CrossChainBridgeScreen(), Icons.swap_horiz, 'Мост'),
    _NavItem(DeFiAnalyticsScreen(), Icons.analytics, 'DeFi'),
    _NavItem(HardwareWalletScreen(), Icons.security, 'Кошелек'),
    _NavItem(DEXTradingScreen(), Icons.swap_horiz, 'DEX'),
    _NavItem(YieldFarmingScreen(), Icons.agriculture, 'Ферминг'),
    _NavItem(GovernanceDAOScreen(), Icons.account_balance, 'DAO'),
    _NavItem(Web3IdentityScreen(), Icons.verified_user, 'Identity'),
    _NavItem(Web3GamingScreen(), Icons.games, 'Gaming'),
    _NavItem(Web3EducationScreen(), Icons.school, 'Education'),
    _NavItem(Web3HealthcareScreen(), Icons.medical_services, 'Healthcare'),
    _NavItem(AchievementsScreen(), Icons.emoji_events, 'Достижения'),
    _NavItem(ReputationScreen(), Icons.stars, 'Репутация'),
    _NavItem(Web4MovementScreen(), Icons.trending_up, 'Web4'),
    _NavItem(Web5CreationScreen(), Icons.auto_awesome, 'Web5'),
    _NavItem(ProfileScreen(), Icons.person, 'Профиль'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeProviders());
  }

  void _initializeProviders() {
    if (!mounted) return;
    try {
      final achievementsProvider = context.read<AchievementsProvider>();
      final reputationProvider = context.read<ReputationProvider>();
      final realtimeProvider = context.read<RealtimeNotificationsProvider>();
      achievementsProvider.initialize();
      reputationProvider.initialize();
      realtimeProvider.initialize(
        notificationProvider: context.read<NotificationProvider>(),
        reputationProvider: reputationProvider,
        achievementsProvider: achievementsProvider,
      );
    } catch (e, st) {
      debugPrint('MainScreen: provider init error: $e\n$st');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RealtimeNotificationsProvider>(
      builder: (context, realtimeProvider, child) {
        return RealtimeNotificationOverlay(
          provider: realtimeProvider,
          child: Scaffold(
            body: IndexedStack(index: _currentIndex, children: _navItems.map((item) => item.screen).toList()),
            floatingActionButton: _buildNotificationsFAB(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            bottomNavigationBar: _buildBottomNav(),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_navItems.length, (i) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    height: 3,
                    decoration: BoxDecoration(
                      color: _currentIndex == i ? AppTheme.primaryColor : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 6),
            Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: _navItems.asMap().entries.map((e) => _buildNavItem(e.key, e.value.icon, e.value.label)).toList(),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Icon(Icons.chevron_right, color: AppTheme.primaryColor, size: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsFAB() {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final unreadCount = notificationProvider.unreadCount;
        return FloatingActionButton.small(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          child: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              if (unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isSelected ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1) : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final Widget screen;
  final IconData icon;
  final String label;
  const _NavItem(this.screen, this.icon, this.label);
}
