import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class Product {
   final int id;  
  final String name;
  final String price;
  final String image;
  final String description;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      price: "LKR ${json['price']}",
      image: "${Config.imageBaseUrl}/${json['image']}",
      description: json['description'] ?? 'No description available',
      sizes: List<String>.from(json['sizes'] ?? ['XS', 'S', 'M', 'L', 'XL']),
    );
  }
}

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}