import 'package:flutter/material.dart';

class LogoLoopData {
  final Widget child;
  const LogoLoopData({required this.child});
}

class LogoLoop extends StatefulWidget {
  final List<LogoLoopData> logos;
  final double speed; // Pixels per second
  final double height;
  final double gap;

  const LogoLoop({
    super.key,
    required this.logos,
    this.speed = 50.0,
    this.height = 80.0,
    this.gap = 40.0,
  });

  @override
  State<LogoLoop> createState() => _LogoLoopState();
}

class _LogoLoopState extends State<LogoLoop> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        if (!_isHovering && _scrollController.hasClients) {
          final maxExtent = _scrollController.position.maxScrollExtent;
          final current = _scrollController.offset;
          
          // Calculate pixels to move per frame based on speed and time delta
          // To keep it simple, we just move constantly
          double next = current + (widget.speed * 0.016);
          if (next >= maxExtent) {
            next = 0;
          }
          _scrollController.jumpTo(next);
        }
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Generate an artificially large list for infinite scrolling illusion
    final loopedList = List.generate(
      1000, 
      (index) => widget.logos[index % widget.logos.length]
    );

    return MouseRegion(
      onEnter: (_) => _isHovering = true,
      onExit: (_) => _isHovering = false,
      child: SizedBox(
        height: widget.height,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: loopedList.length,
          physics: const NeverScrollableScrollPhysics(), // Managed by controller
          separatorBuilder: (context, index) => SizedBox(width: widget.gap),
          itemBuilder: (context, index) {
            return Center(
              child: loopedList[index].child,
            );
          },
        ),
      ),
    );
  }
}
