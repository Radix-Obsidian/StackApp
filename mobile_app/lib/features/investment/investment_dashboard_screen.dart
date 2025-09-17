import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api/stackapp_api_client.dart';
import '../../core/models/investment_models.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_provider.dart';

class InvestmentDashboardScreen extends StatefulWidget {
  const InvestmentDashboardScreen({super.key});

  @override
  State<InvestmentDashboardScreen> createState() => _InvestmentDashboardScreenState();
}

class _InvestmentDashboardScreenState extends State<InvestmentDashboardScreen> {
  bool _loadingAdvice = false;
  String? _adviceText;
  bool _loadingStock = false;
  String? _stockText;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Investment Dashboard'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            final confirmed = await showCupertinoDialog<bool>(
              context: context,
              builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
            if (confirmed == true && context.mounted) {
              await context.read<AuthProvider>().logout();
            }
          },
          child: const Icon(CupertinoIcons.square_arrow_right),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portfolio Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.brightGold, AppTheme.brightGold.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Stack',
                    style: TextStyle(
                      color: AppTheme.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$0.00',
                    style: TextStyle(
                      color: AppTheme.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: AppTheme.emeraldGreen,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '+0.00% today',
                        style: TextStyle(
                          color: AppTheme.emeraldGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.add,
                    title: 'Invest',
                    subtitle: 'Start building',
                    onTap: () {
                      _showInvestmentAdviceDialog();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.analytics,
                    title: 'Analyze',
                    subtitle: 'Stock research',
                    onTap: () {
                      _showStockAnalysisDialog();
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Market Trends
            const Text(
              'Market Trends',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.brightGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Market data will be available when you connect to the backend',
                    style: TextStyle(
                      color: AppTheme.gray,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start the StackApp backend to see real-time data',
                    style: TextStyle(
                      color: AppTheme.gray,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.brightGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.brightGold,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.gray,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvestmentAdviceDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setLocal) {
        Future<void> _fetchAdvice() async {
          setLocal(() { _loadingAdvice = true; _adviceText = null; });
          try {
            final res = await StackAppApiClient.getInvestmentAdvice(
              userId: 'demo_user',
              amountToInvest: 1000,
              investmentHorizon: 'long-term',
              riskTolerance: 'moderate',
            );
            setLocal(() { _adviceText = res.advice; });
          } catch (e) {
            setLocal(() { _adviceText = 'Failed to fetch advice: $e'; });
          } finally {
            setLocal(() { _loadingAdvice = false; });
          }
        }

        if (_adviceText == null && !_loadingAdvice) {
          _fetchAdvice();
        }

        return CupertinoAlertDialog(
          title: const Text('Investment Advice'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _loadingAdvice
                ? const CupertinoActivityIndicator()
                : Text(_adviceText ?? '...'),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      }),
    );
  }

  void _showStockAnalysisDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setLocal) {
        Future<void> _fetchStock() async {
          setLocal(() { _loadingStock = true; _stockText = null; });
          try {
            final res = await StackAppApiClient.analyzeStock('AAPL');
            setLocal(() { _stockText = res.analysis; });
          } catch (e) {
            setLocal(() { _stockText = 'Failed to fetch stock analysis: $e'; });
          } finally {
            setLocal(() { _loadingStock = false; });
          }
        }

        if (_stockText == null && !_loadingStock) {
          _fetchStock();
        }

        return CupertinoAlertDialog(
          title: const Text('Stock Analysis (AAPL)'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _loadingStock
                ? const CupertinoActivityIndicator()
                : Text(_stockText ?? '...'),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      }),
    );
  }
}
