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
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    children: [
                      TextSpan(text: 'Infinity '),
                      TextSpan(
                        text: 'Business Suite',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Cloud ERP & POS Mobile App',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
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
                            borderRadius: BorderRadius.circular(12),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : () => _handleLogin('COMPANY_OWNER'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.vertical(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _isLoading ? null : () => _handleLogin('EMPLOYEE'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.vertical(14),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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

  @override
  void initState() {
    super.initState();
    if (widget.userRole == 'EMPLOYEE') {
      _currentIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MobileDashboardTab(userRole: widget.userRole),
      const MobilePOSTab(),
      const MobileInventoryTab(),
      MobileProfileTab(userEmail: widget.userEmail, userRole: widget.userRole),
    ];

    return Scaffold(
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

class MobileDashboardTab extends StatelessWidget {
  final String userRole;

  const MobileDashboardTab({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
              Icon(icon, size: 18, color: color),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          Container(
            padding: const EdgeInsets.horizontal(6, vertical: 2),
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
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
        Container(
          padding: const EdgeInsets.horizontal(8, vertical: 2),
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

class MobilePOSTab extends StatefulWidget {
  const MobilePOSTab({super.key});

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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📷 Camera Barcode Scanner activated!')),
              );
            },
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
                    borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
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
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                                  const SizedBox(height: 12),
                                  const Text('GST Invoice Generated!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text('Total Paid: ₹${_grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.print),
                                    label: const Text('Print Receipt via Bluetooth'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Checkout & Generate Invoice', style: TextStyle(fontWeight: FontWeight.bold)),
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
                borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text('SKU: $sku', style: const TextStyle(fontSize: 11)),
        trailing: Container(
          padding: const EdgeInsets.horizontal(10, vertical: 4),
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
              padding: const EdgeInsets.horizontal(10, vertical: 2),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
