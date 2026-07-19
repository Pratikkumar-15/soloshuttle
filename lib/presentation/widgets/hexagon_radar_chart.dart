import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class HexagonRadarChart extends StatelessWidget {
  final Map<String, int> skillRatings;
  final double size;

  const HexagonRadarChart({
    super.key,
    required this.skillRatings,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['Technical', 'Footwork', 'Tactical', 'Physical', 'Mental', 'Consistency'];
    final values = categories.map((cat) => (skillRatings[cat] ?? 45).clamp(0, 100) / 100.0).toList();

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPainterWidget(
            categories: categories,
            values: values,
          ),
        ),
        const SizedBox(height: 12),
        // Skill Values Grid Legend
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: categories.map((cat) {
            final val = skillRatings[cat] ?? 45;
            Color dotColor;
            switch (cat) {
              case 'Technical':
                dotColor = AppColors.primaryGreen;
                break;
              case 'Footwork':
                dotColor = AppColors.cyan;
                break;
              case 'Tactical':
                dotColor = AppColors.purple;
                break;
              case 'Physical':
                dotColor = AppColors.orange;
                break;
              case 'Mental':
                dotColor = AppColors.red;
                break;
              default:
                dotColor = AppColors.electricGreen;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: dotColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$cat: ',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '$val/100',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CustomPainterWidget extends StatelessWidget {
  final List<String> categories;
  final List<double> values;

  const CustomPainterWidget({
    super.key,
    required this.categories,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadarChartPainter(categories: categories, values: values),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List<String> categories;
  final List<double> values;

  RadarChartPainter({required this.categories, required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 38;
    final numSides = categories.length;
    final angleStep = (2 * pi) / numSides;

    // Paints
    final gridPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final fillPaint = Paint()
      ..color = AppColors.primaryGreen.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = AppColors.electricGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final vertexDotPaint = Paint()
      ..color = AppColors.electricGreen
      ..style = PaintingStyle.fill;

    // Draw concentric polygon grid webs (20%, 40%, 60%, 80%, 100%)
    for (int step = 1; step <= 5; step++) {
      final r = radius * (step / 5.0);
      final path = Path();
      for (int i = 0; i < numSides; i++) {
        final angle = i * angleStep - (pi / 2);
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw axis lines and category labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < numSides; i++) {
      final angle = i * angleStep - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.drawLine(center, Offset(x, y), axisPaint);

      // Label positioning
      final labelRadius = radius + 22;
      final lx = center.dx + labelRadius * cos(angle);
      final ly = center.dy + labelRadius * sin(angle);

      textPainter.text = TextSpan(
        text: categories[i],
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(lx - (textPainter.width / 2), ly - (textPainter.height / 2)),
      );
    }

    // Draw value polygon
    final valuePath = Path();
    final points = <Offset>[];

    for (int i = 0; i < numSides; i++) {
      final angle = i * angleStep - (pi / 2);
      final val = values[i];
      final r = radius * val;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      final point = Offset(x, y);
      points.add(point);

      if (i == 0) {
        valuePath.moveTo(x, y);
      } else {
        valuePath.lineTo(x, y);
      }
    }
    valuePath.close();

    // Draw fill & outline
    canvas.drawPath(valuePath, fillPaint);
    canvas.drawPath(valuePath, outlinePaint);

    // Draw vertex dots
    for (final pt in points) {
      canvas.drawCircle(pt, 4.5, vertexDotPaint);
      canvas.drawCircle(pt, 2.0, Paint()..color = Colors.black);
    }
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) => true;
}
