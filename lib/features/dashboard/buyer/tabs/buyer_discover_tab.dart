import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../shared/widgets/product_carousel.dart';
import '../../seller/seller_theme.dart';

class BuyerDiscoverTab extends StatefulWidget {
  const BuyerDiscoverTab({super.key});

  @override
  State<BuyerDiscoverTab> createState() => _BuyerDiscoverTabState();
}

class _BuyerDiscoverTabState extends State<BuyerDiscoverTab> {
  String _activeFilter = 'All';
  final _filters = ['All', 'Snacks', 'Pickles', 'Sweets'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final allProducts = MockData.mockProducts
            .where((p) => _activeFilter == 'All' || p['category'] == _activeFilter)
            .where((p) => p['status'] == 'Live')
            .toList();
        final isMobile = MediaQuery.sizeOf(context).width < 600;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Welcome Banner ─────────────────────────────────────────────
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
                            lang.translate('Good morning! 🌿', 'ഗുഡ് മോർണിംഗ്! 🌿'),
                            style: const TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lang.translate('Discover Kerala', 'കേരളം കണ്ടെത്തുക'),
                            style: const TextStyle(
                              color: SellerTheme.gold,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.translate('Authentic homemade products from real makers', 'യഥാർത്ഥ നിർമ്മാതാക്കളിൽ നിന്ന്'),
                            style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.search_rounded, color: SellerTheme.gold, size: 24),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Filter Chips ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: _filters.map((f) {
                      final isActive = _activeFilter == f;
                      return GestureDetector(
                        onTap: () => setState(() => _activeFilter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutQuart,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive ? SellerTheme.navy : SellerTheme.bgCard,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isActive ? SellerTheme.navy : SellerTheme.borderLight,
                            ),
                            boxShadow: isActive
                                ? [BoxShadow(color: SellerTheme.navy.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))]
                                : null,
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              color: isActive ? SellerTheme.gold : SellerTheme.textSecondary,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Section label ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 4, height: 18,
                      decoration: BoxDecoration(
                        color: SellerTheme.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      lang.translate('${allProducts.length} products found', '${allProducts.length} ഉൽപ്പന്നങ്ങൾ'),
                      style: SellerTheme.heading3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Product Grid ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: isMobile
                    ? Column(
                        children: allProducts.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _ProductCard(product: entry.value, lang: lang),
                          );
                        }).toList(),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: allProducts.length,
                        itemBuilder: (context, index) {
                          return _ProductCard(product: allProducts[index], lang: lang);
                        },
                      ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final LanguageProvider lang;
  const _ProductCard({required this.product, required this.lang});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final lang = widget.lang;

    return Container(
      decoration: BoxDecoration(
        color: SellerTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SellerTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image with overlays ──────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: ProductCarousel(
                  imageUrls: List<String>.from(p['images']),
                  height: 220,
                ),
              ),
              // Dark gradient at bottom
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.62)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Price badge
              Positioned(
                bottom: 14, left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: SellerTheme.gold,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: SellerTheme.gold.withValues(alpha: 0.3), blurRadius: 8)],
                  ),
                  child: Text(
                    '₹${p['price']}',
                    style: const TextStyle(
                      color: SellerTheme.navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              // Save heart
              Positioned(
                top: 12, right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _saved = !_saved);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_saved
                          ? lang.translate('Saved!', 'സൂക്ഷിച്ചു!')
                          : lang.translate('Removed', 'നീക്കി')),
                      backgroundColor: SellerTheme.navy,
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8)],
                    ),
                    child: Icon(
                      _saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _saved ? Colors.redAccent : SellerTheme.textMuted,
                      size: 18,
                    ),
                  ),
                ),
              ),
              // Live badge
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(children: [
                    Icon(Icons.circle, size: 6, color: SellerTheme.statusGreen),
                    SizedBox(width: 5),
                    Text('Live', style: TextStyle(color: SellerTheme.navy, fontSize: 11, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
            ],
          ),

          // ── Content ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['title'], style: SellerTheme.heading3, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.storefront_outlined, size: 13, color: SellerTheme.goldDeep),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      lang.translate('by ${p['seller_name']}', '${p['seller_name']} നിർമ്മിച്ചത്'),
                      style: SellerTheme.goldBold.copyWith(fontSize: 12),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.star_rounded, size: 13, color: SellerTheme.gold),
                  const SizedBox(width: 2),
                  Text('4.8', style: SellerTheme.caption.copyWith(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 12),
                Text(
                  p['description'],
                  style: SellerTheme.bodyText.copyWith(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // ── CTA Row ──
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SellerTheme.navy,
                        foregroundColor: SellerTheme.gold,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        lang.translate('Order Now', 'ഓർഡർ'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showSellerStory(context, lang),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SellerTheme.goldSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.5)),
                      ),
                      child: const Icon(Icons.play_circle_outline_rounded, color: SellerTheme.goldDeep, size: 20),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSellerStory(BuildContext context, LanguageProvider lang) {
    final seller = MockData.sellerProfile;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.72,
        decoration: BoxDecoration(
          color: SellerTheme.bgPage,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: SellerTheme.borderLight),
        ),
        child: Column(children: [
          // Handle bar
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 14),
              decoration: BoxDecoration(color: SellerTheme.borderLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: SellerTheme.goldSoft,
                backgroundImage: NetworkImage(seller['profile_image']),
                onBackgroundImageError: (_, __) {},
                child: const Icon(Icons.person, color: SellerTheme.goldDeep),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(seller['name'], style: SellerTheme.heading2),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: SellerTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(seller['location'], style: SellerTheme.caption),
                  ]),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: SellerTheme.goldSoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.5)),
                ),
                child: Row(children: [
                  const Icon(Icons.verified_outlined, color: SellerTheme.goldDeep, size: 13),
                  const SizedBox(width: 4),
                  Text(lang.translate('Verified', 'പരിശോധിച്ചു'), style: SellerTheme.goldBold.copyWith(fontSize: 12)),
                ]),
              ),
            ]),
          ),
          Divider(color: SellerTheme.borderLight, height: 32, indent: 24, endIndent: 24),
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 12),
            child: Row(children: [
              const Icon(Icons.auto_stories_outlined, color: SellerTheme.goldDeep, size: 16),
              const SizedBox(width: 8),
              Text(lang.translate('Her Story', 'അവളുടെ കഥ'), style: SellerTheme.heading3),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(seller['story'], style: SellerTheme.bodyText.copyWith(fontSize: 15, height: 1.7)),
            ),
          ),
        ]),
      ),
    );
  }
}
