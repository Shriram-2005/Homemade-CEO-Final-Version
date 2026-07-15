import 'package:flutter/material.dart';

class MasonryItemData {
  final String id;
  final String img;
  final double height;
  final String title;

  MasonryItemData({
    required this.id,
    required this.img,
    required this.height,
    required this.title,
  });
}

class MasonryGrid extends StatefulWidget {
  final List<MasonryItemData> items;
  
  const MasonryGrid({
    super.key,
    required this.items,
  });

  @override
  State<MasonryGrid> createState() => _MasonryGridState();
}

class _MasonryGridState extends State<MasonryGrid> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;
        if (constraints.maxWidth > 1200) {
          columns = 4;
        } else if (constraints.maxWidth > 800) {
          columns = 3;
        } else if (constraints.maxWidth > 500) {
          columns = 2;
        }

        // Extremely simple masonry logic for demonstration
        List<Widget> columnWidgets = List.generate(columns, (index) => Column(children: []));
        List<double> columnHeights = List.generate(columns, (index) => 0);

        for (int i = 0; i < widget.items.length; i++) {
          final item = widget.items[i];
          final bool isMobile = constraints.maxWidth < 600;
          final double displayHeight = isMobile ? item.height * 0.6 : item.height;

          int shortestColIndex = 0;
          for (int c = 1; c < columns; c++) {
            if (columnHeights[c] < columnHeights[shortestColIndex]) {
              shortestColIndex = c;
            }
          }

          // Build item with stagger
          final animation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
              .animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (i * 0.1).clamp(0.0, 1.0),
              1.0,
              curve: Curves.easeOutCubic,
            ),
          ));

          final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (i * 0.1).clamp(0.0, 1.0),
              1.0,
              curve: Curves.easeOutCubic,
            ),
          ));

          final itemWidget = Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: animation,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    height: displayHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(item.img),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          (columnWidgets[shortestColIndex] as Column).children.add(itemWidget);
          columnHeights[shortestColIndex] += displayHeight;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnWidgets.map((col) => Expanded(child: col)).toList(),
        );
      },
    );
  }
}
