import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/providers/auth_provider.dart';
import 'tabs/buyer_discover_tab.dart';
import 'tabs/buyer_saved_tab.dart';
import 'tabs/buyer_orders_tab.dart';
import 'tabs/buyer_profile_tab.dart';
import 'package:go_router/go_router.dart';
import 'widgets/buyer_card_nav.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const BuyerDiscoverTab(),
    const BuyerSavedTab(),
    const BuyerOrdersTab(),
    const BuyerProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundCream, // Updated to light theme
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(top: 84.0),
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _tabs,
                  ),
                ),
              ),
              BuyerCardNav(
                currentIndex: _currentIndex,
                onTabSelected: (i) => setState(() => _currentIndex = i),
                onSignOut: () { AuthProvider().signOut(); context.go('/'); },
              ),
            ],
          ),
        );
      },
    );
  }
}
