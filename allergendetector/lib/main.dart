import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scanner_screen.dart';
import 'services/allergen_service.dart';
import 'models/allergen_model.dart';

void main() {
  runApp(const AllergenDetectorApp());
}

class AllergenDetectorApp extends StatefulWidget {
  const AllergenDetectorApp({super.key});

  @override
  State<AllergenDetectorApp> createState() => _AllergenDetectorAppState();
}

class _AllergenDetectorAppState extends State<AllergenDetectorApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AllergyProfileScreen(),
    const ScannerScreen(),
  ];

  final List<String> _appBarTitles = [
    'Allergy Profile',
    'Scan Product',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allergen Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitles[_selectedIndex]),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Scan',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class AllergyProfileScreen extends StatefulWidget {
  const AllergyProfileScreen({super.key});

  @override
  State<AllergyProfileScreen> createState() => _AllergyProfileScreenState();
}

class _AllergyProfileScreenState extends State<AllergyProfileScreen> {
  Set<String> selectedAllergies = {};
  final TextEditingController _customAllergyController = TextEditingController();
  List<AllergenCategory> allergenCategories = [];
  bool isLoadingAllergens = true;

  @override
  void initState() {
    super.initState();
    _loadAllergies();
    _loadAllergenData();
  }

  Future<void> _loadAllergenData() async {
    final service = AllergenService();
    final allergenData = await service.loadAllergens();

    if (!mounted) return;

    setState(() {
      allergenCategories = allergenData.categories;
      isLoadingAllergens = false;
    });
  }

  Future<void> _loadAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAllergies = prefs.getStringList('userAllergies') ?? [];

    if (!mounted) return;

    setState(() {
      selectedAllergies = savedAllergies.toSet();
    });
  }

  Future<void> _saveAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('userAllergies', selectedAllergies.toList());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Allergies saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (selectedAllergies.contains(allergy)) {
        selectedAllergies.remove(allergy);
      } else {
        selectedAllergies.add(allergy);
      }
    });
  }

  void _addCustomAllergy() {
    final allergy = _customAllergyController.text.trim();
    if (allergy.isNotEmpty && !selectedAllergies.contains(allergy)) {
      setState(() {
        selectedAllergies.add(allergy);
        _customAllergyController.clear();
      });
    }
  }

  void _removeAllergy(String allergy) {
    setState(() {
      selectedAllergies.remove(allergy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Allergies
            const Text(
              'Your Allergies:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            selectedAllergies.isEmpty
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No allergies selected. Add some below.',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedAllergies.map((allergy) {
                return Chip(
                  label: Text(allergy),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => _removeAllergy(allergy),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Custom Allergy Input
            const Text(
              'Add Custom Allergy:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customAllergyController,
                    decoration: const InputDecoration(
                      hintText: 'Enter an allergy (e.g., Latex)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addCustomAllergy(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCustomAllergy,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Allergens from JSON
            const Text(
              'Select Allergens:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Tap to select/deselect:'),
            const SizedBox(height: 12),

            isLoadingAllergens
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: allergenCategories.length,
                itemBuilder: (context, categoryIndex) {
                  final category = allergenCategories[categoryIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: category.items.map((allergen) {
                          final isSelected = selectedAllergies.contains(allergen);
                          return FilterChip(
                            label: Text(allergen),
                            selected: isSelected,
                            onSelected: (_) => _toggleAllergy(allergen),
                            backgroundColor: isSelected
                                ? Colors.blue.withAlpha(40)
                                : null,
                            selectedColor: Colors.blue[100],
                            checkmarkColor: Colors.blue[800],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAllergies,
        tooltip: 'Save Allergies',
        child: const Icon(Icons.save),
      ),
    );
  }
}