import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class ExpandableCardData {
  final String title;
  final String description;
  final String imageUrl;

  ExpandableCardData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class ExpandableCards extends StatefulWidget {
  final List<ExpandableCardData> items;
  final double height;

  const ExpandableCards({
    super.key,
    required this.items,
    this.height = 500,
  });

  @override
  State<ExpandableCards> createState() => _ExpandableCardsState();
}

class _ExpandableCardsState extends State<ExpandableCards> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          // Stack them vertically on mobile with fixed height per card
          return Column(
            children: List.generate(widget.items.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 250, // Fixed height per card on mobile
                  child: _buildCard(index, true),
                ),
              );
            }),
          );
        }

        // Desktop - Fixed width grid, only inner content animates
        return SizedBox(
          height: widget.height,
          child: Row(
            children: List.generate(widget.items.length, (index) {
              final isHovered = _hoveredIndex == index;
              return Expanded(
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: Padding(
                    padding: EdgeInsets.only(right: index == widget.items.length - 1 ? 0 : 16.0),
                    child: _buildCard(index, isHovered),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildCard(int index, bool isHovered) {
    final item = widget.items[index];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with scale animation
          AnimatedScale(
            scale: isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutQuart,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          
          // Dark overlay that intensifies on hover
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: isHovered ? 0.9 : 0.6),
                  Colors.black.withValues(alpha: isHovered ? 0.4 : 0.0),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: AppColors.accentGold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                
                // Description that slides up on hover
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuart,
                  child: SizedBox(
                    height: isHovered ? null : 0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        item.description,
                        style: TextStyle(
                          color: AppColors.textWhite.withValues(alpha: 0.9),
                          fontSize: 16,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
