import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/allergen_model.dart';

class AllergenService {
  Future<AllergenData> loadAllergens() async {
    try {
      final jsonString = await rootBundle.loadString('assets/allergens.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return AllergenData.fromJson(jsonData);
    } catch (e) {
      print('Error loading allergens: $e');
      return _getDefaultAllergenData();
    }
  }

  AllergenData _getDefaultAllergenData() {
    return AllergenData(categories: [
      AllergenCategory(
        name: 'Common Allergens',
        items: ['Milk', 'Eggs', 'Peanuts', 'Tree Nuts', 'Soy', 'Wheat', 'Fish', 'Shellfish'],
      ),
    ]);
  }
}