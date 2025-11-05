import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hngstage3/categories.dart';
import 'package:hngstage3/providers/favourites_provider.dart';
import 'package:hngstage3/setup_page.dart';
import 'customicon.dart';
import 'drawer.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:hngstage3/models/wallpaper_model.dart';

void showWallpaperSetupSheet(BuildContext context, Wallpaper wallpaper) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isDesktop = screenWidth > 800;

  if (isDesktop) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Setup',
      pageBuilder: (ctx, a1, a2) => Container(),
      transitionDuration: const Duration(milliseconds: 300),
      barrierColor: Colors.black.withOpacity(0.0),
      transitionBuilder: (ctx, a1, a2, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero);
        final curve = Curves.easeInOut;
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),
            ),
            SlideTransition(
              position: tween.animate(CurvedAnimation(parent: a1, curve: curve)),
              child: Align(
                alignment: Alignment.centerRight,
                child: Material(
                  elevation: 16.0,
                  child: Container(
                    color: Colors.white,
                    width: screenWidth * 0.40,
                    height: double.infinity,
                    child: WallpaperSetupSheet(wallpaper: wallpaper),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  } else {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                ),
                child: WallpaperSetupSheet(wallpaper: wallpaper),
              );
            },
          ),
        );
      },
    );
  }
}

class PreviewPage6 extends StatefulWidget {
  const PreviewPage6({super.key});

  @override
  State<PreviewPage6> createState() => _PreviewPage6State();
}

class _PreviewPage6State extends State<PreviewPage6> {
  final List<Wallpaper> _wallpapers = [
    Wallpaper(
      id: 'animal_1',
      name: 'Red Fox',
      category: 'Animal',
      imagePath: 'assets/fox.jpeg',
      description: 'A beautiful red fox sits attentively in a vibrant, grassy field, its sharp eyes focused and alert.',
      tags: ['Fox', 'Wildlife', 'Mammal', 'Nature', 'Cute'],
    ),

  ];

  late Wallpaper _selectedWallpaper;

  @override
  void initState() {
    super.initState();
    _selectedWallpaper = _wallpapers.first;
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    for (var wallpaper in _wallpapers) {
      if (favoritesProvider.isFavorite(wallpaper)) {
        wallpaper.isFavorite = true;
      }
    }
  }

  void _onWallpaperSelected(Wallpaper wallpaper) {
    setState(() {
      _selectedWallpaper = wallpaper;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return const ResponsiveAppBar();
            } else {
              return AppBar(
                backgroundColor: const Color(0xFFF8F8F8),
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    SvgPicture.asset("assets/icons.svg", height: 24),
                    const SizedBox(width: 8),
                    const Text('Wallpaper Studio', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22)),
                  ],
                ),
              );
            }
          },
        ),
      ),
      endDrawer: const AppDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: WallpaperGrid(
              wallpapers: _wallpapers,
              selectedWallpaper: _selectedWallpaper,
              onWallpaperSelected: _onWallpaperSelected,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 5,
            child: PreviewSection(
              key: ValueKey(_selectedWallpaper.id),
              wallpaper: _selectedWallpaper,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return WallpaperGrid(
      wallpapers: _wallpapers,
      selectedWallpaper: _selectedWallpaper,
      onWallpaperSelected: (wallpaper) {
        _onWallpaperSelected(wallpaper);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: PreviewSection(wallpaper: wallpaper),
            ),
          ),
        );
      },
    );
  }
}

class WallpaperGrid extends StatelessWidget {
  final List<Wallpaper> wallpapers;
  final Wallpaper selectedWallpaper;
  final Function(Wallpaper) onWallpaperSelected;

