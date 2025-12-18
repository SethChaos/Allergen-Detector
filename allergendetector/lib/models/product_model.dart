class Product {
  final String barcode;
  final String name;
  final String brand;
  final String? imageUrl;
  final List<String> ingredients;
  final DateTime? lastModified;

  Product({
    required this.barcode,
    required this.name,
    required this.brand,
    this.imageUrl,
    required this.ingredients,
    this.lastModified,
  });

  factory Product.fromJson(String barcode, Map<String, dynamic> json) {
    return Product(
      barcode: barcode,
      name: json['product_name']?.toString() ?? 'Unknown Product',
      brand: json['brands']?.toString() ?? 'Unknown Brand',
      imageUrl: json['image_url']?.toString(),
      ingredients: _parseIngredients(json),
      lastModified: json['last_modified_t'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['last_modified_t'] * 1000)
          : null,
    );
  }

  static List<String> _parseIngredients(Map<String, dynamic> json) {
    final ingredients = <String>{};

    if (json['ingredients_text'] != null) {
      final text = json['ingredients_text'].toString().toLowerCase();
      final parts = text.split(RegExp(r'[,;()\.\[\]]'));
      for (var part in parts) {
        final trimmed = part.trim();
        if (trimmed.isNotEmpty && trimmed.length > 2) {
          ingredients.add(trimmed);
        }
      }
    }

    if (json['allergens_tags'] != null) {
      final tags = List<String>.from(json['allergens_tags']);
      for (var tag in tags) {
        if (tag.contains(':')) {
          final allergen = tag.split(':')[1].replaceAll('-', ' ');
          ingredients.add(allergen);
        }
      }
    }

    if (json['allergens'] != null) {
      final allergens = json['allergens'].toString().toLowerCase();
      ingredients.add(allergens);
    }

    if (json['traces'] != null) {
      final traces = json['traces'].toString().toLowerCase();
      ingredients.add('may contain: $traces');
    }

    return ingredients.toList();
  }
}