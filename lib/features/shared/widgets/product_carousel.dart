import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/theme/app_colors.dart';

class ProductCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  const ProductCarousel({
    super.key,
    required this.imageUrls,
    this.height = 300,
  });

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  void _startTimer() {
    if (widget.imageUrls.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          int nextPage = _currentPage + 1;
          if (nextPage >= widget.imageUrls.length) {
            nextPage = 0;
            _pageController.jumpToPage(0);
          } else {
            _pageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox();

    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          MouseRegion(
            onEnter: (_) => _timer?.cancel(),
            onExit: (_) => _startTimer(),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          if (widget.imageUrls.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 8.0,
                    width: _currentPage == index ? 24.0 : 8.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? AppColors.accentGold : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  );
                }),
              ),
            )
        ],
      ),
    );
  }
}
