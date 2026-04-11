class AchievementModel {
  final String id;
  final String name;
  final String description;
  final int xpReward;
  final String badgeEmoji;
  bool isUnlocked;
  DateTime? unlockedAt;
  final String category; 

  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.xpReward,
    required this.badgeEmoji,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.category,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      xpReward: json['xpReward'] ?? 0,
      badgeEmoji: json['badgeEmoji'] ?? '',
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'xpReward': xpReward,
      'badgeEmoji': badgeEmoji,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'category': category,
    };
  }
}
