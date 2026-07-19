import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import '../widgets/badminton_court_widget.dart';
import '../widgets/section_title.dart';
import 'active_reaction_session_screen.dart';

class ReactionTrainingScreen extends StatefulWidget {
  const ReactionTrainingScreen({super.key});

  @override
  State<ReactionTrainingScreen> createState() => _ReactionTrainingScreenState();
}

class _ReactionTrainingScreenState extends State<ReactionTrainingScreen> {
  String _selectedMode = 'Random Direction'; // 'Random Direction', 'Random Color', 'Random Number'
  int _roundTimeSeconds = 30; // 20, 30, 45
  String _difficulty = 'Medium'; // Easy (3.5s), Medium (2.2s), Pro (1.3s)

  static const List<String> _modes = [
    'Random Direction',
    'Random Number',
  ];

  static const Map<String, double> _speeds = {
    'Easy': 3.5,
    'Medium': 2.2,
    'Pro': 1.3,
  };

  static const List<Map<String, String>> _numberMappings = [
    {'num': '1', 'corner': 'Front Left'},
    {'num': '2', 'corner': 'Front Right'},
    {'num': '3', 'corner': 'Mid Left'},
    {'num': '4', 'corner': 'Mid Right'},
    {'num': '5', 'corner': 'Rear Left'},
    {'num': '6', 'corner': 'Rear Right'},
  ];

  void _startSession() {
    final pace = _speeds[_difficulty] ?? 2.2;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveReactionSessionScreen(
          mode: _selectedMode,
          roundDurationSeconds: _roundTimeSeconds,
          paceSpeedSeconds: pace,
        ),
      ),
    );
  }

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
        title: Text('Reaction Training Suite', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: AppColors.reactionGradient,
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.bolt_rounded, color: Colors.white, size: 36),
                      BadgeTag(label: '3 ROUNDS SYSTEM', color: Colors.white24),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Reaction Speed & Agility',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Voice callouts integrated into all modes. Place your phone on a stand or court line.',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // MODE SELECTOR
            const SectionTitle(title: 'Reaction Mode'),
            const SizedBox(height: 10),
            Row(
              children: _modes.map((mode) {
                final isSelected = _selectedMode == mode;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: isSelected ? AppColors.orange : AppColors.surface,
                      onTap: () => setState(() => _selectedMode = mode),
                      child: Text(
                        mode.replaceAll('Random ', ''),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // NUMBER MAPPING EXPLANATION (Only shown if Random Number mode selected)
            if (_selectedMode == 'Random Number') ...[
              const SectionTitle(title: 'Corner Number Mapping'),
              const SizedBox(height: 8),
              AppCard(
                backgroundColor: AppColors.surface,
                borderColor: AppColors.primaryGreen.withValues(alpha: 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Memorize the corner numbers before starting:',
                      style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _numberMappings.length,
                      itemBuilder: (context, index) {
                        final item = _numberMappings[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 26,
                                width: 26,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  item['num']!,
                                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                item['corner']!,
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ROUND DURATION SELECTOR (20s, 30s, 45s)
            const SectionTitle(title: 'Round Duration (3 Rounds Total)'),
            const SizedBox(height: 10),
            Row(
              children: [20, 30, 45].map((sec) {
                final isSelected = _roundTimeSeconds == sec;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: isSelected ? AppColors.primaryGreen : AppColors.surface,
                      onTap: () => setState(() => _roundTimeSeconds = sec),
                      child: Text(
                        '${sec}s / round',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // PACE SPEED SELECTOR
            const SectionTitle(title: 'Pace Speed (Callout Interval)'),
            const SizedBox(height: 10),
            Row(
              children: ['Easy', 'Medium', 'Pro'].map((level) {
                final isSelected = _difficulty == level;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: isSelected ? AppColors.cyan : AppColors.surface,
                      onTap: () => setState(() => _difficulty = level),
                      child: Column(
                        children: [
                          Text(
                            level,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_speeds[level]}s',
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.black87 : AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // LIVE COURT VISUALIZER DEMO
            const SectionTitle(title: 'Court Direction Preview'),
            const SizedBox(height: 10),
            const BadmintonCourtWidget(activeDirection: 'BASE CENTER'),

            const SizedBox(height: 35),

            AppButton(
              text: 'START REACTION DRILL (3 ROUNDS)',
              icon: Icons.bolt_rounded,
              onPressed: _startSession,
            ),
          ],
        ),
      ),
    );
  }
}
