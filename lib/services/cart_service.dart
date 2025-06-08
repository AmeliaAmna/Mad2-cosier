import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class CartService {
  static const String baseUrl = Config.apiBaseUrl;

  // Get headers with Bearer token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get all cart items
  static Future<List<dynamic>> getCartItems() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Add item to cart
  static Future<Map<String, dynamic>> addToCart(int productId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: headers,
        body: jsonEncode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        throw Exception('Failed to add item to cart');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update cart item quantity
  static Future<Map<String, dynamic>> updateCartItem(int cartItemId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/cart/$cartItemId'),
        headers: headers,
        body: jsonEncode({
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        throw Exception('Failed to update cart item');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Remove item from cart
  static Future<void> removeFromCart(int cartItemId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/$cartItemId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        print('Error ${response.statusCode}: ${response.body}');
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Save auth token after login
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear token on logout
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get token (optional utility)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
