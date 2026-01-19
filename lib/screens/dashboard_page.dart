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
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20), // Top padding for status bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dashboard",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
                  Text("StockFlow Business",
                      style: TextStyle(color: Colors.blueGrey[400], fontSize: 14)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text("NA", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Stats Cards Grid
          Row(
            children: [
              Expanded(child: _buildStatCard(context, 'Total Items', '${inventory.length}', Icons.inventory_2_outlined, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, 'Low Stock', '$lowStock', Icons.warning_amber_rounded, Colors.red, isAlert: lowStock > 0)),
            ],
          ),

          const SizedBox(height: 30),

          // Quick Actions
          Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(context, Icons.add_circle_outline, "Add Item", Colors.teal, onAddPressed),
              _buildActionButton(context, Icons.phone_in_talk_outlined, "Order", Colors.green, () => onTabChange(2)),
              _buildActionButton(context, Icons.analytics_outlined, "Trends", Colors.purple, () => onTabChange(3)),
            ],
          ),

          const SizedBox(height: 30),

          // Recent Activity
          Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                _buildActivityItem("Stock In: Fresh Milk", "10:45 AM • +20 Units", Colors.green),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: Colors.grey[100]),
                ),
                _buildActivityItem("Sale: Arabica Coffee", "09:30 AM • -2 Units", Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 100), // Extra space for FAB
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color, {bool isAlert = false}) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isAlert ? Border.all(color: color.withOpacity(0.3), width: 2) : null,
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 3)
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey[800], fontSize: 15)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        )
      ],
    );
  }
}