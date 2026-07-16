import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../seller_theme.dart';

class SellerPaymentsTab extends StatelessWidget {
  const SellerPaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final payments = MockData.payments;
        final seller = MockData.sellerProfile;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Earnings Banner ───────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SellerTheme.navy, SellerTheme.navyLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.translate('Earnings', 'വരുമാനം'),
                      style: const TextStyle(
                        color: SellerTheme.gold,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lang.translate('Your financial overview', 'നിങ്ങളുടെ സാമ്പത്തിക അവലോകനം'),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 24),

                    // Big revenue number
                    Text(
                      lang.translate('Total Earned (80% Share)', 'മൊത്തം (80% വിഹിതം)'),
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${seller['total_revenue']}',
                      style: const TextStyle(
                        color: SellerTheme.gold,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sub stats row
                    Row(children: [
                      _miniStat(lang.translate('Pending', 'ബാക്കി'), '₹${seller['pending_payouts']}', SellerTheme.statusOrange),
                      _vLine(),
                      _miniStat(lang.translate('Platform Fee', 'ഫീ'), '20%', Colors.lightBlueAccent),
                      _vLine(),
                      _miniStat(lang.translate('Next Payout', 'അടുത്ത'), 'Fri', SellerTheme.statusGreen),
                    ]),
                    const SizedBox(height: 18),

                    // Info note
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.info_outline_rounded, color: Colors.white54, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lang.translate('20% goes to platform & ads management', '20% പ്ലാറ്റ്‌ഫോമിനും ആഡ്‌സ് മാനേജ്‌മെന്റിനും'),
                            style: const TextStyle(color: Colors.white60, fontSize: 11),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Payment History ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [SellerTheme.goldSoft, Color(0xFFF5E6C8)]),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.history_rounded, color: SellerTheme.goldDeep, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(lang.translate('Payment History', 'പേയ്‌മെന്റ് ചരിത്രം'), style: SellerTheme.heading2)),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      lang.translate('Export', 'എക്‌സ്‌പോർട്ട്'),
                      style: const TextStyle(color: SellerTheme.goldDeep, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: payments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final pay = payments[index];
                  final isPaid = pay['status'] == 'Paid';
                  final statusColor = isPaid ? SellerTheme.statusGreen : SellerTheme.statusOrange;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: SellerTheme.bgCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: SellerTheme.borderLight),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                        ),
                        child: Icon(
                          isPaid ? Icons.account_balance_outlined : Icons.pending_outlined,
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            '₹${pay['amount']}',
                            style: const TextStyle(color: SellerTheme.navy, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 3),
                          Text(pay['details'], style: SellerTheme.caption),
                        ]),
                      ),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(pay['date'], style: SellerTheme.caption),
                        const SizedBox(height: 6),
                        SellerTheme.statusChip(pay['status']),
                      ]),
                    ]),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Expanded(
      child: Column(children: [
        Text(value, style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ]),
    );
  }

  Widget _vLine() => Container(
    width: 1, height: 36,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    color: Colors.white.withValues(alpha: 0.15),
  );
}
