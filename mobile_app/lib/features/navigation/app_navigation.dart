import 'package:flutter/cupertino.dart';
import '../stack_master/stack_master_chat_screen.dart';
import '../investment/investment_dashboard_screen.dart';
import '../community/community_screen.dart';
import '../education/education_screen.dart';
import '../../core/ui/cupertino_tokens.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoTokens.background,
        activeColor: CupertinoTokens.systemBlue,
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2), label: 'Stack Master'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chart_bar), label: 'Investment'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_2), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.book), label: 'Education'),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const StackMasterChatScreen();
          case 1:
            return const InvestmentDashboardScreen();
          case 2:
            return const CommunityScreen();
          case 3:
          default:
            return const EducationScreen();
        }
      },
    );
  }
}

