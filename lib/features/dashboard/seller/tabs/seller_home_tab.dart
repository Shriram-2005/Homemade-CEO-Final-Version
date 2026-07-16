import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../seller_theme.dart';

class SellerHomeTab extends StatelessWidget {
  const SellerHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final seller = MockData.sellerProfile;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Header ───────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SellerTheme.navy, SellerTheme.navyLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Header row
                    Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            lang.translate('Hello,', 'നമസ്കാരം,'),
                            style: const TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            seller['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.translate('Your business is growing! 🌟', 'നിങ്ങളുടെ ബിസിനസ്സ് വളരുകയാണ്! 🌟'),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ]),
                      ),
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: SellerTheme.gold, width: 2.5),
                          boxShadow: [BoxShadow(color: SellerTheme.gold.withValues(alpha: 0.3), blurRadius: 12)],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            seller['profile_image'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: SellerTheme.goldSoft,
                              child: const Icon(Icons.person, color: SellerTheme.gold, size: 28),
                            ),
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Revenue Card inside hero
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: SellerTheme.gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.currency_rupee, color: SellerTheme.gold, size: 14),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              lang.translate('Total Revenue', 'മൊത്തം വരുമാനം'),
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF059669).withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.4)),
                              ),
                              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.arrow_upward_rounded, color: Color(0xFF6EE7B7), size: 12),
                                SizedBox(width: 3),
                                Text('+18% MoM', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 11, fontWeight: FontWeight.bold)),
                              ]),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Text(
                            '₹${seller['total_revenue']}',
                            style: const TextStyle(
                              color: SellerTheme.gold,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.translate('Pending payout: ₹${seller['pending_payouts']}', 'ബാക്കി: ₹${seller['pending_payouts']}'),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Stats Grid ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  Row(children: [
                    _statCard(Icons.inventory_2_outlined, lang.translate('Products', 'ഉൽപ്പന്നങ്ങൾ'),
                        '${seller['active_products']}', lang.translate('Active', 'സജീവ'), SellerTheme.statusBlue),
                    const SizedBox(width: 12),
                    _statCard(Icons.shopping_bag_outlined, lang.translate('Orders', 'ഓർഡറുകൾ'),
                        '45', lang.translate('This Month', 'ഈ മാസം'), SellerTheme.statusGreen),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    _statCard(Icons.visibility_outlined, lang.translate('Views', 'കാഴ്‌ചകൾ'),
                        '2,130', lang.translate('All Products', 'എല്ലാ'), SellerTheme.gold),
                    const SizedBox(width: 12),
                    _statCard(Icons.campaign_outlined, lang.translate('Ad Spend', 'ആഡ്'),
                        '₹450', lang.translate('Running Ads', 'ആക്ടീവ്'), SellerTheme.statusOrange),
                  ]),
                ]),
              ),

              const SizedBox(height: 20),

              // ── LMS Progress Card ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: SellerTheme.bgCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.5)),
                    boxShadow: [BoxShadow(color: SellerTheme.gold.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [SellerTheme.goldSoft, Color(0xFFF5E6C8)]),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
                          ),
                          child: const Icon(Icons.school_outlined, color: SellerTheme.goldDeep, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(lang.translate('Course Progress', 'കോഴ്‌സ് പുരോഗതി'), style: SellerTheme.heading3),
                            Text(lang.translate('Complete to unlock more features', 'കൂടുതൽ ഫീച്ചറുകൾ അൺലോക്ക്'), style: SellerTheme.caption),
                          ]),
                        ),
                        Text(
                          '${seller['lms_progress']}%',
                          style: const TextStyle(color: SellerTheme.goldDeep, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (seller['lms_progress'] as int) / 100,
                          minHeight: 10,
                          backgroundColor: SellerTheme.bgSurface,
                          valueColor: const AlwaysStoppedAnimation<Color>(SellerTheme.gold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Jami Alert ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: SellerTheme.statusOrange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: SellerTheme.statusOrange.withValues(alpha: 0.3)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: SellerTheme.statusOrange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_active_outlined, color: SellerTheme.statusOrange, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          lang.translate('Jami Alert', 'ജാമി അറിയിപ്പ്'),
                          style: const TextStyle(color: SellerTheme.statusOrange, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang.translate(
                            'Your ad for "Spicy Mango Pickle" is paused. Tap to see why.',
                            '"Spicy Mango Pickle" പരസ്യം നിർത്തിവച്ചു.',
                          ),
                          style: SellerTheme.bodyText.copyWith(fontSize: 13),
                        ),
                      ]),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: SellerTheme.statusOrange, size: 20),
                  ]),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(IconData icon, String label, String value, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SellerTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SellerTheme.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const Spacer(),
            Text(sub, style: SellerTheme.caption),
          ]),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          const SizedBox(height: 2),
          Text(label, style: SellerTheme.bodyText.copyWith(fontSize: 13)),
        ]),
      ),
    );
  }
}
