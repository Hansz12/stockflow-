import 'package:flutter/material.dart';
import 'models/product.dart';
import 'models/supplier.dart';
import 'screens/dashboard_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/supplier_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/scanner_screen.dart';

void main() {
  runApp(const StockFlowApp());
}

class StockFlowApp extends StatelessWidget {
  const StockFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E), // Teal 700
          secondary: Colors.orange,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _showScanner = false;

  // --- MOCK DATA ---
  // Data ini kekal di sini supaya boleh dikongsi antara screen
  final List<Product> _inventory = [
    Product(id: 1, name: 'Premium Arabica Coffee', stock: 5, min: 10, price: 35.00, category: 'Beverages'),
    Product(id: 2, name: 'FarmFresh Fresh Milk', stock: 45, min: 20, price: 7.50, category: 'Dairy'),
    Product(id: 3, name: 'Brown Sugar 1kg', stock: 8, min: 15, price: 4.20, category: 'Raw Material'),
    Product(id: 4, name: 'Paper Cups 12oz', stock: 150, min: 50, price: 0.30, category: 'Packaging'),
  ];

  final List<Supplier> _suppliers = [
    Supplier(id: 1, name: 'Jaya Coffee Supplier', items: 'Coffee Beans, Sugar', phone: '60123456789'),
    Supplier(id: 2, name: 'Dairy King Supplies', items: 'Milk, Cheese', phone: '60198765432'),
  ];

  @override
  void initState() {
    super.initState();
    // Simulate low stock check on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int lowStockCount = _inventory.where((i) => i.stock <= i.min).length;
      if (lowStockCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Warning: $lowStockCount items are below minimum level!'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          ),
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanner) {
      return ScannerScreen(onClose: () => setState(() => _showScanner = false));
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _showScanner = true),
        backgroundColor: Colors.orange,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    String title = "Dashboard";
    bool showProfile = true;

    switch (_selectedIndex) {
      case 0: title = "Dashboard"; break;
      case 1: title = "Inventory"; break;
      case 2: title = "Suppliers"; break;
      case 3: title = "Reports"; showProfile = false; break;
    }

    int lowStockCount = _inventory.where((i) => i.stock <= i.min).length;

    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
      decoration: const BoxDecoration(
        color: Color(0xFF0F766E), // Teal 700
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const Text("StockFlow Business", style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
            ],
          ),
          if (showProfile)
            Row(
              children: [
                Stack(
                  children: [
                    const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                    if (lowStockCount > 0)
                      Positioned(
                        right: 0, top: 0,
                        child: Container(
                          width: 12, height: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0F766E), width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 15),
                Container(
                  width: 35, height: 35,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.teal.shade400, width: 2),
                  ),
                  child: Center(child: Text("NA", style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold))),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return DashboardScreen(inventory: _inventory, onTabChange: _onItemTapped);
      case 1: return InventoryScreen(inventory: _inventory);
      case 2: return SupplierScreen(suppliers: _suppliers);
      case 3: return ReportsScreen();
      default: return const Center(child: Text("Page Not Found"));
    }
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, "Home", 0),
            _buildNavItem(Icons.inventory_2_outlined, "Stock", 1),
            const SizedBox(width: 40), // Spacer for FAB
            _buildNavItem(Icons.people_alt_outlined, "Contact", 2),
            _buildNavItem(Icons.bar_chart_rounded, "Reports", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFF0F766E) : Colors.grey, size: 26),
          Text(label, style: TextStyle(
            color: isActive ? const Color(0xFF0F766E) : Colors.grey,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          )),
        ],
      ),
    );
  }
}