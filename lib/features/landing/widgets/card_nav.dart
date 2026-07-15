import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';

class NavItemData {
  final String label;
  final List<String> links;
  NavItemData({required this.label, required this.links});
}

class CardNav extends StatefulWidget {
  const CardNav({super.key});

  @override
  State<CardNav> createState() => _CardNavState();
}

class _CardNavState extends State<CardNav> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  final List<NavItemData> items = [
    NavItemData(label: "Our Story", links: ["Kudumbashree", "The Makers"]),
    NavItemData(label: "Products", links: ["Mango Pickle", "Handicrafts"]),
    NavItemData(label: "Contact", links: ["WhatsApp Us", "Email"]),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _heightFactor = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return Container(
      width: isMobile ? MediaQuery.sizeOf(context).width * 0.9 : 800,
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textWhite.withValues(alpha: 0.15), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: AppColors.primaryNavy.withValues(alpha: 0.4), // Ultra-premium glass background
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTopBar(isMobile),
                _buildExpandedContent(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isMobile) ...[
              _buildLogo(),
              _buildHamburger(),
            ] else ...[
              _buildHamburger(),
              _buildLogo(),
              _buildCTA(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHamburger() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: Container(
          width: 40,
          height: 40,
          color: Colors.transparent,
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _controller,
              color: AppColors.accentGold,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Homemade ',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          'CEO',
          style: TextStyle(
            color: AppColors.accentGold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildCTA() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accentGold,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: AppColors.primaryNavy,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(bool isMobile) {
    return SizeTransition(
      sizeFactor: _heightFactor,
      axisAlignment: -1.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: isMobile
            ? Column(
                children: List.generate(items.length, (index) => _buildAnimatedCard(index, isMobile)),
              )
            : Row(
                children: List.generate(items.length, (index) => Expanded(child: _buildAnimatedCard(index, isMobile))),
              ),
      ),
    );
  }

  Widget _buildAnimatedCard(int index, bool isMobile) {
    // Staggered animation for each card mimicking the GSAP stagger: 0.08
    double start = 0.1 + (index * 0.15);
    double end = start + 0.4;
    
    Animation<double> slideAndFade = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end > 1.0 ? 1.0 : end, curve: Curves.easeOutQuart),
    );

    return AnimatedBuilder(
      animation: slideAndFade,
      builder: (context, child) {
        return Opacity(
          opacity: slideAndFade.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - slideAndFade.value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: isMobile ? (index == items.length - 1 ? 0 : 8) : 0,
          right: !isMobile ? (index == items.length - 1 ? 0 : 8) : 0,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.textWhite.withValues(alpha: 0.05), // Inner frosted card
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.15), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              items[index].label,
              style: const TextStyle(
                color: AppColors.goldSoft,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...items[index].links.map((link) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_outward, color: AppColors.textWhite, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        link,
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
