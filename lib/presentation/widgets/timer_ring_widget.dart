import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerRingWidget extends StatefulWidget {
  const TimerRingWidget({
    super.key,
    required this.secondsRemaining,
    required this.totalSeconds,
    required this.contextText,
    this.primaryColor = const Color(0xFF00FF87),
    this.size = 220.0,
    this.isPaused = false,
  });

  final int secondsRemaining;
  final int totalSeconds;
  final String contextText;
  final Color primaryColor;
  final double size;
  final bool isPaused;

  @override
  State<TimerRingWidget> createState() => _TimerRingWidgetState();
}

class _TimerRingWidgetState extends State<TimerRingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _timeFormatted {
    final mins = (widget.secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final secs = (widget.secondsRemaining % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final isFinalFive = widget.secondsRemaining <= 5 && widget.secondsRemaining > 0;
    final progress = widget.totalSeconds > 0
        ? (widget.secondsRemaining / widget.totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    final ringColor = widget.isPaused
        ? Colors.amberAccent
        : isFinalFive
            ? const Color(0xFFFF5252)
            : widget.primaryColor;

    final glowIntensity = isFinalFive ? 28.0 : 16.0;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scalePulse = (isFinalFive && !widget.isPaused)
            ? 1.0 + (_pulseController.value * 0.03)
            : 1.0;

        return Transform.scale(
          scale: scalePulse,
          child: Container(
            width: widget.size,
            height: widget.size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ringColor.withValues(alpha: isFinalFive ? 0.45 : 0.2),
                  blurRadius: glowIntensity,
                  spreadRadius: isFinalFive ? 4 : 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circular Progress Ring
                SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CustomPaint(
                    painter: _TimerRingPainter(
                      progress: progress,
                      color: ringColor,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      strokeWidth: 8.0,
                    ),
                  ),
                ),

                // Center Content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _timeFormatted,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: widget.size * 0.22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: ringColor.withValues(alpha: 0.5),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        widget.contextText.toUpperCase(),
                        key: ValueKey(widget.contextText),
                        style: GoogleFonts.poppins(
                          color: ringColor,
                          fontSize: widget.size * 0.065,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  _TimerRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Active progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
