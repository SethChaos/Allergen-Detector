import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/product_model.dart';
import 'services/product_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String? scannedBarcode;
  String? scanError;
  bool isLoading = false;
  bool isFetchingProduct = false;
  Product? currentProduct;
  String? productError;
  List<String> detectedAllergens = [];
  List<String> userAllergies = [];

  @override
  void initState() {
    super.initState();
    _loadUserAllergies();
  }

  Future<void> _loadUserAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    final allergies = prefs.getStringList('userAllergies') ?? [];
    if (mounted) {
      setState(() {
        userAllergies = allergies;
      });
    }
  }

  Future<void> _scanBarcode() async {
    setState(() {
      isLoading = true;
      scanError = null;
      scannedBarcode = null;
      currentProduct = null;
      productError = null;
      detectedAllergens = [];
    });

    try {
      // Simple scan without complex options
      final result = await BarcodeScanner.scan();

      if (!mounted) return;

      final barcode = result.rawContent;

      // Fixed: Remove unnecessary ?.
      if (barcode.isEmpty) {
        setState(() {
          isLoading = false;
          scanError = 'No barcode detected. Please try again.';
        });
        return;
      }

      setState(() {
        scannedBarcode = barcode;
      });

      await _fetchProductData(barcode);

    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        if (e.toString().contains('PERMISSION_NOT_GRANTED')) {
          scanError = 'Camera permission required.';
        } else {
          scanError = 'Scan failed: ${e.toString()}';
        }
      });
    }
  }

  Future<void> _fetchProductData(String barcode) async {
    setState(() {
      isFetchingProduct = true;
      productError = null;
    });

    try {
      final service = ProductService();
      final productData = await service.getProductByBarcode(barcode);

      if (!mounted) return;

      if (productData != null) {
        final product = Product.fromJson(barcode, productData);

        setState(() {
          currentProduct = product;
          isFetchingProduct = false;
          isLoading = false;
        });

        await _checkForAllergens(product);
      } else {
        setState(() {
          productError = 'Product not found in database.';
          isFetchingProduct = false;
          isLoading = false;
        });
      }

    } catch (e) {
      if (!mounted) return;

      setState(() {
        productError = 'Failed to fetch product: $e';
        isFetchingProduct = false;
        isLoading = false;
      });
    }
  }

  Future<void> _checkForAllergens(Product product) async {
    final detected = <String>{};

    for (final allergy in userAllergies) {
      final allergyLower = allergy.toLowerCase();

      for (final ingredient in product.ingredients) {
        final ingredientLower = ingredient.toLowerCase();

        if (ingredientLower.contains(allergyLower)) {
          detected.add(allergy);
          break;
        }
      }
    }

    if (mounted) {
      setState(() {
        detectedAllergens = detected.toList();
      });
    }
  }

  void _clearScan() {
    setState(() {
      scannedBarcode = null;
      scanError = null;
      currentProduct = null;
      productError = null;
      detectedAllergens = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
        actions: [
          if (scannedBarcode != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearScan,
              tooltip: 'Clear Scan',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Scan Button
            ElevatedButton(
              onPressed: isLoading ? null : _scanBarcode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 60),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'SCAN BARCODE',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Loading State
            if (isFetchingProduct)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Looking up product...'),
                  if (scannedBarcode != null)
                    Text(
                      'Barcode: $scannedBarcode',
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                ],
              ),

            // Errors
            if (scanError != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        scanError!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _scanBarcode,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),

            if (productError != null)
              Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        productError!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _scanBarcode,
                        child: const Text('Try Another'),
                      ),
                    ],
                  ),
                ),
              ),

            // Product Info
            if (currentProduct != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: detectedAllergens.isEmpty
                        ? Colors.green[50]
                        : Colors.orange[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (currentProduct!.imageUrl != null)
                                Image.network(
                                  currentProduct!.imageUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                                ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentProduct!.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(currentProduct!.brand),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: detectedAllergens.isEmpty
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            detectedAllergens.isEmpty
                                                ? Icons.check_circle
                                                : Icons.warning,
                                            color: detectedAllergens.isEmpty
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              detectedAllergens.isEmpty
                                                  ? 'No allergens detected'
                                                  : 'Contains: ${detectedAllergens.join(", ")}',
                                              style: TextStyle(
                                                color: detectedAllergens.isEmpty
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ingredients:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(currentProduct!.ingredients.join(', ')),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _scanBarcode,
                            child: const Text('Scan Another Product'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else if (!isLoading && !isFetchingProduct && scannedBarcode == null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey),
                      const SizedBox(height: 20),
                      const Text(
                        'Scan a product barcode',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Point camera at any product barcode',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}