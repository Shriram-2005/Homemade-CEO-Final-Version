import 'package:flutter_test/flutter_test.dart';
import 'package:homemade_ceo/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomemadeCeoApp());
    expect(find.text('HOMEMADE'), findsOneWidget);
  });
}
