import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hngstage3/home_page.dart';
import 'package:hngstage3/previewpage1.dart';
import 'package:hngstage3/previewpage2.dart';
import 'package:hngstage3/previewpage3.dart';
import 'package:hngstage3/previewpage4.dart';
import 'package:hngstage3/previewpage5.dart';
import 'package:hngstage3/previewpage6.dart' hide PreviewPage5;
import 'package:hngstage3/settings_page.dart';
import 'customicon.dart';
import 'drawer.dart';
import 'favourites_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _isDetailedList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ResponsiveAppBar(),
      ),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.orange.shade600,
                                Colors.red.shade400
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'Browse Categories',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Explore our curated collections of stunning wallpapers.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (MediaQuery.of(context).size.width > 600) {
                        return Row(
                          children: [
                            _buildViewIconButton(Icons.grid_view, !_isDetailedList,
                                    () {
                                  setState(() => _isDetailedList = false);
                                }),
                            const SizedBox(width: 8),
                            _buildViewIconButton(Icons.view_list, _isDetailedList,
                                    () {
                                  setState(() => _isDetailedList = true);
                                }),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth <= 600) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildViewIconButton(Icons.grid_view, !_isDetailedList,
                                () {
                              setState(() => _isDetailedList = false);
                            }),
                        const SizedBox(width: 8),
                        _buildViewIconButton(Icons.view_list, _isDetailedList,
                                () {
                              setState(() => _isDetailedList = true);
                            }),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isDesktop = constraints.maxWidth > 600;

                  if (isDesktop && !_isDetailedList) {
                    return buildDesktopGridView();
                  }

                  if (isDesktop && _isDetailedList) {
                    return buildDetailedListView();
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isDetailedList
                        ? buildDetailedListView()
                        : buildCardListView(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardListView() {
    return ListView.separated(
      key: const ValueKey('cardList'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryData.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final category = categoryData[index];
        return CategoryCard(
          height: 240,
          imagePath: category['imagePath'] as String,
          category: category['category'] as String,
          description: category['description'] as String,
          wallpaperCount: category['wallpaperCount'] as int,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => category['targetPage'] as Widget),
            );
          },
        );
      },
    );
  }

  Widget buildDetailedListView() {
    return ListView.separated(
      key: const ValueKey('detailedList'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryData.length,
      separatorBuilder: (context, index) =>
      const Divider(height: 32, color: Colors.black12),
      itemBuilder: (context, index) {
        final category = categoryData[index];
        return CategoryListItem(
          imagePath: category['imagePath'] as String,
          category: category['category'] as String,
          description: category['description'] as String,
          wallpaperCount: category['wallpaperCount'] as int,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => category['targetPage'] as Widget),
            );
          },
        );
      },
    );
  }

  Widget buildDesktopGridView() {
    return GridView.builder(
      key: const ValueKey('desktopGridView'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemCount: categoryData.length,
      itemBuilder: (context, index) {
        final category = categoryData[index];
        return CategoryCard(
          imagePath: category['imagePath'] as String,
          category: category['category'] as String,
          description: category['description'] as String,
          wallpaperCount: category['wallpaperCount'] as int,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => category['targetPage'] as Widget),
            );
          },
        );
      },
    );
  }

  Widget _buildViewIconButton(
      IconData icon, bool isActive, VoidCallback onPressed) {
    return IconButton(
      splashRadius: 20,
      icon: Icon(icon, color: isActive ? Colors.orange.shade700 : Colors.grey),
      onPressed: onPressed,
    );
  }
}

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({super.key});

  @override
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
            const Text('Wallpaper Studio',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ],
        ),
        actions: [
          _buildNavItem(context, 'Home', CustomIcon.home_icon),
          _buildNavItem(context, 'Browse', CustomIcon.browse_icon, isActive: true),
          _buildNavItem(context, 'Favourites', CustomIcon.heart_icon),
          _buildNavItem(context, 'Settings', CustomIcon.gearsix),
          const SizedBox(width: 20),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SvgPicture.asset("assets/icons.svg", height: 24),
            const SizedBox(width: 8),
            const Text('Wallpaper Studio',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ],
        ),
      );
    }
  }


  Widget _buildNavItem(BuildContext context, String title, IconData icon,
      {bool isActive = false}) {
    final color = isActive ? Colors.orange.shade700 : Colors.black87;return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton.icon(
        onPressed: () {
          if (title == 'Home') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
            );
          } else if (title == 'Favourites') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavouritesPage()),
            );
          } else if (title == 'Settings') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
        },
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
          backgroundColor: isActive ? Colors.orange.withOpacity(0.1) : Colors.transparent,
        ),
      ),
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class CategoryListItem extends StatelessWidget {
  final String imagePath;
  final String category;
  final String description;
  final int wallpaperCount;
  final VoidCallback onTap;

  const CategoryListItem({
    super.key,
    required this.imagePath,
    required this.category,
    required this.description,
    required this.wallpaperCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$wallpaperCount wallpapers',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String category;
  final String description;
  final int wallpaperCount;
  final double? height;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.description,
    required this.wallpaperCount,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
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
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.8)],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              stops: const [0.4, 1.0],
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white54, width: 1),
                ),
                child: Text(
                  '$wallpaperCount wallpapers',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, Object>> categoryData = [
  {
    'imagePath': 'assets/nature.jpeg',
    'category': 'Nature',
    'description': 'Mountains, Forest and Landscapes',
    'wallpaperCount': 7,
    'targetPage': const PreviewPage1(),
  },
  {
    'imagePath': 'assets/abstract.jpeg',
    'category': 'Abstract',
    'description': 'Modern Geometric and artistic designs',
    'wallpaperCount': 1,
    'targetPage': const PreviewPage2(),
  },
  {
    'imagePath': 'assets/urban.jpeg',
    'category': 'Urban',
    'description': 'Cities, architecture and street',
    'wallpaperCount': 1,
    'targetPage': const PreviewPage3(),
  },
  {
    'imagePath': 'assets/comos.jpeg',
    'category': 'Space',
    'description': 'Cosmos, planets, and galaxies',
    'wallpaperCount': 1,
    'targetPage': const PreviewPage4(),
  },
  {
    'imagePath': 'assets/coffee.jpeg',
    'category': 'Minimalist',
    'description': 'Clean, simple, and elegant',
    'wallpaperCount': 1,
    'targetPage': const PreviewPage5(),
  },
  {
    'imagePath': 'assets/fox.jpeg',
    'category': 'Animals',
    'description': 'Wildlife and nature photography',
    'wallpaperCount': 1,
    'targetPage': const PreviewPage6(),
  },
];
