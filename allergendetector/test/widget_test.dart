import 'package:flutter_test/flutter_test.dart';
import 'package:allergendetector/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const AllergenDetectorApp());
    expect(find.text('Allergy Profile'), findsOneWidget);
  });
}