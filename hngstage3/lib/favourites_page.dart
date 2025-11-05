import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hngstage3/categories.dart';
import 'package:hngstage3/customicon.dart';
import 'package:hngstage3/drawer.dart';
import 'package:hngstage3/home_page.dart';
import 'package:hngstage3/models/wallpaper_model.dart';
import 'package:hngstage3/providers/favourites_provider.dart';
import 'package:hngstage3/settings_page.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final savedWallpapers = favoritesProvider.favoriteWallpapers;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ResponsiveAppBar(),
      ),
      endDrawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [Colors.orange.shade600, Colors.red.shade400],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: const Text(
                'Saved Wallpapers',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your saved wallpapers collection',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: savedWallpapers.isEmpty
                  ? const EmptyFavoritesView()
                  : WallpaperGridView(wallpapers: savedWallpapers),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyFavoritesView extends StatelessWidget {
  const EmptyFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/nosaved.svg',
            width: isDesktop ? 150 : 120,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Saved Wallpapers',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start saving your favorite wallpapers to see them here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade400,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Browse Wallpapers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class WallpaperGridView extends StatelessWidget {
  final List<Wallpaper> wallpapers;
  const WallpaperGridView({super.key, required this.wallpapers});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 6 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: wallpapers.length,
      itemBuilder: (context, index) {
        final wallpaper = wallpapers[index];
        return WallpaperGridItem(
          wallpaper: wallpaper,
          onTap: () {},
        );
      },
    );
  }
}
class WallpaperGridItem extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback onTap;

  const WallpaperGridItem({
    super.key,
    required this.wallpaper,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              wallpaper.imagePath,
              fit: BoxFit.cover,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                ),
              ),
            ),

            // Favorite Icon
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  favoritesProvider.toggleFavorite(wallpaper);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.orange,
                    size: 18,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallpaper.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 2.0, color: Colors.black45)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      wallpaper.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({super.key});@override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    if (isDesktop) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset("assets/icons.svg"),
            ),
            const SizedBox(width: 8),
            const Text(
              'Wallpaper Studio',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          _buildNavItem(context, 'Home', CustomIcon.home_icon, () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          }),
          _buildNavItem(context, 'Browse', CustomIcon.browse_icon, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoriesPage()),
            );
          }),
          _buildNavItem(
            context,
            'Favourites',
            CustomIcon.heart_icon,
                () {
            },
            isActive: true,
          ),
          _buildNavItem(context, 'Settings', CustomIcon.gearsix, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }),
          const SizedBox(width: 20),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SvgPicture.asset("assets/icons.svg", height: 24),
            const SizedBox(width: 8),
            const Text(
              'Wallpaper Studio',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ],
      );
    }
  }

  Widget _buildNavItem(
      BuildContext context, String title, IconData icon, VoidCallback onPressed,
      {bool isActive = false}) {
    final color = isActive ? Colors.orange.shade700 : Colors.black87;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20),
        label: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor:
          isActive ? Colors.orange.withOpacity(0.1) : Colors.transparent,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

