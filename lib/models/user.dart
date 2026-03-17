class User {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final DateTime createdAt;
  final int meditationStreak;
  final int totalMeditationMinutes;
  final List<String> completedMeditationIds;
  final List<String> favoriteCategories;
  final List<String> favoriteMeditationIds;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.createdAt,
    this.meditationStreak = 0,
    this.totalMeditationMinutes = 0,
    this.completedMeditationIds = const [],
    this.favoriteCategories = const [],
    this.favoriteMeditationIds = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      meditationStreak: json['meditationStreak'] as int? ?? 0,
      totalMeditationMinutes: json['totalMeditationMinutes'] as int? ?? 0,
      completedMeditationIds: List<String>.from(json['completedMeditationIds'] as List? ?? []),
      favoriteCategories: List<String>.from(json['favoriteCategories'] as List? ?? []),
      favoriteMeditationIds: List<String>.from(json['favoriteMeditationIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'meditationStreak': meditationStreak,
      'totalMeditationMinutes': totalMeditationMinutes,
      'completedMeditationIds': completedMeditationIds,
      'favoriteCategories': favoriteCategories,
      'favoriteMeditationIds': favoriteMeditationIds,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    DateTime? createdAt,
    int? meditationStreak,
    int? totalMeditationMinutes,
    List<String>? completedMeditationIds,
    List<String>? favoriteCategories,
    List<String>? favoriteMeditationIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      meditationStreak: meditationStreak ?? this.meditationStreak,
      totalMeditationMinutes: totalMeditationMinutes ?? this.totalMeditationMinutes,
      completedMeditationIds: completedMeditationIds ?? this.completedMeditationIds,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      favoriteMeditationIds: favoriteMeditationIds ?? this.favoriteMeditationIds,
    );
  }
}