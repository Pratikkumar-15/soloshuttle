import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/assessment.dart';
import '../../providers/user_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';

class AssessmentDrillsScreen extends StatefulWidget {
  const AssessmentDrillsScreen({super.key});

  @override
  State<AssessmentDrillsScreen> createState() => _AssessmentDrillsScreenState();
}

class _AssessmentDrillsScreenState extends State<AssessmentDrillsScreen> {
  bool _isTesting = false;
  String _activeTest = '';
  int _timerMs = 0;
  Timer? _timer;

  void _runTest(String testType) {
    setState(() {
      _isTesting = true;
      _activeTest = testType;
      _timerMs = 0;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      setState(() {
        _timerMs += 50;
      });
      if (_timerMs >= 4000) {
        _finishTest(testType);
      }
    });
  }

  void _finishTest(String testType) {
    _timer?.cancel();
    setState(() {
      _isTesting = false;
    });

    final score = (_timerMs / 100.0).clamp(65.0, 95.0);
    final newAssessment = Assessment(
      id: 'ast_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      type: testType,
      score: score,
      unit: testType.contains('Speed') ? 'sec' : '%',
      notes: 'Completed BWF Level 3 baseline evaluation test.',
      ratingLevel: score > 85 ? 'Elite' : (score > 75 ? 'Advanced' : 'Developing'),
    );

    Provider.of<UserProvider>(context, listen: false).logAssessment(newAssessment);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$testType completed! Score: ${score.toStringAsFixed(1)} stored in your profile.'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final history = userProvider.user.assessmentHistory;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Periodic Skill Assessments', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isTesting) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cyan, width: 2),
                ),
                child: Column(
                  children: [
                    BadgeTag(label: 'ASSESSMENT TEST IN PROGRESS', color: AppColors.cyan),
                    const SizedBox(height: 12),
                    Text(_activeTest, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      '${(_timerMs / 1000.0).toStringAsFixed(2)} s',
                      style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () => _finishTest(_activeTest),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.black),
                      child: const Text('STOP & RECORD TEST'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text('Available Assessment Tests', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Evaluate footwork speed, reaction time, and stroke accuracy.', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: 16),

            _buildTestCard('Footwork Speed Test', '6-corner shadow movement sprint time evaluation.', Icons.directions_run_rounded, AppColors.primaryGreen),
            const SizedBox(height: 10),
            _buildTestCard('Reaction Time Test', 'Visual and voice cue response latency evaluation.', Icons.bolt_rounded, AppColors.orange),
            const SizedBox(height: 10),
            _buildTestCard('Stroke Accuracy Test', '% of wall drive exchanges staying inside target zone.', Icons.gps_fixed_rounded, AppColors.cyan),
            const SizedBox(height: 10),
            _buildTestCard('Recovery Speed Test', 'Time taken to return to base center post-lunge.', Icons.restore_rounded, AppColors.purple),

            const SizedBox(height: 28),

            Text('Assessment History', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            if (history.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Text('No assessments completed yet. Tap a test above to record your score.', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                ),
              )
            else
              ...history.reversed.map((ast) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    child: Row(
                      children: [
                        const Icon(Icons.assessment_rounded, color: AppColors.electricGreen, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ast.type, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              Text('${ast.date.day}/${ast.date.month}/${ast.date.year} • Rating: ${ast.ratingLevel}', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                            ],
                          ),
                        ),
                        Text(
                          '${ast.score.toStringAsFixed(1)} ${ast.unit}',
                          style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(String title, String desc, IconData icon, Color color) {
    return AppCard(
      onTap: () => _runTest(title),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                Text(desc, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11.5)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}
