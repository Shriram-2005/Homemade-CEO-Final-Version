import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';

class PremiumLanguageToggle extends StatelessWidget {
  final bool isDarkTheme;
  const PremiumLanguageToggle({super.key, this.isDarkTheme = true});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final bool isEnglish = LanguageProvider().isEnglish;
        
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => LanguageProvider().toggleLanguage(),
            child: Container(
              width: 220,
              height: 40,
              decoration: BoxDecoration(
                color: isDarkTheme ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDarkTheme ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.1), width: 1),
              ),
              child: Stack(
                children: [
                  // Animated Sliding Pill
                  AnimatedPositioned(
                    duration: Duration.zero,
                    curve: Curves.linear,
                    left: isEnglish ? 2 : 110,
                    top: 2,
                    bottom: 2,
                    width: 106,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                  ),
                  
                  // Text Overlay
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: Duration.zero,
                            style: TextStyle(
                              color: isEnglish ? AppColors.navyBlack : (isDarkTheme ? Colors.white : Colors.black54),
                              fontWeight: isEnglish ? FontWeight.bold : FontWeight.w500,
                              fontSize: 14,
                            ),
                            child: const Text('English'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: Duration.zero,
                            style: TextStyle(
                              color: !isEnglish ? AppColors.navyBlack : (isDarkTheme ? Colors.white : Colors.black54),
                              fontWeight: !isEnglish ? FontWeight.bold : FontWeight.w500,
                              fontSize: 14,
                            ),
                            child: const Text('മലയാളം'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
