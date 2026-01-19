import 'package:flutter/material.dart';
import '../models/supplier.dart';

class SupplierScreen extends StatelessWidget {
  final List<Supplier> suppliers;
  const SupplierScreen({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...suppliers.map((sup) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sup.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(sup.items, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.people, color: Colors.grey, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening WhatsApp to ${sup.name}...'), backgroundColor: Colors.green),
                        );
                      },
                      icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                      label: const Text("WhatsApp Order", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade100, style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              Text("Add New Supplier", style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Save contact for quick ordering", style: TextStyle(color: Colors.blue.shade600, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}