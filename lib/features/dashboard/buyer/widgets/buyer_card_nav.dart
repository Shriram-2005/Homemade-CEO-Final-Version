import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/language_provider.dart';

class BuyerCardNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onSignOut;

  const BuyerCardNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onSignOut,
  });

  @override
  State<BuyerCardNav> createState() => _BuyerCardNavState();
}

class _BuyerCardNavState extends State<BuyerCardNav> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;

  final List<Map<String, dynamic>> _menuCategories = [
    {
      'labelEn': 'Shopping',
      'labelMl': 'ഷോപ്പിംഗ്',
      'bgColor': const Color(0xFFEAF4FC), // Soft blue
      'textColor': AppColors.primaryNavy,
      'links': [
        {'labelEn': 'Discover', 'labelMl': 'കണ്ടെത്തുക', 'index': 0, 'icon': Icons.explore_outlined},
        {'labelEn': 'Saved', 'labelMl': 'സംരക്ഷിച്ചു', 'index': 1, 'icon': Icons.favorite_outline},
      ],
    },
    {
      'labelEn': 'Account',
      'labelMl': 'അക്കൗണ്ട്',
      'bgColor': const Color(0xFFF9F6EA), // Soft gold/cream
      'textColor': AppColors.primaryNavy,
      'links': [
        {'labelEn': 'Orders', 'labelMl': 'ഓർഡറുകൾ', 'index': 2, 'icon': Icons.receipt_long_outlined},
        {'labelEn': 'Profile', 'labelMl': 'പ്രൊഫൈൽ', 'index': 3, 'icon': Icons.person_outline},
      ],
    },
    {
      'labelEn': 'Language',
      'labelMl': 'ഭാഷ',
      'bgColor': const Color(0xFFEAF9F1), // Soft green
      'textColor': AppColors.primaryNavy,
      'isLanguageNode': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
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

  void _selectTab(int index) {
    widget.onTabSelected(index);
    if (_isExpanded) {
      _toggleMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;
    final lang = LanguageProvider();

    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double maxNavHeight = screenHeight - (isMobile ? 24 : 48);
    final double closedHeight = 60.0;
    final double contentPadding = 32.0;
    final double cardsHeight = isMobile ? (_menuCategories.length * 140.0) : 160.0;
    final double calculatedExpandedHeight = closedHeight + cardsHeight + contentPadding;
    final double expandedHeight = calculatedExpandedHeight > maxNavHeight ? maxNavHeight : calculatedExpandedHeight;

    return ListenableBuilder(
      listenable: lang,
      builder: (context, _) {
        return Stack(
          children: [
            if (_isExpanded)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleMenu,
                  child: Container(color: Colors.transparent),
                ),
              ),
              
            Positioned(
              top: isMobile ? 12 : 24,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuart,
                  width: isMobile ? MediaQuery.sizeOf(context).width * 0.92 : 800,
                  height: _isExpanded ? expandedHeight : closedHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned(
                          top: closedHeight,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            ignoring: !_isExpanded,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: isMobile 
                                  ? SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: _menuCategories.asMap().entries.map((e) => _buildCard(e.value, e.key)).toList(),
                                      ),
                                    )
                                  : Row(
                                      children: _menuCategories.asMap().entries.map((e) => Expanded(child: _buildCard(e.value, e.key))).toList(),
                                    ),
                            ),
                          ),
                        ),
                        
                        Positioned(
                          top: 0, left: 0, right: 0,
                          height: closedHeight,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: _toggleMenu,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          color: Colors.transparent,
                                          child: AnimatedIcon(
                                            icon: AnimatedIcons.menu_close,
                                            progress: _controller,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Row(
                                      children: [
                                        Text('Homemade ', style: TextStyle(color: AppColors.navyBlack, fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w400)),
                                        Text('CEO', style: TextStyle(color: AppColors.accentGold, fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: AppColors.accentGold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                                          child: const Text('Buyer', style: TextStyle(color: AppColors.accentGold, fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                                Row(
                                  children: [
                                    if (!isMobile) ...[
                                      const Text(
                                        'Buyer Profile',
                                        style: TextStyle(
                                          color: AppColors.navyBlack,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: widget.onSignOut,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF111111),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            lang.translate('Sign Out', 'സൈൻ ഔട്ട്'),
                                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildLangBtn(String label, String code, LanguageProvider lang) {
    final bool isSelected = lang.currentLocale.languageCode == code;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (lang.currentLocale.languageCode != code) lang.toggleLanguage();
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black87 : Colors.black54,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> category, int index) {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;
    
    final double start = (index * 0.1).clamp(0.0, 1.0);
    final double end = (start + 0.4).clamp(0.0, 1.0);
    final Animation<double> slideFadeAnim = CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOutQuart));

    return AnimatedBuilder(
      animation: slideFadeAnim,
      builder: (context, child) {
        return Opacity(
          opacity: slideFadeAnim.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1.0 - slideFadeAnim.value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isMobile && index < _menuCategories.length -1 ? 8 : 0, right: isMobile ? 0 : (index < _menuCategories.length - 1 ? 8 : 0)),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: category['bgColor'] as Color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              lang.translate(category['labelEn'], category['labelMl']),
              style: TextStyle(color: category['textColor'], fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            isMobile ? const SizedBox(height: 12) : const Spacer(),
            if (category['isLanguageNode'] == true) ...[
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLangBtn('English', 'en', lang),
                    const SizedBox(height: 4),
                    _buildLangBtn('മലയാളം', 'ml', lang),
                  ],
                ),
              ),
            ] else ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (category['links'] as List).map<Widget>((link) {
                  final bool isActive = widget.currentIndex == link['index'];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _selectTab(link['index']),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              link['icon'] as IconData,
                              size: 16,
                              color: isActive ? AppColors.accentGold : category['textColor'].withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              lang.translate(link['labelEn'], link['labelMl']),
                              style: TextStyle(
                                color: isActive ? AppColors.accentGold : category['textColor'].withValues(alpha: 0.7),
                                fontSize: 15,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
