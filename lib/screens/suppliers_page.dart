import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/supplier_model.dart';

class SuppliersPage extends StatefulWidget {
  final List<Supplier> suppliers;
  // Callback ini penting supaya data disimpan ke Main Screen
  final Function(Supplier) onAddSupplier;

  const SuppliersPage({
    super.key,
    required this.suppliers,
    required this.onAddSupplier
  });

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {

  // --- FUNGSI WHATSAPP ---
  Future<void> _launchWhatsApp(String phone, String name) async {
    // Bersihkan nombor
    var cleanPhone = phone.replaceAll(RegExp(r'\D'), '');

    // Auto tambah 60 jika user isi 01...
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '60${cleanPhone.substring(1)}';
    }

    final url = Uri.parse("https://wa.me/$cleanPhone?text=Hi $name, I would like to order stock.");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Cannot launch WhatsApp");
    }
  }

  // --- FUNGSI TAMBAH SUPPLIER (DIALOG) ---
  void _showAddDialog() {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final itemC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Supplier"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Company Name")),
            TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Phone (e.g. 0123456789)")),
            TextField(controller: itemC, decoration: const InputDecoration(labelText: "Items (e.g. Milk)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameC.text.isNotEmpty && phoneC.text.isNotEmpty) {
                // 1. Buat data baru
                final newSup = Supplier(
                  id: DateTime.now().toString(),
                  name: nameC.text,
                  items: itemC.text,
                  phone: phoneC.text,
                );

                // 2. Hantar ke Main Screen supaya simpan
                widget.onAddSupplier(newSup);

                Navigator.pop(ctx); // Tutup dialog
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.suppliers.length + 1,
      itemBuilder: (context, index) {

        // --- BUTTON ADD NEW (Item Terakhir) ---
        if (index == widget.suppliers.length) {
          return InkWell( // Guna InkWell supaya boleh tekan
            onTap: _showAddDialog,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!, style: BorderStyle.solid),
              ),
              child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(width: 8),
                      Text("Add New Supplier", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  )
              ),
            ),
          );
        }

        final sup = widget.suppliers[index];

        // --- KAD LIST SUPPLIER ---
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sup.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const CircleAvatar(radius: 16, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white, size: 20)),
                ],
              ),
              const SizedBox(height: 4),
              Text(sup.items, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: () => _launchWhatsApp(sup.phone, sup.name),
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text("WhatsApp Order"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}