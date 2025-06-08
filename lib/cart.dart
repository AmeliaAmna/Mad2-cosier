import 'package:flutter/material.dart';
import 'checkout.dart';
import 'services/cart_service.dart';
import 'config.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      
      final items = await CartService.getCartItems();
      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _incrementQuantity(int index) async {
    try {
      final item = cartItems[index];
      final newQuantity = item['quantity'] + 1;
      
      await CartService.updateCartItem(item['id'], newQuantity);
      
      setState(() {
        cartItems[index]['quantity'] = newQuantity;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: $e')),
      );
    }
  }

  Future<void> _decrementQuantity(int index) async {
    try {
      final item = cartItems[index];
      if (item['quantity'] > 1) {
        final newQuantity = item['quantity'] - 1;
        
        await CartService.updateCartItem(item['id'], newQuantity);
        
        setState(() {
          cartItems[index]['quantity'] = newQuantity;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: $e')),
      );
    }
  }

  Future<void> _removeProduct(int index) async {
    try {
      final item = cartItems[index];
      await CartService.removeFromCart(item['id']);
      
      setState(() {
        cartItems.removeAt(index);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: _loadCartItems,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    double subtotal = cartItems.fold<double>(
      0,
      (sum, item) => sum + (double.parse(item['product']['price'].toString()) * item['quantity']),
    );
    double shippingFee = 300;
    double total = subtotal + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("CART"),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cartItems.isEmpty
            ? const Center(child: Text("Your cart is empty."))
            : ListView(
                children: [
                  ...cartItems.map((item) {
                    int index = cartItems.indexOf(item);
                    final product = item['product'];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "${Config.imageBaseUrl}/${product['image']}",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported, size: 50),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product['name'],
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text("Size: ${item['size'] ?? 'M'}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _decrementQuantity(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Icon(Icons.remove, size: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('${item['quantity']}',
                                            style: const TextStyle(fontSize: 16)),
                                      ),
                                      GestureDetector(
                                        onTap: () => _incrementQuantity(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Icon(Icons.add, size: 16),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("LKR ${double.parse(product['price'].toString()) * item['quantity']}",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeProduct(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Subtotal", style: TextStyle(fontSize: 16)),
                      Text("LKR ${subtotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Shipping Fee", style: TextStyle(fontSize: 16)),
                      Text("LKR ${shippingFee.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("LKR ${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CheckoutPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text("Proceed to Checkout"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
