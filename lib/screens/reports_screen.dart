import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [Icon(Icons.trending_up, color: Color(0xFF0F766E)), SizedBox(width: 8), Text("Best Selling Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
              const SizedBox(height: 20),
              _buildChartBar("Fresh Milk", 0.85, Colors.teal),
              _buildChartBar("Arabica Coffee", 0.60, Colors.teal.shade400),
              _buildChartBar("Paper Cups", 0.45, Colors.teal.shade200),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartBar(String label, double pct, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(fontSize: 12)), Text("${(pct * 100).toInt()}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: Colors.grey.shade100, color: color),
          ),
        ],
      ),
    );
  }
}