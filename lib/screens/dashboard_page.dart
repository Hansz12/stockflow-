import 'package:flutter/material.dart';
import '../models/product_model.dart';

class DashboardPage extends StatelessWidget {
  final List<Product> inventory;
  final VoidCallback onAddPressed;
  final Function(int) onTabChange;

  const DashboardPage({
    super.key,
    required this.inventory,
    required this.onAddPressed,
    required this.onTabChange
  });

  @override
  Widget build(BuildContext context) {
    int lowStock = inventory.where((i) => i.stock <= i.minStock).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Items', '${inventory.length}', Icons.inventory, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Low Stock', '$lowStock', Icons.warning_amber_rounded, Colors.red)),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(Icons.add, "Add Item", Colors.teal, onAddPressed),
              _buildActionButton(Icons.phone, "Order Stock", Colors.green, () => onTabChange(2)), // Index 2 is Supplier
              _buildActionButton(Icons.trending_up, "Trends", Colors.purple, () => onTabChange(3)), // Index 3 is Report
            ],
          ),
          const SizedBox(height: 24),
          // Placeholder activity
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Text("Recent activity will appear here...", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("StockFlow Business", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        CircleAvatar(backgroundColor: Colors.teal[100], child: const Text("NA", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.1))),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}