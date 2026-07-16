import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import 'tabs/seller_home_tab.dart';
import 'tabs/seller_products_tab.dart';
import 'tabs/seller_lms_tab.dart';
import 'tabs/seller_payments_tab.dart';
import 'tabs/seller_help_tab.dart';
import 'package:go_router/go_router.dart';
import 'widgets/seller_card_nav.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const SellerHomeTab(),
    const SellerProductsTab(),
    const SellerLmsTab(),
    const SellerPaymentsTab(),
    const SellerHelpTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundCream,
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
              SellerCardNav(
                currentIndex: _currentIndex,
                onTabSelected: (i) => setState(() => _currentIndex = i),
                onSignOut: () => context.go('/'),
              ),
            ],
          ),
        );
      },
    );
  }
}
