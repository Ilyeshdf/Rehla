class PostModel {
  final String id;
  final String userId;
  final String username;
  final String wilayaBadge;
  final String journeyId;
  final String photoUrl;
  final String caption;
  final List<String> tags;
  int likes;
  int comments;
  bool isLiked; 
  final DateTime createdAt;
  final String achievementBadge;
  final double distanceKm;
  final Duration time;
  final String difficulty;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.wilayaBadge,
    required this.journeyId,
    required this.photoUrl,
    required this.caption,
    required this.tags,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    required this.createdAt,
    this.achievementBadge = '',
    required this.distanceKm,
    required this.time,
    required this.difficulty,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      wilayaBadge: json['wilayaBadge'] ?? '',
      journeyId: json['journeyId'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      caption: json['caption'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      achievementBadge: json['achievementBadge'] ?? '',
      distanceKm: (json['distanceKm'] ?? 0.0).toDouble(),
      time: Duration(seconds: json['timeSeconds'] ?? 0),
      difficulty: json['difficulty'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'wilayaBadge': wilayaBadge,
      'journeyId': journeyId,
      'photoUrl': photoUrl,
      'caption': caption,
      'tags': tags,
      'likes': likes,
      'comments': comments,
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
      'achievementBadge': achievementBadge,
      'distanceKm': distanceKm,
      'timeSeconds': time.inSeconds,
      'difficulty': difficulty,
    };
  }
}
