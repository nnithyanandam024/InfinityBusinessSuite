import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/whatsapp_service.dart';

class WhatsAppHubScreen extends StatefulWidget {
  const WhatsAppHubScreen({super.key});

  @override
  State<WhatsAppHubScreen> createState() => _WhatsAppHubScreenState();
}

class _WhatsAppHubScreenState extends State<WhatsAppHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _phoneController = TextEditingController(text: '+91 98765 11111');
  final _messageController = TextEditingController();
  String _selectedTemplate = 'Payment Reminder';

  final List<Map<String, dynamic>> _storeCustomers = [
    {'name': 'Apex Digital Solutions', 'phone': '+91 98765 11111', 'balance': 4500.0, 'selected': true},
    {'name': 'Metro Trade Supermarket', 'phone': '+91 98765 22222', 'balance': 12800.0, 'selected': true},
    {'name': 'Guindy Paper Wholesalers', 'phone': '+91 98765 33333', 'balance': 8200.0, 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _applyTemplate('Payment Reminder');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _applyTemplate(String templateName) {
    setState(() {
      _selectedTemplate = templateName;
      if (templateName == 'Invoice Receipt') {
        _messageController.text = WhatsAppService.buildInvoiceTemplate(
          customerName: 'Apex Digital Solutions',
          invoiceNumber: 'INV-2026-042',
          grandTotal: 3498.00,
          itemLength: 3,
        );
      } else if (templateName == 'Payment Reminder') {
        _messageController.text = WhatsAppService.buildPaymentReminderTemplate(
          customerName: 'Metro Trade Supermarket',
          balanceDue: 12800.00,
        );
      } else if (templateName == 'Promo Offer Coupon') {
        _messageController.text = WhatsAppService.buildPromoOfferTemplate(
          customerName: 'Valued Customer',
          couponCode: 'WELCOME10',
          offerTitle: 'Get 10% OFF on all office supplies this week!',
        );
      } else if (templateName == 'Shipment Tracking') {
        _messageController.text = WhatsAppService.buildShipmentTrackingTemplate(
          customerName: 'Apex Digital Solutions',
          trackingId: 'EXP-984021',
          courierName: 'Bluedart Express',
        );
      } else if (templateName == 'Supplier Restock') {
        _messageController.text = WhatsAppService.buildSupplierRestockTemplate(
          supplierName: 'Guindy Paper Wholesalers',
          sku: 'SKU-PAP-A4',
          requestedQty: 100,
        );
      }
    });
  }

  void _openCustomerPickerModal() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Pick Store Customer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _storeCustomers.map((c) {
            return ListTile(
              title: Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text('${c['phone']} • Dues: ₹${(c['balance'] as double).toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
              onTap: () {
                setState(() {
                  _phoneController.text = c['phone'] as String;
                });
                Navigator.pop(dialogCtx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _dispatchWhatsApp() {
    if (_phoneController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please fill in customer phone number and message')),
      );
      return;
    }
    WhatsAppService.launchWhatsApp(
      context,
      phone: _phoneController.text,
      message: _messageController.text,
    );
  }

  void _runBatchBroadcast() {
    final selectedList = _storeCustomers.where((c) => c['selected'] == true).toList();
    if (selectedList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please select at least 1 customer for broadcast')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🚀 Broadcasting WhatsApp Payment Reminders to ${selectedList.length} customers...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp CRM Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF128C7E),
          indicatorColor: const Color(0xFF128C7E),
          tabs: const [
            Tab(text: 'Direct Composer'),
            Tab(text: 'Batch Broadcast'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Direct Composer View
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Banner Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.chat, color: Colors.white, size: 36),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('WhatsApp Business Dispatcher', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(height: 2),
                          Text('Send instant invoices, balance reminders & UPI pay links', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Customer Phone Field with Contact Picker Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Customer WhatsApp Phone Number',
                        prefixIcon: const Icon(Icons.phone, size: 18, color: Color(0xFF25D366)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _openCustomerPickerModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF128C7E),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      side: const BorderSide(color: Color(0xFF128C7E)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Icon(Icons.contacts),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Message Template Selector Chips
              const Text('Select Message Template:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Payment Reminder', 'Invoice Receipt', 'Promo Offer Coupon', 'Shipment Tracking', 'Supplier Restock'].map((tmpl) {
                    final isSelected = _selectedTemplate == tmpl;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tmpl, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textDark)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF128C7E),
                        backgroundColor: Colors.white,
                        onSelected: (val) {
                          if (val) _applyTemplate(tmpl);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Message Content Editor
              TextField(
                controller: _messageController,
                maxLines: 9,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                decoration: InputDecoration(
                  labelText: 'WhatsApp Message Body (Markdown & UPI Links)',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _dispatchWhatsApp,
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Send Message via WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ],
          ),

          // 2. Batch Broadcast View
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Batch Broadcast Receivables Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Select customers to dispatch payment due reminder messages with embedded UPI pay links.', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 16),
              ..._storeCustomers.map((c) {
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.borderLight),
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: CheckboxListTile(
                    title: Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('${c['phone']} • Dues: ₹${(c['balance'] as double).toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
                    value: c['selected'] as bool,
                    activeColor: const Color(0xFF25D366),
                    onChanged: (val) {
                      setState(() {
                        c['selected'] = val ?? false;
                      });
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _runBatchBroadcast,
                icon: const Icon(Icons.campaign, size: 20),
                label: const Text('Launch WhatsApp Batch Broadcast', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF128C7E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
