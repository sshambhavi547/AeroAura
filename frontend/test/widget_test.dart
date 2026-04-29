import 'package:flutter_test/flutter_test.dart';
import 'package:aeroaura_app/main.dart';

void main() {
  testWidgets('AeroAura app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AeroAuraApp());
    expect(find.byType(AeroAuraApp), findsOneWidget);
  });
}
