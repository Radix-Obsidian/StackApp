import 'package:flutter/foundation.dart';
import '../api/stackapp_api_client.dart';
import '../models/stack_master_models.dart';

class StackMasterProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(
      text: message,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get response from Stack Master
      final response = await StackAppApiClient.chatWithStackMaster(
        userId: _userId,
        message: message,
      );

      // Add Stack Master response
      final stackMasterMessage = ChatMessage.fromStackMaster(
        text: response.response,
        timestamp: DateTime.now(),
        adviceType: response.adviceType,
        actionableSteps: response.actionableSteps,
      );
      _messages.add(stackMasterMessage);
    } catch (e) {
      _error = 'Failed to get response from Stack Master: $e';
      
      // Add error message
      final errorMessage = ChatMessage.fromStackMaster(
        text: 'Sorry, I\'m having trouble connecting right now. Please try again later.',
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  Future<void> analyzeStack({
    double? currentIncome,
    double? currentSavings,
    double? monthlyExpenses,
    int? creditScore,
    List<String>? investmentGoals,
    String riskTolerance = 'moderate',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await StackAppApiClient.analyzeStack(
        userId: _userId,
        currentIncome: currentIncome,
        currentSavings: currentSavings,
        monthlyExpenses: monthlyExpenses,
        creditScore: creditScore,
        investmentGoals: investmentGoals,
        riskTolerance: riskTolerance,
      );

      // Add analysis message
      final analysisMessage = ChatMessage.fromStackMaster(
        text: response.analysis,
        timestamp: DateTime.now(),
      );
      _messages.add(analysisMessage);
    } catch (e) {
      _error = 'Failed to analyze stack: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
