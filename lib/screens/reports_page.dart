import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ReportsPage extends StatelessWidget {
  final List<Product> inventory;
  const ReportsPage({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Best Selling Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _buildProgressBar("Fresh Milk", 0.85, Colors.teal),
              _buildProgressBar("Arabica Coffee", 0.60, Colors.teal[400]!),
              _buildProgressBar("Paper Cups", 0.45, Colors.teal[200]!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text("${(value * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[100],
            color: color,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }
}