import 'dart:convert';
import 'package:studio_projects/Utiles/HTTP/global_http_client.dart';
import '../../Utiles/constants/api_constants.dart';

class WishlistService {
  static const String baseUrl = ApiConstants.baseUrl + '/wishlist';
  static final client = GlobalHttpClient();

  static Future<List<dynamic>> getWishlist() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'] ?? [];
    } else {
      throw Exception('Failed to fetch wishlist');
    }
  }

  static Future<void> addToWishlist(String productId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'productId': productId}),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add to wishlist');
    }
  }

  static Future<void> removeFromWishlist(String productId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/remove'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'productId': productId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove from wishlist');
    }
  }

  static Future<void> toggleWishlist(String productId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/toggle'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'productId': productId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to toggle wishlist');
    }
  }
}
