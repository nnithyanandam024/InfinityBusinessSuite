import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MobileLedgersTab extends StatefulWidget {
  const MobileLedgersTab({super.key});

  @override
  State<MobileLedgersTab> createState() => _MobileLedgersTabState();
}

class _MobileLedgersTabState extends State<MobileLedgersTab> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _customers = [
    {'name': 'Apex Digital Solutions', 'phone': '+91 98765 11111', 'balance': 4500.0, 'type': 'Customer'},
    {'name': 'Metro Trade Supermarket', 'phone': '+91 98765 22222', 'balance': 12800.0, 'type': 'Customer'},
    {'name': 'Guindy Paper Wholesalers', 'phone': '+91 98765 33333', 'balance': -8200.0, 'type': 'Supplier'},
  ];

  void _sendWhatsAppReminder(BuildContext context, String customerName, String phone, double balance) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💬 Opening WhatsApp reminder for $customerName (₹$balance)...'),
      ),
    );
  }

  void _openAddCustomerModal() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final balanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add New Customer Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Customer / Business Name',
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _customers.insert(0, {
                    'name': nameController.text,
                    'phone': phoneController.text.isEmpty ? '+91 99999 00000' : phoneController.text,
                    'balance': double.tryParse(balanceController.text) ?? 0.0,
                    'type': 'Customer',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Customer Account ${nameController.text} Created!')),
                );
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
    final filteredList = _customers.where((c) {
      final b = c['balance'] as double;
      if (_selectedFilter == 'Receivables') return b > 0;
      if (_selectedFilter == 'Payables') return b < 0;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer & Supplier Ledgers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: AppColors.primary),
            onPressed: _openAddCustomerModal,
            tooltip: 'Add Customer Account',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Filter Tabs
          Row(
            children: ['All', 'Receivables', 'Payables'].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textDark)),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  onSelected: (val) {
                    if (val) setState(() => _selectedFilter = filter);
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          ...filteredList.map((item) {
            final balance = item['balance'] as double;
            final isReceivable = balance > 0;

            return Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isReceivable ? Colors.green.shade50 : Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isReceivable ? 'Receivable' : 'Payable',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isReceivable ? Colors.green.shade700 : Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Phone: ${item['phone']}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance: ₹${balance.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isReceivable ? Colors.green.shade700 : Colors.redAccent,
                          ),
                        ),
                        if (isReceivable)
                          ElevatedButton.icon(
                            onPressed: () => _sendWhatsAppReminder(context, item['name'] as String, item['phone'] as String, balance),
                            icon: const Icon(Icons.chat, size: 14),
                            label: const Text('WhatsApp Reminder', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
