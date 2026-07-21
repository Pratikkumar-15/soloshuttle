import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/drill.dart';
import 'app_button.dart';

class SkillIntroScreen extends StatelessWidget {
  final Drill drill;
  final VoidCallback onContinue;

  const SkillIntroScreen({
    super.key,
    required this.drill,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Learn Before Practice',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                drill.title,
                style: GoogleFonts.poppins(
                  color: AppColors.primaryGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Objective'),
              const SizedBox(height: 8),
              _buildSectionContent(drill.objective),
              const SizedBox(height: 24),
              if (drill.instructions.isNotEmpty) ...[
                _buildSectionTitle('Instructions'),
                const SizedBox(height: 8),
                ...drill.instructions.map((inst) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: Colors.white, fontSize: 16)),
                          Expanded(child: _buildSectionContent(inst)),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
              ],
              if (drill.coachCue.isNotEmpty) ...[
                _buildSectionTitle('Coach Cue'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.psychology, color: AppColors.cyan),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSectionContent(drill.coachCue)),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'CONTINUE TO DRILL',
                  icon: Icons.play_arrow_rounded,
                  onPressed: onContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        color: Colors.white60,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 15,
        height: 1.5,
      ),
    );
  }
}
