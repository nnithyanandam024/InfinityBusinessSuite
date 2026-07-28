import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MobileLedgersTab extends StatelessWidget {
  const MobileLedgersTab({super.key});

  void _sendWhatsAppReminder(BuildContext context, String customerName, String phone, double balance) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💬 Opening WhatsApp reminder for $customerName (₹$balance)...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customers = [
      {'name': 'Apex Digital Solutions', 'phone': '+91 98765 11111', 'balance': 4500.0, 'type': 'Customer'},
      {'name': 'Metro Trade Supermarket', 'phone': '+91 98765 22222', 'balance': 12800.0, 'type': 'Customer'},
      {'name': 'Guindy Paper Wholesalers', 'phone': '+91 98765 33333', 'balance': -8200.0, 'type': 'Supplier'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer & Supplier Ledgers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: customers.length,
        itemBuilder: (context, idx) {
          final item = customers[idx];
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
                            backgroundColor: const Color(0xFF25D366), // WhatsApp Green
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
        },
      ),
    );
  }
}
