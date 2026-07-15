import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../../core/theme/app_colors.dart';

class OptionWheel extends StatefulWidget {
  final List<String> items;
  final int defaultSelected;
  final ValueChanged<int>? onChange;

  const OptionWheel({
    super.key,
    required this.items,
    this.defaultSelected = 0,
    this.onChange,
  });

  @override
  State<OptionWheel> createState() => _OptionWheelState();
}

class _OptionWheelState extends State<OptionWheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scrollPosition;
  double _dragVelocity = 0.0;
  
  // Wheel Configuration
  final double rowHeight = 70.0;
  final double curve = 1.0;
  final double tilt = 0.0; // degrees
  final double fade = 0.3;
  final double blurAmount = 4.0;
  
  @override
  void initState() {
    super.initState();
    _scrollPosition = widget.defaultSelected.toDouble();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addListener(_onAnimationTick);
  }
  
  @override
  void dispose() {
    _controller.removeListener(_onAnimationTick);
    _controller.dispose();
    super.dispose();
  }

  void _onAnimationTick() {
    if (_controller.isAnimating) {
      setState(() {
        _scrollPosition += _dragVelocity;
        _dragVelocity *= 0.9; // friction
        
        if (_dragVelocity.abs() < 0.02) {
          double target = _scrollPosition.roundToDouble();
          target = target.clamp(0, widget.items.length - 1);
          
          // Smoother, faster snap
          _scrollPosition += (target - _scrollPosition) * 0.2;
          
          if ((target - _scrollPosition).abs() < 0.05) {
            _scrollPosition = target;
            _controller.stop();
            if (widget.onChange != null) {
              widget.onChange!(_scrollPosition.round());
            }
          }
        }
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.stop();
    setState(() {
      _scrollPosition -= details.delta.dy / rowHeight;
      // Clamp bounds with a little elastic overscroll
      if (_scrollPosition < -0.5) _scrollPosition = -0.5;
      if (_scrollPosition > widget.items.length - 0.5) _scrollPosition = widget.items.length - 0.5;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _dragVelocity = -(details.velocity.pixelsPerSecond.dy / rowHeight) * 0.016;
    _controller.repeat();
  }
  
  void _onTapItem(int index) {
    _controller.stop();
    _dragVelocity = 0;
    // Simple smooth scroll to item
    _scrollPosition = index.toDouble(); // For a perfect implementation we'd animate this
    if (widget.onChange != null) {
      widget.onChange!(index);
    }
    setState(() {});
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      _controller.stop();
      setState(() {
        _scrollPosition += event.scrollDelta.dy / (rowHeight * 2);
        if (_scrollPosition < -0.5) _scrollPosition = -0.5;
        if (_scrollPosition > widget.items.length - 0.5) _scrollPosition = widget.items.length - 0.5;
      });
      
      _dragVelocity = (event.scrollDelta.dy / rowHeight) * 0.05;
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _onPointerSignal,
      child: GestureDetector(
        onVerticalDragUpdate: _onPanUpdate,
        onVerticalDragEnd: _onPanEnd,
        child: Container(
          height: 300, // Fixed height for the wheel viewport
          width: 300,
          color: Colors.transparent, // Hit area
          child: Stack(
            alignment: Alignment.centerLeft,
            children: List.generate(widget.items.length, (index) => _buildItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    double d = index - _scrollPosition;
    double dist = d.abs();
    
    // Math logic translated from the React OptionWheel
    double tiltRad = tilt * math.pi / 180;
    double R = tiltRad > 0.0005 ? rowHeight / tiltRad : 0;
    
    double x = 0;
    double y = d * rowHeight;
    double rot = 0;
    
    if (R > 0) {
      double maxAng = math.pi / 2;
      double ang = (d * tiltRad).clamp(-maxAng, maxAng);
      y = R * math.sin(ang);
      x = R * (1 - math.cos(ang)) * curve;
      rot = ang * 180 / math.pi;
    }
    
    double opacity = (1 - dist * fade).clamp(0.1, 1.0);
    double blur = dist * blurAmount;
    
    bool isSelected = dist < 0.5;

    Widget child = Text(
      widget.items[index],
      style: TextStyle(
        fontSize: isSelected ? 48 : 42,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
        letterSpacing: -1.0,
        color: isSelected ? AppColors.textWhite : AppColors.textWhite.withValues(alpha: 0.5),
      ),
    );


    return Positioned(
      left: 40,
      top: 150, // center of viewport
      child: Transform.translate(
        offset: Offset(x, y - (isSelected ? 24 : 21)), // Adjust for font centering
        child: Transform.rotate(
          angle: rot * math.pi / 180,
          alignment: Alignment.centerLeft,
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: () => _onTapItem(index),
              child: blur > 0.1 
                ? ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: child) 
                : child,
            ),
          ),
        ),
      ),
    );
  }
}
