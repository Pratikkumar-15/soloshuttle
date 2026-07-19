import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class BadmintonCourtWidget extends StatelessWidget {
  const BadmintonCourtWidget({
    super.key,
    required this.activeDirection,
  });

  final String activeDirection;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12, width: 2),
      ),
      child: Stack(
        children: [
          // Outer Boundary Court Lines
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Center Net Line
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 3,
              width: double.infinity,
              color: AppColors.primaryGreen.withValues(alpha: 0.8),
            ),
          ),
          // Center Service Line
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 2,
              height: double.infinity,
              color: Colors.white12,
            ),
          ),

          // 6 Zone Targets Grid
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Front Net Court
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildZoneTarget('FRONT LEFT', 'Front Left'),
                  _buildZoneTarget('FRONT RIGHT', 'Front Right'),
                ],
              ),
              // Mid Court
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildZoneTarget('MID LEFT', 'Mid Left'),
                  _buildZoneTarget('BASE', 'BASE CENTER'),
                  _buildZoneTarget('MID RIGHT', 'Mid Right'),
                ],
              ),
              // Rear Back Court
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildZoneTarget('BACK LEFT', 'Back Left'),
                  _buildZoneTarget('BACK RIGHT', 'Back Right'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneTarget(String directionKey, String label) {
    final dirUpper = activeDirection.toUpperCase();
    final isTarget = dirUpper.contains(directionKey) ||
        (directionKey == 'BACK LEFT' && dirUpper.contains('REAR LEFT')) ||
        (directionKey == 'BACK RIGHT' && dirUpper.contains('REAR RIGHT'));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isTarget ? AppColors.electricGreen : AppColors.surfaceLight.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isTarget ? Colors.white : Colors.white12,
          width: isTarget ? 2 : 1,
        ),
        boxShadow: isTarget
            ? [
                BoxShadow(
                  color: AppColors.electricGreen.withValues(alpha: 0.6),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: isTarget ? Colors.black : Colors.white60,
          fontWeight: isTarget ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
    );
  }
}
