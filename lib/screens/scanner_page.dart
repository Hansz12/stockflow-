import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  final Function(String) onScan;

  const BarcodeScannerPage({super.key, required this.onScan});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool isScanned = false; // Elak scan berkali-kali dalam 1 saat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: false,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (!isScanned && barcode.rawValue != null) {
              isScanned = true;
              final code = barcode.rawValue!;

              // Tutup scanner dan hantar code
              Navigator.pop(context);
              widget.onScan(code);
              break;
            }
          }
        },
      ),
    );
  }
}