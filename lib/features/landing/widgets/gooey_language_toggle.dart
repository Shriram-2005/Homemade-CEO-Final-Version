import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

class GooeyLanguageToggle extends StatefulWidget {
  const GooeyLanguageToggle({super.key});

  @override
  State<GooeyLanguageToggle> createState() => _GooeyLanguageToggleState();
}

class _GooeyLanguageToggleState extends State<GooeyLanguageToggle> with TickerProviderStateMixin {
  int _activeIndex = 0;
  final List<String> _items = ['EN', 'ML'];
  final double _itemWidth = 60.0;
  
  // Particle system state
  List<Particle> _particles = [];
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (_activeIndex == index) return;
    
    setState(() {
      _activeIndex = index;
    });
    
    _generateParticles(index);
    _particleController.forward(from: 0.0);
  }

  void _generateParticles(int activeIndex) {
    final math.Random random = math.Random();
    _particles = List.generate(15, (i) {
      double angle = random.nextDouble() * 2 * math.pi;
      double distance = 30.0 + random.nextDouble() * 40.0;
      return Particle(
        angle: angle,
        distance: distance,
        scale: 0.5 + random.nextDouble(),
        color: random.nextBool() ? AppColors.accentGold : Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _itemWidth * 2 + 16,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Track
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          
          // Particles (rendered beneath the pill)
          if (_particleController.isAnimating)
            ..._particles.map((p) {
              double progress = Curves.easeOutCubic.transform(_particleController.value);
              double currentDist = p.distance * progress;
              double centerX = (_activeIndex == 0 ? _itemWidth / 2 : _itemWidth * 1.5) + 8;
              
              return Positioned(
                left: centerX + math.cos(p.angle) * currentDist - 4,
                top: 20 + math.sin(p.angle) * currentDist - 4,
                child: Opacity(
                  opacity: 1.0 - progress,
                  child: Transform.scale(
                    scale: p.scale * (1.0 - progress),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: p.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),

          // The Bouncing Liquid Pill
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut, // Gives that snappy, gooey feel
            left: _activeIndex == 0 ? 4 : _itemWidth + 4,
            top: 4,
            child: Container(
              width: _itemWidth,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    blurRadius: 8,
                  )
                ],
              ),
            ),
          ),

          // The Text Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_items.length, (index) {
              bool isActive = _activeIndex == index;
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: Container(
                  width: _itemWidth,
                  color: Colors.transparent, // Hit area
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: isActive ? AppColors.navyBlack : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      child: Text(_items[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class Particle {
  final double angle;
  final double distance;
  final double scale;
  final Color color;

  Particle({
    required this.angle,
    required this.distance,
    required this.scale,
    required this.color,
  });
}
