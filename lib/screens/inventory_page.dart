import 'package:flutter/material.dart';
import '../models/product_model.dart';

class InventoryPage extends StatefulWidget {
  final List<Product> inventory;

  const InventoryPage({super.key, required this.inventory});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  // List untuk simpan hasil carian/filter
  List<Product> _filteredList = [];
  String _searchQuery = "";
  String _selectedFilter = "All"; // All, Low Stock, Beverages, etc.

  @override
  void initState() {
    super.initState();
    _filteredList = widget.inventory;
  }

  // Fungsi Logic Carian & Filter
  void _runFilter(String query, String filter) {
    List<Product> results = [];

    if (query.isEmpty) {
      results = widget.inventory;
    } else {
      results = widget.inventory
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    // Apply Category Filter
    if (filter == "Low Stock") {
      results = results.where((item) => item.stock <= item.minStock).toList();
    } else if (filter != "All") {
      results = results.where((item) => item.category == filter).toList();
    }

    setState(() {
      _filteredList = results;
      _searchQuery = query;
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan list unik kategori untuk Filter Chips
    final categories = ["All", "Low Stock", ...widget.inventory.map((e) => e.category).toSet().toList()];

    return Column(
      children: [
        // --- SEARCH BAR & FILTERS ---
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input
              TextField(
                onChanged: (value) => _runFilter(value, _selectedFilter),
                decoration: InputDecoration(
                  hintText: 'Search product name...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0D9488)),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips (Scrollable)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = _selectedFilter == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0D9488),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                        ),
                        onSelected: (bool selected) {
                          if (selected) _runFilter(_searchQuery, cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // --- LIST VIEW ---
        Expanded(
          child: _filteredList.isEmpty
              ? Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text("No products found", style: TextStyle(color: Colors.grey[400])),
            ],
          ))
              : ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 100),
            physics: const BouncingScrollPhysics(),
            itemCount: _filteredList.length,
            itemBuilder: (context, index) {
              final item = _filteredList[index];
              final isLow = item.stock <= item.minStock;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                  border: isLow ? Border.all(color: Colors.red.withOpacity(0.3)) : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // 1. Icon Box
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: isLow ? Colors.red[50] : const Color(0xFF0D9488).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isLow ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                          color: isLow ? Colors.red : const Color(0xFF0D9488),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 2. Info Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)
                            ),
                            const SizedBox(height: 4),
                            // Category Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                              child: Text(item.category, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                            ),
                            const SizedBox(height: 4),
                            Text("RM ${item.price.toStringAsFixed(2)}",
                                style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 13)
                            ),
                          ],
                        ),
                      ),

                      // 3. Quick Actions (Stock +/-)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              _buildQuickBtn(Icons.remove, Colors.red, () {
                                // Logic to decrease logic (In real app, update DB)
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("${item.stock}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isLow ? Colors.red : Colors.black87
                                    )
                                ),
                              ),
                              _buildQuickBtn(Icons.add, Colors.green, () {
                                // Logic to increase
                              }),
                            ],
                          ),
                          if (isLow)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, right: 4),
                              child: Text("Low Stock", style: TextStyle(fontSize: 10, color: Colors.red[400], fontWeight: FontWeight.bold)),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper untuk butang kecil +/-
  Widget _buildQuickBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}