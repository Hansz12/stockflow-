import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/supplier_model.dart';

class SuppliersPage extends StatelessWidget {
  final List<Supplier> suppliers;
  const SuppliersPage({super.key, required this.suppliers});

  Future<void> _launchWhatsApp(String phone, String name) async {
    var cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    // Guna nombor fallback jika testing di simulator
    final url = Uri.parse("https://wa.me/$cleanPhone?text=Hi $name, I would like to order stock.");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Cannot launch WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: suppliers.length + 1,
      itemBuilder: (context, index) {
        if (index == suppliers.length) {
          return Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!, style: BorderStyle.solid),
            ),
            child: const Center(child: Text("+ Add New Supplier", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
          );
        }

        final sup = suppliers[index];
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