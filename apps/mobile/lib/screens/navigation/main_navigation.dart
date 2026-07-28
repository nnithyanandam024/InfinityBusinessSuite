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
      const MobileLedgersTab(),
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
