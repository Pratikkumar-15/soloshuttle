import 'dart:math';
import 'package:flutter/material.dart';

class WaveformWidget extends StatefulWidget {
  const WaveformWidget({
    super.key,
    required this.isSpeaking,
    this.barCount = 7,
    this.height = 24.0,
    this.activeColor = const Color(0xFF00FF87),
    this.inactiveColor = Colors.white30,
  });

  final bool isSpeaking;
  final int barCount;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    if (widget.isSpeaking) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking != oldWidget.isSpeaking) {
      if (widget.isSpeaking) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.animateTo(0.2, duration: const Duration(milliseconds: 300));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.barCount, (index) {
            final double baseHeight = widget.isSpeaking
                ? (0.2 + (sin(_controller.value * pi * 2 + index * 0.8).abs() * 0.8))
                : (index % 2 == 0 ? 0.25 : 0.15);

            final double barH = (baseHeight * widget.height).clamp(3.0, widget.height);
            return Container(
              width: 3.5,
              height: barH,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                color: widget.isSpeaking ? widget.activeColor : widget.inactiveColor,
                borderRadius: BorderRadius.circular(4),
                boxShadow: widget.isSpeaking
                    ? [
                        BoxShadow(
                          color: widget.activeColor.withValues(alpha: 0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
            );
          }),
        );
      },
    );
  }
}
