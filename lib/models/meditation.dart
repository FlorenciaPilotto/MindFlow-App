class Meditation {
  final String id;
  final String title;
  final String description;
  final int duration; // in seconds
  final String category;
  final String audioUrl;
  final String imageUrl;
  final double rating;
  final int completions;

  Meditation({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.category,
    required this.audioUrl,
    required this.imageUrl,
    required this.rating,
    required this.completions,
  });

  factory Meditation.fromJson(Map<String, dynamic> json) {
    return Meditation(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int,
      category: json['category'] as String,
      audioUrl: json['audioUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      completions: json['completions'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'category': category,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'rating': rating,
      'completions': completions,
    };
  }
}