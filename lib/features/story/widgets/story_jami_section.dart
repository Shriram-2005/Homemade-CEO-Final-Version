import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';

class StoryJamiSection extends StatelessWidget {
  const StoryJamiSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.navyDeep, // Slight contrast from navyBlack
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 120,
        vertical: 160,
      ),
      child: Center(
        child: SizedBox(
          width: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.translate('THE JAMI PROTOCOL', 'ജാമി പ്രോട്ടോക്കോൾ'),
                style: const TextStyle(
                  color: AppColors.accentGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4.0,
                ),
              ).animate().fade(duration: 800.ms).slideX(begin: -0.1),
              
              const SizedBox(height: 40),
              
              Text(
                lang.translate(
                  'Enter Jami. Our proprietary AI Compliance Engine.',
                  'ഞങ്ങളുടെ സ്വന്തം AI കംപ്ലയൻസ് എഞ്ചിൻ ആയ ജാമിയെ പരിചയപ്പെടുക.'
                ),
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: isMobile ? 32 : 56,
                  fontWeight: FontWeight.w300,
                  height: 1.2,
                ),
              ).animate().fade(delay: 200.ms, duration: 800.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 60),
              
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.navyBlack,
                  border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.accentGold, size: 40),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.translate('100% Hygiene Verification', '100% ശുചിത്വ പരിശോധന'),
                                style: const TextStyle(color: AppColors.textWhite, fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                lang.translate(
                                  'Every product undergoes visual and algorithmic scrutiny to guarantee FSSAI standards.',
                                  'FSSAI മാനദണ്ഡങ്ങൾ ഉറപ്പുനൽകുന്നതിനായി ഓരോ ഉൽപ്പന്നവും പരിശോധനയ്ക്ക് വിധേയമാകുന്നു.'
                                ),
                                style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.6), fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    Divider(color: AppColors.textWhite.withValues(alpha: 0.1)),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Icon(Icons.calculate_outlined, color: AppColors.accentGold, size: 40),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.translate('The Mathematical Gate', 'ഗണിതശാസ്ത്ര ഗേറ്റ്'),
                                style: const TextStyle(color: AppColors.textWhite, fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                lang.translate(
                                  'Profit = Price - (Materials + Labor + Overhead). Jami ensures margins are strictly ≥100%.',
                                  'ലാഭം = വില - (വസ്തുക്കൾ + അധ്വാനം). ലാഭം കർശനമായി ≥100% ആണെന്ന് ജാമി ഉറപ്പാക്കുന്നു.'
                                ),
                                style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.6), fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ).animate().fade(delay: 400.ms, duration: 800.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
