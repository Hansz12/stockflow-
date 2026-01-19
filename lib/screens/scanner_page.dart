import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  final Function(String) onScan;

  const BarcodeScannerPage({super.key, required this.onScan});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  // Controller untuk kawal kamera & lampu
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
    torchEnabled: false,
  );

  bool isScanned = false; // Elak double scan

  @override
  void dispose() {
    controller.dispose(); // Wajib tutup controller elak memory leak
    super.dispose();
  }

  // Fungsi Input Manual (Jika barcode rosak)
  void _enterManualCode() {
    controller.stop(); // Pause kamera sekejap

    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Input Manual"),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Taip nombor barcode...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.start(); // Sambung kamera
            },
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Navigator.pop(ctx); // Tutup dialog
                Navigator.pop(context); // Tutup scanner page
                widget.onScan(textController.text);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            child: const Text("Simpan"),
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
          // 1. KAMERA (Layer paling bawah)
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (isScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  setState(() => isScanned = true);
                  final code = barcode.rawValue!;

                  if (mounted) {
                    Navigator.pop(context);
                    widget.onScan(code);
                  }
                  break;
                }
              }
            },
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 50),
                    const SizedBox(height: 10),
                    Text("Error: ${error.errorCode}", style: const TextStyle(color: Colors.white)),
                  ],
                ),
              );
            },
          ),

          // 2. OVERLAY GELAP (Layer Tengah)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    height: 260,
                    width: 260,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. BORDER HIJAU/TEAL (Layer Atas)
          Center(
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.add, color: Colors.white54, size: 30),
              ),
            ),
          ),

          // 4. HEADER (Back Button)
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 5. TEKS ARAHAN
          const Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Text(
              "Halakan kamera pada barcode",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 5, color: Colors.black)],
              ),
            ),
          ),

          // 6. CONTROL BUTTONS (Manual & Flash)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Butang Manual
                InkWell(
                  onTap: _enterManualCode,
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.keyboard, color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text("Manual", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),

                const SizedBox(width: 60),

                // Butang Flash (YANG DIBETULKAN)
                ValueListenableBuilder(
                  valueListenable: controller, // <--- Dengar terus pada controller
                  builder: (context, state, child) {
                    // Akses torchState dari dalam state controller
                    final isFlashOn = state.torchState == TorchState.on;

                    return InkWell(
                      onTap: () => controller.toggleTorch(),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: isFlashOn ? Colors.yellow : Colors.white24,
                            child: Icon(
                                isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: isFlashOn ? Colors.black : Colors.white
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Flash", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
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
}