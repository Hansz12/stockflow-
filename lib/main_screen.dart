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

  // --- DATA STATE DISIMPAN DI SINI AGAR KEKAL BILA TUKAR PAGE ---
  List<Product> inventory = [
    Product(id: '1', name: 'Premium Arabica Coffee', category: 'Beverages', stock: 5, minStock: 10, price: 35.00),
    Product(id: '2', name: 'FarmFresh Fresh Milk', category: 'Dairy', stock: 45, minStock: 20, price: 7.50),
    Product(id: '3', name: 'Brown Sugar 1kg', category: 'Raw Material', stock: 8, minStock: 15, price: 4.20),
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
      SnackBar(content: Text('${product.name} berjaya ditambah!'), backgroundColor: Colors.teal),
    );
  }

  void _handleBarcodeScan(String code) {
    // 1. Cari jika produk sudah wujud
    final existingIndex = inventory.indexWhere((p) => p.barcode == code);

    if (existingIndex != -1) {
      // 2. Jika wujud, tambah stok sahaja
      setState(() {
        inventory[existingIndex].stock += 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok ditambah: ${inventory[existingIndex].name} (+1)'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // 3. Jika baru, buka form untuk isi nama
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            top: 20, left: 20, right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scannedCode != null ? 'Produk Baru Dikesan!' : 'Tambah Produk',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            if (scannedCode != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text('Barcode: $scannedCode', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 15),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Produk', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Harga (RM)', border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stok Awal', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
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
                child: const Text('Simpan Produk'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Susun pages dalam list
    final List<Widget> pages = [
      DashboardPage(inventory: inventory, onAddPressed: () => _showAddProductDialog(), onTabChange: _onItemTapped),
      InventoryPage(inventory: inventory),
      SuppliersPage(suppliers: suppliers),
      ReportsPage(inventory: inventory),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('StockFlow', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications, color: Colors.white))
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      // Butang Scan Terapung
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BarcodeScannerPage(onScan: _handleBarcodeScan),
          ));
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Suppliers'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
        ],
      ),
    );
  }
}