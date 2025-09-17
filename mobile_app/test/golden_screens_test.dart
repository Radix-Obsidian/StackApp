import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:stackapp/core/ui/cupertino_tokens.dart';
import 'package:stackapp/features/stack_master/stack_master_chat_screen.dart';
import 'package:stackapp/core/providers/stack_master_provider.dart';
import 'package:stackapp/core/network/network_provider.dart';

void main() {
  testWidgets('Chat screen renders (smoke for golden)', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StackMasterProvider()),
          ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ],
        child: const CupertinoApp(
          theme: CupertinoTokens.theme,
          home: StackMasterChatScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('The Stack Master'), findsWidgets);
  });
}


