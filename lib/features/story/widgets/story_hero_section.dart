import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';

class StoryHeroSection extends StatelessWidget {
  const StoryHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height,
      decoration: const BoxDecoration(
        color: AppColors.navyBlack,
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1596464716127-f2a82984de30?auto=format&fit=crop&q=80'),
          fit: BoxFit.cover,
          opacity: 0.2, // Subtle background texture
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lang.translate('OUR STORY', 'ഞങ്ങളുടെ കഥ'),
              style: TextStyle(
                color: AppColors.accentGold,
                fontSize: isMobile ? 32 : 64,
                fontWeight: FontWeight.w300,
                letterSpacing: 8.0,
                fontStyle: FontStyle.italic,
              ),
            ).animate().fade(duration: 1.seconds).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  lang.translate('EST. 2026', '2026 മുതൽ'),
                  style: TextStyle(
                    color: AppColors.textWhite.withValues(alpha: 0.5),
                    letterSpacing: 4.0,
                    fontSize: 12,
                  ),
                ).animate().fade(delay: 800.ms, duration: 600.ms),
                const SizedBox(width: 24),
                Container(
                  width: 1,
                  height: 100,
                  color: AppColors.accentGold.withValues(alpha: 0.5),
                ).animate().fade(delay: 500.ms, duration: 800.ms).scaleY(begin: 0.0, alignment: Alignment.topCenter),
                const SizedBox(width: 24),
                Text(
                  lang.translate('KERALA, INDIA', 'കേരളം, ഇന്ത്യ'),
                  style: TextStyle(
                    color: AppColors.textWhite.withValues(alpha: 0.5),
                    letterSpacing: 4.0,
                    fontSize: 12,
                  ),
                ).animate().fade(delay: 800.ms, duration: 600.ms),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
