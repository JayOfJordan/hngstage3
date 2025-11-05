import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hngstage3/categories.dart';
import 'package:hngstage3/customicon.dart';
import 'package:hngstage3/drawer.dart';
import 'package:hngstage3/favourites_page.dart';
import 'package:hngstage3/settings_page.dart';
import 'package:hngstage3/previewpage1.dart';
import 'package:hngstage3/previewpage2.dart';
import 'package:hngstage3/previewpage3.dart';
import 'package:hngstage3/previewpage4.dart';
import 'package:hngstage3/previewpage5.dart';
import 'package:hngstage3/previewpage6.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return const ResponsiveAppBar();
            } else {
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
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black87),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0)
            : const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [Colors.orange, Colors.red.shade400],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: const Text(
                'Discover Beautiful Wallpapers',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover curated collections of stunning wallpapers. Browse by category, '
                  'preview in full-screen, and set your favorites.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoriesPage()),
                    );
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: categoryData.map((category) {
                    double itemWidth;
                    const double spacing = 20.0;

                    if (constraints.maxWidth > 1200) {
                      itemWidth = (constraints.maxWidth - (2 * spacing)) / 3;
                    } else if (constraints.maxWidth > 600) {
                      itemWidth = (constraints.maxWidth - spacing) / 2;
                    } else {
                      itemWidth = constraints.maxWidth;
                    }

                    return CategoryCard(
                      imagePath: category['imagePath'] as String,
                      category: category['category'] as String,
                      description: category['description'] as String,
                      wallpaperCount: category['wallpaperCount'] as int,
                      width: itemWidth,
                      height: 250,
                      onTap: () =>
                          _navigateToPreviewPage(context, category['category'] as String),
                    );
                  }).toList(),
                );
              },
            )

          ],
        ),
      ),
    );
  }

  void _navigateToPreviewPage(BuildContext context, String category) {
    Widget page;
    switch (category) {
      case 'Nature':
        page = const PreviewPage1();
        break;
      case 'Abstract':
        page = const PreviewPage2();
        break;

      case 'Urban':
        page = const PreviewPage3();
        break;
      case 'Space':
        page = const PreviewPage4();
        break;
      case 'Minimalist':
        page = const PreviewPage5();
        break;
      case 'Animals':
        page = const PreviewPage6();
        break;
      default:
        page = const CategoriesPage();
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}


final List<Map<String, Object>> categoryData = [
  {
    'imagePath': 'assets/nature.jpeg',
    'category': 'Nature',
    'description': 'Mountains, Forest and Landscapes',
    'wallpaperCount': 7,
  },
  {
    'imagePath': 'assets/abstract.jpeg',
    'category': 'Abstract',
    'description': 'Modern Geometric and artistic designs',
    'wallpaperCount': 1,
  },
  {
    'imagePath': 'assets/urban.jpeg',
    'category': 'Urban',
    'description': 'Cities, architecture and street',
    'wallpaperCount': 1,
  },
  {
    'imagePath': 'assets/comos.jpeg',
    'category': 'Space',
    'description': 'Cosmos, planets and galaxies',
    'wallpaperCount': 1,
  },
  {
    'imagePath': 'assets/coffee.jpeg',
    'category': 'Minimalist',
    'description': 'Clean, simple, and elegant',
    'wallpaperCount': 1,
  },
  {
    'imagePath': 'assets/fox.jpeg',
    'category': 'Animals',
    'description': 'Wildlife and nature photography',
    'wallpaperCount': 1,
  },
];

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
        _buildNavItem(
          context,
          'Home',
          CustomIcon.home_icon,
              () {
          },
          isActive: true,
        ),
        _buildNavItem(
          context,
          'Browse',
          CustomIcon.browse_icon,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoriesPage()),
            );
          },
        ),
        _buildNavItem(
          context,
          'Favourites',
          CustomIcon.heart_icon,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavouritesPage()),
            );
          },
        ),
        _buildNavItem(
          context,
          'Settings',
          CustomIcon.gearsix,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon,
      VoidCallback onPressed, {bool isActive = false}) {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // Apply active style
          backgroundColor:
          isActive ? Colors.orange.withOpacity(0.1) : Colors.transparent,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String category;
  final String description;
  final int wallpaperCount;
  final double? height;
  final double? width;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.description,
    required this.wallpaperCount,
    required this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
                Colors.black.withOpacity(0.8)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white54, width: 1),
                ),
                child: Text(
                  '$wallpaperCount wallpapers',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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
