import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
  });

  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    if (actionText != null && onActionPressed != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionText!,
              style: GoogleFonts.poppins(
                color: Colors.greenAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
