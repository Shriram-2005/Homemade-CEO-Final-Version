import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../../seller/seller_theme.dart';

class BuyerSavedTab extends StatelessWidget {
  const BuyerSavedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final savedProducts = MockData.mockProducts
            .where((p) => (MockData.buyerProfile['saved_products'] as List).contains(p['id']))
            .toList();
        final totalValue = savedProducts.fold<int>(0, (sum, p) => sum + (p['price'] as int));

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Banner ──────────────────────────────────────────────
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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.translate('Saved Items', 'സൂക്ഷിച്ചവ'),
                            style: const TextStyle(
                              color: SellerTheme.gold,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.translate('Your wishlist collection', 'നിങ്ങളുടെ വിഷ്‌ലിസ്റ്റ്'),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // Stats
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _statPill('${savedProducts.length}', lang.translate('Saved', 'സൂക്ഷിച്ചത്')),
                        const SizedBox(height: 8),
                        _statPill('₹$totalValue', lang.translate('Total Value', 'ആകെ')),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (savedProducts.isEmpty)
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
                        lang.translate('${savedProducts.length} items saved', '${savedProducts.length} ഇനങ്ങൾ'),
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
                  itemCount: savedProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final p = savedProducts[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: SellerTheme.bgCard,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: SellerTheme.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(children: [
                        // Image
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                          child: Image.network(
                            (p['images'] as List).first,
                            width: 120, height: 120, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 120, height: 120,
                              color: SellerTheme.bgSurface,
                              child: const Icon(Icons.image_outlined, color: SellerTheme.textMuted, size: 32),
                            ),
                          ),
                        ),
                        // Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['title'], style: SellerTheme.heading3, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 5),
                                Row(children: [
                                  const Icon(Icons.storefront_outlined, size: 12, color: SellerTheme.goldDeep),
                                  const SizedBox(width: 4),
                                  Text(p['seller_name'], style: SellerTheme.goldBold.copyWith(fontSize: 12)),
                                ]),
                                const SizedBox(height: 12),
                                Row(children: [
                                  Text(
                                    '₹${p['price']}',
                                    style: const TextStyle(
                                      color: SellerTheme.navy,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: SellerTheme.navy,
                                      foregroundColor: SellerTheme.gold,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      elevation: 0,
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      lang.translate('Order', 'ഓർഡർ'),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                        // Heart
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 18),
                          ),
                        ),
                      ]),
                    );
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

  Widget _statPill(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(value, style: const TextStyle(color: SellerTheme.gold, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
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
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [SellerTheme.goldSoft, SellerTheme.bgSurface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.favorite_border_rounded, size: 52, color: SellerTheme.gold),
            ),
            const SizedBox(height: 24),
            Text(
              lang.translate('Nothing saved yet', 'ഇതുവരെ ഒന്നും സൂക്ഷിച്ചിട്ടില്ല'),
              style: SellerTheme.heading2,
            ),
            const SizedBox(height: 10),
            Text(
              lang.translate(
                'Tap the ♥ on any product to save it here.',
                'ഏതെങ്കിലും ഉൽപ്പന്നത്തിൽ ♥ ടാപ്പ് ചെയ്ത് ഇവിടെ സൂക്ഷിക്കുക.',
              ),
              textAlign: TextAlign.center,
              style: SellerTheme.bodyText,
            ),
          ],
        ),
      ),
    );
  }
}
