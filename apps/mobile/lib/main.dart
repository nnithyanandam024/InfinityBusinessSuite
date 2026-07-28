import 'package:flutter/material.dart';

void main() {
  runApp(const InfinityBusinessSuiteApp());
}

class InfinityBusinessSuiteApp extends StatelessWidget {
  const InfinityBusinessSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinity Business Suite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF0F172A),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const MobileAuthScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. MOBILE LOGIN SCREEN WITH BIOMETRIC FINGERPRINT UNLOCK
// -----------------------------------------------------------------------------
class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({super.key});

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  final _emailController = TextEditingController(text: 'admin@infinitytech.com');
  final _passwordController = TextEditingController(text: 'Infinity@2026');
  bool _isLoading = false;

  void _handleLogin(String role) {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MobileMainNavigation(
            userEmail: _emailController.text,
            userRole: role,
          ),
        ),
      );
    });
  }

  void _handleBiometricAuth() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('👆 Biometric Fingerprint / Face ID Verified! Logging in...')),
    );
    _handleLogin('COMPANY_OWNER');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.all_inclusive, color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: 'Infinity '),
                            TextSpan(
                              text: 'Business Suite',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Cloud ERP & Point of Sale',
                        style: TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.fingerprint, color: Color(0xFF2563EB), size: 28),
                            onPressed: _handleBiometricAuth,
                            tooltip: 'Biometric Unlock',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined, size: 18),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 18),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : () => _handleLogin('COMPANY_OWNER'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Login as Company Owner',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: _isLoading ? null : () => _handleLogin('EMPLOYEE'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.point_of_sale, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Login as Cashier Employee',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. MAIN MOBILE NAVIGATION WITH OFFLINE SYNC BAR
// -----------------------------------------------------------------------------
class MobileMainNavigation extends StatefulWidget {
  final String userEmail;
  final String userRole;

  const MobileMainNavigation({
    super.key,
    required this.userEmail,
    required this.userRole,
  });

  @override
  State<MobileMainNavigation> createState() => _MobileMainNavigationState();
}

class _MobileMainNavigationState extends State<MobileMainNavigation> {
  int _currentIndex = 0;
  bool _isOfflineMode = false;
  int _offlineQueueCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.userRole == 'EMPLOYEE') {
      _currentIndex = 1;
    }
  }

  void _toggleOfflineMode() {
    setState(() {
      _isOfflineMode = !_isOfflineMode;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOfflineMode
            ? '📡 Offline Mode Activated! Invoices will cache locally.'
            : '🌐 Online Mode Restored! Auto-sync ready.'),
      ),
    );
  }

  void _syncOfflineInvoices() {
    if (_offlineQueueCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✨ No offline invoices pending sync.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🔄 Syncing $_offlineQueueCount offline invoices to cloud NestJS API...')),
    );
    setState(() => _offlineQueueCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MobileDashboardTab(userRole: widget.userRole),
      MobilePOSTab(
        isOfflineMode: _isOfflineMode,
        onInvoiceCreatedOffline: () => setState(() => _offlineQueueCount += 1),
      ),
      const MobileInventoryTab(),
      MobileProfileTab(userEmail: widget.userEmail, userRole: widget.userRole),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: GestureDetector(
          onTap: _toggleOfflineMode,
          child: Container(
            color: _isOfflineMode ? Colors.amber.shade800 : Colors.green.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(_isOfflineMode ? Icons.wifi_off : Icons.wifi, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        _isOfflineMode ? 'OFFLINE MODE (Local Cache)' : 'ONLINE CLOUD SYNC ACTIVE',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (_offlineQueueCount > 0)
                    GestureDetector(
                      onTap: _syncOfflineInvoices,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Sync ($_offlineQueueCount)',
                          style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'POS Billing'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. DASHBOARD TAB
// -----------------------------------------------------------------------------
class MobileDashboardTab extends StatelessWidget {
  final String userRole;

  const MobileDashboardTab({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Infinity Business Suite', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Live Sales Dashboard', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Icon(Icons.insights, color: Colors.white, size: 32),
              ],
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildKpiCard('Total Revenue', '₹24,980', '+12.5%', Icons.attach_money, const Color(0xFF2563EB)),
              _buildKpiCard('Invoices', '128 Issued', 'Today: 14', Icons.receipt_long, const Color(0xFF9333EA)),
              _buildKpiCard('Active Products', '1,480 SKUs', 'In Stock', Icons.inventory_2, const Color(0xFFD97706)),
              _buildKpiCard('Customers', '8,642 Accounts', '+8.1%', Icons.people, const Color(0xFF059669)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Low Stock Alerts',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildLowStockRow('USB-C Fast Charger 65W', '8 Pcs Left'),
                const Divider(height: 16),
                _buildLowStockRow('Wireless Ergonomic Mouse', '5 Pcs Left'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, String badge, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
              Icon(icon, size: 18, color: color),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(badge, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockRow(String title, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. POS BILLING TAB WITH BLUETOOTH THERMAL PRINTER & CAMERA SCANNER
// -----------------------------------------------------------------------------
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
            Icon(Icons.camera_alt, color: Color(0xFF2563EB)),
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
                      border: Border.all(color: const Color(0xFF2563EB), width: 2),
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
                backgroundColor: const Color(0xFF2563EB),
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
            icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF2563EB)),
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
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
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
                          icon: const Icon(Icons.add_circle, color: Color(0xFF2563EB)),
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
                    Text('Grand Total: ₹${_grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
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
                    backgroundColor: widget.isOfflineMode ? Colors.amber.shade800 : const Color(0xFF2563EB),
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
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
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
        side: const BorderSide(color: Color(0xFFE2E8F0)),
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
              color: stock < 10 ? Colors.redAccent : const Color(0xFF2563EB),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileProfileTab extends StatelessWidget {
  final String userEmail;
  final String userRole;

  const MobileProfileTab({
    super.key,
    required this.userEmail,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFF2563EB),
              child: Icon(Icons.person, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(userEmail, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                userRole == 'COMPANY_OWNER' ? 'Company Owner' : 'Cashier Employee',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MobileAuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(48),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
