import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../dashboard/seller/seller_theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        
        return Scaffold(
          backgroundColor: AppColors.navyBlack,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 40, 28, 20),
                  child: GestureDetector(
                    onTap: () => context.go('/landing'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: SellerTheme.gold.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.2)),
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              size: 80,
                              color: SellerTheme.gold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            lang.translate('The Community', 'കമ്മ്യൂണിറ്റി'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lang.translate(
                              'A powerful network of local entrepreneurs is coming soon. Connect, share, and grow together.',
                              'പ്രാദേശിക സംരംഭകരുടെ ഒരു ശക്തമായ ശൃംഖല ഉടൻ വരുന്നു. ബന്ധിപ്പിക്കുക, പങ്കിടുക, ഒരുമിച്ച് വളരുക.'
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
