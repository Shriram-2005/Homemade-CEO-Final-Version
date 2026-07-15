import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/language_provider.dart';

class LandingJamiSection extends StatelessWidget {
  const LandingJamiSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.navyDeep, // Slightly darker section
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 120,
        vertical: 120,
      ),
      child: isMobile 
          ? Column(
              children: _buildContent(lang, isMobile),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildContent(lang, isMobile),
            ),
    );
  }

  List<Widget> _buildContent(LanguageProvider lang, bool isMobile) {
    Widget graphic = Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [AppColors.accentGold.withValues(alpha: 0.2), Colors.transparent],
        ),
      ),
      child: Center(
        child: Container(
          width: 200, height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5), width: 2),
          ),
          child: const Center(
            child: Icon(Icons.memory, color: AppColors.accentGold, size: 80),
          ),
        ).animate(onPlay: (controller) => controller.repeat()).rotate(duration: 10.seconds),
      ),
    );

    Widget textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.translate('THE QUALITY GUARANTEE', 'ഗുണനിലവാര ഉറപ്പ്'),
          style: const TextStyle(color: AppColors.accentGold, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2.0),
        ),
        const SizedBox(height: 24),
        Text(
          lang.translate('Meet Jami. Our AI compliance engine.', 'ജാമി. ഞങ്ങളുടെ AI കംപ്ലയൻസ് എഞ്ചിൻ.'),
          style: TextStyle(color: AppColors.textWhite, fontSize: isMobile ? 32 : 48, fontWeight: FontWeight.w300, height: 1.2),
        ),
        const SizedBox(height: 32),
        Text(
          lang.translate(
            'Every product on this platform passes through rigorous algorithmic vetting. Jami ensures 100% hygiene compliance, validates fair profit margins (≥100%), and audits every seller before a product goes live.',
            'ഈ പ്ലാറ്റ്‌ഫോമിലെ എല്ലാ ഉൽപ്പന്നങ്ങളും കർശനമായ അൽഗോരിതം വഴി പരിശോധിക്കപ്പെടുന്നു. ജാമി 100% ശുചിത്വ നിയമങ്ങൾ ഉറപ്പാക്കുന്നു, ന്യായമായ ലാഭം (≥100%) സാധൂകരിക്കുന്നു.'
          ),
          style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.7), fontSize: 18, height: 1.6),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            const Icon(Icons.verified, color: AppColors.accentGold),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                lang.translate('You aren\'t just buying homemade. You are buying premium.', 'നിങ്ങൾ വെറും ഹോംമെയ്ഡ് മാത്രമല്ല വാങ്ങുന്നത്. നിങ്ങൾ പ്രീമിയം വാങ്ങുന്നു.'),
                style: const TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          ],
        )
      ],
    );

    return [
      isMobile ? graphic : Expanded(child: graphic),
      if (isMobile) const SizedBox(height: 60),
      isMobile ? textContent : Expanded(child: textContent),
    ];
  }
}
