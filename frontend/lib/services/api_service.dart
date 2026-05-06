import 'dart:convert';
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

  static Future<Map<String, dynamic>> get(String url) async {
    final response = await http
        .get(Uri.parse(url), headers: _headers)
        .timeout(_defaultTimeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http
        .post(
          Uri.parse(url),
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_defaultTimeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http
        .patch(
          Uri.parse(url),
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_defaultTimeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> postForm(
    String url, {
    required Map<String, String> fields,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      if (_token != null) 'Authorization': 'Bearer $_token',
    });
    request.fields.addAll(fields);
    final streamedResponse = await request.send().timeout(_defaultTimeout);
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  static const Duration wordEvalTimeout = Duration(seconds: 12);

  static Future<Map<String, dynamic>> postMultipart(
    String url, {
    required Map<String, String> fields,
    required String filePath,
    required String fileField,
    Duration? timeout,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      if (_token != null) 'Authorization': 'Bearer $_token',
    });
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath(fileField, filePath));

    final streamedResponse = await request
        .send()
        .timeout(timeout ?? _uploadTimeout);
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body is Map<String, dynamic> ? body : {'data': body};
    } else {
      final detail = body is Map ? body['detail'] ?? 'Terjadi kesalahan' : 'Terjadi kesalahan';
      throw ApiException(response.statusCode, detail.toString());
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}
