import 'package:flutter/material.dart';

class DrillMovementGraphic extends StatefulWidget {
  const DrillMovementGraphic({
    super.key,
    this.size = 76.0,
    this.primaryColor = const Color(0xFF00FF87),
    this.accentColor = const Color(0xFF00CEC9),
  });

  final double size;
  final Color primaryColor;
  final Color accentColor;

  @override
  State<DrillMovementGraphic> createState() => _DrillMovementGraphicState();
}

class _DrillMovementGraphicState extends State<DrillMovementGraphic> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: widget.primaryColor.withValues(alpha: 0.25), width: 1.2),
          ),
          child: CustomPaint(
            painter: _CourtGraphicPainter(
              animValue: _animController.value,
              primaryColor: widget.primaryColor,
              accentColor: widget.accentColor,
            ),
          ),
        );
      },
    );
  }
}

class _CourtGraphicPainter extends CustomPainter {
  _CourtGraphicPainter({
    required this.animValue,
    required this.primaryColor,
    required this.accentColor,
  });

  final double animValue;
  final Color primaryColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final courtPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer rectangle
    final pad = 10.0;
    final rect = Rect.fromLTWH(pad, pad, size.width - (pad * 2), size.height - (pad * 2));
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), courtPaint);

    // Center net line
    final midY = size.height / 2;
    canvas.drawLine(Offset(pad, midY), Offset(size.width - pad, midY), courtPaint);

    // Animated player dot moving from center to front right corner and back
    final centerX = size.width / 2;
    final centerY = midY + 12;

    // Movement path animation
    final t = animValue;
    double playerX, playerY;
    if (t < 0.5) {
      final subT = t / 0.5;
      playerX = centerX + (size.width / 2 - pad - 6 - centerX) * subT;
      playerY = centerY - (centerY - pad - 6) * subT;
    } else {
      final subT = (t - 0.5) / 0.5;
      playerX = (size.width - pad - 6) - (size.width - pad - 6 - centerX) * subT;
      playerY = (pad + 6) + (centerY - pad - 6) * subT;
    }

    // Trail line
    final trailPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(centerX, centerY), Offset(playerX, playerY), trailPaint);

    // Base Center dot
    final baseDotPaint = Paint()
      ..color = Colors.white38
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 3.0, baseDotPaint);

    // Player dot
    final playerDotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(playerX, playerY), 4.5, playerDotPaint);

    // Player dot glow
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(playerX, playerY), 8.0, glowPaint);
  }

  @override
  bool shouldRepaint(_CourtGraphicPainter oldDelegate) {
    return oldDelegate.animValue != animValue;
  }
}