  const WallpaperGrid({
    super.key,
    required this.wallpapers,
    required this.selectedWallpaper,
    required this.onWallpaperSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;
    final crossAxisCount = isMobile ? 2 : 3;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesPage()),
                    (Route<dynamic> route) => false,
              ),
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              label: const Text('Back to Categories', style: TextStyle(color: Colors.black54, fontSize: 16)),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 0)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Animal', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                Icon(CustomIcon.grid_view, color: Colors.orange),
                const SizedBox(width: 8),
                Icon(CustomIcon.list_view, color: Colors.grey.shade600),
              ],
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                final wallpaper = wallpapers[index];
                return WallpaperGridItem(
                  wallpaper: wallpaper,
                  isSelected: wallpaper.id == selectedWallpaper.id,
                  onTap: () => onWallpaperSelected(wallpaper),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WallpaperGridItem extends StatelessWidget {
  final Wallpaper wallpaper;
  final bool isSelected;
  final VoidCallback onTap;

  const WallpaperGridItem({
    super.key,
    required this.wallpaper,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // FIX: Listen to the provider to get the favorite status
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isCurrentlyFavorite = favoritesProvider.isFavorite(wallpaper);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.orange, width: 3) : null,
          image: DecorationImage(image: AssetImage(wallpaper.imagePath), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  // FIX: Call the provider's toggle method
                  favoritesProvider.toggleFavorite(wallpaper);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.4),
                  radius: 16,
                  child: Icon(
                    // FIX: Use the state from the provider to set the icon
                    isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isCurrentlyFavorite ? Colors.orange : Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallpaper.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, shadows: [Shadow(blurRadius: 2.0, color: Colors.black45)]),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.19),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(wallpaper.category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreviewSection extends StatelessWidget {
  final Wallpaper wallpaper;

  const PreviewSection({
    super.key,
    required this.wallpaper,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isDesktop ? BorderRadius.circular(20) : const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 5, blurRadius: 15)],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isDesktop) const SizedBox(height: 30),
                if (isDesktop)
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: _buildDetailsColumn(context, isDesktop: true)),
                          const SizedBox(width: 24),
                          Expanded(flex: 3, child: _buildPhoneMockup()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildFooterButtons(context, isDesktop: true),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPhoneMockup(),
                      const SizedBox(height: 24),
                      const Text('Preview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 24),
                      _buildDetailsColumn(context, isDesktop: false),
                    ],
                  )
              ],
            ),
          ),
          if (!isDesktop)
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                  child: const Icon(CustomIcon.XCircle, color: Colors.orange, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhoneMockup() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 420,
            width: 210,
            decoration: BoxDecoration(border: Border.all(color: Colors.black87, width: 4), borderRadius: BorderRadius.circular(40)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(wallpaper.imagePath, fit: BoxFit.cover, height: double.infinity, width: double.infinity),
                      Container(margin: const EdgeInsets.only(bottom: 10), height: 3, width: 90, decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(10))),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 20,
                    width: 75,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                    child: Align(alignment: Alignment.centerRight, child: Padding(padding: const EdgeInsets.only(right: 8.0), child: Container(height: 8, width: 8, decoration: BoxDecoration(color: Colors.grey.shade800, shape: BoxShape.circle)))),
                  ),
                ],
              ),
            ),
          ),
          Positioned(right: -3, top: 120, child: Container(height: 50, width: 3, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
          Positioned(left: -3, top: 75, child: Container(height: 20, width: 3, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
          Positioned(left: -3, top: 110, child: Container(height: 35, width: 3, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
          Positioned(left: -3, top: 150, child: Container(height: 35, width: 3, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
        ],
      ),
    );
  }

  Widget _buildDetailsColumn(BuildContext context, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop) const Text('Preview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
        if (isDesktop) const SizedBox(height: 25),
        const Text('Name', style: TextStyle(color: Colors.grey)),
        Text(wallpaper.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Text('Tags', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: wallpaper.tags.map((tag) => Chip(
            label: Text(tag),
            backgroundColor: Colors.grey.shade100,
            labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade200)),
          )).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Description', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(wallpaper.description, style: const TextStyle(color: Colors.black54, height: 1.5)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.start,
          children: [
            _buildActionButton(CustomIcon.share),
            const SizedBox(width: 16),
            _buildActionButton(CustomIcon.set),
            const SizedBox(width: 16),
            _buildActionButton(CustomIcon.setting),
          ],
        ),
        if (!isDesktop) const SizedBox(height: 32),
        if (!isDesktop) _buildFooterButtons(context, isDesktop: false),
      ],
    );
  }

  Widget _buildFooterButtons(BuildContext context, {required bool isDesktop}) {
    // FIX: Listen to the provider to get the current state and the toggle function
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isCurrentlyFavorite = favoritesProvider.isFavorite(wallpaper);

    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            child: TextButton.icon(
              // FIX: Added the onPressed functionality for the desktop button
              onPressed: () {
                // Call the provider's toggle method
                favoritesProvider.toggleFavorite(wallpaper);
              },
              icon: Icon(
                // Use the state from the provider to set the icon
                isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                color: isCurrentlyFavorite ? Colors.orange : Colors.black,
                size: 25,
              ),
              label: const Text('Save to Favorites', style: TextStyle(color: Colors.black, fontSize: 15)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => showWallpaperSetupSheet(context, wallpaper),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Text('Set to Wallpaper', style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ),
        ],
      );
    } else {
      // Mobile view (already correct)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            onPressed: () {
              // Call the provider's toggle method
              favoritesProvider.toggleFavorite(wallpaper);
            },
            icon: Icon(
              // Use state from provider to set the icon
              isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
              color: isCurrentlyFavorite ? Colors.orange : Colors.black,
              size: 25,
            ),
            label: const Text('Save to Favorites', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => showWallpaperSetupSheet(context, wallpaper),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: const Text('Set to Wallpaper', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ],
      );
    }
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 20, color: Colors.grey.shade700),
    );
  }
}

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F8F8),
      elevation: 0,
      title: Row(
        children: [
          SvgPicture.asset("assets/icons.svg", height: 24),
          const SizedBox(width: 8),
          const Text('Wallpaper Studio', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22)),
        ],
      ),
      actions: [
        _buildNavItem(context, 'Home', CustomIcon.home_icon),
        _buildNavItem(context, 'Browse', CustomIcon.browse_icon, isActive: true),
        _buildNavItem(context, 'Favourites', CustomIcon.heart_icon),
        _buildNavItem(context, 'Settings', CustomIcon.gearsix),
        const SizedBox(width: 20),
      ],
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, {bool isActive = false}) {
    final color = isActive ? Colors.orange.shade700 : Colors.black87;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton.icon(
        onPressed: () {
          if (title == 'Home') {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
          if (title == 'Browse') Navigator.pop(context);
        },
        icon: Icon(icon, color: color, size: 20),
        label: Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: isActive ? Colors.orange.withOpacity(0.1) : Colors.transparent,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
