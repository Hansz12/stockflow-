import 'package:flutter/material.dart';
import '../models/product_model.dart';

class InventoryPage extends StatelessWidget {
  final List<Product> inventory;

  const InventoryPage({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: inventory.isEmpty
              ? const Center(child: Text("No items yet. Scan to add!", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: inventory.length,
            itemBuilder: (context, index) {
              final item = inventory[index];
              final isLow = item.stock <= item.minStock;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: isLow ? Colors.red : Colors.teal, width: 4)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("${item.category} • RM ${item.price.toStringAsFixed(2)}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        if (isLow)
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(4)),
                            child: const Text("Critical Stock!", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${item.stock}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isLow ? Colors.red : Colors.black)),
                        const Text("Units", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}