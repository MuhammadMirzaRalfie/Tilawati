import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  Future<bool> checkAuth() async {
    await ApiService.loadToken();
    if (ApiService.token == null) return false;

    try {
      final response = await ApiService.get(ApiConfig.me);
      _user = UserModel.fromJson(response);
      notifyListeners();
      return true;
    } catch (e) {
      await ApiService.clearToken();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post(
        ApiConfig.login,
        body: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response);
      await ApiService.setToken(authResponse.accessToken);
      _user = authResponse.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post(
        ApiConfig.register,
        body: {'name': name, 'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response);
      await ApiService.setToken(authResponse.accessToken);
      _user = authResponse.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String name) async {
    try {
      final response = await ApiService.patch(
        ApiConfig.updateProfile,
        body: {'name': name},
      );
      _user = UserModel.fromJson(response);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.clearToken();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
