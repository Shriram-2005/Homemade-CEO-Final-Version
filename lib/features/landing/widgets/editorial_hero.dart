import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import 'light_rays.dart';

class EditorialHero extends StatelessWidget {
  final VoidCallback? onScrollDown;
  
  const EditorialHero({super.key, this.onScrollDown});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.navyBlack,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Generative Luxury Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.navyDeep, AppColors.navyBlack],
                ),
              ),
            ),
          ),
          
          // The Interactive Golden Light Rays
          const Positioned.fill(
            child: LightRays(color: AppColors.accentGold),
          ),

          // Content Layer (Centered)
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Minimalist Label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    lang.translate('KERALA FIRST', 'കേരളം ആദ്യം'),
                    style: const TextStyle(
                      color: AppColors.accentGold,
                      fontSize: 15,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fade(delay: 400.ms).slideY(begin: 0.5, end: 0, duration: 800.ms, curve: Curves.easeOutQuart),
                
                const SizedBox(height: 32),
                
                // The Main Wordmark
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'HOMEMADE',
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: isMobile ? 42 : 72,
                            fontWeight: FontWeight.w300, 
                            letterSpacing: isMobile ? 1.0 : 4.0, 
                            height: 1.0,
                          ),
                        ).animate().fade(delay: 600.ms, duration: 800.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOutQuart),
                        SizedBox(width: isMobile ? 12 : 24),
                        Text(
                          'CEO',
                          style: TextStyle(
                            color: AppColors.accentGold,
                            fontSize: isMobile ? 54 : 96,
                            fontWeight: FontWeight.w900, 
                            fontStyle: FontStyle.italic,
                            letterSpacing: -2.0,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                color: AppColors.accentGold.withValues(alpha: 0.5),
                                blurRadius: 20,
                              )
                            ]
                          ),
                        ).animate().fade(delay: 800.ms, duration: 800.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), curve: Curves.easeOutQuart),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Tagline / Thesis
                SizedBox(
                  width: isMobile ? MediaQuery.sizeOf(context).width - 64 : 800,
                  child: Text(
                    lang.translate(
                      'Every home has a CEO. She always had the skill — now she has the platform.',
                      'ഓരോ വീട്ടിലുമുണ്ട് ഒരു CEO. അവൾക്ക് എപ്പോഴും കഴിവുണ്ടായിരുന്നു - ഇപ്പോൾ അവൾക്ക് പ്ലാറ്റ്‌ഫോം ഉണ്ട്.'
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textWhite.withValues(alpha: 0.8),
                      fontSize: isMobile ? 20 : 28,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ).animate().fade(delay: 1000.ms, duration: 800.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
                
                const SizedBox(height: 40),
                
                // Call to Action
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
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGold.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            )
                          ]
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              lang.translate('Join as a Maker', 'ഒരു മേക്കറായി ചേരുക'),
                              style: const TextStyle(
                                color: AppColors.primaryNavy, 
                                fontSize: 16, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.arrow_forward, color: AppColors.primaryNavy, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate().fade(delay: 1200.ms, duration: 800.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
                
                // Extra padding at bottom for scroll view on small devices
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
        ),
          
        ],
      ),
    );
  }
}
