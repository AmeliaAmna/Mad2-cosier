import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, // Disables the debug banner on top of the app
    home: CheckoutPage(), // Sets the CheckoutPage as the home page
  ));
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Default payment method is set to "Bank"
  String paymentMethod = "Bank";

  @override
  Widget build(BuildContext context) {
    // Determine if the device is in portrait or landscape mode
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")), // Title of the app bar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Adds padding around the content
          child: isPortrait ? _portraitLayout() : _landscapeLayout(),
        ),
      ),
    );
  }

  // Layout for portrait mode: Product details on top and checkout form below, both scrollable
  Widget _portraitLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productDetails(), // Display product details
          const SizedBox(height: 20),
          _checkoutForm(isPortrait: true), // Display the checkout form
        ],
      ),
    );
  }

  // Layout for landscape mode: Checkout form on the left (scrollable) and product details on the right (fixed)
  Widget _landscapeLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: _checkoutForm(isPortrait: false), // Scrollable checkout form
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: _productDetails(), // Fixed product details
        ),
      ],
    );
  }

  // Widget for displaying the product details section
  Widget _productDetails() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/cosier_49.jpg", // Product image
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Long Sleeve Lia Top", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("M", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                const Text("3,200", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Product price
              ],
            ),
            const Divider(),
            _summaryRow("Subtotal", "3,200"),
            _summaryRow("Shipping Fee", "300"),
            const Divider(thickness: 1.5),
            _summaryRow("TOTAL", "3,500", isBold: true), // Total price
          ],
        ),
      ),
    );
  }

  // Widget for displaying the checkout form section
  Widget _checkoutForm({required bool isPortrait}) {
    double fieldHeight = isPortrait ? 55 : 45; // Adjust field height for portrait and landscape

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Contact"),
        _customTextField("Email", fieldHeight), // Email field

        _sectionTitle("Delivery"),
        Row(
          children: [
            Expanded(child: _customTextField("First Name", fieldHeight)),
            const SizedBox(width: 10),
            Expanded(child: _customTextField("Last Name", fieldHeight)),
          ],
        ),
        _customTextField("Address", fieldHeight),
        _customTextField("Apartment/Suite, etc. (Optional)", fieldHeight),
        Row(
          children: [
            Expanded(child: _customTextField("City", fieldHeight)),
            const SizedBox(width: 10),
            Expanded(child: _customTextField("Postal Code", fieldHeight)),
          ],
        ),
        _customTextField("Phone", fieldHeight),

        _sectionTitle("Payment"),
        _paymentOption("Bank (Debit/Credit/Master)", "Bank"), // Payment option for Bank
        _paymentOption("Cash", "Cash"), // Payment option for Cash

        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Show a confirmation dialog when the order is placed
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Order Placed'),
                  content: const Text('Your order has been placed successfully!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const HomePage()), // Redirect to home page
                          (Route<dynamic> route) => false, // Remove all previous routes
                        );
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, fieldHeight),
              backgroundColor: const Color.fromARGB(255, 60, 60, 60), // Dark Gray Button
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text("PAY NOW", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // Widget for creating a custom text input field
  Widget _customTextField(String label, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: height,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        ),
      ),
    );
  }

  // Widget for displaying section titles (like "Contact", "Delivery")
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  // Widget for displaying payment options (Radio buttons)
  Widget _paymentOption(String title, String value) {
    return RadioListTile(
      title: Text(title),
      value: value,
      groupValue: paymentMethod, // Tracks the selected payment method
      activeColor: const Color(0xFF424242), // Dark Gray Selection
      onChanged: (newValue) {
        setState(() {
          paymentMethod = newValue.toString(); // Updates the selected payment method
        });
      },
    );
  }

  // Widget for displaying summary rows like subtotal, shipping fee, total
  Widget _summaryRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(amount, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
