import 'dart:async';
import 'package:flutter/material.dart';

class FlowingMenuItemData {
  final String text;
  final String image;
  final String link;

  FlowingMenuItemData({
    required this.text,
    required this.image,
    required this.link,
  });
}

class FlowingMenu extends StatelessWidget {
  final List<FlowingMenuItemData> items;
  final Color textColor;
  final Color bgColor;
  final Color marqueeBgColor;
  final Color marqueeTextColor;
  final Color borderColor;
  final double speed; // Pixels per frame

  const FlowingMenu({
    super.key,
    required this.items,
    this.textColor = Colors.white,
    this.bgColor = const Color(0xFF120F17),
    this.marqueeBgColor = Colors.white,
    this.marqueeTextColor = const Color(0xFF120F17),
    this.borderColor = Colors.white,
    this.speed = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final isFirst = items.first == item;
          return FlowingMenuItem(
            item: item,
            isFirst: isFirst,
            textColor: textColor,
            marqueeBgColor: marqueeBgColor,
            marqueeTextColor: marqueeTextColor,
            borderColor: borderColor,
            speed: speed,
          );
        }).toList(),
      ),
    );
  }
}

class FlowingMenuItem extends StatefulWidget {
  final FlowingMenuItemData item;
  final bool isFirst;
  final Color textColor;
  final Color marqueeBgColor;
  final Color marqueeTextColor;
  final Color borderColor;
  final double speed;

  const FlowingMenuItem({
    super.key,
    required this.item,
    required this.isFirst,
    required this.textColor,
    required this.marqueeBgColor,
    required this.marqueeTextColor,
    required this.borderColor,
    required this.speed,
  });

  @override
  State<FlowingMenuItem> createState() => _FlowingMenuItemState();
}

class _FlowingMenuItemState extends State<FlowingMenuItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _revealController;
  late Animation<Offset> _revealAnimation;
  Timer? _ticker;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _revealAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutExpo,
    ));
  }

  @override
  void dispose() {
    _revealController.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  void _startMarquee() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          _scrollOffset += widget.speed;
          if (_scrollOffset > 1000) {
            // Rough loop
            _scrollOffset = 0;
          }
        });
      }
    });
  }

  void _stopMarquee() {
    _ticker?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() => _isHovered = true);
        _revealController.forward();
        _startMarquee();
      },
      onExit: (event) {
        setState(() => _isHovered = false);
        _revealController.reverse();
        _stopMarquee();
      },
      child: GestureDetector(
        onTap: () {
          // Nav
        },
        child: Container(
          height: 120, // fixed height for item
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: widget.isFirst
                  ? BorderSide.none
                  : BorderSide(color: widget.borderColor, width: 1),
            ),
          ),
          child: Stack(
            children: [
              // Default Text
              Center(
                child: Text(
                  widget.item.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              // Marquee Reveal
              ClipRect(
                child: SlideTransition(
                  position: _revealAnimation,
                  child: Container(
                    color: widget.marqueeBgColor,
                    height: double.infinity,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: -_scrollOffset,
                          child: Row(
                            children: List.generate(20, (index) {
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      widget.item.text.toUpperCase(),
                                      style: TextStyle(
                                        color: widget.marqueeTextColor,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 80,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      image: DecorationImage(
                                        image: NetworkImage(widget.item.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
