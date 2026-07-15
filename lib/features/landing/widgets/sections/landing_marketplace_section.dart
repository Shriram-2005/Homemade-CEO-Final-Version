import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/language_provider.dart';

class LandingMarketplaceSection extends StatelessWidget {
  const LandingMarketplaceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    final List<Map<String, String>> mockProducts = [
      {
        'titleEn': 'Artisanal Mango Pickle',
        'titleMl': 'നാടൻ മാങ്ങാ അച്ചാർ',
        'makerEn': 'Made by Saina, Ernakulam',
        'makerMl': 'സൈന നിർമ്മിച്ചത്, എറണാകുളം',
        'price': '₹ 250',
      },
      {
        'titleEn': 'Hand-woven Set Mundu',
        'titleMl': 'കൈത്തറി സെറ്റ് മുണ്ട്',
        'makerEn': 'Made by Lakshmi, Thrissur',
        'makerMl': 'ലക്ഷ്മി നിർമ്മിച്ചത്, തൃശൂർ',
        'price': '₹ 1,200',
      },
      {
        'titleEn': 'Organic Black Pepper',
        'titleMl': 'ജൈവ കുരുമുളക്',
        'makerEn': 'Made by Mary, Idukki',
        'makerMl': 'മേരി നിർമ്മിച്ചത്, ഇടുക്കി',
        'price': '₹ 450',
      },
      {
        'titleEn': 'Pure Coconut Oil',
        'titleMl': 'ശുദ്ധമായ വെളിച്ചെണ്ണ',
        'makerEn': 'Made by Amina, Kozhikode',
        'makerMl': 'ആമിന നിർമ്മിച്ചത്, കോഴിക്കോട്',
        'price': '₹ 380',
      },
    ];

    return Container(
      width: double.infinity,
      color: AppColors.navyBlack,
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.translate('CURATED MARKETPLACE', 'ക്യൂറേറ്റഡ് മാർക്കറ്റ് പ്ലേസ്'),
                        style: const TextStyle(color: AppColors.accentGold, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2.0),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        lang.translate('Discover true Kerala craft.', 'യഥാർത്ഥ കേരള കരകൗശലം കണ്ടെത്തുക.'),
                        style: TextStyle(color: AppColors.textWhite, fontSize: isMobile ? 32 : 48, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                if (!isMobile)
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      lang.translate('View All Products', 'എല്ലാ ഉൽപ്പന്നങ്ങളും കാണുക'),
                      style: const TextStyle(color: AppColors.accentGold, fontSize: 16),
                    ),
                  )
              ],
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Horizontal Carousel
          SizedBox(
            height: 400,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 120),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: mockProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final product = mockProducts[index];
                return _buildProductCard(
                  lang.translate(product['titleEn']!, product['titleMl']!),
                  lang.translate(product['makerEn']!, product['makerMl']!),
                  product['price']!,
                ).animate().fade(delay: (200 * index).ms).slideX(begin: 0.2);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String maker, String price) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textWhite.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder Image Area
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navyDeep, AppColors.navyBlack],
                ),
              ),
              child: Center(
                child: Icon(Icons.image_outlined, color: AppColors.textWhite.withValues(alpha: 0.2), size: 48),
              ),
            ),
          ),
          
          // Product Details
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.textWhite, fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  maker,
                  style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.6), fontSize: 14),
                ),
                const SizedBox(height: 16),
                Text(
                  price,
                  style: const TextStyle(color: AppColors.accentGold, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
