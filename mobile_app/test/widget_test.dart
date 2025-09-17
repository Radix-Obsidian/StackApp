// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:stackapp/main.dart';

void main() {
  testWidgets('StackApp boots and shows tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const StackApp(startNetworkPolling: false));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Stack Master'), findsWidgets);
    expect(find.text('Invest'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
  });
}
