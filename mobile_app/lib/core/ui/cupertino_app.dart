import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'cupertino_tokens.dart';
import '../../features/stack_master/stack_master_chat_screen.dart';
import '../../features/investment/investment_dashboard_screen.dart';
import '../../features/community/community_screen.dart';
import '../../features/education/education_screen.dart';

/// Cupertino-only application entry (not wired by default).
/// Use for progressive migration and visual validation.
class CupertinoStackApp extends StatelessWidget {
  const CupertinoStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoTokens.theme,
      debugShowCheckedModeBanner: false,
      home: RootCupertinoTabs(),
    );
  }
}

class RootCupertinoTabs extends StatelessWidget {
  const RootCupertinoTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoTokens.background,
        activeColor: CupertinoTokens.systemBlue,
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2), label: 'Stack Master'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chart_bar), label: 'Invest'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_2), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.book), label: 'Education'),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const _CupertinoTabPage(title: 'Stack Master', child: StackMasterChatScreen());
          case 1:
            return const _CupertinoTabPage(title: 'Invest', child: InvestmentDashboardScreen());
          case 2:
            return const _CupertinoTabPage(title: 'Community', child: CommunityScreen());
          case 3:
          default:
            return const _CupertinoTabPage(title: 'Education', child: EducationScreen());
        }
      },
    );
  }
}

class _CupertinoTabPage extends StatelessWidget {
  final String title;
  final Widget child;
  const _CupertinoTabPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        backgroundColor: CupertinoTokens.background,
      ),
      child: SafeArea(child: child),
      backgroundColor: CupertinoTokens.background,
    );
  }
}


