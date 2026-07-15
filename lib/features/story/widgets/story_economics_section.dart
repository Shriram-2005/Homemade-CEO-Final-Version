import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';

class StoryEconomicsSection extends StatelessWidget {
  const StoryEconomicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.navyBlack,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 120,
        vertical: 160,
      ),
      child: Center(
        child: SizedBox(
          width: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                lang.translate('THE PHILOSOPHY', 'തത്ത്വചിന്ത'),
                style: const TextStyle(
                  color: AppColors.accentGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4.0,
                ),
              ).animate().fade(duration: 800.ms).slideY(begin: 0.2),
              
              const SizedBox(height: 40),
              
              Text(
                lang.translate(
                  'Zero Middleman Fees. Total Empowerment.',
                  'പൂജ്യം ഇടനിലക്കാരുടെ ഫീസ്. പൂർണ്ണ ശാക്തീകരണം.'
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: isMobile ? 32 : 56,
                  fontWeight: FontWeight.w300,
                  height: 1.2,
                ),
              ).animate().fade(delay: 200.ms, duration: 800.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 40),
              
              Text(
                lang.translate(
                  'By removing traditional retail layers, we connect Kerala\'s finest home artisans directly to a global audience. The maker sets the price. The maker takes the profit. Homemade CEO is simply the bridge.',
                  'പരമ്പരാഗത റീട്ടെയിൽ പാളികൾ നീക്കം ചെയ്യുന്നതിലൂടെ, ഞങ്ങൾ കേരളത്തിലെ മികച്ച ഹോം ആർട്ടിസാൻമാരെ ആഗോള പ്രേക്ഷകരുമായി നേരിട്ട് ബന്ധിപ്പിക്കുന്നു. വില നിശ്ചയിക്കുന്നതും ലാഭം എടുക്കുന്നതും നിർമ്മാതാവാണ്.'
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textWhite.withValues(alpha: 0.6),
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ).animate().fade(delay: 400.ms, duration: 800.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 80),
              
              // End Marker
              Container(
                width: 40,
                height: 2,
                color: AppColors.accentGold,
              ).animate().fade(delay: 600.ms).scaleX(),
            ],
          ),
        ),
      ),
    );
  }
}
