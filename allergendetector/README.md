#🚨 Allergen Detector
A Flutter mobile app that scans product barcodes and instantly detects potential allergens based on your personal allergy profile.

#📱 Features
Allergy Profile Management – Select from common allergens or add custom ones

Barcode Scanning – Scan any product barcode using your phone's camera

Instant Detection – Compares product ingredients with your allergy profile

Product Information – Displays product name, brand, image, and full ingredient list

Safety Alerts – Clear warnings for detected allergens with ingredient highlighting

#🛠️ Built With
Flutter – Cross-platform framework

barcode_scan2 – Barcode scanning

Open Food Facts API – Free product database

Shared Preferences – Local storage for user allergies

#🚀 Getting Started
Prerequisites
Flutter SDK (3.16.0+)

Android device with camera (or emulator)

Internet connection for product lookups

Installation
bash
# Clone the repository
git clone https://github.com/SethChaos/allergen-detector.git

# Navigate to project
cd allergen-detector

# Install dependencies
flutter pub get

# Run on device
flutter run
#📸 How It Works
Set up your allergy profile – Select allergens you're sensitive to

Scan a product barcode – Use the built-in camera scanner

Get instant results – See if the product contains your allergens

Review ingredients – View the full ingredient list with allergens highlighted

#🧪 Test Barcodes
5449000000996 – Coca-Cola (typically safe)

3017620425035 – Nutella (contains milk, soy)

7613034626844 – Nestle Crunch (contains milk)

#📁 Project Structure
text
lib/
├── main.dart              # App entry & allergy screen
├── scanner_screen.dart    # Barcode scanning & results
├── models/
│   └── product_model.dart # Data structures
└── services/
    └── product_service.dart # API integration
#🔮 Roadmap
Scan history with local storage

Multiple allergy profiles (family support)

Offline mode for saved products

Additional product databases

Improved allergen matching algorithm

#🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

#📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

#⚠️ Disclaimer
This app provides informational guidance only. Always double-check product labels and consult with healthcare professionals for medical advice regarding allergies.

#⭐ Star this repo if you find it useful!
