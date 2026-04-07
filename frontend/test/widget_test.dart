import 'package:flutter_test/flutter_test.dart';
import 'package:tilawati/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const TilawatiApp());
    expect(find.text('Tilawati'), findsAny);
  });
}
