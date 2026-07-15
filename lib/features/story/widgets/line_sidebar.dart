import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LineSidebar extends StatefulWidget {
  final List<String> items;
  final int activeIndex;
  final Function(int) onItemTapped;

  const LineSidebar({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onItemTapped,
  });

  @override
  State<LineSidebar> createState() => _LineSidebarState();
}

class _LineSidebarState extends State<LineSidebar> {
  double? _pointerY;
  final double proximityRadius = 150.0;
  final double maxShift = 20.0; // Shorter shift
  final double itemHeight = 60.0; 

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _pointerY = event.localPosition.dy;
        });
      },
      onExit: (event) {
        setState(() {
          _pointerY = null;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.items.length, (index) {
          double targetEffect = 0.0;
          if (_pointerY != null) {
            final center = index * itemHeight + (itemHeight / 2);
            final distance = (_pointerY! - center).abs();
            // falloff: smooth
            double p = (1 - (distance / proximityRadius)).clamp(0.0, 1.0);
            targetEffect = p * p * (3 - 2 * p); // smooth step
          }
          if (widget.activeIndex == index) {
            targetEffect = 1.0;
          }

          return GestureDetector(
            onTap: () => widget.onItemTapped(index),
            child: SizedBox(
              height: itemHeight,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: targetEffect),
                duration: const Duration(milliseconds: 100), // Smoother and shorter duration
                curve: Curves.easeOutCubic,
                builder: (context, effect, child) {
                  // Text and marker are always golden now
                  final color = AppColors.accentGold;

                  return Row(
                    children: [
                      // Marker Line
                      Container(
                        width: 20 + (effect * 15), // Made line shorter
                        height: 1,
                        color: color.withValues(alpha: 0.5 + (effect * 0.5)),
                      ),
                      const SizedBox(width: 12),
                      // Text shifted
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(effect * maxShift, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Index (01, 02)
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  (index + 1).toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: color.withValues(alpha: 0.6),
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Label
                              Expanded(
                                child: Text(
                                  widget.items[index],
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 14 + (effect * 2),
                                    letterSpacing: 1.0,
                                    fontWeight: effect > 0.5 ? FontWeight.w600 : FontWeight.w300,
                                  ),
                                  softWrap: true, // Allow wrapping
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
