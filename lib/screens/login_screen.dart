import 'package:flutter/material.dart';
import '../main.dart'; // Import main to navigate to MainScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _workerIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() {
    setState(() {
      _isLoading = true;
    });

    // Simulate database check (1.5 seconds)
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });

      // Basic Validation
      if (_workerIdController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
        // Navigate to MainScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please enter Worker ID and Password"),
              backgroundColor: Colors.red
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.inventory_2, size: 50, color: Color(0xFF0F766E)),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                "Staff Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
              ),
              const Text(
                "Enter your Worker ID to continue",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Input Worker ID
              TextField(
                controller: _workerIdController,
                textCapitalization: TextCapitalization.characters, // Auto CAPS
                decoration: InputDecoration(
                  labelText: "Worker ID",
                  hintText: "e.g. STAF001",
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Input Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),

              // Footer
              const SizedBox(height: 24),
              const Text("StockFlow System v1.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}