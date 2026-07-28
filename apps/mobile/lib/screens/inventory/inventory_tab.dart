import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MobileInventoryTab extends StatelessWidget {
  const MobileInventoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Catalog', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search SKU or Barcode...',
              prefixIcon: const Icon(Icons.search, size: 18),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildInventoryCard('Wireless Ergonomic Mouse', 'SKU-LOG-001', 45, 'Pcs'),
          _buildInventoryCard('USB-C Fast Charger 65W', 'SKU-CHG-065', 8, 'Pcs'),
          _buildInventoryCard('A4 Premium Copy Paper Box', 'SKU-PAP-A4', 120, 'Box'),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(String name, String sku, int stock, String unit) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text('SKU: $sku', style: const TextStyle(fontSize: 11)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: stock < 10 ? Colors.red.shade50 : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$stock $unit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: stock < 10 ? Colors.redAccent : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
