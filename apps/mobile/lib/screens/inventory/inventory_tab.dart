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
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  final List<String> _categories = ['All', 'Electronics', 'Accessories', 'Paper & Office'];

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
    _filterCatalog(query, _selectedCategory);
  }

  void _filterCatalog(String query, String category) {
    setState(() {
      _selectedCategory = category;
      List<ProductModel> temp = _products;

      if (category != 'All') {
        if (category == 'Electronics') {
          temp = temp.where((p) => p.name.contains('Charger') || p.name.contains('Mouse')).toList();
        } else if (category == 'Paper & Office') {
          temp = temp.where((p) => p.name.contains('Paper') || p.name.contains('Box')).toList();
        }
      }

      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        temp = temp.where((p) => p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q)).toList();
      }

      _filteredProducts = temp;
    });
  }

  void _openAddProductModal() {
    final nameController = TextEditingController();
    final skuController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add New Product SKU', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  filled: true,
                  fillColor: AppColors.bgLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: skuController,
                decoration: InputDecoration(
                  labelText: 'SKU Code (e.g. SKU-100)',
                  filled: true,
                  fillColor: AppColors.bgLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Selling Price (₹)',
                  filled: true,
                  fillColor: AppColors.bgLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Initial Stock Quantity',
                  filled: true,
                  fillColor: AppColors.bgLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && skuController.text.isNotEmpty) {
                final newProduct = ProductModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  sku: skuController.text.toUpperCase(),
                  buyPrice: (double.tryParse(priceController.text) ?? 100) * 0.7,
                  sellPrice: double.tryParse(priceController.text) ?? 100,
                  currentStock: int.tryParse(stockController.text) ?? 10,
                );
                setState(() {
                  _products.insert(0, newProduct);
                  _filteredProducts.insert(0, newProduct);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Product SKU ${newProduct.sku} Created!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Save Product'),
          ),
        ],
      ),
    );
  }

  void _openStockAdjustmentModal(ProductModel product) {
    final stockController = TextEditingController(text: '${product.currentStock}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Adjust Stock: ${product.sku}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 12),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'New Stock Quantity (${product.unit})',
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final newStock = int.tryParse(stockController.text) ?? product.currentStock;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Stock updated for ${product.sku}: $newStock ${product.unit}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Save Stock'),
          ),
        ],
      ),
    );
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
            icon: const Icon(Icons.add_box_outlined, color: AppColors.primary),
            onPressed: _openAddProductModal,
            tooltip: 'Add Product SKU',
          ),
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
          const SizedBox(height: 10),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(cat, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textDark)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    onSelected: (val) {
                      if (val) _filterCatalog(_searchController.text, cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
          else
            ..._filteredProducts.map((p) => _buildInventoryCard(p)),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(ProductModel p) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text('SKU: ${p.sku} • ₹${p.sellPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _openStockAdjustmentModal(p),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: p.currentStock < 10 ? Colors.red.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${p.currentStock} ${p.unit}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: p.currentStock < 10 ? Colors.redAccent : AppColors.primary,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_note, size: 20, color: AppColors.textMuted),
              onPressed: () => _openStockAdjustmentModal(p),
            ),
          ],
        ),
      ),
    );
  }
}
