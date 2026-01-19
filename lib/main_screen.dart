import 'package:flutter/material.dart';
import 'screens/dashboard_page.dart';
import 'screens/inventory_page.dart';
import 'screens/suppliers_page.dart';
import 'screens/reports_page.dart';
import 'screens/scanner_page.dart';
import 'models/product_model.dart';
import 'models/supplier_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Initial Data
  List<Product> inventory = [
    Product(id: '1', name: 'Premium Arabica Coffee', category: 'Beverages', stock: 5, minStock: 10, price: 35.00),
    Product(id: '2', name: 'FarmFresh Fresh Milk', category: 'Dairy', stock: 45, minStock: 20, price: 7.50),
    Product(id: '3', name: 'Brown Sugar 1kg', category: 'Raw Material', stock: 8, minStock: 15, price: 4.20),
    Product(id: '4', name: 'Paper Cups 12oz', category: 'Packaging', stock: 150, minStock: 50, price: 0.30),
  ];

  List<Supplier> suppliers = [
    Supplier(id: '1', name: 'Jaya Coffee Supplier', items: 'Coffee Beans, Sugar', phone: '60123456789'),
    Supplier(id: '2', name: 'Dairy King Supplies', items: 'Milk, Cheese', phone: '60198765432'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addNewProduct(Product product) {
    setState(() {
      inventory.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} Added!'), backgroundColor: Colors.teal),
    );
  }

  void _handleBarcodeScan(String code) {
    final existingIndex = inventory.indexWhere((p) => p.barcode == code);

    if (existingIndex != -1) {
      setState(() {
        inventory[existingIndex].stock += 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock Updated: ${inventory[existingIndex].name} (+1)'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _showAddProductDialog(scannedCode: code);
    }
  }

  void _showAddProductDialog({String? scannedCode}) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final categoryController = TextEditingController(text: 'General');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.only(
            top: 25, left: 25, right: 25,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 25
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50, height: 5,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Text(scannedCode != null ? 'New Product Detected!' : 'Add New Product',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),

            if (scannedCode != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code, size: 20, color: Colors.orange),
                    const SizedBox(width: 10),
                    Text('Barcode: $scannedCode', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            _buildTextField(nameController, 'Product Name', Icons.inventory),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildTextField(priceController, 'Price (RM)', Icons.attach_money, isNumber: true)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField(stockController, 'Initial Stock', Icons.numbers, isNumber: true)),
              ],
            ),
            const SizedBox(height: 15),
            _buildTextField(categoryController, 'Category', Icons.category),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: const Color(0xFF0D9488).withOpacity(0.4),
                ),
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    _addNewProduct(Product(
                      id: DateTime.now().toString(),
                      name: nameController.text,
                      category: categoryController.text,
                      stock: int.tryParse(stockController.text) ?? 0,
                      minStock: 5,
                      price: double.tryParse(priceController.text) ?? 0.0,
                      barcode: scannedCode,
                    ));
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Save Product', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardPage(inventory: inventory, onAddPressed: () => _showAddProductDialog(), onTabChange: _onItemTapped),
      InventoryPage(inventory: inventory),
      SuppliersPage(
        suppliers: suppliers,
        onAddSupplier: (newSupplier) { // <--- Tambah ini
          setState(() {
            suppliers.add(newSupplier);
          });
        },
      ),
      ReportsPage(inventory: inventory),
    ];

    return Scaffold(
      extendBody: true, // Key for floating navbar effect
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _currentIndex != 0
          ? AppBar(
        title: Text(
          _currentIndex == 1 ? 'Inventory' : _currentIndex == 2 ? 'Suppliers' : 'Reports',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      )
          : null,

      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),

      floatingActionButton: SizedBox(
        width: 70, height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BarcodeScannerPage(onScan: _handleBarcodeScan),
            ));
          },
          backgroundColor: const Color(0xFFF97316),
          elevation: 10,
          shape: const CircleBorder(),
          child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: BottomAppBar(
          height: 80,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, "Home"),
              _buildNavItem(1, Icons.inventory_2_rounded, "Stock"),
              const SizedBox(width: 48), // Gap for FAB
              _buildNavItem(2, Icons.people_alt_rounded, "Supplier"),
              _buildNavItem(3, Icons.bar_chart_rounded, "Report"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0D9488) : Colors.grey[400],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF0D9488) : Colors.grey[400],
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}