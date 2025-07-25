import 'dart:convert';
import 'package:studio_projects/Utiles/HTTP/global_http_client.dart';
import '../../Utiles/constants/api_constants.dart';

class CartService {
  static const String baseUrl = ApiConstants.baseUrl + '/cart';
  static final client = GlobalHttpClient();

  static Future<Map<String, dynamic>> getCart() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  static Future<Map<String, dynamic>> addToCart(
      String productId, int quantity, double price) async {
    final response = await client.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'productId': productId,
        'quantity': quantity,
        'price': price,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add to cart');
    }
  }

  static Future<Map<String, dynamic>> updateCartItem(
      String productId, int quantity) async {
    final response = await client.put(
      Uri.parse('$baseUrl/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'productId': productId,
        'quantity': quantity,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update cart item');
    }
  }

  static Future<Map<String, dynamic>> removeFromCart(String productId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/remove'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'productId': productId,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to remove from cart');
    }
  }

  static Future<Map<String, dynamic>> clearCart() async {
    final response = await client.delete(
      Uri.parse('$baseUrl/clear'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to clear cart');
    }
  }
}
