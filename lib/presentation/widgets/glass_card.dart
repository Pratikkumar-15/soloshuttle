import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24.0,
    this.borderColor,
    this.glowColor,
    this.backgroundColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? glowColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? Colors.white.withValues(alpha: 0.12);
    final effectiveGlowColor = glowColor ?? AppColors.cyan.withValues(alpha: 0.15);
    final effectiveBgColor = backgroundColor ?? const Color(0xFF111C2E).withValues(alpha: 0.75);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: effectiveBorderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: effectiveGlowColor,
                blurRadius: 24,
                spreadRadius: -4,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
