import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';

class ProgressProvider extends ChangeNotifier {
  int totalEvaluations = 0;
  double averageScore = 0;
  double bestScore = 0;
  int streakDays = 0;
  List<Map<String, dynamic>> jilidProgress = [];
  List<Map<String, dynamic>> recentEvaluations = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchDashboard() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await ApiService.get(ApiConfig.dashboard);
      totalEvaluations = (data['total_evaluations'] as num?)?.toInt() ?? 0;
      averageScore = (data['average_score'] as num?)?.toDouble() ?? 0;
      bestScore = (data['best_score'] as num?)?.toDouble() ?? 0;
      streakDays = (data['streak_days'] as num?)?.toInt() ?? 0;
      jilidProgress = List<Map<String, dynamic>>.from(
        (data['jilid_progress'] as List? ?? []).map((e) => Map<String, dynamic>.from(e)),
      );
      recentEvaluations = List<Map<String, dynamic>>.from(
        (data['recent_evaluations'] as List? ?? []).map((e) => Map<String, dynamic>.from(e)),
      );
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  int completedLessons(int jilid) {
    final entry = jilidProgress.where((e) => e['jilid'] == jilid).firstOrNull;
    return (entry?['completed_lessons'] as num?)?.toInt() ?? 0;
  }

  int totalLessons(int jilid) {
    final entry = jilidProgress.where((e) => e['jilid'] == jilid).firstOrNull;
    return (entry?['total_lessons'] as num?)?.toInt() ?? 0;
  }
}
