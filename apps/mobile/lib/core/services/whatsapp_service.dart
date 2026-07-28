import 'package:flutter/material.dart';

class WhatsAppService {
  static String formatPhone(String rawPhone) {
    String cleaned = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!cleaned.startsWith('+')) {
      if (cleaned.length == 10) {
        cleaned = '+91$cleaned';
      }
    }
    return cleaned;
  }

  static String buildUpiLink({required String upiId, required double amount, String note = 'Invoice Payment'}) {
    final cleanNote = Uri.encodeComponent(note);
    return 'upi://pay?pa=$upiId&am=${amount.toStringAsFixed(2)}&cu=INR&tn=$cleanNote';
  }

  static String buildInvoiceTemplate({
    required String customerName,
    required String invoiceNumber,
    required double grandTotal,
    required int itemLength,
    String storeName = 'Infinity Business Suite',
  }) {
    return '''
🧾 *GST Invoice Receipt - $storeName*

Dear *$customerName*,
Thank you for shopping with us! Here is your invoice summary:

📄 *Invoice #*: $invoiceNumber
📦 *Total Items*: $itemLength Pcs
💰 *Grand Total*: ₹${grandTotal.toStringAsFixed(2)}
✅ *Payment Status*: PAID

Thank you for your business! Have a great day!
''';
  }

  static String buildPaymentReminderTemplate({
    required String customerName,
    required double balanceDue,
    String storeUpiId = 'infinity@okicici',
    String storeName = 'Infinity Business Suite',
  }) {
    final upiUrl = buildUpiLink(upiId: storeUpiId, amount: balanceDue);
    return '''
💳 *Payment Due Balance Reminder - $storeName*

Dear *$customerName*,
This is a gentle reminder regarding your outstanding account balance:

💰 *Current Dues Balance*: ₹${balanceDue.toStringAsFixed(2)}

👉 *Pay Instantly via UPI (GPay / PhonePe / Paytm)*:
$upiUrl

Please contact us once payment is completed. Thank you!
''';
  }

  static String buildPromoOfferTemplate({
    required String customerName,
    required String couponCode,
    required String offerTitle,
    String storeName = 'Infinity Business Suite',
  }) {
    return '''
🎁 *Special Offer For You! - $storeName*

Hello *$customerName*,
Enjoy *10% OFF* on your next purchase at $storeName!

🎟️ *Use Promo Code*: *$couponCode*
✨ *Offer Details*: $offerTitle

Visit our store or order online today! T&C Apply.
''';
  }

  static String buildShipmentTrackingTemplate({
    required String customerName,
    required String trackingId,
    required String courierName,
    String storeName = 'Infinity Business Suite',
  }) {
    return '''
📦 *Order Dispatched & Tracking - $storeName*

Hello *$customerName*,
Great news! Your order has been dispatched via *$courierName*.

🚚 *Tracking ID*: *$trackingId*
📍 *Estimated Delivery*: 2-3 Business Days

Thank you for choosing $storeName!
''';
  }

  static String buildSupplierRestockTemplate({
    required String supplierName,
    required String sku,
    required int requestedQty,
    String storeName = 'Infinity Business Suite',
  }) {
    return '''
🏭 *Purchase Restock Request - $storeName*

Dear *$supplierName*,
Please send a purchase quotation & availability confirmation for the following stock replenishment:

📦 *Item SKU*: $sku
📊 *Requested Quantity*: $requestedQty Pcs

Thank you!
''';
  }

  static void launchWhatsApp(BuildContext context, {required String phone, required String message}) {
    final formattedPhone = formatPhone(phone);
    final encodedMsg = Uri.encodeComponent(message);
    final whatsappUrl = 'whatsapp://send?phone=$formattedPhone&text=$encodedMsg';
    debugPrint('Launching WhatsApp URI: $whatsappUrl');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💬 Dispatching WhatsApp Message to $formattedPhone...'),
        action: SnackBarAction(
          label: 'View Message',
          onPressed: () {
            showDialog(
              context: context,
              builder: (dialogCtx) => AlertDialog(
                title: const Text('WhatsApp Message Preview', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                content: SingleChildScrollView(
                  child: Text(message, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
