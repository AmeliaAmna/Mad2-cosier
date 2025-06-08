import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup.dart';
import 'home.dart'; // Import HomeScreen

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

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
              const Text(
                "LOGIN TO YOUR ACCOUNT",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot your password?", style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          bool success = await auth.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(auth.error ?? 'Login failed')),
                            );
                          } else {
                            // ✅ Navigate to HomeScreen on success
                            
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const HomePage()),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: auth.isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("LOG IN", style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
                },
                child: const Text("OR CREATE AN ACCOUNT", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
