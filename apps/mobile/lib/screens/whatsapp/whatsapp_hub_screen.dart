import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/whatsapp_service.dart';

class WhatsAppHubScreen extends StatefulWidget {
  const WhatsAppHubScreen({super.key});

  @override
  State<WhatsAppHubScreen> createState() => _WhatsAppHubScreenState();
}

class _WhatsAppHubScreenState extends State<WhatsAppHubScreen> {
  final _phoneController = TextEditingController(text: '+91 98765 11111');
  final _messageController = TextEditingController();
  String _selectedTemplate = 'Invoice Receipt';

  @override
  void initState() {
    super.initState();
    _applyTemplate('Invoice Receipt');
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
      } else if (templateName == 'Payment Due Reminder') {
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
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp CRM Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF25D366), Color(0xFF128C7E)], // WhatsApp Green Gradient
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
                      Text('Send instant invoices, balance reminders & promo offers', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Customer Phone Field
          TextField(
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
          const SizedBox(height: 16),

          // Message Template Selector Chips
          const Text('Select Message Template:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Invoice Receipt', 'Payment Due Reminder', 'Promo Offer Coupon'].map((tmpl) {
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
            maxLines: 8,
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: 'WhatsApp Message Body',
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

          // Send WhatsApp Button
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
    );
  }
}
