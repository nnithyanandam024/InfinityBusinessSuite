import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/whatsapp_service.dart';

class MobileLedgersTab extends StatefulWidget {
  const MobileLedgersTab({super.key});

  @override
  State<MobileLedgersTab> createState() => _MobileLedgersTabState();
}

class _MobileLedgersTabState extends State<MobileLedgersTab> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'cust-1',
      'name': 'Rajesh Stores',
      'phone': '+91 98765 11111',
      'balance': 12450.0,
      'type': 'Customer',
      'entries': [
        {'title': 'Invoice #1061', 'amount': 5000.0, 'type': 'DEBIT', 'date': 'Today'},
        {'title': 'Invoice #1058', 'amount': 4450.0, 'type': 'DEBIT', 'date': 'Yesterday'},
        {'title': 'Payment Received', 'amount': -2000.0, 'type': 'CREDIT', 'date': '24 Jul 2026'},
        {'title': 'Invoice #1042', 'amount': 5000.0, 'type': 'DEBIT', 'date': '20 Jul 2026'},
      ],
    },
    {
      'id': 'cust-2',
      'name': 'Metro Trade Supermarket',
      'phone': '+91 98765 22222',
      'balance': 12800.0,
      'type': 'Customer',
      'entries': [
        {'title': 'Invoice #1050', 'amount': 12800.0, 'type': 'DEBIT', 'date': '22 Jul 2026'},
      ],
    },
    {
      'id': 'cust-3',
      'name': 'Guindy Paper Wholesalers',
      'phone': '+91 98765 33333',
      'balance': -8200.0,
      'type': 'Supplier',
      'entries': [
        {'title': 'Purchase Order #PO-90', 'amount': -8200.0, 'type': 'CREDIT', 'date': '18 Jul 2026'},
      ],
    },
  ];

  void _sendWhatsAppReminder(BuildContext context, String customerName, String phone, double balance) {
    final msg = WhatsAppService.buildPaymentReminderTemplate(
      customerName: customerName,
      balanceDue: balance,
    );
    WhatsAppService.launchWhatsApp(context, phone: phone, message: msg);
  }

  void _openLedgerTimelineModal(Map<String, dynamic> account) {
    final entries = account['entries'] as List<dynamic>? ?? [];
    final balance = account['balance'] as double;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account['name'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text('Outstanding: ₹${balance.abs().toStringAsFixed(2)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: balance > 0 ? Colors.green.shade700 : Colors.amber.shade900)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20),
            const Text('Khata Ledger Timeline Entries', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, idx) {
                  final entry = entries[idx];
                  final amt = entry['amount'] as double;
                  final isDebit = amt > 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(entry['date'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                        Text(
                          '${isDebit ? '+' : ''}₹${amt.abs().toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDebit ? Colors.redAccent : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openReceivePaymentModal(account);
                    },
                    icon: const Icon(Icons.payments, size: 16),
                    label: const Text('Receive Payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _sendWhatsAppReminder(context, account['name'] as String, account['phone'] as String, balance);
                    },
                    icon: const Icon(Icons.chat, size: 16),
                    label: const Text('Reminder'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openReceivePaymentModal(Map<String, dynamic> account) {
    final amountController = TextEditingController(text: '${(account['balance'] as double).abs()}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Receive Payment: ${account['name']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Dues: ₹${(account['balance'] as double).abs().toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Payment Received Amount (₹)',
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
              final paid = double.tryParse(amountController.text) ?? 0.0;
              setState(() {
                final oldB = account['balance'] as double;
                account['balance'] = oldB - paid;
                (account['entries'] as List).insert(0, {
                  'title': 'Payment Received',
                  'amount': -paid,
                  'type': 'CREDIT',
                  'date': 'Just Now',
                });
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Recorded ₹$paid Khata Payment Entry for ${account['name']}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Record Payment Entry'),
          ),
        ],
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
        title: const Text('Add New Digital Khata Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                labelText: 'Opening Balance Dues (₹)',
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
                final initB = double.tryParse(balanceController.text) ?? 0.0;
                setState(() {
                  _customers.insert(0, {
                    'name': nameController.text,
                    'phone': phoneController.text.isEmpty ? '+91 99999 00000' : phoneController.text,
                    'balance': initB,
                    'type': 'Customer',
                    'entries': [
                      if (initB != 0) {'title': 'Opening Balance', 'amount': initB, 'type': 'DEBIT', 'date': 'Just Now'},
                    ],
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Digital Khata Account ${nameController.text} Created!')),
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
        title: const Text('Digital Khata Ledgers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: AppColors.primary),
            onPressed: _openAddCustomerModal,
            tooltip: 'Add Khata Account',
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
              child: InkWell(
                onTap: () => _openLedgerTimelineModal(item),
                borderRadius: BorderRadius.circular(16),
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
                            'Outstanding: ₹${balance.abs().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isReceivable ? Colors.green.shade700 : Colors.redAccent,
                            ),
                          ),
                          Row(
                            children: [
                              if (isReceivable) ...[
                                OutlinedButton.icon(
                                  onPressed: () => _openReceivePaymentModal(item),
                                  icon: const Icon(Icons.payments_outlined, size: 14),
                                  label: const Text('Pay', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.green.shade700,
                                    side: BorderSide(color: Colors.green.shade300),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                ElevatedButton.icon(
                                  onPressed: () => _sendWhatsAppReminder(context, item['name'] as String, item['phone'] as String, balance),
                                  icon: const Icon(Icons.chat, size: 14),
                                  label: const Text('Reminder', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
