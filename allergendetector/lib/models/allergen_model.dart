class AllergenCategory {
  final String name;
  final List<String> items;

  AllergenCategory({required this.name, required this.items});

  factory AllergenCategory.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List).cast<String>();

    return AllergenCategory(
      name: json['name'] ?? '',
      items: items,
    );
  }
}

class AllergenData {
  final List<AllergenCategory> categories;

  AllergenData({required this.categories});

  factory AllergenData.fromJson(Map<String, dynamic> json) {
    final categories = (json['categories'] as List)
        .map((category) => AllergenCategory.fromJson(category))
        .toList();

    return AllergenData(categories: categories);
  }

  // Get all allergens as a flat list
  List<String> getAllAllergens() {
    return categories.expand((category) => category.items).toList();
  }
}