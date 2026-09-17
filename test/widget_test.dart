// Basic smoke test for ConfiCircle app
import 'package:flutter_test/flutter_test.dart';
import 'package:conficircle/main.dart';

void main() {
  testWidgets('ConfiCircle app builds without crashing', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const ConfiCircleApp());
    // Verify that the app widget exists
    expect(find.byType(ConfiCircleApp), findsOneWidget);
  });
}
