import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/language_provider.dart';

class LandingTestimonialsSection extends StatelessWidget {
  const LandingTestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.navyBlack,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 120,
        vertical: 120,
      ),
      child: Column(
        children: [
          // The Big Quote
          Icon(Icons.format_quote, color: AppColors.accentGold.withValues(alpha: 0.5), size: 64),
          const SizedBox(height: 24),
          SizedBox(
            width: 800,
            child: Text(
              lang.translate(
                '“I always knew my recipes were good, but I didn\'t know how to sell them. Homemade CEO gave me the platform, the pricing strategy, and the confidence to become a business owner.”',
                '“എൻ്റെ പാചകക്കുറിപ്പുകൾ നല്ലതാണെന്ന് എനിക്കറിയാമായിരുന്നു, പക്ഷേ അവ എങ്ങനെ വിൽക്കണമെന്ന് എനിക്കറിയില്ലായിരുന്നു. ഹോംമെയ്ഡ് സിഇഒ എനിക്ക് പ്ലാറ്റ്‌ഫോമും വിലനിർണ്ണയ തന്ത്രവും ബിസിനസ്സ് ഉടമയാകാനുള്ള ആത്മവിശ്വാസവും നൽകി.”'
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: isMobile ? 22 : 32,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            lang.translate('— Fatima, 42, Palakkad', '— ഫാത്തിമ, 42, പാലക്കാട്'),
            style: const TextStyle(color: AppColors.accentGold, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 100),
          
          // Metrics Grid
          Wrap(
            spacing: isMobile ? 40 : 120,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _buildMetric(lang.translate('10,000+', '10,000+'), lang.translate('Women Empowered', 'സ്ത്രീകളെ ശാക്തീകരിച്ചു')),
              _buildMetric(lang.translate('₹ 5Cr+', '₹ 5Cr+'), lang.translate('Generated Revenue', 'വരുമാനം ഉണ്ടാക്കി')),
              _buildMetric(lang.translate('14', '14'), lang.translate('Districts Covered', 'ജില്ലകൾ ഉൾക്കൊള്ളുന്നു')),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMetric(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: AppColors.textWhite, fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.accentGold, fontSize: 16, letterSpacing: 1.0),
        ),
      ],
    );
  }
}
