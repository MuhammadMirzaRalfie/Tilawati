import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/evaluation_model.dart';
import '../services/api_service.dart';

class EvaluationProvider extends ChangeNotifier {
  EvaluationModel? _currentEvaluation;
  List<EvaluationModel> _history = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  EvaluationModel? get currentEvaluation => _currentEvaluation;
  List<EvaluationModel> get history => _history;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Future<bool> submitEvaluation({
    required int jilid,
    required int lessonNumber,
    required String audioPath,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.postMultipart(
        ApiConfig.submitEvaluation,
        fields: {
          'jilid': jilid.toString(),
          'lesson_number': lessonNumber.toString(),
        },
        filePath: audioPath,
        fileField: 'audio',
      );
      _currentEvaluation = EvaluationModel.fromJson(response);
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchHistory({int? jilid, int limit = 20}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String url = '${ApiConfig.evaluationHistory}?limit=$limit';
      if (jilid != null) {
        url += '&jilid=$jilid';
      }
      final response = await ApiService.get(url);
      final data = response['data'] as List? ?? [];
      _history = data.map((e) => EvaluationModel.fromJson(e)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCurrentEvaluation() {
    _currentEvaluation = null;
    notifyListeners();
  }
}
