import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/jilid_model.dart';
import '../services/api_service.dart';

class LessonProvider extends ChangeNotifier {
  List<JilidModel> _jilids = [];
  JilidModel? _selectedJilid;
  LessonModel? _selectedLesson;
  bool _isLoading = false;
  String? _error;

  List<JilidModel> get jilids => _jilids;
  JilidModel? get selectedJilid => _selectedJilid;
  LessonModel? get selectedLesson => _selectedLesson;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchJilids() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get(ApiConfig.jilids);
      final jilidsJson = response['jilids'] as List;
      _jilids = jilidsJson.map((j) => JilidModel.fromJson(j)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchJilidDetail(int jilidId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get(ApiConfig.jilidDetail(jilidId));
      _selectedJilid = JilidModel.fromJson(response);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectLesson(LessonModel lesson) {
    _selectedLesson = lesson;
    notifyListeners();
  }

  void clearSelection() {
    _selectedJilid = null;
    _selectedLesson = null;
    notifyListeners();
  }
}
