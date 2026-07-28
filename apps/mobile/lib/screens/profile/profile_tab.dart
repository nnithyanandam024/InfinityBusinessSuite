import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../auth/login_screen.dart';

class MobileProfileTab extends StatefulWidget {
  final String userEmail;
  final String userRole;

  const MobileProfileTab({
    super.key,
    required this.userEmail,
    required this.userRole,
  });

  @override
  State<MobileProfileTab> createState() => _MobileProfileTabState();
}

class _MobileProfileTabState extends State<MobileProfileTab> {
  bool _isDarkMode = false;
  String _storeName = 'Infinity Electronics & Retail';
  String _gstin = '33AAAAA0000A1Z5';

  void _openEditStoreProfileModal() {
    final nameController = TextEditingController(text: _storeName);
    final gstinController = TextEditingController(text: _gstin);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Store Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Store Trade Name',
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gstinController,
              decoration: InputDecoration(
                labelText: 'GSTIN Number',
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
              setState(() {
                _storeName = nameController.text;
                _gstin = gstinController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Store Profile Updated!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Save Details'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront, color: AppColors.primary),
            onPressed: _openEditStoreProfileModal,
            tooltip: 'Edit Store Details',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(_storeName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('GSTIN: $_gstin • ${widget.userEmail}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.userRole == 'COMPANY_OWNER' ? 'Company Owner' : 'Cashier Employee',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.edit_note, color: AppColors.primary),
              title: const Text('Edit Store Profile', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('Update Store Name, Address & GSTIN', style: TextStyle(fontSize: 11)),
              onTap: _openEditStoreProfileModal,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Dark Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('Low-light retail store theme', style: TextStyle(fontSize: 11)),
              value: _isDarkMode,
              onChanged: (val) {
                setState(() => _isDarkMode = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_isDarkMode ? '🌙 Dark Mode Activated' : '☀️ Light Mode Activated')),
                );
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MobileAuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(48),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
