import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../../seller/seller_theme.dart';

class BuyerProfileTab extends StatelessWidget {
  const BuyerProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final buyer = MockData.buyerProfile;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile Hero ──────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SellerTheme.navy, SellerTheme.navyLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: 84, height: 84,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [SellerTheme.gold, Color(0xFFE8B86D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: SellerTheme.gold.withValues(alpha: 0.35),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_rounded, size: 40, color: SellerTheme.navy),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: SellerTheme.statusGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      buyer['name'],
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(buyer['email'], style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: SellerTheme.statusGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: SellerTheme.statusGreen.withValues(alpha: 0.35)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.verified_outlined, size: 13, color: Color(0xFF6EE7B7)),
                        const SizedBox(width: 5),
                        Text(
                          lang.translate('Verified Buyer', 'പരിശോധിച്ച വാങ്ങുന്നയാൾ'),
                          style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Stats Row ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  _statCard(lang.translate('Orders', 'ഓർഡറുകൾ'), '1', Icons.shopping_bag_outlined),
                  const SizedBox(width: 12),
                  _statCard(lang.translate('Saved', 'സൂക്ഷിച്ചവ'), '1', Icons.favorite_border_rounded),
                  const SizedBox(width: 12),
                  _statCard(lang.translate('Reviews', 'അവലോകനം'), '0', Icons.star_border_rounded),
                ]),
              ),

              const SizedBox(height: 24),

              // ── Settings Section ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(width: 4, height: 18, decoration: BoxDecoration(color: SellerTheme.gold, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Text(lang.translate('Settings', 'ക്രമീകരണങ്ങൾ'), style: SellerTheme.heading2),
                ]),
              ),
              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  _settingTile(
                    Icons.language_outlined,
                    lang.translate('Language', 'ഭാഷ'),
                    lang.translate('English / Malayalam', 'ഇംഗ്ലീഷ് / മലയാളം'),
                    trailing: Switch(
                      value: !lang.isEnglish,
                      onChanged: (_) => lang.toggleLanguage(),
                      activeThumbColor: SellerTheme.navy,
                      activeTrackColor: SellerTheme.gold,
                    ),
                  ),
                  _settingTile(
                    Icons.notifications_outlined,
                    lang.translate('Notifications', 'അറിയിപ്പുകൾ'),
                    lang.translate('Order updates & deals', 'ഓർഡർ അപ്‌ഡേറ്റുകൾ'),
                    trailing: const Switch(value: true, onChanged: null),
                  ),
                  _settingTile(
                    Icons.location_on_outlined,
                    lang.translate('Delivery Addresses', 'ഡെലിവറി വിലാസം'),
                    lang.translate('Manage your addresses', 'വിലാസങ്ങൾ നിയന്ത്രിക്കുക'),
                    trailing: const Icon(Icons.chevron_right_rounded, color: SellerTheme.textMuted),
                  ),
                  _settingTile(
                    Icons.payment_outlined,
                    lang.translate('Payment Methods', 'പേയ്‌മെന്റ് രീതികൾ'),
                    lang.translate('UPI, Cards, Wallets', 'UPI, കാർഡ്'),
                    trailing: const Icon(Icons.chevron_right_rounded, color: SellerTheme.textMuted),
                  ),
                  _settingTile(
                    Icons.help_outline_rounded,
                    lang.translate('Help & Support', 'സഹായം'),
                    lang.translate('FAQs, contact us', 'FAQ, ഞങ്ങളെ ബന്ധപ്പെടുക'),
                    trailing: const Icon(Icons.chevron_right_rounded, color: SellerTheme.textMuted),
                  ),
                ]),
              ),

              const SizedBox(height: 20),

              // ── Sign Out ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: Text(lang.translate('Sign Out', 'സൈൻ ഔട്ട്')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SellerTheme.statusRed,
                      side: BorderSide(color: SellerTheme.statusRed.withValues(alpha: 0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: SellerTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SellerTheme.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [SellerTheme.goldSoft, Color(0xFFF5E6C8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: SellerTheme.goldDeep, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: SellerTheme.navy, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: SellerTheme.caption, textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, String subtitle, {required Widget trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: SellerTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SellerTheme.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [SellerTheme.goldSoft, Color(0xFFF5E6C8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
          ),
          child: Icon(icon, color: SellerTheme.goldDeep, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: SellerTheme.heading3),
            const SizedBox(height: 1),
            Text(subtitle, style: SellerTheme.caption),
          ]),
        ),
        trailing,
      ]),
    );
  }
}
