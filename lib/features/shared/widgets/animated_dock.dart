import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DockItemData {
  final IconData icon;
  final String label;
  DockItemData({required this.icon, required this.label});
}

class AnimatedDock extends StatefulWidget {
  final List<DockItemData> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final double baseSize;
  final double magnifiedSize;

  const AnimatedDock({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.baseSize = 50.0,
    this.magnifiedSize = 70.0,
  });

  @override
  State<AnimatedDock> createState() => _AnimatedDockState();
}

class _AnimatedDockState extends State<AnimatedDock> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.navyDeep.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.items.length, (index) {
          return _buildDockItem(index);
        }),
      ),
    );
  }

  Widget _buildDockItem(int index) {
    final isSelected = widget.currentIndex == index;
    final item = widget.items[index];
    
    // Calculate scale based on hover state
    double scale = 1.0;
    if (_hoveredIndex != null) {
      if (_hoveredIndex == index) {
        scale = widget.magnifiedSize / widget.baseSize;
      } else if ((_hoveredIndex! - index).abs() == 1) {
        // Adjacent items get a slight bump
        scale = (widget.magnifiedSize + widget.baseSize) / (2 * widget.baseSize);
      }
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () {
          widget.onItemSelected(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: widget.baseSize * scale,
          height: widget.baseSize * scale,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentGold.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16 * scale),
            border: Border.all(
              color: isSelected ? AppColors.accentGold : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(
                item.icon,
                color: isSelected ? AppColors.accentGold : Colors.white54,
                size: (widget.baseSize * 0.5) * scale,
              ),
              // Tooltip on hover
              if (_hoveredIndex == index)
                Positioned(
                  top: -45,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: 1.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.navyBlack,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
