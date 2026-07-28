import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MobilePOSTab extends StatefulWidget {
  final bool isOfflineMode;
  final VoidCallback? onInvoiceCreatedOffline;

  const MobilePOSTab({
    super.key,
    this.isOfflineMode = false,
    this.onInvoiceCreatedOffline,
  });

  @override
  State<MobilePOSTab> createState() => _MobilePOSTabState();
}

class _MobilePOSTabState extends State<MobilePOSTab> {
  final List<Map<String, dynamic>> _cart = [];

  final List<Map<String, dynamic>> _catalog = [
    {'name': 'Wireless Ergonomic Mouse', 'sku': 'SKU-LOG-001', 'price': 1499.0, 'gst': 18.0},
    {'name': 'USB-C Fast Charger 65W', 'sku': 'SKU-CHG-065', 'price': 1999.0, 'gst': 18.0},
    {'name': 'A4 Premium Copy Paper Box', 'sku': 'SKU-PAP-A4', 'price': 1250.0, 'gst': 12.0},
  ];

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      final existingIndex = _cart.indexWhere((c) => c['sku'] == item['sku']);
      if (existingIndex >= 0) {
        _cart[existingIndex]['qty'] += 1;
      } else {
        _cart.add({...item, 'qty': 1});
      }
    });
  }

  double get _subtotal => _cart.fold(0, (sum, i) => sum + (i['price'] * i['qty']));
  double get _tax => _subtotal * 0.18;
  double get _grandTotal => _subtotal + _tax;

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
                _addToCart(_catalog[0]);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('⚡ Barcode Scanned: Wireless Ergonomic Mouse added!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(42),
              ),
              child: const Text('Simulate Scan SKU-LOG-001'),
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
            icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
            onPressed: _openCameraScanner,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('SKU: ${item['sku']} • GST ${item['gst']}%', style: const TextStyle(fontSize: 11)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('₹${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                  onPressed: _cart.isEmpty
                      ? null
                      : () {
                          if (widget.isOfflineMode && widget.onInvoiceCreatedOffline != null) {
                            widget.onInvoiceCreatedOffline!();
                          }
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.isOfflineMode ? Icons.cached : Icons.check_circle,
                                    color: widget.isOfflineMode ? Colors.amber.shade800 : Colors.green,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.isOfflineMode ? 'Invoice Cached Offline!' : 'GST Invoice Generated!',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Total Paid: ₹${_grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.bluetooth_connected),
                                    label: const Text('Print via Bluetooth Thermal Printer'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isOfflineMode ? Colors.amber.shade800 : AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    widget.isOfflineMode ? 'Save Offline Invoice' : 'Checkout & Generate Invoice',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
