import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class InventoryScreen extends StatefulWidget {
  final List<Product>? inventory; // Optional now
  const InventoryScreen({super.key, this.inventory});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> _productsStream;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _productsStream = _supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .order('name', ascending: true);
  }

  Future<void> _updateStock(int id, int currentStock, int change, String itemName) async {
    final newStock = currentStock + change;
    if (newStock >= 0) {
      try {
        // Update DB
        await _supabase.from('products').update({'stock': newStock}).eq('id', id);
        // Record Activity
        final type = change > 0 ? 'IN' : 'OUT';
        final desc = change > 0 ? 'Restock: $itemName' : 'Sold: $itemName';
        await _supabase.from('activities').insert({'description': desc, 'type': type});
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error updating"), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await _supabase.from('products').delete().eq('id', id);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item Deleted"), backgroundColor: Colors.orange));
    } catch (e) { /* handle error */ }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search products from cloud...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),

        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _productsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

              final products = snapshot.data!;
              final filtered = products.where((p) => (p['name'] as String).toLowerCase().contains(_searchQuery)).toList();

              if (filtered.isEmpty) return const Center(child: Text("No products found.", style: TextStyle(color: Colors.grey)));

              return ListView.separated(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  final item = filtered[i];
                  final id = item['id'];
                  final name = item['name'];
                  final stock = item['stock'];
                  final price = item['price'];
                  final minLevel = item['min_level'] ?? 5;
                  final isLow = stock <= minLevel;

                  return Dismissible(
                    key: Key(id.toString()),
                    background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                    confirmDismiss: (_) async => await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Delete Item?"),
                        content: Text("Delete $name permanently?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Cancel")),
                          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ),
                    onDismissed: (_) => _deleteProduct(id),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(left: BorderSide(color: isLow ? Colors.red : const Color(0xFF0F766E), width: 4)),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text("RM ${price.toString()}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                if (isLow) const Text("Critical Stock!", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: () => _updateStock(id, stock, -1, name), icon: const Icon(Icons.remove_circle_outline, color: Colors.red)),
                              SizedBox(width: 40, child: Text(stock.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isLow ? Colors.red : Colors.black87))),
                              IconButton(onPressed: () => _updateStock(id, stock, 1, name), icon: const Icon(Icons.add_circle_outline, color: Colors.green)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}