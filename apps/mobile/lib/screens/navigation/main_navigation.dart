import 'package:flutter/material.dart';
import '../ledgers/ledgers_tab.dart';
import '../cashbook/cashbook_screen.dart';
import '../pos/pos_billing_tab.dart';
import '../profile/profile_tab.dart';
import '../whatsapp/whatsapp_hub_screen.dart';

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
  Widget build(BuildContext context) {
    final screens = [
      const MobileLedgersTab(),
      const CashbookScreen(),
      const MobilePOSTab(),
      MobileProfileTab(userEmail: widget.userEmail, userRole: widget.userRole),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WhatsAppHubScreen()),
          );
        },
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        tooltip: 'WhatsApp CRM Hub',
        child: const Icon(Icons.chat),
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
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Khata'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Cashbook'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'POS Billing'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view), label: 'More'),
        ],
      ),
    );
  }
}
