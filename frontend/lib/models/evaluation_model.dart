class EvaluationModel {
  final String id;
  final String userId;
  final int jilid;
  final int lessonNumber;
  final String lessonTitle;
  final double overallScore;
  final double makharijulHurufScore;
  final double tajwidScore;
  final double kelancaranScore;
  final Map<String, dynamic>? feedbackJson;
  final Map<String, dynamic>? phonemeDetails;
  final DateTime createdAt;

  EvaluationModel({
    required this.id,
    required this.userId,
    required this.jilid,
    required this.lessonNumber,
    required this.lessonTitle,
    required this.overallScore,
    required this.makharijulHurufScore,
    required this.tajwidScore,
    required this.kelancaranScore,
    this.feedbackJson,
    this.phonemeDetails,
    required this.createdAt,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      id: json['id'],
      userId: json['user_id'],
      jilid: json['jilid'],
      lessonNumber: json['lesson_number'],
      lessonTitle: json['lesson_title'],
      overallScore: (json['overall_score'] as num).toDouble(),
      makharijulHurufScore: (json['makharijul_huruf_score'] as num).toDouble(),
      tajwidScore: (json['tajwid_score'] as num).toDouble(),
      kelancaranScore: (json['kelancaran_score'] as num).toDouble(),
      feedbackJson: json['feedback_json'],
      phonemeDetails: json['phoneme_details'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get grade {
    if (feedbackJson != null && feedbackJson!['grade'] != null) {
      return feedbackJson!['grade'];
    }
    if (overallScore >= 85) return 'Mumtaz';
    if (overallScore >= 70) return 'Jayyid Jiddan';
    if (overallScore >= 55) return 'Jayyid';
    return 'Maqbul';
  }

  String get gradeMessage {
    if (feedbackJson != null && feedbackJson!['message'] != null) {
      return feedbackJson!['message'];
    }
    return '';
  }

  List<String> get tips {
    if (feedbackJson != null && feedbackJson!['tips'] != null) {
      return List<String>.from(feedbackJson!['tips']);
    }
    return [];
  }
}
