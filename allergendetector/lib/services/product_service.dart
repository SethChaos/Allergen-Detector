import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'https://world.openfoodfacts.org/api/v2/product';

  Future<Map<String, dynamic>?> getProductByBarcode(String barcode) async {
    try {
      final cleanBarcode = barcode.replaceAll(RegExp(r'[^0-9]'), '');

      if (cleanBarcode.isEmpty || cleanBarcode.length < 8) {
        throw Exception('Invalid barcode: $barcode');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/$cleanBarcode.json'),
        headers: {
          'User-Agent': 'AllergenDetector/1.0 (Android)',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          return data['product'] as Map<String, dynamic>;
        } else {
          return null;
        }
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }
}