import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/providers/course_provider.dart';
import '../../../core/providers/auth_provider.dart';
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
  // Hard rule: sellers start on LMS (index 2) when courses not done
  int _currentIndex = 2;

  final _course = CourseProvider();

  final List<Widget> _tabs = [
    const SellerHomeTab(),
    const SellerProductsTab(),
    const SellerLmsTab(),
    const SellerPaymentsTab(),
    const SellerHelpTab(),
  ];

  // Tabs gated behind course completion (Products=1, Payments=3)
  static const _gatedIndexes = {1, 3};

  @override
  void initState() {
    super.initState();
    // Ensure we always start on LMS if courses aren't finished
    _currentIndex = _course.canSell ? 0 : 2;
  }

  void _onTabSelected(int i) {
    if (!_course.canSell) {
      // Hard block — any tab that isn't the LMS tab (2) or Help tab (4) is forbidden
      // Allow Home (0) as read-only view and Help (4), but Products (1) and Payments (3) are completely off-limits
      if (_gatedIndexes.contains(i)) {
        // Silently redirect back to LMS — no dialog, just hard redirect
        setState(() => _currentIndex = 2);
        _showMiniToast();
        return;
      }
    }
    setState(() => _currentIndex = i);
  }

  void _showMiniToast() {
    final lang = LanguageProvider();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              lang.translate(
                'Complete all course modules first to unlock this.',
                'ആദ്യം കോഴ്‌സ് പൂർത്തിയാക്കൂ.',
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ]),
        backgroundColor: SellerTheme.navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      ),
    );
  }

  void _onSignOut() {
    AuthProvider().signOut();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([LanguageProvider(), _course]),
      builder: (context, _) {
        // If courses just got completed while on LMS tab, allow going to index 0
        if (!_course.canSell && !_gatedIndexes.contains(_currentIndex) && _currentIndex != 2) {
          // Keep current non-gated tab (Home / Help) — fine
        } else if (!_course.canSell && _gatedIndexes.contains(_currentIndex)) {
          // Force back to LMS if somehow landed on gated tab
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _currentIndex = 2);
          });
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundCream,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(top: 84.0),
                  child: Column(
                    children: [
                      // ── Course gating banner (shows at top when locked) ──
                      if (!_course.canSell)
                        _CourseLockBanner(
                          progress: _course.progress,
                          completedCount: _course.completedCount,
                          totalCount: _course.totalCount,
                          onGoToCourse: () => setState(() => _currentIndex = 2),
                        ),
                      // ── Actual tab content ───────────────────────────────
                      Expanded(
                        child: IndexedStack(
                          index: _currentIndex,
                          children: _tabs,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SellerCardNav(
                currentIndex: _currentIndex,
                onTabSelected: _onTabSelected,
                onSignOut: _onSignOut,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Persistent sticky banner shown at the top of the seller dashboard
/// while courses are not yet completed.
class _CourseLockBanner extends StatelessWidget {
  final double progress;
  final int completedCount;
  final int totalCount;
  final VoidCallback onGoToCourse;

  const _CourseLockBanner({
    required this.progress,
    required this.completedCount,
    required this.totalCount,
    required this.onGoToCourse,
  });

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: SellerTheme.navy,
      ),
      child: Row(children: [
        const Icon(Icons.school_rounded, color: SellerTheme.gold, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang.translate(
                  '$completedCount of $totalCount modules done — complete the course to start selling',
                  '$completedCount / $totalCount മൊഡ്യൂൾ തീർന്നു — വിൽക്കാൻ കോഴ്‌സ് തീർക്കൂ',
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  valueColor: const AlwaysStoppedAnimation<Color>(SellerTheme.gold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onGoToCourse,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: SellerTheme.gold,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              lang.translate('Go to Course', 'കോഴ്‌സ്'),
              style: const TextStyle(
                color: SellerTheme.navy,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
