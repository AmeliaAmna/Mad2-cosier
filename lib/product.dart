import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/cart_service.dart';
import 'checkout.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  String? selectedSize;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _addToCart() async {
    if (selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a size')),
      );
      return;
    }

    try {
      await CartService.addToCart(
        widget.product.id,  // use the product ID here
  quantity,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.product.image,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.product.price,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Size',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widget.product.sizes.map((size) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      size,
                      style: TextStyle(
                        color: selectedSize == size ? Colors.white : Colors.black,
                      ),
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    selected: selectedSize == size,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedSize = selected ? size : null;
                      });
                    },
                    selectedColor: const Color.fromARGB(255, 39, 39, 39),
                    backgroundColor: const Color.fromARGB(236, 51, 51, 51),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quantity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _decrementQuantity,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: const Icon(Icons.remove, color: Colors.black),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      GestureDetector(
                        onTap: _incrementQuantity,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: const Icon(Icons.add, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color.fromARGB(236, 51, 51, 51)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                    ),
                    child: const Text("Add to Cart"),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CheckoutPage()),
  );
},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color.fromARGB(236, 51, 51, 51)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                    ),
                    child: const Text("Buy Now"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}