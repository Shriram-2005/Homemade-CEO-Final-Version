import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/language_provider.dart';

class LandingFooterSection extends StatelessWidget {
  const LandingFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.primaryNavy,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 120,
        vertical: 100,
      ),
      child: Column(
        children: [
          Text(
            lang.translate('READY TO START?', 'തുടങ്ങാൻ തയ്യാറാണോ?'),
            style: const TextStyle(color: AppColors.accentGold, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 4.0),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              // Buyer CTA
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.accentGold),
                  ),
                  child: Text(
                    lang.translate('Enter Marketplace', 'മാർക്കറ്റ് പ്ലേസിൽ പ്രവേശിക്കുക'),
                    style: const TextStyle(color: AppColors.accentGold, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              // Maker CTA
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lang.translate('Join as a Maker', 'ഒരു മേക്കറായി ചേരുക'),
                        style: const TextStyle(color: AppColors.primaryNavy, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward, color: AppColors.primaryNavy, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 100),
          
          // Actual Footer Links
          Divider(color: AppColors.textWhite.withValues(alpha: 0.1)),
          const SizedBox(height: 40),
          isMobile
            ? Column(
                children: [
                  Text('© 2026 Homemade CEO', style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.54))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Privacy Policy', style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.54))),
                      const SizedBox(width: 24),
                      Text('Terms of Service', style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.54))),
                    ],
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('© 2026 Homemade CEO', style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.54))),
                  Row(
                    children: [
                      Text('Privacy Policy', style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.54))),
                      const SizedBox(width: 24),
                      Text('Terms of Service', style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.54))),
                    ],
                  )
                ],
              )
        ],
      ),
    );
  }
}
