import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/product_model.dart';
import '../../core/services/product_service.dart';

class MobileInventoryTab extends StatefulWidget {
  const MobileInventoryTab({super.key});

  @override
  State<MobileInventoryTab> createState() => _MobileInventoryTabState();
}

class _MobileInventoryTabState extends State<MobileInventoryTab> {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final items = await ProductService.fetchProducts();
    if (!mounted) return;
    setState(() {
      _products = items;
      _filteredProducts = items;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        final q = query.toLowerCase();
        _filteredProducts = _products.where((p) {
          return p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Catalog API', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadProducts,
            tooltip: 'Sync API Catalog',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
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
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
          else
            ..._filteredProducts.map((p) => _buildInventoryCard(p.name, p.sku, p.currentStock, p.unit)),
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
