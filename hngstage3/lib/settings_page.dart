import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hngstage3/categories.dart';
import 'package:hngstage3/customicon.dart';
import 'package:hngstage3/drawer.dart';
import 'package:hngstage3/favourites_page.dart';
import 'package:hngstage3/home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedQuality = 'High';
  bool _notificationsEnabled = true;

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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;
            return Column(
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
                    'Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Customize your Wallpaper Studio experience',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 32),
                if (isDesktop)
                  _buildDesktopLayout()
                else
                  _buildMobileLayout(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: _buildSettingsCard(),
        ),
        const SizedBox(width: 40),
        const Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: PhoneMockup(),
          ),
        ),
      ],
    );
  }
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildSettingsCard(),
        const SizedBox(height: 40),
        const PhoneMockup(),
      ],
    );
  }

  Widget _buildSettingsCard() {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wallpaper Setup',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Configure your wallpaper settings and enable auto-rotation',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 32),
          const Text(
            'Image Quality',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          _buildDropdown(),
          const SizedBox(height: 24),
          _buildNotificationSwitch(),
          const SizedBox(height: 40),
          _buildActionButtons(isDesktop: isDesktop),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedQuality,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          onChanged: (String? newValue) {
            setState(() {
              _selectedQuality = newValue!;
            });
          },
          items: <String>['High', 'Medium', 'Low']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value == 'High'
                    ? 'High (Best Quality)'
                    : value,
                style: const TextStyle(color: Colors.black87),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Get notified about new wallpapers and updates',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeTrackColor: Colors.orange.shade400,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: MaterialStateProperty.all(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({required bool isDesktop}) {
    final buttonTextStyle = TextStyle(
      fontSize: isDesktop ? 15 : 20,
      fontWeight: FontWeight.bold,
    );
    const buttonPadding = EdgeInsets.symmetric(vertical: 16);

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    );
    if (isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: buttonShape,
            ),
            child: Text('Cancel', style: TextStyle(color: Colors.black, fontSize: buttonTextStyle.fontSize)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: buttonShape,
            ),
            child: Text('Save Settings', style: buttonTextStyle),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: buttonPadding,
              side: BorderSide(color: Colors.grey.shade300),
              shape: buttonShape,
            ),
            child: Text('Cancel', style: buttonTextStyle.copyWith(color: Colors.black)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: buttonPadding,
              shape: buttonShape,
            ),
            child: Text('Save Settings', style: buttonTextStyle),
          ),
        ],
      );
    }
  }
}


class PhoneMockup extends StatelessWidget {const PhoneMockup({super.key});

@override
Widget build(BuildContext context) {
  return Center(
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 420,
          width: 210,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 4),
            borderRadius: BorderRadius.circular(40),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Container(
              color: Colors.white,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.green.shade600),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.link, color: Colors.green.shade800, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Connected to device',
                                style: TextStyle(
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Click to disconnect',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 20,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Container(
                      height: 4,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: -3,
          top: 120,
          child: Container(
            height: 50,
            width: 3,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Positioned(
          left: -3,
          top: 75,
          child: Container(
            height: 20,
            width: 3,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Positioned(
          left: -3,
          top: 110,
          child: Container(
            height: 35,
            width: 3,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Positioned(
          left: -3,
          top: 150,
          child: Container(
            height: 35,
            width: 3,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    ),
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
          _buildNavItem(context, 'Favourites', CustomIcon.heart_icon, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavouritesPage()),
            );
          }),
          _buildNavItem(
            context,
            'Settings',
            CustomIcon.gearsix,
                () {},
            isActive: true,
          ),
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
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onPressed, {
        bool isActive = false,
      }) {
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
