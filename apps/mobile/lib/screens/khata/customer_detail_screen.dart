import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/whatsapp_service.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Map<String, dynamic> customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late Map<String, dynamic> _customerData;

  @override
  void initState() {
    super.initState();
    _customerData = Map<String, dynamic>.from(widget.customer);
    if (!_customerData.containsKey('entries')) {
      _customerData['entries'] = [
        {'title': 'Invoice #1061', 'amount': 5000.0, 'type': 'GAVE', 'date': 'Today, 2:30 PM'},
        {'title': 'Invoice #1058', 'amount': 4450.0, 'type': 'GAVE', 'date': 'Yesterday'},
        {'title': 'Payment Received', 'amount': 2000.0, 'type': 'GOT', 'date': '24 Jul 2026'},
        {'title': 'Invoice #1042', 'amount': 5000.0, 'type': 'GAVE', 'date': '20 Jul 2026'},
      ];
    }
  }

  double get _currentBalance => _customerData['balance'] as double;
  bool get _youWillGet => _currentBalance > 0;

  void _openAddEntryModal(String entryType) {
    final isGave = entryType == 'GAVE';
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isGave ? '🔴 You Gave ₹ (Debit Entry)' : '🟢 You Got ₹ (Credit Payment)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isGave ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: '₹ ',
                labelText: isGave ? 'Enter Amount You Gave' : 'Enter Amount You Got',
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Add Note / Invoice # (Optional)',
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amt = double.tryParse(amountController.text) ?? 0.0;
                if (amt <= 0) return;

                setState(() {
                  final oldB = _customerData['balance'] as double;
                  if (isGave) {
                    _customerData['balance'] = oldB + amt;
                  } else {
                    _customerData['balance'] = oldB - amt;
                  }

                  (_customerData['entries'] as List).insert(0, {
                    'title': noteController.text.isNotEmpty ? noteController.text : (isGave ? 'Credit Sale' : 'Payment Received'),
                    'amount': amt,
                    'type': entryType,
                    'date': 'Today, Just Now',
                  });
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Entry recorded for ${_customerData['name']}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isGave ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                isGave ? 'SAVE YOU GAVE ENTRY' : 'SAVE YOU GOT PAYMENT',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _sendWhatsAppReminder() {
    final msg = WhatsAppService.buildPaymentReminderTemplate(
      customerName: _customerData['name'] as String,
      balanceDue: _currentBalance,
    );
    WhatsAppService.launchWhatsApp(context, phone: _customerData['phone'] as String, message: msg);
  }

  @override
  Widget build(BuildContext context) {
    final entries = _customerData['entries'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_customerData['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('📄 Downloading PDF Statement for ${_customerData['name']}...')),
              );
            },
            tooltip: 'PDF Statement',
          ),
          IconButton(
            icon: const Icon(Icons.chat, color: Color(0xFF25D366)),
            onPressed: _sendWhatsAppReminder,
            tooltip: 'WhatsApp Reminder',
          ),
        ],
      ),
      body: Column(
        children: [
          // Authentic Khatabook Net Balance Banner Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: _youWillGet ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _youWillGet ? 'YOU WILL GET' : 'YOU WILL GIVE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: _youWillGet ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${_currentBalance.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: _youWillGet ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _sendWhatsAppReminder,
                  icon: const Icon(Icons.chat, size: 14),
                  label: const Text('Send Reminder', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),

          // Date-wise Khatabook Double Entry Feed
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, idx) {
                final entry = entries[idx];
                final isGave = entry['type'] == 'GAVE';
                final amt = (entry['amount'] as num).toDouble();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isGave ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isGave ? const Color(0xFFFFF1F2) : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isGave ? const Color(0xFFFECDD3) : const Color(0xFFBBF7D0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isGave ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isGave ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 14,
                                  color: isGave ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  entry['title'] as String,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${amt.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: isGave ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry['date'] as String,
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Khatabook Signature Fixed Bottom Action Bar (YOU GAVE & YOU GOT)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openAddEntryModal('GAVE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626), // Khatabook Red
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.remove_circle_outline, size: 18),
                          SizedBox(width: 6),
                          Text('YOU GAVE ₹', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openAddEntryModal('GOT'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A), // Khatabook Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 18),
                          SizedBox(width: 6),
                          Text('YOU GOT ₹', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
