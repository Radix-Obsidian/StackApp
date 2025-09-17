class StackChallenge {
  final String id;
  final String name;
  final String description;
  final String reward;
  final int participants;
  final String difficulty;

  StackChallenge({
    required this.id,
    required this.name,
    required this.description,
    required this.reward,
    required this.participants,
    required this.difficulty,
  });

  factory StackChallenge.fromJson(Map<String, dynamic> json) {
    return StackChallenge(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      reward: json['reward'] ?? '',
      participants: json['participants'] ?? 0,
      difficulty: json['difficulty'] ?? '',
    );
  }
}

class SuccessStory {
  final String id;
  final String user;
  final String achievement;
  final String story;
  final String category;
  final bool verified;

  SuccessStory({
    required this.id,
    required this.user,
    required this.achievement,
    required this.story,
    required this.category,
    required this.verified,
  });

  factory SuccessStory.fromJson(Map<String, dynamic> json) {
    return SuccessStory(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      achievement: json['achievement'] ?? '',
      story: json['story'] ?? '',
      category: json['category'] ?? '',
      verified: json['verified'] ?? false,
    );
  }
}

class EducationTopic {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String duration;

  EducationTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
  });

  factory EducationTopic.fromJson(Map<String, dynamic> json) {
    return EducationTopic(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
}
