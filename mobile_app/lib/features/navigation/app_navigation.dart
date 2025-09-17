import 'package:flutter/material.dart';
import '../stack_master/stack_master_chat_screen.dart';
import '../investment/investment_dashboard_screen.dart';
import '../community/community_screen.dart';
import '../education/education_screen.dart';
import '../../core/theme/app_theme.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const StackMasterChatScreen(),
    const InvestmentDashboardScreen(),
    const CommunityScreen(),
    const EducationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppTheme.systemBlue,
        unselectedItemColor: AppTheme.gray,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Stack Master',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Investment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Education',
          ),
        ],
      ),
    );
  }
}
