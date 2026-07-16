import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../seller_theme.dart';

class SellerProductsTab extends StatelessWidget {
  const SellerProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final products = MockData.mockProducts;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Banner Header ──────────────────────────────────────────────
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          lang.translate('My Products', 'എന്റെ ഉൽപ്പന്നങ്ങൾ'),
                          style: const TextStyle(
                            color: SellerTheme.gold,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang.translate('${products.length} products listed', '${products.length} ഉൽപ്പന്നങ്ങൾ ലിസ്റ്റ് ചെയ്തു'),
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ]),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(lang.translate('Add New', 'ചേർക്കുക'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SellerTheme.gold,
                        foregroundColor: SellerTheme.navy,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Section Label ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(width: 4, height: 18, decoration: BoxDecoration(color: SellerTheme.gold, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Text(lang.translate('All Products', 'എല്ലാ ഉൽപ്പന്നങ്ങൾ'), style: SellerTheme.heading3),
                ]),
              ),

              const SizedBox(height: 16),

              // ── Product Cards ──────────────────────────────────────────────
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final p = products[index];
                  final statusStr = p['status'] as String;

                  return Container(
                    decoration: BoxDecoration(
                      color: SellerTheme.bgCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: SellerTheme.borderLight),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(children: [
                      // ── Main Row ───────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              p['images'][0],
                              width: 88, height: 88, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 88, height: 88,
                                color: SellerTheme.bgSurface,
                                child: const Icon(Icons.image_outlined, color: SellerTheme.textMuted, size: 32),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(p['title'], style: SellerTheme.heading3, maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Row(children: [
                                SellerTheme.statusChip(lang.translate(statusStr, statusStr)),
                                const Spacer(),
                                Text(
                                  '₹${p['price']}',
                                  style: const TextStyle(color: SellerTheme.navy, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                                ),
                              ]),
                              const SizedBox(height: 8),
                              Row(children: [
                                const Icon(Icons.star_rounded, size: 13, color: SellerTheme.gold),
                                const SizedBox(width: 3),
                                Text('4.8 · ', style: SellerTheme.caption),
                                Text('${p['orders']} ${lang.translate('sold', 'വിറ്റു')}', style: SellerTheme.caption),
                              ]),
                            ]),
                          ),
                          PopupMenuButton<String>(
                            color: SellerTheme.bgCard,
                            icon: const Icon(Icons.more_vert_rounded, color: SellerTheme.textMuted, size: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: SellerTheme.borderLight)),
                            onSelected: (val) {},
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'edit', child: Row(children: [
                                const Icon(Icons.edit_outlined, size: 15, color: SellerTheme.textSecondary),
                                const SizedBox(width: 10),
                                Text(lang.translate('Edit', 'എഡിറ്റ്'), style: const TextStyle(color: SellerTheme.textPrimary, fontSize: 13)),
                              ])),
                              PopupMenuItem(value: 'pause', child: Row(children: [
                                const Icon(Icons.pause_circle_outline, size: 15, color: SellerTheme.statusOrange),
                                const SizedBox(width: 10),
                                Text(lang.translate('Pause', 'നിർത്തൽ'), style: const TextStyle(color: SellerTheme.textPrimary, fontSize: 13)),
                              ])),
                              PopupMenuItem(value: 'delete', child: Row(children: [
                                const Icon(Icons.delete_outline_rounded, size: 15, color: SellerTheme.statusRed),
                                const SizedBox(width: 10),
                                Text(lang.translate('Delete', 'ഇല്ലാതാക്കുക'), style: const TextStyle(color: SellerTheme.statusRed, fontSize: 13)),
                              ])),
                            ],
                          ),
                        ]),
                      ),

                      // ── Metrics Footer ─────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: SellerTheme.bgSurface,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                          border: Border(top: BorderSide(color: SellerTheme.borderLight)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _metric(Icons.visibility_outlined, '${p['views']}', lang.translate('Views', 'കാഴ്‌ചകൾ')),
                            _divider(),
                            _metric(Icons.shopping_bag_outlined, '${p['orders']}', lang.translate('Orders', 'ഓർഡർ')),
                            _divider(),
                            _metric(Icons.campaign_outlined, '₹${p['ad_spend']}', lang.translate('Ad Spend', 'ആഡ്')),
                            _divider(),
                            _metric(
                              Icons.bar_chart_rounded,
                              p['orders'] > 0
                                  ? '${((p['orders'] as int) * (p['price'] as int) / (p['ad_spend'] as int)).toStringAsFixed(1)}x'
                                  : '—',
                              lang.translate('ROAS', 'ROAS'),
                            ),
                          ],
                        ),
                      ),
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

  Widget _metric(IconData icon, String value, String label) {
    return Column(children: [
      Icon(icon, color: SellerTheme.goldDeep, size: 15),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: SellerTheme.navy, fontWeight: FontWeight.bold, fontSize: 14)),
      Text(label, style: SellerTheme.caption.copyWith(fontSize: 10)),
    ]);
  }

  Widget _divider() => Container(width: 1, height: 36, color: SellerTheme.borderLight);
}
