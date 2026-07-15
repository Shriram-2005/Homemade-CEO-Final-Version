import 'dart:async';
import 'package:flutter/material.dart';

class CardSwap extends StatefulWidget {
  final List<Widget> children;
  final double width;
  final double height;
  final Duration delay;
  final Function(int)? onSwap;

  const CardSwap({
    super.key,
    required this.children,
    this.width = 500,
    this.height = 400,
    this.delay = const Duration(seconds: 5),
    this.onSwap,
  });

  @override
  State<CardSwap> createState() => _CardSwapState();
}

class _CardSwapState extends State<CardSwap> {
  late List<int> _order;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _order = List.generate(widget.children.length, (i) => i);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.delay, (timer) {
      _swap();
    });
  }

  void _swap() {
    if (_order.isEmpty) return;
    setState(() {
      final front = _order.removeAt(0);
      _order.add(front);
    });
    if (widget.onSwap != null) {
      widget.onSwap!(_order.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxOffsetX = (widget.children.length - 1) * 40.0;
    final double maxOffsetY = (widget.children.length - 1) * 20.0;

    return SizedBox(
      width: widget.width + maxOffsetX,
      height: widget.height + maxOffsetY,
      child: MouseRegion(
        onEnter: (_) => _timer?.cancel(),
        onExit: (_) => _startTimer(),
        child: Stack(
          clipBehavior: Clip.none,
          // We map over _order reversed, so the 0th item (front) is drawn last (on top)
          children: _order.reversed.toList().map((originalIndex) {
            final currentIndex = _order.indexOf(originalIndex);
            
            // Positioning math to simulate the 3D stacking
            final double xOffset = currentIndex * 40.0;
            final double yOffset = currentIndex * -20.0;
            final double scale = 1.0 - (currentIndex * 0.05);
            final double opacity = currentIndex > 2 ? 0.0 : 1.0; // Hide cards too far back

            return AnimatedPositioned(
              key: ValueKey(originalIndex),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              left: xOffset,
              bottom: yOffset,
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 600),
                  child: GestureDetector(
                    onTap: () {
                      if (currentIndex == 0) {
                        _swap();
                      }
                    },
                    child: Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(10, 10),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: widget.children[originalIndex],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
