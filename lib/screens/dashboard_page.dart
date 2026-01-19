import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:intl/intl.dart'; // Pastikan add intl: ^0.19.0 dalam pubspec.yaml jika belum

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

    // Kira Total Nilai Stok (Harga x Kuantiti)
    double totalValue = inventory.fold(0, (sum, item) => sum + (item.price * item.stock));

    // Format duit (RM)
    final currencyFormatter = NumberFormat.currency(locale: 'ms_MY', symbol: 'RM ', decimalDigits: 2);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
      physics: const BouncingScrollPhysics(),
      children: [
        // --- HEADER ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("StockFlow",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                      letterSpacing: -0.5,
                    )
                ),
                Text("Overview & Statistic",
                    style: TextStyle(color: Colors.blueGrey[400], fontSize: 14)),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10)],
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(Icons.notifications_none_rounded, color: Colors.blueGrey[900]),
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),

        // --- NEW: TOTAL ASSET CARD (Nilai Duit) ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF115E59)], // Teal Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D9488).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined, color: Colors.white70, size: 20),
                  SizedBox(width: 8),
                  Text("Total Inventory Value", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                currencyFormatter.format(totalValue),
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "${inventory.length} Products in stock",
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // --- STATS CARDS (GRID) ---
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Items', '${inventory.length}', Icons.inventory_2_outlined, Colors.blue)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Low Stock', '$lowStock', Icons.warning_amber_rounded, Colors.red, isAlert: lowStock > 0)),
          ],
        ),

        const SizedBox(height: 30),

        // --- QUICK ACTIONS ---
        Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(context, Icons.add_circle_outline, "Add Item", const Color(0xFF0D9488), onAddPressed),
            _buildActionButton(context, Icons.qr_code_scanner, "Scan", Colors.orange, () {
              // Aksi Scan (boleh link ke page scanner)
            }),
            _buildActionButton(context, Icons.analytics_outlined, "Reports", const Color(0xFF8B5CF6), () => onTabChange(3)),
          ],
        ),

        const SizedBox(height: 30),

        // --- UPGRADED: RECENT ACTIVITY ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
            Text("View All", style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 5))],
          ),
          child: Column(
            children: [
              _buildActivityItem("Stock In: Fresh Milk", "10:45 AM • +20 Units", Colors.green, true),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: Colors.grey[100]),
              ),
              _buildActivityItem("Sale: Arabica Coffee", "09:30 AM • -2 Units", Colors.orange, false),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: Colors.grey[100]),
              ),
              _buildActivityItem("Sale: Paper Cups", "08:15 AM • -50 Units", Colors.orange, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {bool isAlert = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAlert ? Colors.red[50] : Colors.white, // Background merah nipis jika Low Stock
        borderRadius: BorderRadius.circular(24),
        border: isAlert ? Border.all(color: Colors.red.withOpacity(0.2)) : null,
        boxShadow: [
          BoxShadow(
              color: isAlert ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isAlert ? Colors.white : color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    double width = (MediaQuery.of(context).size.width - 40 - 24) / 3;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(color: Colors.blueGrey[700], fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // Activity Item yang lebih cantik (Ada kotak icon)
  Widget _buildActivityItem(String title, String subtitle, Color color, bool isIn) {
    return Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isIn ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, // Arrow down means stock IN (landing)
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[900], fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}