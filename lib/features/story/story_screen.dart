import 'package:flutter/material.dart';
import '../../core/localization/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../landing/widgets/staggered_menu.dart';
import 'widgets/line_sidebar.dart';
import 'widgets/story_hero_section.dart';
import 'widgets/story_origin_section.dart';
import 'widgets/story_jami_section.dart';
import 'widgets/story_economics_section.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final ScrollController _scrollController = ScrollController();
  int _activeIndex = 0;
  
  final List<GlobalKey> _sectionKeys = [
    GlobalKey(), // Overview (Hero)
    GlobalKey(), // Origin
    GlobalKey(), // Jami Protocol
    GlobalKey(), // Philosophy
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveIndex);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveIndex);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateActiveIndex() {
    if (!_scrollController.hasClients) return;
    
    final offset = _scrollController.offset;
    final screenHeight = MediaQuery.sizeOf(context).height;
    
    // Very basic active index detection based on scroll position
    int newIndex = 0;
    if (offset >= screenHeight * 2.5) {
      newIndex = 3;
    } else if (offset >= screenHeight * 1.5) {
      newIndex = 2;
    } else if (offset >= screenHeight * 0.5) {
      newIndex = 1;
    }

    if (newIndex != _activeIndex) {
      setState(() {
        _activeIndex = newIndex;
      });
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutQuart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 768;

    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final sidebarItems = [
          lang.translate('Overview', 'അവലോകനം'),
          lang.translate('Origin', 'തുടക്കം'),
          lang.translate('Jami Protocol', 'ജാമി പ്രോട്ടോക്കോൾ'),
          lang.translate('Philosophy', 'തത്ത്വചിന്ത'),
        ];

        return Scaffold(
          backgroundColor: AppColors.navyBlack,
          body: Stack(
            children: [
              Row(
                children: [
                  // Interactive Line Sidebar (Desktop Only)
                  if (!isMobile)
                    Container(
                      width: 320, // Increased width column for sidebar to fit Malayalam
                      height: double.infinity,
                      color: const Color(0xFF090F24),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 40),
                      child: LineSidebar(
                        items: sidebarItems,
                        activeIndex: _activeIndex,
                        onItemTapped: _scrollToSection,
                      ),
                    ),

                  // Main Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          StoryHeroSection(key: _sectionKeys[0]),
                          StoryOriginSection(key: _sectionKeys[1]),
                          StoryJamiSection(key: _sectionKeys[2]),
                          StoryEconomicsSection(key: _sectionKeys[3]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // The Staggered Glassmorphism Side Menu overlay (fixed on top)
              const Positioned.fill(
                child: StaggeredMenu(),
              ),
            ],
          ),
        );
      },
    );
  }
}
