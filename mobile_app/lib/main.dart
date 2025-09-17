import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/stack_master_provider.dart';
import 'features/navigation/app_navigation.dart';

void main() {
  runApp(const StackApp());
}

class StackApp extends StatelessWidget {
  const StackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StackMasterProvider()),
      ],
      child: MaterialApp(
        title: 'StackApp',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const AppNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
