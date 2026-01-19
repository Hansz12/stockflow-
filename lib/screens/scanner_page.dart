import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  final Function(String) onScan;

  const BarcodeScannerPage({super.key, required this.onScan});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> with SingleTickerProviderStateMixin {
  // Controller Kamera
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
    torchEnabled: false,
  );

  bool isScanned = false;
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Setup Laser Animation (Gerak turun naik 2 saat)
    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animController);
  }

  @override
  void dispose() {
    controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  // Fungsi Manual Input
  void _enterManualCode() {
    controller.stop();
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Input Manual", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Nombor Barcode...",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.start();
            },
            child: const Text("Batal", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Navigator.pop(ctx);
                Navigator.pop(context);
                widget.onScan(textController.text);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. KAMERA
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (!isScanned && capture.barcodes.isNotEmpty) {
                final barcode = capture.barcodes.first;
                if (barcode.rawValue != null) {
                  setState(() => isScanned = true);
                  if (mounted) {
                    Navigator.pop(context);
                    widget.onScan(barcode.rawValue!);
                  }
                }
              }
            },
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam_off, color: Colors.white54, size: 50),
                    const SizedBox(height: 10),
                    const Text("Kamera tidak berfungsi di Emulator", style: TextStyle(color: Colors.white54)),
                    Text("Error: ${error.errorCode}", style: const TextStyle(color: Colors.white24, fontSize: 10)),
                  ],
                ),
              );
            },
          ),

          // 2. GELAP TEPI (Overlay)
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.srcOut),
            child: Stack(
              children: [
                Container(decoration: const BoxDecoration(color: Colors.transparent, backgroundBlendMode: BlendMode.dstOut)),
                Center(child: Container(height: 280, width: 280, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)))),
              ],
            ),
          ),

          // 3. KOTAK OREN & LASER MERAH (Design Belah Kiri)
          Center(
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Bucu Oren (Custom Painter or Simple Borders)
                  // Top Left
                  Positioned(top: 0, left: 0, child: Container(width: 30, height: 30, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.orange, width: 4), left: BorderSide(color: Colors.orange, width: 4))))),
                  // Top Right
                  Positioned(top: 0, right: 0, child: Container(width: 30, height: 30, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.orange, width: 4), right: BorderSide(color: Colors.orange, width: 4))))),
                  // Bottom Left
                  Positioned(bottom: 0, left: 0, child: Container(width: 30, height: 30, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.orange, width: 4), left: BorderSide(color: Colors.orange, width: 4))))),
                  // Bottom Right
                  Positioned(bottom: 0, right: 0, child: Container(width: 30, height: 30, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.orange, width: 4), right: BorderSide(color: Colors.orange, width: 4))))),

                  // Laser Merah Bergerak
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: 280 * _animation.value, // Bergerak dari 0 ke 280
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. HEADER BACK BUTTON
          Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(50)),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),

          // 5. TEKS ARAHAN
          const Positioned(
            bottom: 160,
            left: 0,
            right: 0,
            child: Text(
              "Halakan kamera pada produk",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),

          // 6. BUTANG FUNGSI (Flash & Manual)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Butang Manual
                _buildFunctionBtn(Icons.keyboard, "Manual", _enterManualCode, false),

                const SizedBox(width: 60),

                // Butang Flash
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, state, child) {
                    final isFlashOn = state.torchState == TorchState.on;
                    return _buildFunctionBtn(
                        isFlashOn ? Icons.flash_on : Icons.flash_off,
                        "Flash",
                            () => controller.toggleTorch(),
                        isFlashOn
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionBtn(IconData icon, String label, VoidCallback onTap, bool isActive) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive ? Colors.orange : Colors.white24,
              shape: BoxShape.circle,
              border: Border.all(color: isActive ? Colors.orange : Colors.white12),
            ),
            child: Icon(icon, color: isActive ? Colors.white : Colors.white70, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}