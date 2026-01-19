import 'package:flutter/material.dart';
import '../models/product.dart';

class InventoryScreen extends StatelessWidget {
  final List<Product> inventory;
  const InventoryScreen({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products or scan...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: const Icon(Icons.qr_code_scanner, color: Colors.grey),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
            itemCount: inventory.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final item = inventory[i];
              final isLow = item.stock <= item.min;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: isLow ? Colors.red : const Color(0xFF0F766E), width: 4)),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text("${item.category} • RM ${item.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        if (isLow) Container(
                          margin: const EdgeInsets.only(top: 6), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                          child: const Text("Critical Stock!", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.stock.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isLow ? Colors.red : Colors.black87)),
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

// Modal Add Product kita letak sekali di sini atau dalam file widgets/ asing
class AddProductModal extends StatelessWidget {
  const AddProductModal({super.key});
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
          const TextField(decoration: InputDecoration(labelText: "Product Name", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const Row(children: [
            Expanded(child: TextField(decoration: InputDecoration(labelText: "Initial Stock", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
            SizedBox(width: 12),
            Expanded(child: TextField(decoration: InputDecoration(labelText: "Price (RM)", border: OutlineInputBorder()), keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Save Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}