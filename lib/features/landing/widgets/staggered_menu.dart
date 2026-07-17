import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import 'premium_language_toggle.dart';
import '../../auth/widgets/option_wheel.dart';

class MenuItemData {
  final String labelEn;
  final String labelMl;
  final String route;
  MenuItemData({required this.labelEn, required this.labelMl, required this.route});
}

class StaggeredMenu extends StatefulWidget {
  final bool showLogo;
  final bool isDarkTheme;
  const StaggeredMenu({super.key, this.showLogo = true, this.isDarkTheme = true});

  @override
  State<StaggeredMenu> createState() => _StaggeredMenuState();
}

class _StaggeredMenuState extends State<StaggeredMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;
  bool _showLoginWheel = false;
  int _selectedLoginIndex = 1; // Default to Seller Login

  final List<MenuItemData> menuItems = [
    MenuItemData(labelEn: "Home", labelMl: "ഹോം", route: "/landing"),
    MenuItemData(labelEn: "Our Story", labelMl: "ഞങ്ങളുടെ കഥ", route: "/story"),
    MenuItemData(labelEn: "Products", labelMl: "ഉൽപ്പന്നങ്ങൾ", route: "/products"),
    MenuItemData(labelEn: "Community", labelMl: "കമ്മ്യൂണിറ്റി", route: "/community"),
    MenuItemData(labelEn: "Contact", labelMl: "ബന്ധപ്പെടുക", route: "/contact"),
  ];

  final List<String> socialItems = ["WhatsApp", "Instagram", "Facebook"];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _showLoginWheel = false;
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final double screenWidth = MediaQuery.sizeOf(context).width;
        final bool isMobile = screenWidth < 768;
        final double panelWidth = isMobile ? screenWidth : 420.0;

        return Stack(
          children: [
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: Container(color: Colors.transparent),
            ),
          ),
          
        IgnorePointer(
          ignoring: !_isOpen,
          child: Stack(
            children: [
              _buildSlidingLayer(
                width: panelWidth,
                color: AppColors.accentGold,
                interval: const Interval(0.0, 0.5, curve: Curves.easeOutQuart),
              ),
              _buildSlidingLayer(
                width: panelWidth,
                color: AppColors.navyDeep,
                interval: const Interval(0.08, 0.58, curve: Curves.easeOutQuart),
              ),
              _buildMainPanel(panelWidth),
            ],
          ),
        ),
        _buildHeader(),
      ],
    );
      }
    );
  }

  Widget _buildSlidingLayer({required double width, required Color color, required Interval interval}) {
    return Positioned(
      top: 0, bottom: 0, right: 0, width: width,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double progress = CurvedAnimation(parent: _controller, curve: interval).value;
          return Transform.translate(
            offset: Offset(width * (1.0 - progress), 0),
            child: child,
          );
        },
        child: Container(color: color),
      ),
    );
  }

  Widget _buildMainPanel(double width) {
    return Positioned(
      top: 0, bottom: 0, right: 0, width: width,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double progress = CurvedAnimation(parent: _controller, curve: const Interval(0.15, 0.75, curve: Curves.easeOutQuart)).value;
          return Transform.translate(
            offset: Offset(width * (1.0 - progress), 0),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  color: AppColors.primaryNavy.withValues(alpha: 0.7),
                  padding: const EdgeInsets.only(top: 140, left: 40, right: 40, bottom: 40),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutQuart,
                    switchOutCurve: Curves.easeInQuart,
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: _showLoginWheel 
                        ? _buildLoginWheelView() 
                        : _buildMainMenuView(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainMenuView() {
    return Column(
      key: const ValueKey('MainMenu'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: menuItems.length + 1,
            itemBuilder: (context, index) {
              if (index < menuItems.length) {
                String label = LanguageProvider().translate(menuItems[index].labelEn, menuItems[index].labelMl);
                return _buildAnimatedMenuItem(index, label, false);
              } else {
                String loginLabel = LanguageProvider().translate("Login", "ലോഗിൻ");
                return _buildAnimatedMenuItem(index, loginLabel, true);
              }
            },
          ),
        ),
        _buildSocials(),
      ],
    );
  }
  
  Widget _buildLoginWheelView() {
    final lang = LanguageProvider();
    
    final List<String> loginOptions = [
      lang.translate("Buyer Login", "വാങ്ങുന്നയാൾ ലോഗിൻ"),
      lang.translate("Seller Login", "വിൽക്കുന്നയാൾ ലോഗിൻ"),
      lang.translate("Admin Login", "അഡ്മിൻ ലോഗിൻ"),
    ];
    
    return Column(
      key: const ValueKey('LoginWheel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _showLoginWheel = false),
          child: Row(
            children: [
              const Icon(Icons.arrow_back, color: AppColors.accentGold),
              const SizedBox(width: 8),
              Text(
                lang.translate("Back to Menu", "മെനുവിലേക്ക് മടങ്ങുക"), 
                style: const TextStyle(color: AppColors.accentGold, fontSize: 16)
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          lang.translate("SELECT ACCOUNT", "അക്കൗണ്ട് തിരഞ്ഞെടുക്കുക"),
          style: const TextStyle(color: AppColors.textWhite, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0),
        ),
        const SizedBox(height: 8),
        // Scroll hint
        Row(children: [
          const Icon(Icons.swipe_vertical_rounded, color: AppColors.accentGold, size: 14),
          const SizedBox(width: 6),
          Text(
            lang.translate('Scroll or tap to select', 'സ്ക്രോൾ അല്ലെങ്കിൽ ടാപ്പ് ചെയ്യുക'),
            style: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.45), fontSize: 12),
          ),
        ]),
        // Scroll arrows + wheel
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The wheel itself (must be first in Stack to be painted at the bottom)
              OptionWheel(
                items: loginOptions,
                defaultSelected: _selectedLoginIndex,
                onChange: (index) => setState(() => _selectedLoginIndex = index),
              ),
              // Up arrow
              Positioned(
                top: 57,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _selectedLoginIndex > 0 ? 0.8 : 0.2,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _selectedLoginIndex > 0
                        ? () => setState(() {
                              _selectedLoginIndex--;
                            })
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.expand_less_rounded, color: AppColors.accentGold, size: 20),
                    ),
                  ),
                ),
              ),
              // Down arrow
              Positioned(
                bottom: 57,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _selectedLoginIndex < loginOptions.length - 1 ? 0.8 : 0.2,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _selectedLoginIndex < loginOptions.length - 1
                        ? () => setState(() {
                              _selectedLoginIndex++;
                            })
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.expand_more_rounded, color: AppColors.accentGold, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Selected account indicator
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.3)),
            ),
            child: Text(
              loginOptions[_selectedLoginIndex],
              style: const TextStyle(color: AppColors.accentGold, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // Continue button
        Center(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _toggleMenu();
                if (_selectedLoginIndex == 0) {
                  context.go('/auth/buyer');
                } else if (_selectedLoginIndex == 1) {
                  context.go('/auth/seller');
                } else {
                  context.go('/auth/admin');
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    lang.translate("Continue", "തുടരുക"),
                    style: const TextStyle(
                      color: AppColors.primaryNavy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildAnimatedMenuItem(int index, String label, bool isLoginAction) {
    final double start = 0.25 + (index * 0.1);
    final double end = (start + 0.4).clamp(0.0, 1.0);
    final Animation<double> anim = CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOutBack));

    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        final double val = anim.value;
        return Opacity(
          opacity: val.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 60 * (1.0 - val)),
            child: Transform.rotate(
              angle: (10 * (1.0 - val)) * math.pi / 180,
              alignment: Alignment.bottomLeft,
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (isLoginAction) {
                setState(() {
                  _showLoginWheel = true;
                  _selectedLoginIndex = 1; // Always default to Seller Login when opened
                });
              } else {
                final route = menuItems[index].route;
                _toggleMenu();
                if (route == "/landing" || route == "/story" || route == "/products") {
                  context.go(route);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Route $route is coming soon!'),
                      backgroundColor: AppColors.accentGold,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      color: isLoginAction ? AppColors.accentGold : AppColors.textWhite,
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1.0,
                      height: 1.2,
                    ),
                  ),
                ),
                if (!isLoginAction) ...[
                  const SizedBox(width: 8),
                  Text(
                    '0${index + 1}',
                    style: const TextStyle(color: AppColors.accentGold, fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocials() {
    final lang = LanguageProvider();
    final Animation<double> anim = CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeOutQuart));
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        return Opacity(
          opacity: anim.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1.0 - anim.value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.translate('Socials', 'സോഷ്യൽസ്'), style: const TextStyle(color: AppColors.accentGold, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24, runSpacing: 12,
            children: socialItems.map((social) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(social, style: const TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.w400)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final lang = LanguageProvider();
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;
    
    return Positioned(
      top: 0, left: 0, right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16.0 : 32.0, 
            vertical: isMobile ? 16.0 : 24.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            // Logo
            if (widget.showLogo)
              Row(
                children: [
                  Text('Homemade ', style: TextStyle(color: AppColors.textWhite, fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.w400)),
                  Text('CEO', style: TextStyle(color: AppColors.accentGold, fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                ],
              )
            else
              const SizedBox.shrink(),
            // Actions
            Row(
              children: [
                PremiumLanguageToggle(isDarkTheme: widget.isDarkTheme),
                SizedBox(width: isMobile ? 12 : 24),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _toggleMenu,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          SizedBox(
                            width: isMobile ? 70 : 85, // Strictly fixed width to prevent shifting!
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
                                      CurvedAnimation(parent: animation, curve: Curves.easeOutQuart)
                                    ),
                                    child: FadeTransition(opacity: animation, child: child),
                                  );
                                },
                                child: Text(
                                  _isOpen ? lang.translate('Close', 'അടയ്ക്കുക') : lang.translate('Menu', 'മെനു'),
                                  key: ValueKey(_isOpen.toString() + lang.isEnglish.toString()),
                                  style: TextStyle(
                                    color: _isOpen ? AppColors.textWhite : (widget.isDarkTheme ? AppColors.textWhite : Colors.black87), 
                                    fontSize: isMobile ? 14 : 16, 
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _controller.value * 225 * math.pi / 180,
                                child: SizedBox(
                                  width: isMobile ? 14 : 18, 
                                  height: isMobile ? 14 : 18,
                                  child: Stack(
                                    children: [
                                      Positioned(top: isMobile ? 6 : 8, left: 0, right: 0, child: Container(height: 2, color: _isOpen ? AppColors.textWhite : (widget.isDarkTheme ? AppColors.textWhite : Colors.black87))),
                                      Positioned(left: isMobile ? 6 : 8, top: 0, bottom: 0, child: Container(width: 2, color: _isOpen ? AppColors.textWhite : (widget.isDarkTheme ? AppColors.textWhite : Colors.black87))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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
    );
  }
}
