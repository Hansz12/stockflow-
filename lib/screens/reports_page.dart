import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ReportsPage extends StatelessWidget {
  final List<Product> inventory;

  const ReportsPage({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    // --- 1. LOGIC PENGIRAAN DATA (ANALYTICS) ---

    // Kira Total Nilai Keseluruhan
    double totalAssetValue = inventory.fold(0, (sum, item) => sum + (item.price * item.stock));

    // Kira Nilai Mengikut Kategori
    Map<String, double> categoryMap = {};
    for (var item in inventory) {
      double value = item.price * item.stock;
      if (categoryMap.containsKey(item.category)) {
        categoryMap[item.category] = categoryMap[item.category]! + value;
      } else {
        categoryMap[item.category] = value;
      }
    }

    // Kira Barangan Low Stock
    int lowStockCount = inventory.where((i) => i.stock <= i.minStock).length;
    double healthPercentage = inventory.isEmpty
        ? 0
        : ((inventory.length - lowStockCount) / inventory.length);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Padding bawah utk elak tertutup
      physics: const BouncingScrollPhysics(),
      children: [
        const Text("Analytics & Reports", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
        const SizedBox(height: 5),
        const Text("Real-time inventory insights", style: TextStyle(color: Colors.grey)),

        const SizedBox(height: 20),

        // --- KAD STATISTIK UTAMA ---
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                  "Categories",
                  "${categoryMap.keys.length}",
                  Icons.category_outlined,
                  Colors.orange
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildSummaryCard(
                  "Stock Health",
                  "${(healthPercentage * 100).toInt()}%",
                  Icons.health_and_safety_outlined,
                  healthPercentage > 0.5 ? Colors.green : Colors.red
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // --- SECTION: VALUE BY CATEGORY (Dinamik) ---
        const Text("Stock Value by Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: categoryMap.entries.map((entry) {
              // Kira peratusan nilai kategori berbanding nilai keseluruhan
              double percentage = totalAssetValue == 0 ? 0 : entry.value / totalAssetValue;

              return _buildLiveProgressBar(
                  entry.key,
                  percentage,
                  entry.value, // Nilai RM
                  _getCategoryColor(entry.key)
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 30),

        // --- SECTION: TOP HIGH VALUE ITEMS ---
        const Text("Highest Value Assets", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 15),
        _buildHighValueList(),
      ],
    );
  }

  // Widget untuk List Barang Paling Mahal (Top 3)
  Widget _buildHighValueList() {
    // Sort barang ikut nilai stok (Mahal -> Murah)
    List<Product> sortedList = List.from(inventory);
    sortedList.sort((a, b) => (b.price * b.stock).compareTo(a.price * a.stock));

    // Ambil Top 3 sahaja
    List<Product> top3 = sortedList.take(3).toList();

    return Column(
      children: top3.map((item) {
        double value = item.price * item.stock;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("${item.stock} units x RM${item.price}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Text(
                  "RM ${value.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488))
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Widget Progress Bar Dinamik
  Widget _buildLiveProgressBar(String label, double percentage, double valueRM, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text("RM ${valueRM.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              // Background Bar
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              // Foreground Bar (Animated)
              LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: 10,
                      width: constraints.maxWidth * percentage,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                    );
                  }
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text("${(percentage * 100).toStringAsFixed(1)}%", style: const TextStyle(fontSize: 10, color: Colors.grey)),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // Helper Warna Random untuk Kategori
  Color _getCategoryColor(String category) {
    // Bagi warna tetap ikut huruf pertama kategori supaya tak berubah-ubah
    final colors = [
      Colors.teal, Colors.orange, Colors.blue, Colors.purple, Colors.pink, Colors.indigo
    ];
    return colors[category.length % colors.length];
  }
}