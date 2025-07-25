import 'dart:convert';
import 'package:studio_projects/Utiles/HTTP/global_http_client.dart';

import '../../Features/Shop/Models/category.dart';
import '../../Utiles/constants/api_constants.dart';

class CategoryService {
  static const String baseUrl = ApiConstants.baseUrl + '/categories';
  static final client = GlobalHttpClient();

  static Future<List<Category>> fetchCategories() async {
    final response = await client.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<bool> createCategory(String name, String icon) async {
    final response = await client.post(
      Uri.parse('$baseUrl/category'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'icon': icon}),
    );
    return response.statusCode == 201;
  }
}
