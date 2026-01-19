import 'package:flutter/material.dart';
import '../models/product.dart';

class InventoryScreen extends StatefulWidget {
  final List<Product> inventory;
  const InventoryScreen({super.key, required this.inventory});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Logic to update stock live
  void _updateStock(int index, int change) {
    setState(() {
      int currentStock = widget.inventory[index].stock;
      int newStock = currentStock + change;

      if (newStock >= 0) {
        // Create new object to update list reference
        Product old = widget.inventory[index];
        widget.inventory[index] = Product(
            id: old.id,
            name: old.name,
            stock: newStock,
            min: old.min,
            price: old.price,
            category: old.category
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products or scan...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),

        // Product List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
            itemCount: widget.inventory.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final item = widget.inventory[i];
              final isLow = item.stock <= item.min;

              return Container(
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
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text("RM ${item.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          if (isLow) const Text("Critical Stock!", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    // Interactive Buttons (+/-)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _updateStock(i, -1),
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            item.stock.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isLow ? Colors.red : Colors.black87),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _updateStock(i, 1),
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                        ),
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

// Modal for adding product (Visual Placeholder)
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