class InvestmentAdviceResponse {
  final String userId;
  final String advice;
  final List<String> recommendedActions;
  final String riskAssessment;
  final String potentialReturns;

  InvestmentAdviceResponse({
    required this.userId,
    required this.advice,
    required this.recommendedActions,
    required this.riskAssessment,
    required this.potentialReturns,
  });

  factory InvestmentAdviceResponse.fromJson(Map<String, dynamic> json) {
    return InvestmentAdviceResponse(
      userId: json['user_id'] ?? '',
      advice: json['advice'] ?? '',
      recommendedActions: List<String>.from(json['recommended_actions'] ?? []),
      riskAssessment: json['risk_assessment'] ?? '',
      potentialReturns: json['potential_returns'] ?? '',
    );
  }
}

class StockAnalysisResponse {
  final String ticker;
  final String analysis;
  final String recommendation;
  final String confidence;
  final String lastUpdated;

  StockAnalysisResponse({
    required this.ticker,
    required this.analysis,
    required this.recommendation,
    required this.confidence,
    required this.lastUpdated,
  });

  factory StockAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return StockAnalysisResponse(
      ticker: json['ticker'] ?? '',
      analysis: json['analysis'] ?? '',
      recommendation: json['recommendation'] ?? '',
      confidence: json['confidence'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
    );
  }
}

class CreditPlanResponse {
  final String userId;
  final int currentScore;
  final int targetScore;
  final String plan;
  final String timeline;
  final List<String> monthlyActions;
  final String motivationalMessage;

  CreditPlanResponse({
    required this.userId,
    required this.currentScore,
    required this.targetScore,
    required this.plan,
    required this.timeline,
    required this.monthlyActions,
    required this.motivationalMessage,
  });

  factory CreditPlanResponse.fromJson(Map<String, dynamic> json) {
    return CreditPlanResponse(
      userId: json['user_id'] ?? '',
      currentScore: json['current_score'] ?? 0,
      targetScore: json['target_score'] ?? 0,
      plan: json['plan'] ?? '',
      timeline: json['timeline'] ?? '',
      monthlyActions: List<String>.from(json['monthly_actions'] ?? []),
      motivationalMessage: json['motivational_message'] ?? '',
    );
  }
}
