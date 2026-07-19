import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class TrainingBottomNav extends StatelessWidget {
  const TrainingBottomNav({
    super.key,
    required this.isFirstPhase,
    required this.isLastPhase,
    required this.isPaused,
    required this.onPreviousPhase,
    required this.onTogglePause,
    required this.onNextPhase,
    this.requiresSkipConfirmation = true,
  });

  final bool isFirstPhase;
  final bool isLastPhase;
  final bool isPaused;
  final VoidCallback onPreviousPhase;
  final VoidCallback onTogglePause;
  final VoidCallback onNextPhase;
  final bool requiresSkipConfirmation;

  void _handlePrevious(BuildContext context) {
    if (isFirstPhase) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162238),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Go to Previous Phase?',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          'Your progress for the current phase will reset. Are you sure?',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onPreviousPhase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Go Back', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleNext(BuildContext context) {
    if (isLastPhase) {
      onNextPhase();
      return;
    }

    if (!requiresSkipConfirmation) {
      onNextPhase();
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162238),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Skip this phase?',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          'Your progress for this phase won\'t be counted.',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onNextPhase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Skip Phase', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1524),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ◀ Previous Phase
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: isFirstPhase ? null : () => _handlePrevious(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white24,
                  side: BorderSide(
                    color: isFirstPhase ? Colors.white12 : Colors.white.withValues(alpha: 0.25),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_rounded, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Previous',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ⏸ Pause / ▶ Resume
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onTogglePause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPaused ? AppColors.cyan : Colors.white.withValues(alpha: 0.12),
                  foregroundColor: isPaused ? Colors.black : Colors.white,
                  elevation: isPaused ? 6 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isPaused ? 'Resume' : 'Pause',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ▶ Next Phase or 🏁 Finish Training
          Expanded(
            child: SizedBox(
              height: 52,
              child: Container(
                decoration: isLastPhase
                    ? BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      )
                    : null,
                child: ElevatedButton(
                  onPressed: () => _handleNext(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLastPhase ? Colors.transparent : AppColors.primaryGreen,
                    foregroundColor: Colors.black,
                    shadowColor: isLastPhase ? Colors.transparent : AppColors.primaryGreen.withValues(alpha: 0.3),
                    elevation: isLastPhase ? 0 : 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLastPhase ? 'Finish 🏁' : 'Next Phase',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isLastPhase) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
