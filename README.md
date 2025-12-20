# 🚨 Allergen Detector

A Flutter mobile app that scans product barcodes and instantly detects potential allergens based on your personal allergy profile.

---

## 📱 Features
- **Allergy Profile Management** – Select from common allergens or add custom ones  
- **Barcode Scanning** – Scan any product barcode using your phone's camera  
- **Instant Detection** – Compares product ingredients with your allergy profile  
- **Product Information** – Displays product name, brand, image, and full ingredient list  
- **Safety Alerts** – Clear warnings for detected allergens with ingredient highlighting  

---

## 🛠️ Built With
- [Flutter](https://flutter.dev/) – Cross-platform framework  
- [barcode_scan2](https://pub.dev/packages/barcode_scan2) – Barcode scanning  
- [Open Food Facts API](https://world.openfoodfacts.org/) – Free product database  
- [Shared Preferences](https://pub.dev/packages/shared_preferences) – Local storage for user allergies  

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.16.0+)  
- Android device with camera (or emulator)  
- Internet connection for product lookups  

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/allergen-detector.git

# Navigate to project
cd allergen-detector

# Install dependencies
flutter pub get

# Run on device
flutter run
