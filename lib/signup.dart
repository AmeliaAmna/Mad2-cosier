import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login.dart';
import 'home.dart'; // ✅ Import HomeScreen

class SignUpPage extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("SIGN UP FOR COSIER ACCOUNT", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: "First Name", labelStyle: TextStyle(fontSize: 12), border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: "Last Name", labelStyle: TextStyle(fontSize: 12), border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email", labelStyle: TextStyle(fontSize: 12), border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password", labelStyle: TextStyle(fontSize: 12), border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: auth.isLoading
    ? null
    : () async {
        bool success = await auth.signup(
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error ?? 'Signup failed')));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      },

                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  child: auth.isLoading ? const CircularProgressIndicator() : const Text("SIGN UP", style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
                child: const Text("OR LOGIN", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
