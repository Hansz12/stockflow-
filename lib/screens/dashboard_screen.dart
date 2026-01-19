import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onTabChange;

  const DashboardScreen({super.key, required this.onTabChange});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> _productsStream;
  late final Future<List<Map<String, dynamic>>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    // 1. Live Stream Products
    _productsStream = _supabase.from('products').stream(primaryKey: ['id']);

    // 2. Recent Activities (Fetch on load)
    _activitiesFuture = _supabase.from('activities').select().order('created_at', ascending: false).limit(3);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _productsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!;
        final totalItems = products.length;
        // Count items where stock <= min_level
        final lowStockCount = products.where((p) {
          final stock = p['stock'] as int? ?? 0;
          final min = p['min_level'] as int? ?? 0;
          return stock <= min;
        }).length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- STATS CARDS (LIVE) ---
            Row(
              children: [
                Expanded(child: _buildStatCard(
                  icon: Icons.inventory_2, iconColor: Colors.blue, bgIconColor: Colors.blue.shade50,
                  label: "Total Items", value: totalItems.toString(),
                )),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(
                  icon: Icons.warning_amber_rounded, iconColor: Colors.red, bgIconColor: Colors.red.shade50,
                  label: "Low Stock", value: lowStockCount.toString(), isAlert: true,
                )),
              ],
            ),
            const SizedBox(height: 24),

            // --- QUICK ACTIONS ---
            const Text("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildActionButton(Icons.add, "Add Item", Colors.teal, () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => const AddProductModalSupabase()
                    );
                  }),
                  const SizedBox(width: 12),
                  _buildActionButton(Icons.smartphone, "Order Stock", Colors.green, () => widget.onTabChange(2)),
                  const SizedBox(width: 12),
                  _buildActionButton(Icons.trending_up, "View Trends", Colors.purple, () => widget.onTabChange(3)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- RECENT ACTIVITY (FROM DB) ---
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
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _activitiesFuture,
                    builder: (context, actSnapshot) {
                      if (actSnapshot.connectionState == ConnectionState.waiting) return const Text("Loading...");
                      if (!actSnapshot.hasData || actSnapshot.data!.isEmpty) return const Text("No recent activity.");

                      return Column(
                        children: actSnapshot.data!.map((act) {
                          final isStockIn = act['type'] == 'IN';
                          return Column(
                            children: [
                              _buildActivityItem(
                                  isStockIn ? Colors.green : Colors.orange,
                                  act['description'] ?? 'Activity',
                                  act['created_at'] != null
                                      ? DateTime.parse(act['created_at']).toString().substring(0, 16)
                                      : 'Just now'
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
        ),
      ],
    );
  }
}

// --- MODAL TO ADD PRODUCT TO SUPABASE ---
class AddProductModalSupabase extends StatefulWidget {
  const AddProductModalSupabase({super.key});

  @override
  State<AddProductModalSupabase> createState() => _AddProductModalSupabaseState();
}

class _AddProductModalSupabaseState extends State<AddProductModalSupabase> {
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveProduct() async {
    setState(() => _isLoading = true);
    final name = _nameController.text;
    final stock = int.tryParse(_stockController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (name.isNotEmpty) {
      // 1. Insert Product
      await Supabase.instance.client.from('products').insert({
        'name': name,
        'stock': stock,
        'price': price,
        'min_level': 5,
        'category': 'General'
      });
      // 2. Insert Activity
      await Supabase.instance.client.from('activities').insert({
        'description': 'New Item: $name',
        'type': 'IN'
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product Saved to Cloud!"), backgroundColor: Colors.green));
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Add New Product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ]),
          const SizedBox(height: 20),
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Product Name", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _stockController, decoration: const InputDecoration(labelText: "Initial Stock", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _priceController, decoration: const InputDecoration(labelText: "Price (RM)", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProduct,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                  : const Text("Save Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}