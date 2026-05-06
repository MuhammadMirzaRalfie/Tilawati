class ApiConfig {
  // Pilih sesuai konfigurasi:
  //
  // 1) USB device (recommended): jalankan dulu di host:
  //      adb reverse tcp:8000 tcp:8000
  //    lalu pakai baris 'localhost' di bawah.
  //
  // 2) Android emulator: 'http://10.0.2.2:8000'
  //
  // 3) Real device via Wi-Fi LAN: 'http://192.168.x.x:8000'
  //    (cari IP host dengan `ipconfig` di Windows / `ifconfig` di Mac/Linux,
  //     dan pastikan firewall mengizinkan port 8000)
  static const String baseUrl = 'http://localhost:8000'; // USB/Web/iOS Simulator
  //static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://10.222.230.53:8000'; // LAN Wi-Fi

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
  static const String submitEvaluation = '$apiUrl/evaluation/submit';
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
