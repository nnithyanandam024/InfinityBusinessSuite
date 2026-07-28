import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class MorphLoader extends StatefulWidget {
  final double size;
  final bool showSubtext;

  const MorphLoader({
    super.key,
    this.size = 120,
    this.showSubtext = true,
  });

  @override
  State<MorphLoader> createState() => _MorphLoaderState();
}

class _MorphLoaderState extends State<MorphLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  int _loadingStep = 0;

  final List<String> _loadingMessages = [
    'Initializing Infinity ERP Engine...',
    'Authenticating Security Session...',
    'Syncing Offline Inventory Cache...',
    'Readying POS Counter...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _loadingStep = (_loadingStep + 1) % _loadingMessages.length;
        });
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Glowing Infinity Symbol Box
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: _glowAnimation.value * 0.4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: _glowAnimation.value),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const Center(
                  child: Icon(
                    Icons.all_inclusive,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            );
          },
        ),

        if (widget.showSubtext) ...[
          const SizedBox(height: 36),
          Text(
            _loadingMessages[_loadingStep],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white60,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          const SizedBox(
            width: 140,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white12,
              color: AppColors.primary,
              minHeight: 2.5,
            ),
          ),
        ],
      ],
    );
  }
}
