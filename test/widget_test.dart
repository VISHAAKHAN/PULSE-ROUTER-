import 'package:flutter_test/flutter_test.dart';
import 'package:medical_vit/main.dart';

void main() {
  testWidgets('Ambulance app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AmbulanceApp());
    await tester.pumpAndSettle();

    // Verify Login Screen elements exist
    expect(find.text('AMBULANCE'), findsOneWidget);
    expect(find.text('RESPONSE'), findsOneWidget);
  });
}
