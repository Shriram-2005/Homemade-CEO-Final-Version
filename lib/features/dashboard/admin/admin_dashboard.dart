import 'package:flutter/material.dart';
import 'admin_theme.dart';
import 'tabs/admin_overview_tab.dart';
import 'tabs/admin_sellers_tab.dart';
import 'tabs/admin_products_tab.dart';
import 'tabs/admin_campaigns_tab.dart';
import 'tabs/admin_analytics_tab.dart';
import 'tabs/admin_settings_tab.dart';
import 'widgets/admin_card_nav.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/language_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.bgPage,
      body: ListenableBuilder(
        listenable: LanguageProvider(),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Main Content ────────────────────────────────────────────────
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(top: 84.0), // Space for top nav
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      const AdminOverviewTab(),
                      const AdminSellersTab(),
                      const AdminProductsTab(),
                      const AdminCampaignsTab(),
                      const AdminAnalyticsTab(),
                      const AdminSettingsTab(),
                    ],
                  ),
                ),
              ),
              
              // ── Floating Top Navigation ───────────────────────────────────────
              AdminCardNav(
                currentIndex: _currentIndex,
                onTabSelected: (i) => setState(() => _currentIndex = i),
                onSignOut: () => context.go('/'),
              ),
            ],
          );
        }
      ),
    );
  }
}


