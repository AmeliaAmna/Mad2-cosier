import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class CartService {
  static const String baseUrl = Config.apiBaseUrl;

  // Helper method to get headers
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Get cart items
  static Future<List<dynamic>> getCartItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Add to cart
  static Future<Map<String, dynamic>> addToCart(int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: _getHeaders(),
        body: jsonEncode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add item to cart');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update cart item
  static Future<Map<String, dynamic>> updateCartItem(int cartItemId, int quantity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/cart/$cartItemId'),
        headers: _getHeaders(),
        body: jsonEncode({
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update cart item');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Remove from cart
  static Future<void> removeFromCart(int cartItemId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/$cartItemId'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 