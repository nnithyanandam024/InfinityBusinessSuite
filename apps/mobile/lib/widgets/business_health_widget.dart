import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class BusinessHealthWidget extends StatelessWidget {
  final int healthScore; // 0 to 100
  final String scoreStatus;
  final String changeDiagnosis;

  const BusinessHealthWidget({
    super.key,
    this.healthScore = 82,
    this.scoreStatus = 'HEALTHY',
    this.changeDiagnosis = 'Score changed 82 → 76 because Outstanding Receivables increased by ₹12,450 and Sales dropped 8%.',
  });

  @override
  Widget build(BuildContext context) {
    Color gaugeColor = Colors.green.shade700;
    if (healthScore < 50) {
      gaugeColor = Colors.redAccent;
    } else if (healthScore < 75) {
      gaugeColor = Colors.amber.shade800;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.monitor_heart, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'BUSINESS HEALTH SCORE',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: gaugeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scoreStatus,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: gaugeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Circular Health Score Meter
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: healthScore / 100,
                      strokeWidth: 7,
                      backgroundColor: AppColors.bgLight,
                      color: gaugeColor,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$healthScore',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textDark),
                      ),
                      const Text(
                        '/100',
                        style: TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // KPI Metrics Grid Overview
              const Expanded(
                child: Column(
                  children: [
                    _HealthMetricRow(label: 'Sales Growth', value: '+12.5%', isPositive: true),
                    SizedBox(height: 4),
                    _HealthMetricRow(label: 'Profit Margin', value: '24.2%', isPositive: true),
                    SizedBox(height: 4),
                    _HealthMetricRow(label: 'Receivables Dues', value: '₹42,500', isPositive: false),
                    SizedBox(height: 4),
                    _HealthMetricRow(label: 'Inventory Turnover', value: 'Healthy (4.2x)', isPositive: true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Natural Language Diagnosis Text
          Row(
            children: [
              const Icon(Icons.info_outline, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  changeDiagnosis,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthMetricRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;

  const _HealthMetricRow({
    required this.label,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isPositive ? Colors.green.shade700 : Colors.amber.shade900,
          ),
        ),
      ],
    );
  }
}
