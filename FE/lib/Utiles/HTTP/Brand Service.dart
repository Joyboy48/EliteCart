import 'dart:convert';
import 'package:studio_projects/Utiles/HTTP/global_http_client.dart';

import '../../Features/Shop/Models/band.dart';
import '../../Utiles/constants/api_constants.dart';

class BrandService {
  static const String baseUrl = ApiConstants.baseUrl + '/brands';
  static final client = GlobalHttpClient();

  static Future<List<Brand>> fetchBrands() async {
    final response = await client.get(Uri.parse('$baseUrl/brands'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Brand.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load brands');
    }
  }

  static Future<bool> createBrand(String name, String logo) async {
    final response = await client.post(
      Uri.parse('$baseUrl/brand'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'logo': logo}),
    );
    return response.statusCode == 201;
  }

  static Future<List<Brand>> fetchBrandsByCategory(String categoryId) async {
    final response = await client
        .get(Uri.parse('$baseUrl/by-category?category=$categoryId'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Brand.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load brands by category');
    }
  }
}
