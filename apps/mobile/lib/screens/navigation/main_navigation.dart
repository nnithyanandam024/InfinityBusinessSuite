import 'package:flutter/material.dart';
import '../dashboard/dashboard_tab.dart';
import '../pos/pos_billing_tab.dart';
import '../inventory/inventory_tab.dart';
import '../ledgers/ledgers_tab.dart';
import '../profile/profile_tab.dart';

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
      const MobileLedgersTab(),
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
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'POS Billing'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Ledgers'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
