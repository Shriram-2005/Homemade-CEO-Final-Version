import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/language_provider.dart';
import 'widgets/staggered_menu.dart';
import 'widgets/editorial_hero.dart';
import 'widgets/sections/landing_mission_section.dart';
import 'widgets/sections/landing_marketplace_section.dart';
import 'widgets/sections/landing_jami_section.dart';
import 'widgets/sections/landing_testimonials_section.dart';
import 'widgets/sections/landing_footer_section.dart';

import 'package:flutter_animate/flutter_animate.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final isBottom = _scrollController.offset >= _scrollController.position.maxScrollExtent - 50;
        if (isBottom != _isAtBottom) {
          setState(() {
            _isAtBottom = isBottom;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollDown() {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    _scrollController.animateTo(
      _scrollController.offset + screenHeight,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.navyBlack,
          body: Stack(
            children: [
              // Scrollable Content
              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // 1. The Hero (Takes up full screen height)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: EditorialHero(
                        onScrollDown: _scrollDown,
                      ),
                    ),
                    
                    // 2. The Mission
                    LandingMissionSection(),
                    
                    // 3. Marketplace Preview
                    LandingMarketplaceSection(),
                    
                    // 4. Quality Guarantee (Jami)
                    LandingJamiSection(),
                    
                    // 5. Testimonials & Impact
                    LandingTestimonialsSection(),
                    
                    // 6. Footer / CTA
                    LandingFooterSection(),
                  ],
                ),
              ),
              
              // Global Floating Scroll Indicator
              if (!_isAtBottom)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _scrollDown,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.textWhite.withValues(alpha: 0.05),
                            border: Border.all(color: AppColors.textWhite.withValues(alpha: 0.1)),
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.accentGold,
                            size: 28,
                          ),
                        ),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .moveY(begin: 0, end: 10, duration: 1.seconds, curve: Curves.easeInOut),
                  ),
                ),

              // The Staggered Glassmorphism Side Menu overlay (fixed on top)
              const Positioned.fill(
                child: StaggeredMenu(),
              ),
            ],
          ),
        );
      }
    );
  }
}
