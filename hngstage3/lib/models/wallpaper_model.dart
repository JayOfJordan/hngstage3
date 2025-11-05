// This class is now the single source of truth for the Wallpaper model.
class Wallpaper {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final String description;
  final List<String> tags;
  bool isFavorite;

  Wallpaper({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.tags,
    this.isFavorite = false,
  });
}
