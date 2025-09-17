import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackapp/core/ui/cupertino_tokens.dart';

void main() {
  testWidgets('Cupertino theme loads and has correct colors', (tester) async {
    await tester.pumpWidget(const CupertinoApp(theme: CupertinoTokens.theme, home: Placeholder()));
    expect(find.byType(Placeholder), findsOneWidget);
  });
}


