import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../dashboard/seller/seller_theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
                              Icons.headset_mic_rounded,
                              size: 80,
                              color: SellerTheme.gold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            lang.translate('Contact Support', 'പിന്തുണയുമായി ബന്ധപ്പെടുക'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildContactRow(Icons.email_outlined, 'support@homemadeceo.com'),
                          const SizedBox(height: 16),
                          _buildContactRow(Icons.phone_outlined, '+91 80000 12345'),
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

  Widget _buildContactRow(IconData icon, String text) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 350),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SellerTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SellerTheme.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: SellerTheme.gold, size: 24),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
