import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stack_master_models.dart';
import '../models/investment_models.dart';
import '../models/community_models.dart';

class StackAppApiClient {
  // Use 127.0.0.1 to avoid some sandbox/ATS edge-cases with 'localhost'
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const Duration timeout = Duration(seconds: 30);

  // Stack Master Chat
  static Future<StackMasterResponse> chatWithStackMaster({
    required String userId,
    required String message,
    Map<String, dynamic>? context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/stack-master/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'message': message,
          'context': context ?? {},
        }),
      ).timeout(timeout);

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
      final response = await http.post(
        Uri.parse('$baseUrl/stack-master/analyze-stack'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'current_income': currentIncome,
          'current_savings': currentSavings,
          'monthly_expenses': monthlyExpenses,
          'credit_score': creditScore,
          'investment_goals': investmentGoals ?? [],
          'risk_tolerance': riskTolerance,
        }),
      ).timeout(timeout);

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
      final response = await http.post(
        Uri.parse('$baseUrl/investment/advice'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'amount_to_invest': amountToInvest,
          'investment_horizon': investmentHorizon,
          'risk_tolerance': riskTolerance,
          'investment_type': investmentType,
        }),
      ).timeout(timeout);

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
      final response = await http.get(
        Uri.parse('$baseUrl/investment/stock-analysis/$ticker'),
      ).timeout(timeout);

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
      final response = await http.post(
        Uri.parse('$baseUrl/credit/building-plan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'current_score': currentScore,
          'current_debt': currentDebt,
          'monthly_income': monthlyIncome,
          'goals': goals,
        }),
      ).timeout(timeout);

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
      final response = await http.get(
        Uri.parse('$baseUrl/community/stack-challenges'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final challenges = (data['challenges'] as List)
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
      final response = await http.get(
        Uri.parse('$baseUrl/community/success-stories'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final stories = (data['stories'] as List)
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
      final response = await http.get(
        Uri.parse('$baseUrl/education/topics'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final topics = (data['topics'] as List)
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
