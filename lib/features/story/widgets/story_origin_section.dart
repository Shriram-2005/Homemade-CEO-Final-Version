import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';

class StoryOriginSection extends StatelessWidget {
  const StoryOriginSection({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.translate('THE ORIGIN', 'തുടക്കം'),
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
                  'Kerala is home to millions of women who possess world-class artisanal skills passed down through generations. From authentic homemade culinary products to intricate handicrafts, the quality is unparalleled.',
                  'തലമുറകളായി കൈമാറ്റം ചെയ്യപ്പെട്ട ലോകോത്തര കരകൗശല നൈപുണ്യമുള്ള ദശലക്ഷക്കണക്കിന് സ്ത്രീകളുടെ നാടാണ് കേരളം. തനതായ പാചക ഉൽപ്പന്നങ്ങൾ മുതൽ സങ്കീർണ്ണമായ കരകൗശലവസ്തുക്കൾ വരെ, ഗുണനിലവാരം സമാനതകളില്ലാത്തതാണ്.'
                ),
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: isMobile ? 24 : 40,
                  fontWeight: FontWeight.w300,
                  height: 1.4,
                ),
              ).animate().fade(delay: 200.ms, duration: 800.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 40),
              
              Text(
                lang.translate(
                  'Yet, the system is fundamentally broken. They lack access to modern digital markets, reliable distribution networks, and most critically, fair pricing. Middlemen consume the margins, leaving the actual creators with pennies.',
                  'എന്നിട്ടും, സിസ്റ്റം അടിസ്ഥാനപരമായി തകർന്നിരിക്കുന്നു. അവർക്ക് ആധുനിക ഡിജിറ്റൽ വിപണികൾ, വിതരണ ശൃംഖലകൾ, ഏറ്റവും പ്രധാനമായി ന്യായമായ വില എന്നിവ ലഭ്യമല്ല. ഇടനിലക്കാർ ലാഭം എടുക്കുന്നു, യഥാർത്ഥ സൃഷ്ടാക്കൾക്ക് നാണയത്തുട്ടുകൾ മാത്രം ലഭിക്കുന്നു.'
                ),
                style: TextStyle(
                  color: AppColors.textWhite.withValues(alpha: 0.6),
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ).animate().fade(delay: 400.ms, duration: 800.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
