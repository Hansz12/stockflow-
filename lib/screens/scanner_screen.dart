import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  final VoidCallback onClose;
  const ScannerScreen({super.key, required this.onClose});

  void _simulateScan(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text("Product Detected!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("FarmFresh Fresh Milk", style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          content: const Text("Select action to update stock:", textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                onClose();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success: Stock Deducted (-1)"), backgroundColor: Colors.red));
              },
              icon: const Icon(Icons.remove, color: Colors.white),
              label: const Text("Sell"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                onClose();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success: Stock Added (+1)"), backgroundColor: Colors.green));
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Restock"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 280, height: 280,
              decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.5), width: 1), borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: [
                  const Positioned(top: 0, left: 0, child: _CornerMarker()),
                  const Positioned(top: 0, right: 0, child: RotatedBox(quarterTurns: 1, child: _CornerMarker())),
                  const Positioned(bottom: 0, left: 0, child: RotatedBox(quarterTurns: 3, child: _CornerMarker())),
                  const Positioned(bottom: 0, right: 0, child: RotatedBox(quarterTurns: 2, child: _CornerMarker())),
                  Center(child: Container(height: 2, width: 260, color: Colors.red.withOpacity(0.8))),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white, size: 30)),
                const Text("Scan Barcode", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.flash_on, color: Colors.white)),
              ],
            ),
          ),
          Positioned(
            bottom: 60, left: 0, right: 0,
            child: Center(
              child: Column(
                children: [
                  const Text("Point camera at product", style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _simulateScan(context),
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.withOpacity(0.5), width: 6)),
                      child: const Center(child: Icon(Icons.qr_code_scanner, color: Colors.black, size: 40)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  const _CornerMarker();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 40,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.orange, width: 4), left: BorderSide(color: Colors.orange, width: 4)),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
      ),
    );
  }
}