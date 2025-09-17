import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/stack_master_provider.dart';
import 'features/navigation/app_navigation.dart';
import 'core/ui/cupertino_app.dart';
import 'core/auth/auth_provider.dart';
import 'core/network/network_provider.dart';

void main() {
  final appStart = DateTime.now();
  runApp(const StackApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final ttiMs = DateTime.now().difference(appStart).inMilliseconds;
    // Startup Time To Interactive log (for profiling)
    // Expectation: <= 2000 ms on mid-tier devices
    // This is a dev log only and has no production impact.
    // ignore: avoid_print
    print('startup_tti_ms=$ttiMs');
  });
}

class StackApp extends StatelessWidget {
  final bool startNetworkPolling;
  const StackApp({super.key, this.startNetworkPolling = true});

  @override
  Widget build(BuildContext context) {
    const bool useCupertino = true; // Flip to true to preview Cupertino app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StackMasterProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..load()),
        ChangeNotifierProvider(create: (_) {
          final provider = NetworkProvider();
          if (startNetworkPolling) {
            provider.start();
          }
          return provider;
        }),
      ],
      child: useCupertino
          ? const CupertinoStackApp()
          : MaterialApp(
              title: 'StackApp',
              theme: AppTheme.lightTheme,
              themeMode: ThemeMode.light,
              home: const AppNavigation(),
              debugShowCheckedModeBanner: false,
            ),
    );
  }
}
