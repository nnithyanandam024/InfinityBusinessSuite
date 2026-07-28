import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../khata/customer_detail_screen.dart';

class MobileLedgersTab extends StatefulWidget {
  const MobileLedgersTab({super.key});

  @override
  State<MobileLedgersTab> createState() => _MobileLedgersTabState();
}

class _MobileLedgersTabState extends State<MobileLedgersTab> with SingleTickerProviderStateMixin {
  late TabController _segmentedTabController;

  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'cust-1',
      'name': 'Rajesh Stores',
      'phone': '+91 98765 11111',
      'balance': 12450.0,
      'type': 'Customer',
      'entries': [
        {'title': 'Invoice #1061', 'amount': 5000.0, 'type': 'GAVE', 'date': 'Today, 2:30 PM'},
        {'title': 'Invoice #1058', 'amount': 4450.0, 'type': 'GAVE', 'date': 'Yesterday'},
        {'title': 'Payment Received', 'amount': 2000.0, 'type': 'GOT', 'date': '24 Jul 2026'},
        {'title': 'Invoice #1042', 'amount': 5000.0, 'type': 'GAVE', 'date': '20 Jul 2026'},
      ],
    },
    {
      'id': 'cust-2',
      'name': 'Metro Trade Supermarket',
      'phone': '+91 98765 22222',
      'balance': 12800.0,
      'type': 'Customer',
      'entries': [
        {'title': 'Invoice #1050', 'amount': 12800.0, 'type': 'GAVE', 'date': '22 Jul 2026'},
      ],
    },
    {
      'id': 'cust-3',
      'name': 'Apex Digital Solutions',
      'phone': '+91 98765 44444',
      'balance': 4500.0,
      'type': 'Customer',
      'entries': [
        {'title': 'Invoice #1049', 'amount': 4500.0, 'type': 'GAVE', 'date': '21 Jul 2026'},
      ],
    },
  ];

  final List<Map<String, dynamic>> _suppliers = [
    {
      'id': 'supp-1',
      'name': 'Guindy Paper Wholesalers',
      'phone': '+91 98765 33333',
      'balance': 8200.0,
      'type': 'Supplier',
      'entries': [
        {'title': 'Purchase Order #PO-90', 'amount': 8200.0, 'type': 'GOT', 'date': '18 Jul 2026'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _segmentedTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _segmentedTabController.dispose();
    super.dispose();
  }

  double get _totalCustomerReceivables => _customers.fold(0.0, (sum, c) => sum + (c['balance'] as double));
  double get _totalSupplierPayables => _suppliers.fold(0.0, (sum, s) => sum + (s['balance'] as double));

  void _openAddAccountModal(bool isCustomer) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final balanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isCustomer ? 'Add Customer Account' : 'Add Supplier Account', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: isCustomer ? 'Customer / Shop Name' : 'Supplier Business Name',
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number (+91)',
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Opening Balance (₹)',
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final initB = double.tryParse(balanceController.text) ?? 0.0;
                setState(() {
                  final newAcc = {
                    'name': nameController.text,
                    'phone': phoneController.text.isEmpty ? '+91 99999 00000' : phoneController.text,
                    'balance': initB,
                    'type': isCustomer ? 'Customer' : 'Supplier',
                    'entries': [
                      if (initB != 0) {'title': 'Opening Balance', 'amount': initB, 'type': 'GAVE', 'date': 'Just Now'},
                    ],
                  };
                  if (isCustomer) {
                    _customers.insert(0, newAcc);
                  } else {
                    _suppliers.insert(0, newAcc);
                  }
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Create Account'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Khata Ledgers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        bottom: TabBar(
          controller: _segmentedTabController,
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'CUSTOMERS (${_customers.length})'),
            Tab(text: 'SUPPLIERS (${_suppliers.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Total Dues Summary Bar (Red / Green Khatabook style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFECDD3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('YOU WILL GET', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                        const SizedBox(height: 2),
                        Text('₹${_totalCustomerReceivables.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFDC2626))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('YOU WILL GIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                        const SizedBox(height: 2),
                        Text('₹${_totalSupplierPayables.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF16A34A))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _segmentedTabController,
              children: [
                // Customers List
                _buildAccountListView(_customers, true),
                // Suppliers List
                _buildAccountListView(_suppliers, false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddAccountModal(_segmentedTabController.index == 0),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: Text(_segmentedTabController.index == 0 ? 'Add Customer' : 'Add Supplier'),
      ),
    );
  }

  Widget _buildAccountListView(List<Map<String, dynamic>> list, bool isCustomerTab) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final acc = list[idx];
        final balance = (acc['balance'] as num).toDouble();
        final youWillGet = balance > 0;

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderLight),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerDetailScreen(customer: acc)),
              );
            },
            leading: CircleAvatar(
              backgroundColor: AppColors.bgLight,
              child: Text(
                (acc['name'] as String).substring(0, 1).toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            title: Text(acc['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('Phone: ${acc['phone']}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${balance.abs().toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: youWillGet ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                  ),
                ),
                Text(
                  youWillGet ? 'YOU WILL GET' : 'YOU WILL GIVE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: youWillGet ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
