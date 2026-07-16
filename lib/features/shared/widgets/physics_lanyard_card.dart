import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

class PhysicsLanyardCard extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double lanyardLength;

  const PhysicsLanyardCard({
    super.key,
    required this.imageUrl,
    this.width = 250,
    this.height = 350,
    this.lanyardLength = 200,
  });

  @override
  State<PhysicsLanyardCard> createState() => _PhysicsLanyardCardState();
}

class _PhysicsLanyardCardState extends State<PhysicsLanyardCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SpringSimulation _springSimulation;
  double _angle = 0.0;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    
    // Initial slight movement
    _startSwing(0.2);
  }

  void _startSwing(double velocity) {
    _springSimulation = SpringSimulation(
      const SpringDescription(
        mass: 1,
        stiffness: 50,
        damping: 4,
      ),
      _angle,
      0, // target is 0 (straight down)
      velocity,
    );
    
    _controller.animateWith(_springSimulation);
    _controller.addListener(() {
      setState(() {
        _angle = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.stop();
    setState(() {
      _dragOffset += details.delta;
      // Calculate angle based on horizontal drag
      _angle = math.max(-math.pi / 2, math.min(math.pi / 2, _dragOffset.dx / widget.lanyardLength));
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _dragOffset = Offset.zero;
    // Start spring animation with the velocity of the drag
    final velocity = details.velocity.pixelsPerSecond.dx / widget.lanyardLength;
    _startSwing(velocity);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: const Offset(0, -50),
        child: Transform.rotate(
          angle: _angle,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lanyard string
              Container(
                width: 4,
                height: widget.lanyardLength,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              // Card
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Glassmorphism reflection
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                    // Hole punch for the lanyard
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 16,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
