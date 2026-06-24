class ApiConfig {
  // Override at build time:
  //   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000     (Android emulator)
  //   flutter build apk --release --dart-define=API_BASE_URL=https://<app>.railway.app
  // Default (USB/Web/iOS Simulator) requires: adb reverse tcp:8000 tcp:8000
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const String apiUrl = '$baseUrl/api';

  // Auth endpoints
  static const String login = '$apiUrl/auth/login';
  static const String register = '$apiUrl/auth/register';
  static const String me = '$apiUrl/auth/me';
  static const String updateProfile = '$apiUrl/auth/me';

  // Lesson endpoints
  static const String jilids = '$apiUrl/lessons/jilids';
  static String jilidDetail(int id) => '$apiUrl/lessons/jilids/$id';
  static String lessonDetail(int jilid, int lesson) =>
      '$apiUrl/lessons/jilids/$jilid/lessons/$lesson';

  // Evaluation endpoints
  static const String submitWord = '$apiUrl/evaluation/submit_word';
  static const String submitLessonResult = '$apiUrl/evaluation/submit_lesson_result';
  static const String transcribeFree = '$apiUrl/evaluation/transcribe_free';
  static const String evaluationHistory = '$apiUrl/evaluation/history';
  static String evaluationDetail(String id) => '$apiUrl/evaluation/$id';

  // Progress endpoints
  static const String dashboard = '$apiUrl/progress/dashboard';
  static String jilidProgress(int id) => '$apiUrl/progress/jilid/$id';

  // Glossary endpoints
  static const String glossaryLetters = '$apiUrl/glossary/letters';
  static const String glossaryClassify = '$apiUrl/glossary/classify';
}
