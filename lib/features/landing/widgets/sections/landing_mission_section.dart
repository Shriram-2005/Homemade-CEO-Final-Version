import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/language_provider.dart';

class LandingMissionSection extends StatelessWidget {
  const LandingMissionSection({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            lang.translate('THE MISSION', 'ദൗത്യം'),
            style: const TextStyle(
              color: AppColors.accentGold,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 4.0,
            ),
          ).animate().fade(duration: 800.ms).slideY(begin: 0.2),
          
          const SizedBox(height: 40),
          
          SizedBox(
            width: isMobile ? double.infinity : 900,
            child: Text(
              lang.translate(
                'Women in Kerala possess immense artisanal skill, yet lack access to modern markets, fair pricing, and distribution. We are changing that.',
                'കേരളത്തിലെ സ്ത്രീകൾക്ക് വലിയ കരകൗശല വൈദഗ്ധ്യമുണ്ട്, എന്നിട്ടും ആധുനിക വിപണികൾ, ന്യായമായ വിലനിർണ്ണയം, വിതരണം എന്നിവയിലേക്ക് അവർക്ക് പ്രവേശനമില്ല. ഞങ്ങൾ അത് മാറ്റുകയാണ്.'
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: isMobile ? 28 : 48,
                fontWeight: FontWeight.w300,
                height: 1.3,
                letterSpacing: -0.5,
              ),
            ),
          ).animate().fade(delay: 200.ms, duration: 800.ms).slideY(begin: 0.2),
          
          const SizedBox(height: 60),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '≥100%',
                      style: TextStyle(
                        color: AppColors.accentGold,
                        fontSize: isMobile ? 28 : 48,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      lang.translate('Fair Profit Margins', 'ന്യായമായ ലാഭം'),
                      style: TextStyle(
                        color: AppColors.textWhite.withValues(alpha: 0.7),
                        fontSize: isMobile ? 12 : 16,
                        letterSpacing: 2.0,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              SizedBox(width: isMobile ? 24 : 60),
              Container(
                width: 1,
                height: isMobile ? 60 : 100,
                color: AppColors.accentGold.withValues(alpha: 0.3),
              ),
              SizedBox(width: isMobile ? 24 : 60),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0%',
                      style: TextStyle(
                        color: AppColors.accentGold,
                        fontSize: isMobile ? 28 : 48,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      lang.translate('Middleman Fees', 'ഇടനിലക്കാരുടെ ഫീസ്'),
                      style: TextStyle(
                        color: AppColors.textWhite.withValues(alpha: 0.7),
                        fontSize: isMobile ? 12 : 16,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fade(delay: 400.ms, duration: 800.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}
