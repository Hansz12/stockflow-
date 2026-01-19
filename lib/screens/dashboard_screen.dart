import 'package:flutter/material.dart';
import '../models/product.dart';
import 'inventory_screen.dart'; // To access AddProductModal

class DashboardScreen extends StatelessWidget {
  final List<Product> inventory;
  final Function(int) onTabChange;

  const DashboardScreen({super.key, required this.inventory, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    int lowStockCount = inventory.where((i) => i.stock <= i.min).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats Cards
        Row(
          children: [
            Expanded(child: _buildStatCard(
              icon: Icons.inventory_2, iconColor: Colors.blue, bgIconColor: Colors.blue.shade50,
              label: "Total Items", value: inventory.length.toString(),
            )),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(
              icon: Icons.warning_amber_rounded, iconColor: Colors.red, bgIconColor: Colors.red.shade50,
              label: "Low Stock", value: lowStockCount.toString(), isAlert: true,
            )),
          ],
        ),
        const SizedBox(height: 24),

        // Quick Actions
        const Text("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildActionButton(Icons.add, "Add Item", Colors.teal, () {
                showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => const AddProductModal());
              }),
              const SizedBox(width: 12),
              _buildActionButton(Icons.smartphone, "Order Stock", Colors.green, () => onTabChange(2)),
              const SizedBox(width: 12),
              _buildActionButton(Icons.trending_up, "View Trends", Colors.purple, () => onTabChange(3)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Recent Activity
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recent Activity", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildActivityItem(Colors.green, "Stock In: Fresh Milk", "10:45 AM • +20 Units"),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 12),
              _buildActivityItem(Colors.orange, "Sale: Arabica Coffee", "09:30 AM • -2 Units"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required IconData icon, required Color iconColor, required Color bgIconColor, required String label, required String value, bool isAlert = false}) {
    return Container(
      height: 130, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: isAlert ? Border.all(color: Colors.red.shade100) : null,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgIconColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: isAlert ? Colors.red : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Text(value, style: TextStyle(color: isAlert ? Colors.red : Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color), const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      ],
    );
  }
}