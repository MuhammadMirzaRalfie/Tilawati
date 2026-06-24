import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/evaluation_model.dart';
import '../services/api_service.dart';

class EvaluationProvider extends ChangeNotifier {
  List<EvaluationModel> _history = [];
  bool _isLoading = false;
  String? _error;

  List<EvaluationModel> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
}
