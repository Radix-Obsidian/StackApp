class StackMasterResponse {
  final String response;
  final String adviceType;
  final List<String> actionableSteps;
  final String motivationalMessage;

  StackMasterResponse({
    required this.response,
    required this.adviceType,
    required this.actionableSteps,
    required this.motivationalMessage,
  });

  factory StackMasterResponse.fromJson(Map<String, dynamic> json) {
    return StackMasterResponse(
      response: json['response'] ?? '',
      adviceType: json['advice_type'] ?? 'general',
      actionableSteps: List<String>.from(json['actionable_steps'] ?? []),
      motivationalMessage: json['motivational_message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'advice_type': adviceType,
      'actionable_steps': actionableSteps,
      'motivational_message': motivationalMessage,
    };
  }
}

class StackAnalysisResponse {
  final String userId;
  final String analysis;
  final Map<String, dynamic> recommendations;
  final double stackScore;
  final String motivationalMessage;

  StackAnalysisResponse({
    required this.userId,
    required this.analysis,
    required this.recommendations,
    required this.stackScore,
    required this.motivationalMessage,
  });

  factory StackAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return StackAnalysisResponse(
      userId: json['user_id'] ?? '',
      analysis: json['analysis'] ?? '',
      recommendations: json['recommendations'] ?? {},
      stackScore: (json['stack_score'] ?? 0.0).toDouble(),
      motivationalMessage: json['motivational_message'] ?? '',
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final String sender; // 'user' or 'stack_master'
  final DateTime timestamp;
  final String? adviceType;
  final List<String>? actionableSteps;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.adviceType,
    this.actionableSteps,
  });

  factory ChatMessage.user({
    required String text,
    required DateTime timestamp,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: 'user',
      timestamp: timestamp,
    );
  }

  factory ChatMessage.fromStackMaster({
    required String text,
    required DateTime timestamp,
    String? adviceType,
    List<String>? actionableSteps,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: 'stack_master',
      timestamp: timestamp,
      adviceType: adviceType,
      actionableSteps: actionableSteps,
    );
  }
}
