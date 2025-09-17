import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_store.dart';
import '../models/stack_master_models.dart';
import '../models/investment_models.dart';
import '../models/community_models.dart';

class StackAppApiClient {
  // Use 127.0.0.1 to avoid some sandbox/ATS edge-cases with 'localhost'
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Stack Master Chat
  static Future<StackMasterResponse> chatWithStackMaster({
    required String userId,
    required String message,
    Map<String, dynamic>? context,
  }) async {
    try {
      final headers = await _headers();
      final response = await _withRetry(() => http.post(
        Uri.parse('$baseUrl/stack-master/chat'),
        headers: headers,
        body: jsonEncode({
          'user_id': userId,
          'message': message,
          'context': context ?? {},
        }),
      ).timeout(timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StackMasterResponse.fromJson(data);
      } else {
        throw Exception('Failed to chat with Stack Master: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Stack Analysis
  static Future<StackAnalysisResponse> analyzeStack({
    required String userId,
    double? currentIncome,
    double? currentSavings,
    double? monthlyExpenses,
    int? creditScore,
    List<String>? investmentGoals,
    String riskTolerance = 'moderate',
  }) async {
    try {
      final headers = await _headers();
      final response = await _withRetry(() => http.post(
        Uri.parse('$baseUrl/stack-master/analyze-stack'),
        headers: headers,
        body: jsonEncode({
          'user_id': userId,
          'current_income': currentIncome,
          'current_savings': currentSavings,
          'monthly_expenses': monthlyExpenses,
          'credit_score': creditScore,
          'investment_goals': investmentGoals ?? [],
          'risk_tolerance': riskTolerance,
        }),
      ).timeout(timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StackAnalysisResponse.fromJson(data);
      } else {
        throw Exception('Failed to analyze stack: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Investment Advice
  static Future<InvestmentAdviceResponse> getInvestmentAdvice({
    required String userId,
    required double amountToInvest,
    required String investmentHorizon,
    required String riskTolerance,
    String investmentType = 'stocks',
  }) async {
    try {
      final headers = await _headers();
      final response = await _withRetry(() => http.post(
        Uri.parse('$baseUrl/investment/advice'),
        headers: headers,
        body: jsonEncode({
          'user_id': userId,
          'amount_to_invest': amountToInvest,
          'investment_horizon': investmentHorizon,
          'risk_tolerance': riskTolerance,
          'investment_type': investmentType,
        }),
      ).timeout(timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return InvestmentAdviceResponse.fromJson(data);
      } else {
        throw Exception('Failed to get investment advice: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Stock Analysis
  static Future<StockAnalysisResponse> analyzeStock(String ticker) async {
    try {
      final headers = await _headers();
      final response = await _withRetry(() => http.get(
        Uri.parse('$baseUrl/investment/stock-analysis/$ticker'),
        headers: headers,
      ).timeout(timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StockAnalysisResponse.fromJson(data);
      } else {
        throw Exception('Failed to analyze stock: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Credit Building Plan
  static Future<CreditPlanResponse> createCreditPlan({
    required String userId,
    required int currentScore,
    required double currentDebt,
    required double monthlyIncome,
    List<String> goals = const [],
  }) async {
    try {
      final headers = await _headers();
      final response = await _withRetry(() => http.post(
        Uri.parse('$baseUrl/credit/building-plan'),
        headers: headers,
        body: jsonEncode({
          'user_id': userId,
          'current_score': currentScore,
          'current_debt': currentDebt,
          'monthly_income': monthlyIncome,
          'goals': goals,
        }),
      ).timeout(timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CreditPlanResponse.fromJson(data);
      } else {
        throw Exception('Failed to create credit plan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Community Challenges
  static Future<List<StackChallenge>> getStackChallenges() async {
    try {
      final headers = await _headers();
      final response = await _withRetry(() => http.get(
        Uri.parse('$baseUrl/community/stack-challenges'),
        headers: headers,
      ).timeout(timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['items'] ?? data['challenges'] ?? []) as List;
        final challenges = list
            .map((json) => StackChallenge.fromJson(json))
            .toList();
        return challenges;
      } else {
        throw Exception('Failed to get challenges: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Success Stories
  static Future<List<SuccessStory>> getSuccessStories() async {
    try {
      final headers = await _headers();
      final response = await _withRetry(() => http.get(
        Uri.parse('$baseUrl/community/success-stories'),
        headers: headers,
      ).timeout(timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['items'] ?? data['stories'] ?? []) as List;
        final stories = list
            .map((json) => SuccessStory.fromJson(json))
            .toList();
        return stories;
      } else {
        throw Exception('Failed to get success stories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Education Topics
  static Future<List<EducationTopic>> getEducationTopics() async {
    try {
      final headers = await _headers();
      final response = await _withRetry(() => http.get(
        Uri.parse('$baseUrl/education/topics'),
        headers: headers,
      ).timeout(timeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['items'] ?? data['topics'] ?? []) as List;
        final topics = list
            .map((json) => EducationTopic.fromJson(json))
            .toList();
        return topics;
      } else {
        throw Exception('Failed to get education topics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Health Check
  static Future<bool> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

Future<Map<String, String>> _headers() async {
  final token = await AuthStore.getToken();
  return {
    'Content-Type': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };
}

Future<http.Response> _withRetry(Future<http.Response> Function() fn) async {
  int attempt = 0;
  http.Response last;
  while (true) {
    try {
      last = await fn();
      if (_isTransient(last.statusCode) && attempt < StackAppApiClient.maxRetries - 1) {
        attempt++;
        await Future.delayed(Duration(milliseconds: 200 * (1 << attempt)));
        continue;
      }
      return last;
    } catch (_) {
      if (attempt >= StackAppApiClient.maxRetries - 1) rethrow;
      attempt++;
      await Future.delayed(Duration(milliseconds: 200 * (1 << attempt)));
    }
  }
}

bool _isTransient(int code) => code == 408 || code == 429 || (code >= 500 && code < 600);
