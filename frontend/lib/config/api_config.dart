class ApiConfig {
  // Change this to your backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // iOS simulator
  // static const String baseUrl = 'http://192.168.x.x:8000'; // Real device

  static const String apiUrl = '$baseUrl/api';

  // Auth endpoints
  static const String login = '$apiUrl/auth/login';
  static const String register = '$apiUrl/auth/register';
  static const String me = '$apiUrl/auth/me';

  // Lesson endpoints
  static const String jilids = '$apiUrl/lessons/jilids';
  static String jilidDetail(int id) => '$apiUrl/lessons/jilids/$id';
  static String lessonDetail(int jilid, int lesson) =>
      '$apiUrl/lessons/jilids/$jilid/lessons/$lesson';

  // Evaluation endpoints
  static const String submitEvaluation = '$apiUrl/evaluation/submit';
  static const String evaluationHistory = '$apiUrl/evaluation/history';
  static String evaluationDetail(String id) => '$apiUrl/evaluation/$id';

  // Progress endpoints
  static const String dashboard = '$apiUrl/progress/dashboard';
  static String jilidProgress(int id) => '$apiUrl/progress/jilid/$id';

  // Glossary endpoints
  static const String glossaryLetters = '$apiUrl/glossary/letters';
  static const String glossaryClassify = '$apiUrl/glossary/classify';
}
