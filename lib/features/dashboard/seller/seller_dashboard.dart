import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/providers/course_provider.dart';
import 'tabs/seller_home_tab.dart';
import 'tabs/seller_products_tab.dart';
import 'tabs/seller_lms_tab.dart';
import 'tabs/seller_payments_tab.dart';
import 'tabs/seller_help_tab.dart';
import 'seller_theme.dart';
import 'package:go_router/go_router.dart';
import 'widgets/seller_card_nav.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  int _currentIndex = 0;
  final _course = CourseProvider();

  final List<Widget> _tabs = [
    const SellerHomeTab(),
    const SellerProductsTab(),
    const SellerLmsTab(),
    const SellerPaymentsTab(),
    const SellerHelpTab(),
  ];

  // Tabs that require course completion: index 1 (Products) and 3 (Payments)
  static const _gatedIndexes = {1, 3};

  void _onTabSelected(int i) {
    if (_gatedIndexes.contains(i) && !_course.canSell) {
      _showGateDialog(i);
      return;
    }
    setState(() => _currentIndex = i);
  }

  void _showGateDialog(int tabIndex) {
    final lang = LanguageProvider();
    final tabName = tabIndex == 1
        ? lang.translate('Products', 'ഉൽപ്പന്നങ്ങൾ')
        : lang.translate('Payments', 'പേയ്‌മെന്റ്');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SellerTheme.bgPage,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: SellerTheme.borderLight)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SellerTheme.statusOrange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lock_outline_rounded, color: SellerTheme.statusOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              lang.translate('$tabName Locked', '$tabName ലോക്ക് ചെയ്‌തു'),
              style: SellerTheme.heading2,
            ),
          ),
        ]),
        content: Text(
          lang.translate(
            'You must complete all course modules before accessing $tabName. Go to the "Course" tab to continue learning.',
            'ഈ ഫീച്ചർ ആക്‌സസ് ചെയ്യാൻ ആദ്യം എല്ലാ കോഴ്‌സ് മൊഡ്യൂളുകളും പൂർത്തിയാക്കണം.',
          ),
          style: SellerTheme.bodyText,
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              foregroundColor: SellerTheme.textSecondary,
              side: BorderSide(color: SellerTheme.borderLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(lang.translate('Dismiss', 'ഡിസ്‌മിസ്')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _currentIndex = 2); // Go to LMS tab
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SellerTheme.navy,
              foregroundColor: SellerTheme.gold,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(lang.translate('Go to Course', 'കോഴ്‌സ് ടാബ്')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([LanguageProvider(), _course]),
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
                onTabSelected: _onTabSelected,
                onSignOut: () => context.go('/'),
              ),
            ],
          ),
        );
      },
    );
  }
}
