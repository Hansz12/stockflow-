import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  final VoidCallback onClose;
  const ScannerScreen({super.key, required this.onClose});

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
                IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white)),
                const Text("Scan Barcode", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.flash_on, color: Colors.white)),
              ],
            ),
          ),
          Positioned(
            bottom: 60, left: 0, right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  onClose();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product detected: Chocolate Syrup (+1 Added)"), backgroundColor: Colors.green));
                },
                child: Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: 4)),
                  child: const Center(child: Icon(Icons.camera_alt, color: Colors.black)),
                ),
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