import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

class LightRays extends StatefulWidget {
  final Color color;
  const LightRays({super.key, this.color = AppColors.accentGold});

  @override
  State<LightRays> createState() => _LightRaysState();
}

class _LightRaysState extends State<LightRays> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Long, slow, luxurious breathing
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _GodRaysPainter(
            color: widget.color,
            time: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _GodRaysPainter extends CustomPainter {
  final Color color;
  final double time;

  _GodRaysPainter({
    required this.color,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double timeOffset = time * math.pi * 2;
    
    final double originX = size.width / 2;
    final double originY = -size.height * 0.2; // Origin well above the screen
    final Offset center = Offset(originX, originY);

    // 1. Draw the core glow at the origin
    final Paint coreGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(originX, 0), radius: size.width * 0.5))
      ..blendMode = BlendMode.screen;
      
    canvas.drawCircle(Offset(originX, 0), size.width * 0.5, coreGlowPaint);

    // 2. Generate the SweepGradient stops for the rays
    final List<Color> colors = [];
    final List<double> stops = [];
    
    final math.Random random = math.Random(12345); // Fixed seed for stable rays
    
    int numRays = 40;
    double currentAngle = 0.0;
    
    for (int i = 0; i < numRays; i++) {
      double rayWidth = 0.01 + random.nextDouble() * 0.04;
      double gapWidth = 0.01 + random.nextDouble() * 0.05;
      
      double baseIntensity = 0.1 + random.nextDouble() * 0.3;
      // Slight pulsing effect based on time
      double intensity = baseIntensity * (0.7 + 0.3 * math.sin(timeOffset * 3.0 + i));
      
      // Gap
      colors.add(Colors.transparent);
      stops.add(currentAngle);
      
      currentAngle += gapWidth;
      if (currentAngle >= 1.0) break;
      
      // Ray Start
      colors.add(color.withValues(alpha: intensity));
      stops.add(currentAngle);
      
      currentAngle += rayWidth;
      if (currentAngle >= 1.0) break;
      
      // Ray End
      colors.add(Colors.transparent);
      stops.add(currentAngle);
    }
    
    if (stops.last < 1.0) {
      colors.add(Colors.transparent);
      stops.add(1.0);
    }

    final sweepGradient = SweepGradient(
      center: Alignment(
        (center.dx / size.width) * 2 - 1, 
        (center.dy / size.height) * 2 - 1
      ),
      colors: colors,
      stops: stops,
      transform: GradientRotation(math.sin(timeOffset * 0.5) * 0.1), // Very slow, subtle sway
    );

    final Paint rayPaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..blendMode = BlendMode.screen
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0); // Soft blur so they look like light, not hard lines

    // Draw rays into a new layer so we can mask them fading downwards
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), rayPaint);
    
    // Create a linear gradient mask to fade the rays as they go down
    final Paint fadeMaskPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Colors.black.withValues(alpha: 0.8), Colors.transparent],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..blendMode = BlendMode.dstIn; // Only keep pixels where the mask is opaque
      
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), fadeMaskPaint);
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GodRaysPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}
