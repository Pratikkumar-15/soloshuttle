import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class HexagonRadarChart extends StatefulWidget {
  final Map<String, int> skillRatings;
  final double size;

  const HexagonRadarChart({
    super.key,
    required this.skillRatings,
    this.size = 270,
  });

  @override
  State<HexagonRadarChart> createState() => _HexagonRadarChartState();
}

class _HexagonRadarChartState extends State<HexagonRadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const List<String> categories = [
    'Technical',
    'Footwork',
    'Tactical',
    'Physical',
    'Mental',
    'Consistency',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant HexagonRadarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skillRatings != widget.skillRatings) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final values = categories
        .map((cat) => (widget.skillRatings[cat] ?? 50).clamp(0, 100) / 100.0)
        .toList();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: CourtFormRadarChartPainter(
              categories: categories,
              values: values,
              skillRatings: widget.skillRatings,
              progress: _animation.value,
            ),
          ),
        );
      },
    );
  }
}

class CourtFormRadarChartPainter extends CustomPainter {
  final List<String> categories;
  final List<double> values;
  final Map<String, int> skillRatings;
  final double progress;

  CourtFormRadarChartPainter({
    required this.categories,
    required this.values,
    required this.skillRatings,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 42;
    final numSides = categories.length;
    final angleStep = (2 * pi) / numSides;

    final gridDashPaint = Paint()
      ..color = AppColors.sageGray.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = AppColors.sageGray.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final dataFillPaint = Paint()
      ..color = AppColors.limeGreen.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    final dataOutlinePaint = Paint()
      ..color = AppColors.limeGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final skyBlueDotPaint = Paint()
      ..color = AppColors.skyBlue
      ..style = PaintingStyle.fill;

    final goldCenterDotPaint = Paint()
      ..color = AppColors.corkGold
      ..style = PaintingStyle.fill;

    // 1. Concentric dashed hexagonal grid rings
    for (int step = 1; step <= 5; step++) {
      final r = radius * (step / 5.0);
      _drawDashedPolygon(canvas, center, r, numSides, angleStep, gridDashPaint);
    }

    // 2. Axis lines & labels
    for (int i = 0; i < numSides; i++) {
      final angle = i * angleStep - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), axisPaint);

      final labelRadius = radius + 24;
      final lx = center.dx + labelRadius * cos(angle);
      final ly = center.dy + labelRadius * sin(angle);
      final scoreVal = ((skillRatings[categories[i]] ?? 50) * progress).round();

      final textSpan = TextSpan(
        children: [
          TextSpan(
            text: '${categories[i].toUpperCase()}\n',
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.sageGray,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          TextSpan(
            text: '$scoreVal',
            style: GoogleFonts.bebasNeue(
              color: AppColors.chalkWhite,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );

      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(lx - (textPainter.width / 2), ly - (textPainter.height / 2)),
      );
    }

    // 3. Animated Lime-Green Data Polygon
    final polygonPath = Path();
    final vertexPoints = <Offset>[];

    for (int i = 0; i < numSides; i++) {
      final angle = i * angleStep - (pi / 2);
      final targetR = radius * values[i];
      final r = targetR * progress; // Smooth animated expansion
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      final pt = Offset(x, y);
      vertexPoints.add(pt);

      if (i == 0) {
        polygonPath.moveTo(x, y);
      } else {
        polygonPath.lineTo(x, y);
      }
    }
    polygonPath.close();

    canvas.drawPath(polygonPath, dataFillPaint);
    canvas.drawPath(polygonPath, dataOutlinePaint);

    // 4. Sky-Blue Dot Markers at each vertex
    for (final pt in vertexPoints) {
      canvas.drawCircle(pt, 5.0, skyBlueDotPaint);
      canvas.drawCircle(pt, 2.0, Paint()..color = AppColors.courtBackground);
    }

    // 5. Gold Dot at center
    canvas.drawCircle(center, 4.0, goldCenterDotPaint);
    canvas.drawCircle(center, 2.0, Paint()..color = AppColors.courtBackground);
  }

  void _drawDashedPolygon(Canvas canvas, Offset center, double radius,
      int sides, double angleStep, Paint paint) {
    for (int i = 0; i < sides; i++) {
      final a1 = i * angleStep - (pi / 2);
      final a2 = (i + 1) * angleStep - (pi / 2);
      final p1 = Offset(
          center.dx + radius * cos(a1), center.dy + radius * sin(a1));
      final p2 = Offset(
          center.dx + radius * cos(a2), center.dy + radius * sin(a2));

      final dx = p2.dx - p1.dx;
      final dy = p2.dy - p1.dy;
      final distance = sqrt(dx * dx + dy * dy);
      const dashWidth = 4.0;
      const dashSpace = 3.0;
      double drawn = 0;

      while (drawn < distance) {
        final double x1 = p1.dx + (dx * (drawn / distance));
        final double y1 = p1.dy + (dy * (drawn / distance));
        drawn += dashWidth;
        if (drawn > distance) drawn = distance;
        final double x2 = p1.dx + (dx * (drawn / distance));
        final double y2 = p1.dy + (dy * (drawn / distance));

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
        drawn += dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CourtFormRadarChartPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
