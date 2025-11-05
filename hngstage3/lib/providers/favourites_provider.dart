import 'package:flutter/material.dart';
import 'package:hngstage3/models/wallpaper_model.dart';
class FavoritesProvider with ChangeNotifier {
  final List<Wallpaper> _favoriteWallpapers = [];

  List<Wallpaper> get favoriteWallpapers => _favoriteWallpapers;

  bool isFavorite(Wallpaper wallpaper) {
    return _favoriteWallpapers.any((item) => item.id == wallpaper.id);
  }

  void toggleFavorite(Wallpaper wallpaper) {
    if (isFavorite(wallpaper)) {
      _favoriteWallpapers.removeWhere((item) => item.id == wallpaper.id);
      wallpaper.isFavorite = false;
    } else {
      _favoriteWallpapers.add(wallpaper);
      wallpaper.isFavorite = true;
    }
    notifyListeners();
  }
}
