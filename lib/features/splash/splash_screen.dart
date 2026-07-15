import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000), // 5 seconds total
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.go('/landing');
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper to map time to an animated value based on a specific curve
  double _mapTime(double time, double start, double end, {Curve curve = Curves.easeOutCubic}) {
    if (time <= start) return 0.0;
    if (time >= end) return 1.0;
    double t = (time - start) / (end - start);
    return curve.transform(t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double time = _controller.value * 5.0; // current time in seconds

          // fadeOutScreen: 3.85s to 4.40s
          double globalOpacity = 1.0 - _mapTime(time, 3.85, 4.40, curve: Curves.easeIn);

          return Opacity(
            opacity: globalOpacity,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.1),
                  radius: 1.2,
                  // Using the Official Navy Palette for the background
                  colors: [AppColors.primaryNavy, AppColors.navyDeep, AppColors.navyBlack],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildGlow(time),
                  _buildFrame(time),
                  _buildContent(time, context),
                  _buildThread(time),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlow(double time) {
    // glowPulse: 0 to 2.6s.
    double progress = (time / 2.6).clamp(0.0, 1.0);
    double curveProgress = Curves.easeOutCubic.transform(progress);
    
    double opacity = 0;
    double scale = 0.6;
    if (curveProgress <= 0.35) {
      double t = curveProgress / 0.35;
      opacity = t;
      scale = 0.6 + (0.4 * t);
    } else {
      double t = (curveProgress - 0.35) / 0.65;
      opacity = 1.0 - (0.25 * t);
      scale = 1.0 + (0.08 * t);
    }

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 800,
          height: 800,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.goldSoft.withValues(alpha: 0.17),
                AppColors.goldSoft.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.65],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrame(double time) {
    // frameIn: 0.05s to 1.05s
    double t = _mapTime(time, 0.05, 1.05);
    double opacity = t * 0.45; // Slightly increased opacity to show the double line
    double scale = 0.97 + (0.03 * t);

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Stack(
              children: [
                // Outer Kasavu-style primary border
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accentGold, width: 1.5),
                  ),
                ),
                // Inner Kasavu-style secondary thin border (creates the traditional Kerala double-line effect)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5), width: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(double time, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMark(time),
        const SizedBox(height: 24),
        _buildSubtitle(time, context),
        _buildHeroWordmark(time, context),
        _buildUnderline(time),
        _buildTagline(time, context),
      ],
    );
  }

  Widget _buildMark(double time) {
    // markIn: 0.15s to 0.85s
    double markT = _mapTime(time, 0.15, 0.85);
    double lineT = _mapTime(time, 0.25, 0.95);
    double dotT = _mapTime(time, 0.55, 1.00, curve: Curves.easeOutBack);

    return Opacity(
      opacity: markT,
      child: Transform.translate(
        offset: Offset(0, 8 - (8 * markT)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scaleX: lineT,
              child: Container(width: 40, height: 1, color: AppColors.accentGold),
            ),
            const SizedBox(width: 14),
            Transform.scale(
              scale: dotT,
              child: Transform.rotate(
                angle: math.pi / 4, // Rotated 45 degrees to create a traditional Kerala temple diamond motif
                child: Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    boxShadow: [
                      BoxShadow(color: AppColors.accentGold.withValues(alpha: 0.7), blurRadius: 12),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Transform.scale(
              scaleX: lineT,
              child: Container(width: 40, height: 1, color: AppColors.accentGold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle(double time, BuildContext context) {
    double enOutT = _mapTime(time, 2.3, 2.85, curve: Curves.easeIn);
    double mlInT = _mapTime(time, 2.55, 3.15, curve: Curves.easeOut);

    double screenWidth = MediaQuery.sizeOf(context).width;
    double baseSizeEn = (screenWidth * 0.025).clamp(14.0, 18.0);
    double baseSizeMl = (screenWidth * 0.025).clamp(16.0, 20.0);

    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 1.0 - enOutT,
            child: Transform.translate(
              offset: Offset(0, -10 * enOutT),
              child: Text(
                'WELCOME TO',
                style: TextStyle(
                  color: AppColors.goldSoft,
                  fontSize: baseSizeEn,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4.0,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: mlInT,
            child: Transform.translate(
              offset: Offset(0, 10 - (10 * mlInT)),
              child: Text(
                'സ്വാഗതം',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.goldSoft,
                  fontSize: baseSizeMl,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroWordmark(double time, BuildContext context) {
    double t = _mapTime(time, 0.4, 1.35);
    
    // Responsive font scaling
    double screenWidth = MediaQuery.sizeOf(context).width;
    // Base size 48 on mobile, scaling up smoothly to max 80 on desktop
    double fontSize = (screenWidth * 0.08).clamp(48.0, 70.0);
    
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, 26 - (26 * t)),
        child: Transform.scale(
          scale: 0.92 + (0.08 * t),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Homemade',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 8),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    double shimmerProgress = 0.0;
                    if (time > 1.1) {
                      shimmerProgress = ((time - 1.1) % 2.2) / 2.2;
                    }
                    
                    return LinearGradient(
                      colors: const [
                        AppColors.accentGold,
                        AppColors.goldSoft,
                        AppColors.textWhite,
                        AppColors.goldSoft,
                        AppColors.accentGold,
                      ],
                      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                      transform: GradientRotation(shimmerProgress * math.pi * 2),
                    ).createShader(bounds);
                  },
                  // Added padding to prevent the italic text from being clipped by the bounding box
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(
                      'CEO',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnderline(double time) {
    double t = _mapTime(time, 0.95, 1.75);
    
    return Container(
      height: 1.5,
      width: 280 * t,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.accentGold,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildTagline(double time, BuildContext context) {
    double enOutT = _mapTime(time, 2.3, 2.85, curve: Curves.easeIn);
    double mlInT = _mapTime(time, 2.55, 3.15, curve: Curves.easeOut);

    double screenWidth = MediaQuery.sizeOf(context).width;
    double baseSizeEn = (screenWidth * 0.02).clamp(12.0, 16.0);
    double baseSizeMl = (screenWidth * 0.022).clamp(14.0, 18.0);

    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: SizedBox(
        height: 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: (1.0 - enOutT) * 0.85,
              child: Transform.translate(
                offset: Offset(0, -10 * enOutT),
                child: Text(
                  'JAMI · YOUR AI BUSINESS ASSISTANT',
                  style: TextStyle(
                    color: AppColors.accentGold,
                    fontSize: baseSizeEn,
                    letterSpacing: 2.5,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: mlInT * 0.9,
              child: Transform.translate(
                offset: Offset(0, 10 - (10 * mlInT)),
                child: Text(
                  'ജാമി · നിങ്ങളുടെ AI ബിസിനസ് അസിസ്റ്റന്റ്',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.accentGold,
                    fontSize: baseSizeMl,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThread(double time) {
    double t = _mapTime(time, 0.1, 3.95, curve: Curves.linear);

    return Positioned(
      bottom: 40,
      child: Container(
        width: 160,
        height: 2,
        decoration: BoxDecoration(
          color: AppColors.accentGold.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(2),
        ),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: t,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [AppColors.goldSoft, AppColors.accentGold],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
