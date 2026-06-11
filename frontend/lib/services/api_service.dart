import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String? _token;

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  static String? get token => _token;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  static const Duration _defaultTimeout = Duration(seconds: 10);
  static const Duration _uploadTimeout = Duration(seconds: 30);

  /// Membungkus request HTTP agar error jaringan jadi ApiException
  /// dengan pesan ramah (bukan stack trace mentah).
  static Future<Map<String, dynamic>> _guard(
    Future<http.Response> Function() run,
  ) async {
    try {
      final response = await run();
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
          0, 'Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException {
      throw ApiException(
          0, 'Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw ApiException(0, 'Koneksi lambat. Silakan coba lagi.');
    }
  }

  static Future<Map<String, dynamic>> get(String url) {
    return _guard(() => http
        .get(Uri.parse(url), headers: _headers)
        .timeout(_defaultTimeout));
  }

  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
  }) {
    return _guard(() => http
        .post(
          Uri.parse(url),
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_defaultTimeout));
  }

  static Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
  }) {
    return _guard(() => http
        .patch(
          Uri.parse(url),
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_defaultTimeout));
  }

  static Future<Map<String, dynamic>> postForm(
    String url, {
    required Map<String, String> fields,
  }) {
    return _guard(() async {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        if (_token != null) 'Authorization': 'Bearer $_token',
      });
      request.fields.addAll(fields);
      final streamedResponse = await request.send().timeout(_defaultTimeout);
      return http.Response.fromStream(streamedResponse);
    });
  }

  static const Duration wordEvalTimeout = Duration(seconds: 70);

  static Future<Map<String, dynamic>> postMultipart(
    String url, {
    required Map<String, String> fields,
    required String filePath,
    required String fileField,
    Duration? timeout,
  }) {
    return _guard(() async {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        if (_token != null) 'Authorization': 'Bearer $_token',
      });
      request.fields.addAll(fields);
      request.files
          .add(await http.MultipartFile.fromPath(fileField, filePath));

      final streamedResponse =
          await request.send().timeout(timeout ?? _uploadTimeout);
      return http.Response.fromStream(streamedResponse);
    });
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final dynamic body;
    try {
      body = jsonDecode(response.body);
    } on FormatException {
      throw ApiException(response.statusCode, 'Terjadi kesalahan pada server');
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body is Map<String, dynamic> ? body : {'data': body};
    } else {
      final detail = body is Map ? body['detail'] ?? 'Terjadi kesalahan' : 'Terjadi kesalahan';
      throw ApiException(response.statusCode, detail.toString());
    }
  }

  // --- Cache sederhana berbasis SharedPreferences (fallback offline) ---

  static Future<void> saveCache(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cache_$key', jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> loadCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cache_$key');
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  bool get isNetworkError => statusCode == 0;

  @override
  String toString() => message;
}
