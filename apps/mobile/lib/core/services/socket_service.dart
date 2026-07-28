import 'package:flutter/material.dart';

class MobileSocketService {
  static void listenToEvents(BuildContext context, {required String companyId}) {
    debugPrint('⚡ Mobile WebSocket Listener Active for company: $companyId');
  }

  static void simulateEventToast(BuildContext context, String eventTitle, String eventDetail) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(eventDetail, style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF0F172A),
      ),
    );
  }
}
