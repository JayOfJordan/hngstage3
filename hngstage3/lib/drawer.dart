import 'package:flutter/material.dart';

import 'package:hngstage3/categories.dart';
import 'package:hngstage3/customicon.dart';
import 'package:hngstage3/home_page.dart';
import 'package:hngstage3/settings_page.dart';

import 'favourites_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          _createDrawerItem(
              icon: CustomIcon.home_icon,
              text: 'Home',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }),
          const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          _createDrawerItem(
              icon: CustomIcon.browse_icon,
              text: 'Browse',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriesPage()),
                );
              }),
          const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          _createDrawerItem(
              icon: CustomIcon.heart_icon, text: 'Favourites', onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FavouritesPage()),
            );
          }),
          const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          _createDrawerItem(
              icon: CustomIcon.gearsix, text: 'Settings', onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }),
          const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
        required String text,
        required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(
          text,
          style: const TextStyle(
              color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }
}
