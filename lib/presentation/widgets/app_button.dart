import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

enum AppButtonType { primary, secondary, outline, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.height = 54.0,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (type == AppButtonType.outline) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24),
          minimumSize: Size.fromHeight(height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _buildChild(Colors.white),
      );
    }

    Color bgColor;
    Color fgColor;

    switch (type) {
      case AppButtonType.secondary:
        bgColor = Colors.white;
        fgColor = Colors.black;
        break;
      case AppButtonType.danger:
        bgColor = AppColors.red;
        fgColor = Colors.white;
        break;
      case AppButtonType.primary:
      default:
        bgColor = AppColors.primaryGreen;
        fgColor = Colors.black;
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _buildChild(fgColor),
      ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }
}
