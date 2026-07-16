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
  int _currentIndex = 2; // Always start on Course tab
  final _course = CourseProvider();
  bool _wasLockedBefore = false; // Tracks if we need to show completion dialog

  final List<Widget> _tabs = [
    const SellerHomeTab(),
    const SellerProductsTab(),
    const SellerLmsTab(),
    const SellerPaymentsTab(),
    const SellerHelpTab(),
  ];

  // Tabs gated behind course completion
  static const _gatedIndexes = {1, 3};

  @override
  void initState() {
    super.initState();
    _wasLockedBefore = !_course.canSell;
    // Always open on LMS if not yet complete, otherwise Home
    _currentIndex = _course.canSell ? 0 : 2;
    _course.addListener(_onCourseChanged);
  }

  @override
  void dispose() {
    _course.removeListener(_onCourseChanged);
    super.dispose();
  }

  void _onCourseChanged() {
    if (_wasLockedBefore && _course.canSell) {
      // Courses just became fully complete — celebrate!
      _wasLockedBefore = false;
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final lang = LanguageProvider();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [SellerTheme.navy, SellerTheme.navyLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.35), width: 1.5),
            boxShadow: [
              BoxShadow(color: SellerTheme.gold.withValues(alpha: 0.15), blurRadius: 40, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated icon
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: SellerTheme.gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.35), width: 1.5),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: SellerTheme.gold, size: 52),
              ),
              const SizedBox(height: 24),

              Text(
                lang.translate('🎉 Congratulations!', '🎉 അഭിനന്ദനങ്ങൾ!'),
                style: const TextStyle(
                  color: SellerTheme.gold,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                lang.translate(
                  'You\'ve completed all course modules!\nYou can now start selling your products on Homemade CEO.',
                  'നിങ്ങൾ എല്ലാ കോഴ്‌സ് മൊഡ്യൂളുകളും പൂർത്തിയാക്കി!\nഇപ്പോൾ ഉൽപ്പന്നങ്ങൾ വിൽക്കാൻ ആരംഭിക്കാം.',
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                lang.translate(
                  'You can rewatch the course anytime from the Course tab, and download your certificate there too.',
                  'Course ടാബിൽ നിന്ന് ഏത് സമയത്തും കോഴ്‌സ് വീണ്ടും കാണാം, സർട്ടിഫിക്കറ്റ് ഡൗൺലോഡ് ചെയ്യാം.',
                ),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 11, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // Navigate to Home tab
                    setState(() => _currentIndex = 0);
                  },
                  icon: const Icon(Icons.storefront_outlined, size: 18),
                  label: Text(
                    lang.translate('Start Selling →', 'വിൽക്കാൻ ആരംഭിക്കുക →'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SellerTheme.gold,
                    foregroundColor: SellerTheme.navy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabSelected(int i) {
    if (!_course.canSell) {
      // Hard block — while courses not done, only Course tab is allowed from the dashboard
      // (menu handles its own locking, this is a second safety net)
      if (_gatedIndexes.contains(i)) {
        setState(() => _currentIndex = 2);
        return;
      }
    }
    setState(() => _currentIndex = i);
  }

  void _onSignOut() {
    _course.resetAll(); // clear progress so next login always starts fresh
    AuthProvider().signOut();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([LanguageProvider(), _course]),
      builder: (context, _) {
        final bool coursesDone = _course.canSell;

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
                      // ── Persistent course progress banner (disappears on completion) ──
                      if (!coursesDone)
                        _CourseLockBanner(
                          progress: _course.progress,
                          completedCount: _course.completedCount,
                          totalCount: _course.totalCount,
                          onGoToCourse: () => setState(() => _currentIndex = 2),
                        ),

                      // ── Tab content ──────────────────────────────────────────────────
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

              // ── Floating card nav (course-aware) ─────────────────────────────────
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

/// Persistent progress banner shown at the top while courses are incomplete.
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
      color: SellerTheme.navy,
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
                  '$completedCount of $totalCount modules done — complete the course to unlock selling',
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
              style: const TextStyle(color: SellerTheme.navy, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]),
    );
  }
}
