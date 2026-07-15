import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../landing/widgets/staggered_menu.dart';
import '../story/widgets/line_sidebar.dart';
import 'widgets/card_swap.dart';
import 'widgets/expandable_cards.dart';
import 'widgets/logo_loop.dart';
import 'widgets/masonry_grid.dart';
import 'widgets/typing_synced_text.dart';
import '../../core/localization/language_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _activeCardIndex = 0;
  int _activeSidebarIndex = 0;

  final List<GlobalKey> _sectionKeys = [
    GlobalKey(), // Hero
    GlobalKey(), // Commitments
    GlobalKey(), // Categories
    GlobalKey(), // Discover
  ];

  final List<String> _enCardMessages = [
    "We source strictly without middlemen to ensure fair pricing for everyone.",
    "Natural, authentic flavors with zero chemical additives.",
    "Every product undergoes strict Jami Protocol checks before it reaches you."
  ];

  final List<String> _mlCardMessages = [
    "ഇടനിലക്കാരില്ലാതെ ഏറ്റവും മികച്ച ഉൽപ്പന്നങ്ങൾ ഞങ്ങൾ നൽകുന്നു.",
    "പ്രകൃതിദത്തമായ തനത് രുചികൾ മാത്രം, രാസവസ്തുക്കൾ ഇല്ലാതെ.",
    "ഓരോ ഉൽപ്പന്നവും കർശനമായി പരിശോധിക്കുന്നു."
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
    
    int newIndex = 0;
    if (offset >= screenHeight * 2.5) {
      newIndex = 3;
    } else if (offset >= screenHeight * 1.5) {
      newIndex = 2;
    } else if (offset >= screenHeight * 0.5) {
      newIndex = 1;
    }

    if (newIndex != _activeSidebarIndex) {
      setState(() {
        _activeSidebarIndex = newIndex;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppColors.navyBlack,
      body: ListenableBuilder(
        listenable: LanguageProvider(),
        builder: (context, _) {
          final isMalayalam = !LanguageProvider().isEnglish;
          final activeMessage = isMalayalam
              ? _mlCardMessages[_activeCardIndex % _mlCardMessages.length]
              : _enCardMessages[_activeCardIndex % _enCardMessages.length];
          
          return Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LINE SIDEBAR (Left Column)
                  if (isDesktop)
                    Container(
                      width: 320,
                      height: double.infinity,
                      color: const Color(0xFF090F24), // Sidebar background color
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 40),
                      child: LineSidebar(
                        items: isMalayalam
                            ? ['സ്വാഗതം', 'വാഗ്ദാനങ്ങൾ', 'വിഭാഗങ്ങൾ', 'കണ്ടെത്തുക']
                            : ['Welcome', 'Commitments', 'Categories', 'Discover'],
                        activeIndex: _activeSidebarIndex,
                        onItemTapped: (index) => _scrollToSection(index),
                      ),
                    ),

                  // MAIN CONTENT (Right Column)
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 120),

                          // PAGE HEADER - Exact replica of StoryHeroSection title
                          Container(
                            key: _sectionKeys[0],
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isMalayalam ? 'ഞങ്ങളുടെ ഉൽപ്പന്നങ്ങൾ' : 'OUR PRODUCTS',
                                  style: TextStyle(
                                    color: AppColors.accentGold,
                                    fontSize: isMobile ? 32 : 64,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 8.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ).animate().fade(duration: 1.seconds).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
                                
                                const SizedBox(height: 24),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      isMalayalam ? '100% ജൈവം' : '100% ORGANIC',
                                      style: TextStyle(
                                        color: AppColors.textWhite.withValues(alpha: 0.5),
                                        letterSpacing: 4.0,
                                        fontSize: 12,
                                      ),
                                    ).animate().fade(delay: 800.ms, duration: 600.ms),
                                    const SizedBox(width: 24),
                                    Container(
                                      width: 1,
                                      height: 100,
                                      color: AppColors.accentGold.withValues(alpha: 0.5),
                                    ).animate().fade(delay: 500.ms, duration: 800.ms).scaleY(begin: 0.0, alignment: Alignment.topCenter),
                                    const SizedBox(width: 24),
                                    Text(
                                      isMalayalam ? 'കർഷകരിൽ നിന്ന് നേരിട്ട്' : 'DIRECT SOURCING',
                                      style: TextStyle(
                                        color: AppColors.textWhite.withValues(alpha: 0.5),
                                        letterSpacing: 4.0,
                                        fontSize: 12,
                                      ),
                                    ).animate().fade(delay: 800.ms, duration: 600.ms),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 80),

                          // HERO SECTION: Typing Text + CardSwap
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 800) {
                                  // Mobile Layout
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 120,
                                        child: TypingSyncedText(
                                          text: activeMessage,
                                          style: TextStyle(
                                            color: AppColors.textWhite.withValues(alpha: 0.8),
                                            fontSize: 18,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      _buildCardSwap(isMalayalam, 300), // Smaller cards
                                    ],
                                  );
                                }
                                // Desktop Layout
                                return Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 200,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TypingSyncedText(
                                            text: activeMessage,
                                            style: TextStyle(
                                              color: AppColors.textWhite.withValues(alpha: 0.9),
                                              fontSize: 32,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 60),
                                      child: _buildCardSwap(isMalayalam, 320), // Smaller cards
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 120),

                          // LOGO LOOP SECTION
                          Center(
                            key: _sectionKeys[1],
                            child: Text(
                              isMalayalam ? 'ഞങ്ങളുടെ വാഗ്ദാനങ്ങൾ' : 'OUR COMMITMENTS',
                              style: const TextStyle(
                                color: AppColors.accentGold,
                                letterSpacing: 4.0,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),
                          LogoLoop(
                            logos: [
                              LogoLoopData(child: _buildDummyLogo(isMalayalam ? 'കർഷകരിൽ നിന്ന് നേരിട്ട്' : 'DIRECT FROM FARMERS')),
                              LogoLoopData(child: _buildDummyLogo(isMalayalam ? '100% ജൈവം' : '100% ORGANIC')),
                              LogoLoopData(child: _buildDummyLogo(isMalayalam ? 'മായമില്ലാത്തത്' : 'ZERO PRESERVATIVES')),
                              LogoLoopData(child: _buildDummyLogo(isMalayalam ? 'ഗുണമേന്മ ഉറപ്പ്' : 'PREMIUM QUALITY')),
                              LogoLoopData(child: _buildDummyLogo(isMalayalam ? 'നമ്മുടെ സ്വന്തം' : 'AUTHENTIC KERALA')),
                            ],
                          ),

                          const SizedBox(height: 120),

                          // PRODUCT PHILOSOPHY TEXT
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: Text(
                              isMalayalam 
                                  ? 'മികച്ച ഉൽപ്പന്നങ്ങൾ മാത്രം നിങ്ങൾക്കായി. ഞങ്ങളുടെ ഓരോ ഉൽപ്പന്നവും പ്രകൃതിയിൽ നിന്ന് നേരിട്ട് നിങ്ങളുടെ മുന്നിലെത്തുന്നു.' 
                                  : 'We believe in purity. Every product curated under Homemade CEO strictly adheres to our core philosophy: no compromises, no middle-men, and 100% authentic Kerala heritage.',
                              style: TextStyle(
                                color: AppColors.textWhite.withValues(alpha: 0.8),
                                fontSize: 20,
                                height: 1.8,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),

                          const SizedBox(height: 120),

                          // NEW CATEGORIES SECTION - EXPANDABLE CARDS
                          Padding(
                            key: _sectionKeys[2],
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              isMalayalam ? 'വിഭാഗങ്ങൾ' : 'CATEGORIES',
                              style: const TextStyle(
                                color: AppColors.accentGold,
                                fontSize: 16,
                                letterSpacing: 4.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: ExpandableCards(
                              height: 500,
                              items: [
                                ExpandableCardData(
                                  title: isMalayalam ? 'സുഗന്ധവ്യഞ്ജനങ്ങൾ' : 'PREMIUM SPICES',
                                  description: isMalayalam ? 'ലോകത്തിലെ ഏറ്റവും മികച്ച സുഗന്ധവ്യഞ്ജനങ്ങൾ' : 'The finest spices sourced directly from the heart of Kerala.',
                                  imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                                ),
                                ExpandableCardData(
                                  title: isMalayalam ? 'അച്ചാറുകൾ' : 'AUTHENTIC PICKLES',
                                  description: isMalayalam ? 'തനത് നാടൻ അച്ചാറുകൾ' : 'Traditional recipes passed down through generations.',
                                  imageUrl: 'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                                ),
                                ExpandableCardData(
                                  title: isMalayalam ? 'തേൻ' : 'WILD HONEY',
                                  description: isMalayalam ? 'കാട്ടുതേൻ' : 'Pure, unprocessed honey collected from wild forests.',
                                  imageUrl: 'https://images.unsplash.com/photo-1587049352847-4d4b137a5be2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                                ),
                                ExpandableCardData(
                                  title: isMalayalam ? 'ലഘുഭക്ഷണങ്ങൾ' : 'TRADITIONAL SNACKS',
                                  description: isMalayalam ? 'പഴയകാല പലഹാരങ്ങൾ' : 'Crunchy, delicious snacks made with pure coconut oil.',
                                  imageUrl: 'https://images.unsplash.com/photo-1604152002577-fb18968987b7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 160),

                          // MASONRY GRID SECTION (Expanded to 12 items)
                          Padding(
                            key: _sectionKeys[3],
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              isMalayalam ? 'ഞങ്ങളുടെ ഉൽപ്പന്നങ്ങൾ കണ്ടെത്തുക' : 'DISCOVER OUR PRODUCTS',
                              style: const TextStyle(
                                color: AppColors.accentGold,
                                fontSize: 16,
                                letterSpacing: 4.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: MasonryGrid(
                              items: [
                                MasonryItemData(
                                  id: '1',
                                  img: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 400,
                                  title: isMalayalam ? 'കറുത്ത പൊന്ന് (കുരുമുളക്)' : 'Black Gold Pepper',
                                ),
                                MasonryItemData(
                                  id: '2',
                                  img: 'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 250,
                                  title: isMalayalam ? 'നാടൻ മാങ്ങാ അച്ചാർ' : 'Traditional Mango Pickle',
                                ),
                                MasonryItemData(
                                  id: '3',
                                  img: 'https://images.unsplash.com/photo-1587049352847-4d4b137a5be2?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 600,
                                  title: isMalayalam ? 'കാട്ടുതേൻ' : 'Wild Forest Honey',
                                ),
                                MasonryItemData(
                                  id: '4',
                                  img: 'https://images.unsplash.com/photo-1604152002577-fb18968987b7?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 350,
                                  title: isMalayalam ? 'ഏലക്ക' : 'Premium Cardamom',
                                ),
                                MasonryItemData(
                                  id: '5',
                                  img: 'https://images.unsplash.com/photo-1626200419109-382a8ee0b754?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 450,
                                  title: isMalayalam ? 'വെളിച്ചെണ്ണ' : 'Cold Pressed Coconut Oil',
                                ),
                                MasonryItemData(
                                  id: '6',
                                  img: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 300,
                                  title: isMalayalam ? 'പഴയകാല പലഹാരങ്ങൾ' : 'Authentic Snacks',
                                ),
                                MasonryItemData(
                                  id: '7',
                                  img: 'https://images.unsplash.com/photo-1599814420311-20925208f869?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 500,
                                  title: isMalayalam ? 'മഞ്ഞൾ പൊടി' : 'Pure Turmeric Powder',
                                ),
                                MasonryItemData(
                                  id: '8',
                                  img: 'https://images.unsplash.com/photo-1606850406839-fd0bc01cb698?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 300,
                                  title: isMalayalam ? 'കറുവാപ്പട്ട' : 'Ceylon Cinnamon',
                                ),
                                MasonryItemData(
                                  id: '9',
                                  img: 'https://images.unsplash.com/photo-1624681123447-3f3d793be81a?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 350,
                                  title: isMalayalam ? 'നാരങ്ങ അച്ചാർ' : 'Zesty Lemon Pickle',
                                ),
                                MasonryItemData(
                                  id: '10',
                                  img: 'https://images.unsplash.com/photo-1602081593539-75bdf4920215?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 450,
                                  title: isMalayalam ? 'ഗ്രാമ്പൂ' : 'Aromatic Cloves',
                                ),
                                MasonryItemData(
                                  id: '11',
                                  img: 'https://images.unsplash.com/photo-1628169904222-793db5f86f7b?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 250,
                                  title: isMalayalam ? 'വറുത്ത കശുവണ്ടി' : 'Roasted Cashews',
                                ),
                                MasonryItemData(
                                  id: '12',
                                  img: 'https://images.unsplash.com/photo-1564834724105-918b73d1b9e0?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                                  height: 550,
                                  title: isMalayalam ? 'ഉണക്കമുന്തിരി' : 'Premium Raisins',
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 120),
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
          );
        }
      ),
    );
  }

  Widget _buildCardSwap(bool isMalayalam, double size) {
    return CardSwap(
      width: size,
      height: size * 1.25,
      delay: const Duration(seconds: 5),
      onSwap: (index) {
        setState(() {
          _activeCardIndex = index;
        });
      },
      children: [
        _buildSwapCard(
          isMalayalam ? 'കർഷകരിൽ നിന്ന് നേരിട്ട്' : 'Direct Sourcing',
          'https://images.unsplash.com/photo-1596464716127-f2a82984de30?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Kerala fields
        ),
        _buildSwapCard(
          isMalayalam ? '100% ശുദ്ധം' : '100% Pure',
          'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Spices close up
        ),
        _buildSwapCard(
          isMalayalam ? 'ഗുണനിലവാര പരിശോധന' : 'Quality Verified',
          'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Lab/quality check feel
        ),
      ],
    );
  }

  Widget _buildDummyLogo(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.accentGold,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildSwapCard(String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.9),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(32),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
        ),
      ),
    );
  }
}
