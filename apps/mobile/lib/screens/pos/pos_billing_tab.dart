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

  // Coupon & Payment Mode State
  String? _appliedCoupon;
  double _discountAmount = 0.0;
  String _selectedPaymentMethod = 'CASH';
  final _couponController = TextEditingController();

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
      _recalculateDiscount();
    });
  }

  void _updateCartQty(int index, int delta) {
    setState(() {
      final newQty = (_cart[index]['qty'] as int) + delta;
      if (newQty <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index]['qty'] = newQty;
      }
      _recalculateDiscount();
    });
  }

  void _applyCouponCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'WELCOME10') {
      setState(() {
        _appliedCoupon = 'WELCOME10 (10% OFF)';
        _recalculateDiscount();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Promo Code WELCOME10 Applied: 10% OFF!')),
      );
    } else if (cleanCode == 'FLAT200') {
      setState(() {
        _appliedCoupon = 'FLAT200 (₹200 OFF)';
        _recalculateDiscount();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Promo Code FLAT200 Applied: ₹200 OFF!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Invalid Promo Coupon Code')),
      );
    }
  }

  void _recalculateDiscount() {
    double sub = _cart.fold(0, (sum, i) => sum + (i['price'] * i['qty']));
    if (_appliedCoupon != null && _appliedCoupon!.contains('10%')) {
      _discountAmount = sub * 0.10;
    } else if (_appliedCoupon != null && _appliedCoupon!.contains('200')) {
      _discountAmount = 200.0;
    } else {
      _discountAmount = 0.0;
    }
  }

  double get _subtotal => _cart.fold(0, (sum, i) => sum + (i['price'] * i['qty']));
  double get _tax => (_subtotal - _discountAmount) * 0.18;
  double get _grandTotal => (_subtotal - _discountAmount + _tax).clamp(0, double.infinity);

  Future<void> _handleCheckout() async {
    if (_cart.isEmpty) return;
    setState(() => _isSubmitting = true);

    final res = await BillingService.createInvoice(
      items: _cart,
      totalAmount: _grandTotal,
      taxAmount: _tax,
      paymentMethod: _selectedPaymentMethod,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final invNumber = res['invoiceNumber'] ?? 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            Text('Invoice #: $invNumber • Payment: $_selectedPaymentMethod', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Text('Total Paid: ₹${_grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _cart.clear();
                  _appliedCoupon = null;
                  _discountAmount = 0.0;
                });
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

  void _openCouponModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Apply Promo Coupon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: 'Enter code (e.g. WELCOME10 or FLAT200)',
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ActionChip(
                  label: const Text('WELCOME10', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  onPressed: () => _couponController.text = 'WELCOME10',
                ),
                const SizedBox(width: 8),
                ActionChip(
                  label: const Text('FLAT200', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  onPressed: () => _couponController.text = 'FLAT200',
                ),
              ],
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
              _applyCouponCode(_couponController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Apply'),
          ),
        ],
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
            icon: const Icon(Icons.local_offer_outlined, color: AppColors.primary),
            onPressed: _openCouponModal,
            tooltip: 'Apply Promo Coupon',
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

          // POS Active Cart Drawer with Quantity Controls & Payment Method Toggle
          if (_cart.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 180),
              color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _cart.length,
                itemBuilder: (context, idx) {
                  final cartItem = _cart[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            cartItem['name'] as String,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 18, color: AppColors.textMuted),
                              onPressed: () => _updateCartQty(idx, -1),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('${cartItem['qty']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, size: 18, color: AppColors.primary),
                              onPressed: () => _updateCartQty(idx, 1),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 12),
                            Text('₹${((cartItem['price'] as double) * (cartItem['qty'] as int)).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ],
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
                // Payment Method Selector Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['CASH', 'UPI QR', 'CARD', 'PAY LATER'].map((method) {
                      final isSelected = _selectedPaymentMethod == method;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(method, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textDark)),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.bgLight,
                          onSelected: (val) {
                            if (val) setState(() => _selectedPaymentMethod = method);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),

                if (_appliedCoupon != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount: $_appliedCoupon', style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                      Text('-₹${_discountAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cart Items: ${_cart.length}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Grand Total: ₹${_grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 10),
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
                      : Text(
                          'Checkout & Post Invoice ($_selectedPaymentMethod)',
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
