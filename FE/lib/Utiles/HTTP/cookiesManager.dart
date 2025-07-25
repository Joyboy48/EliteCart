import 'package:cookie_jar/cookie_jar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class CookieManager {
  static final CookieJar cookieJar = PersistCookieJar();

  static Future<http.Response> get(String url) async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final cookies = await cookieJar.loadForRequest(Uri.parse(url));
    request.cookies.addAll(cookies);
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    await cookieJar.saveFromResponse(Uri.parse(url), response.cookies);
    return http.Response(responseBody, response.statusCode);
  }

  static Future<http.Response> post(String url, {Map<String, String>? headers, Object? body}) async {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(url));
    final cookies = await cookieJar.loadForRequest(Uri.parse(url));
    request.cookies.addAll(cookies);
    if (headers != null) {
      headers.forEach((name, value) {
        request.headers.set(name, value);
      });
    }
    if (body != null) {
      request.write(body);
    }
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    await cookieJar.saveFromResponse(Uri.parse(url), response.cookies);
    return http.Response(responseBody, response.statusCode);
  }
}