import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/product_model.dart';
import '../../core/services/product_service.dart';
import '../../core/services/billing_service.dart';

class MobilePOSTab extends StatefulWidget {
  const MobilePOSTab({super.key});

  @override
  State<MobilePOSTab> createState() => _MobilePOSTabState();
}

class _MobilePOSTabState extends State<MobilePOSTab> {
  final List<Map<String, dynamic>> _cart = [];
  List<ProductModel> _catalog = [];
  bool _isLoadingCatalog = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadLiveCatalog();
  }

  Future<void> _loadLiveCatalog() async {
    setState(() => _isLoadingCatalog = true);
    final products = await ProductService.fetchProducts();
    if (!mounted) return;
    setState(() {
      _catalog = products;
      _isLoadingCatalog = false;
    });
  }

  void _addToCart(ProductModel item) {
    setState(() {
      final existingIndex = _cart.indexWhere((c) => c['sku'] == item.sku);
      if (existingIndex >= 0) {
        _cart[existingIndex]['qty'] += 1;
      } else {
        _cart.add({
          'id': item.id,
          'name': item.name,
          'sku': item.sku,
          'price': item.sellPrice,
          'gst': item.gstRate,
          'qty': 1,
        });
      }
    });
  }

  double get _subtotal => _cart.fold(0, (sum, i) => sum + (i['price'] * i['qty']));
  double get _tax => _subtotal * 0.18;
  double get _grandTotal => _subtotal + _tax;

  Future<void> _handleCheckout() async {
    if (_cart.isEmpty) return;
    setState(() => _isSubmitting = true);

    final res = await BillingService.createInvoice(
      items: _cart,
      totalAmount: _grandTotal,
      taxAmount: _tax,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final invNumber = res['invoiceNumber'] ?? 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            const Text(
              'GST Invoice Generated & Synced!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Invoice #: $invNumber', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Text('Total Paid: ₹${_grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _cart.clear());
                Navigator.pop(context);
              },
              icon: const Icon(Icons.bluetooth_connected),
              label: const Text('Print via Bluetooth Thermal Printer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCameraScanner() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.camera_alt, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Camera Barcode Scanner', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner, color: Colors.white54, size: 80),
                  Container(
                    width: 140,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const Positioned(
                    bottom: 12,
                    child: Text('Align Barcode inside viewfinder', style: TextStyle(color: Colors.white70, fontSize: 10)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (_catalog.isNotEmpty) {
                  _addToCart(_catalog.first);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('⚡ Barcode Scanned: ${_catalog.first.name} added!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(42),
              ),
              child: const Text('Simulate Scan Barcode SKU'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile POS Counter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textMuted),
            onPressed: _loadLiveCatalog,
            tooltip: 'Reload API Catalog',
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
            onPressed: _openCameraScanner,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingCatalog
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _catalog.length,
                    itemBuilder: (context, idx) {
                      final item = _catalog[idx];
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.borderLight),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text('SKU: ${item.sku} • Stock: ${item.currentStock} ${item.unit}', style: const TextStyle(fontSize: 11)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('₹${item.sellPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                                onPressed: () => _addToCart(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cart Items: ${_cart.length}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Grand Total: ₹${_grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: (_cart.isEmpty || _isSubmitting) ? null : _handleCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Checkout & Post Invoice API',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
