import 'dart:convert';
import 'package:studio_projects/Utiles/HTTP/global_http_client.dart';

import '../../Features/Shop/Models/product.dart';
import '../../Utiles/constants/api_constants.dart';

class ProductService {
  static const String baseUrl = ApiConstants.baseUrl + '/products';
  static final client = GlobalHttpClient();

  static Future<List<Product>> fetchProducts() async {
    final response = await client.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<bool> createProduct(Map<String, dynamic> productData) async {
    final response = await client.post(
      Uri.parse('$baseUrl/product'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );
    return response.statusCode == 201;
  }
}
