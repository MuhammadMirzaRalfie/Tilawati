class JilidModel {
  final int jilid;
  final String title;
  final String description;
  final int totalLessons;
  final String icon;
  final String color;
  final List<LessonModel> lessons;

  JilidModel({
    required this.jilid,
    required this.title,
    required this.description,
    required this.totalLessons,
    required this.icon,
    required this.color,
    this.lessons = const [],
  });

  factory JilidModel.fromJson(Map<String, dynamic> json) {
    return JilidModel(
      jilid: json['jilid'],
      title: json['title'],
      description: json['description'],
      totalLessons: json['total_lessons'],
      icon: json['icon'] ?? 'menu_book',
      color: json['color'] ?? '#1B5E20',
      lessons: json['lessons'] != null
          ? (json['lessons'] as List)
              .map((l) => LessonModel.fromJson(l))
              .toList()
          : [],
    );
  }
}

class LessonModel {
  final int lessonNumber;
  final String title;
  final String arabicText;
  final String transliteration;
  final String description;
  final String? audioReferenceUrl;
  final String? imagePath;

  LessonModel({
    required this.lessonNumber,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.description,
    this.audioReferenceUrl,
    this.imagePath,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      lessonNumber: json['lesson_number'] ?? json['number'], // handle both json and local map keys
      title: json['title'],
      arabicText: json['arabic_text'] ?? json['arabic'] ?? '',
      transliteration: json['transliteration'] ?? '',
      description: json['description'] ?? json['desc'] ?? '',
      audioReferenceUrl: json['audio_reference_url'],
      imagePath: json['imagePath'],
    );
  }
}
