import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scanner_screen.dart';

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
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitles[_selectedIndex]),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
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
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: 13,
          unselectedFontSize: 13,
          elevation: 8,
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
  final List<String> commonAllergens = [
    'Milk',
    'Eggs',
    'Peanuts',
    'Tree Nuts',
    'Soy',
    'Wheat',
    'Fish',
    'Shellfish',
    'Gluten',
    'Sesame',
    'Mustard',
    'Celery',
    'Sulfites',
    'Lupin',
    'Lactose',
    'Casein',
    'Whey',
    'Albumin',
  ];

  Set<String> selectedAllergies = {};
  final TextEditingController _customAllergyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllergies();
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
        backgroundColor: Colors.green,
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
      FocusManager.instance.primaryFocus?.unfocus();
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
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Allergies',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These will be checked when scanning products:',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    selectedAllergies.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No allergies selected yet',
                        style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
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
                          backgroundColor: Colors.blue[50],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Custom Allergy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customAllergyController,
                            decoration: InputDecoration(
                              hintText: 'e.g., Latex, Strawberry, Penicillin',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add_circle),
                                onPressed: _addCustomAllergy,
                                color: Colors.blue,
                              ),
                            ),
                            onSubmitted: (_) => _addCustomAllergy(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _addCustomAllergy,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Common Allergens',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to select/deselect:',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3.2,
                      ),
                      itemCount: commonAllergens.length,
                      itemBuilder: (context, index) {
                        final allergen = commonAllergens[index];
                        final isSelected = selectedAllergies.contains(allergen);
                        return Card(
                          color: isSelected ? Colors.blue.withAlpha(40) : Colors.white,
                          elevation: isSelected ? 2 : 1,
                          child: InkWell(
                            onTap: () => _toggleAllergy(allergen),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (_) => _toggleAllergy(allergen),
                                    activeColor: Colors.blue,
                                  ),
                                  Expanded(
                                    child: Text(
                                      allergen,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: isSelected ? Colors.blue[800] : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAllergies,
        icon: const Icon(Icons.save),
        label: const Text('Save Allergies'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}