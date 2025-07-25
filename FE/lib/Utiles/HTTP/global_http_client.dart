import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:studio_projects/Features/Authentication/Screens/Login/login.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';

class GlobalHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }

  Future<Map<String, String>> _addAuthHeader(
      Map<String, String>? headers) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final newHeaders = Map<String, String>.from(headers ?? {});
    if (token != null && token.isNotEmpty) {
      newHeaders['Authorization'] = 'Bearer $token';
    }
    return newHeaders;
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final mergedHeaders = await _addAuthHeader(headers);
    final response = await _inner.get(url, headers: mergedHeaders);
    await _handleAuth(response);
    return response;
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final mergedHeaders = await _addAuthHeader(headers);
    final response = await _inner.post(url,
        headers: mergedHeaders, body: body, encoding: encoding);
    await _handleAuth(response);
    return response;
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final mergedHeaders = await _addAuthHeader(headers);
    final response = await _inner.put(url,
        headers: mergedHeaders, body: body, encoding: encoding);
    await _handleAuth(response);
    return response;
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final mergedHeaders = await _addAuthHeader(headers);
    final response = await _inner.delete(url,
        headers: mergedHeaders, body: body, encoding: encoding);
    await _handleAuth(response);
    return response;
  }

  Future<void> _handleAuth(http.Response response) async {
    if (response.statusCode == 401 && response.body.contains('jwt expired')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      HelperFunctions.showSnackBar('Session expired. Please log in again.');
      Get.offAll(() => loginPage());
    }
  }
}
