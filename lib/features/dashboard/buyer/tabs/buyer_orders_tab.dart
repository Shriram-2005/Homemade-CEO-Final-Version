import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../../seller/seller_theme.dart';

class BuyerOrdersTab extends StatelessWidget {
  const BuyerOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final orders = MockData.buyerProfile['orders'] as List<dynamic>;
        final shipped = orders.where((o) => (o as Map)['status'] == 'Shipped').length;
        final delivered = orders.where((o) => (o as Map)['status'] == 'Delivered').length;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Stats Banner ──────────────────────────────────────
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
                      lang.translate('My Orders', 'എന്റെ ഓർഡറുകൾ'),
                      style: const TextStyle(
                        color: SellerTheme.gold,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lang.translate('Track your purchases', 'നിങ്ങളുടെ വാങ്ങലുകൾ'),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 22),
                    Row(children: [
                      _statPill(lang.translate('Total', 'ആകെ'), '${orders.length}', Icons.receipt_long_outlined),
                      const SizedBox(width: 10),
                      _statPill(lang.translate('Shipped', 'ഷിപ്പ്'), '$shipped', Icons.local_shipping_outlined),
                      const SizedBox(width: 10),
                      _statPill(lang.translate('Delivered', 'ഡെലിവർ'), '$delivered', Icons.check_circle_outline),
                    ]),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (orders.isEmpty)
                _emptyState(lang)
              else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 4, height: 18,
                        decoration: BoxDecoration(color: SellerTheme.gold, borderRadius: BorderRadius.circular(2)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        lang.translate('${orders.length} orders', '${orders.length} ഓർഡറുകൾ'),
                        style: SellerTheme.heading3,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final order = orders[index] as Map<String, dynamic>;
                    return _OrderCard(order: order, lang: lang);
                  },
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _statPill(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.25)),
        ),
        child: Row(children: [
          Icon(icon, color: SellerTheme.gold, size: 16),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
          ]),
        ]),
      ),
    );
  }

  Widget _emptyState(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: SellerTheme.goldSoft,
                shape: BoxShape.circle,
                border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 52, color: SellerTheme.gold),
            ),
            const SizedBox(height: 24),
            Text(lang.translate('No orders yet', 'ഓർഡറുകളൊന്നുമില്ല'), style: SellerTheme.heading2),
            const SizedBox(height: 10),
            Text(
              lang.translate('Your orders will appear here once you place one.', 'ഓർഡർ ചെയ്‌തതിന് ശേഷം ഇവിടെ കാണിക്കും.'),
              textAlign: TextAlign.center,
              style: SellerTheme.bodyText,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final LanguageProvider lang;
  const _OrderCard({required this.order, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SellerTheme.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SellerTheme.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        // ── Header ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [SellerTheme.goldSoft, Color(0xFFF5E6C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: SellerTheme.goldDeep, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(order['product'], style: SellerTheme.heading3, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(
                  '${lang.translate('Order', 'ഓർഡർ')} #${order['order_id']} · ${order['date']}',
                  style: SellerTheme.caption,
                ),
              ]),
            ),
            SellerTheme.statusChip(order['status']),
          ]),
        ),
        Divider(color: SellerTheme.borderLight, height: 1, indent: 16, endIndent: 16),

        // ── Tracker ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
          child: _OrderTracker(status: order['status']),
        ),

        // ── Footer ───────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: SellerTheme.bgSurface,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
          ),
          child: Row(children: [
            const Icon(Icons.currency_rupee, size: 14, color: SellerTheme.goldDeep),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lang.translate('Total Paid', 'ആകെ അടച്ചത്'), style: SellerTheme.caption),
              Text(
                '₹${order['total']}',
                style: const TextStyle(color: SellerTheme.navy, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ]),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.track_changes_outlined, size: 15),
              label: Text(lang.translate('Track', 'ട്രാക്ക്'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: SellerTheme.navy,
                side: const BorderSide(color: SellerTheme.borderGold),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _OrderTracker extends StatelessWidget {
  final String status;
  const _OrderTracker({required this.status});

  @override
  Widget build(BuildContext context) {
    final stages = ['Ordered', 'Packed', 'Shipped', 'Delivered'];
    final statusMap = {'Ordered': 0, 'Packed': 1, 'Shipped': 2, 'Delivered': 3};
    final currentStep = statusMap[status] ?? 2;

    return Row(
      children: stages.asMap().entries.map((e) {
        final isDone = e.key <= currentStep;
        final isCurrent = e.key == currentStep;

        return Expanded(
          child: Row(children: [
            Expanded(
              child: Column(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isCurrent ? 34 : 24,
                  height: isCurrent ? 34 : 24,
                  decoration: BoxDecoration(
                    color: isDone ? SellerTheme.gold : SellerTheme.bgSurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone ? SellerTheme.gold : SellerTheme.borderLight,
                      width: isCurrent ? 2.5 : 1.5,
                    ),
                    boxShadow: isCurrent
                        ? [BoxShadow(color: SellerTheme.gold.withValues(alpha: 0.35), blurRadius: 10, spreadRadius: 2)]
                        : null,
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.check_rounded, color: SellerTheme.navy, size: isCurrent ? 16 : 12)
                        : null,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  e.value,
                  style: TextStyle(
                    color: isDone ? SellerTheme.navy : SellerTheme.textMuted,
                    fontSize: 9,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            if (e.key < stages.length - 1)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: e.key < currentStep ? SellerTheme.gold : SellerTheme.borderLight,
                  ),
                ),
              ),
          ]),
        );
      }).toList(),
    );
  }
}
