class UserModel {
  final String id;
  final String username;
  final String wilaya;
  final String avatarUrl;
  final int xp;
  final String level;
  final int rank;
  final List<String> unlockedAchievements;
  final List<String> firstDiscoveries;
  final bool isGuide;

  UserModel({
    required this.id,
    required this.username,
    required this.wilaya,
    this.avatarUrl = '',
    this.xp = 0,
    required this.level,
    this.rank = 0,
    required this.unlockedAchievements,
    required this.firstDiscoveries,
    this.isGuide = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      wilaya: json['wilaya'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 'مستكشف مبتدئ',
      rank: json['rank'] ?? 0,
      unlockedAchievements: List<String>.from(json['unlockedAchievements'] ?? []),
      firstDiscoveries: List<String>.from(json['firstDiscoveries'] ?? []),
      isGuide: json['isGuide'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'wilaya': wilaya,
      'avatarUrl': avatarUrl,
      'xp': xp,
      'level': level,
      'rank': rank,
      'unlockedAchievements': unlockedAchievements,
      'firstDiscoveries': firstDiscoveries,
      'isGuide': isGuide,
    };
  }

  UserModel copyWith({
    int? xp,
    String? level,
    int? rank,
    List<String>? unlockedAchievements,
    List<String>? firstDiscoveries,
    String? avatarUrl,
    bool? isGuide,
  }) {
    return UserModel(
      id: id,
      username: username,
      wilaya: wilaya,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      rank: rank ?? this.rank,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      firstDiscoveries: firstDiscoveries ?? this.firstDiscoveries,
      isGuide: isGuide ?? this.isGuide,
    );
  }
}
