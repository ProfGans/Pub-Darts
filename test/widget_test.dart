import 'package:flutter_test/flutter_test.dart';

import 'package:pub_darts/src/pub_darts_app.dart';

void main() {
  testWidgets('shows main menu on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const PubDartsApp());

    expect(find.text('Hauptmenue'), findsOneWidget);
    expect(find.text('Schnelles Spiel'), findsOneWidget);
  });
}
