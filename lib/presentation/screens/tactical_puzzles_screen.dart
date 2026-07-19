import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/tactical_puzzle.dart';
import '../../providers/user_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import '../widgets/badminton_court_widget.dart';

class TacticalPuzzlesScreen extends StatefulWidget {
  const TacticalPuzzlesScreen({super.key});

  @override
  State<TacticalPuzzlesScreen> createState() => _TacticalPuzzlesScreenState();
}

class _TacticalPuzzlesScreenState extends State<TacticalPuzzlesScreen> {
  int _currentPuzzleIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;

  final List<TacticalPuzzle> _puzzles = const [
    TacticalPuzzle(
      id: 'tp_01',
      title: 'Deep Rear Court Pressure Escape',
      situationDescription: 'Your opponent clears high and deep into your backhand rear corner. Opponent is standing at center ready to attack.',
      courtZone: 'Rear Court Backhand',
      opponentPosition: 'Base Center Ready',
      shuttleHeight: 'High Overhead',
      coachTip: 'When caught deep in the backhand corner, hitting a high clear resets the rally and allows full recovery to base center.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'High Straight Clear',
          description: 'Hit a high trajectory clear deep into opponent rear court.',
          isCorrect: true,
          explanation: 'Correct! High clear gains maximum air time, forcing the opponent back while giving you full time to return to base center.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Flat Fast Smash',
          description: 'Attempt a maximum power jump smash down the line.',
          isCorrect: false,
          explanation: 'Incorrect. Smashing from deep backhand corner off-balance leaves net wide open for an easy opponent counter-kill.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Tight Cross Net Drop',
          description: 'Try a slow soft drop shot across to front forehand net.',
          isCorrect: false,
          explanation: 'Risky. Off-balance drops often pop up over the net, giving opponent an immediate net kill opportunity.',
        ),
        TacticalPuzzleOption(
          id: 3,
          shotName: 'Midcourt Drive',
          description: 'Drive the shuttle flat directly at opponent chest.',
          isCorrect: false,
          explanation: 'Incorrect. Midcourt drive gives opponent zero pressure and gives you no time to recover to center.',
        ),
      ],
    ),
    TacticalPuzzle(
      id: 'tp_02',
      title: 'Net Exchange Counter Attack',
      situationDescription: 'Opponent plays a tight tumbling net shot. You reach shuttle early at net tape level.',
      courtZone: 'Front Net Tape',
      opponentPosition: 'Midcourt Standing Low',
      shuttleHeight: 'Above Net Tape',
      coachTip: 'High contact at net tape allows tight net pushes that force weak opponent lifts.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Tight Hairpin Net Roll',
          description: 'Brush shuttle gently to roll tight over net tape.',
          isCorrect: true,
          explanation: 'Correct! Hairpin net shot forces opponent to lift under pressure, giving your team immediate attack setup.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'High Underarm Lift',
          description: 'Lift shuttle high to rear court.',
          isCorrect: false,
          explanation: 'Incorrect. Reaching early at net tape to lift surrenders attacking control when you had the upper hand.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Hard Midcourt Push',
          description: 'Push shuttle fast into body.',
          isCorrect: false,
          explanation: 'Acceptable but hairpin net shot creates a guaranteed weak lift opportunity.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final puzzle = _puzzles[_currentPuzzleIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Tactical IQ Puzzles', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BadgeTag(label: 'PUZZLE ${_currentPuzzleIndex + 1}/${_puzzles.length}', color: AppColors.purple),
                Text('Tactical Pillar • +50 XP', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(puzzle.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(puzzle.situationDescription, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),

            const SizedBox(height: 20),

            // Court Graphic Simulation
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const BadmintonCourtWidget(activeDirection: 'REAR LEFT'),
              ),
            ),

            const SizedBox(height: 24),

            Text('Select Best Tactical Shot:', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            ...puzzle.options.map((opt) {
              final isSelected = _selectedOptionIndex == opt.id;
              Color optBorderColor = Colors.white10;
              Color optBgColor = AppColors.surface;

              if (_isAnswered) {
                if (opt.isCorrect) {
                  optBorderColor = AppColors.primaryGreen;
                  optBgColor = AppColors.primaryGreen.withValues(alpha: 0.15);
                } else if (isSelected && !opt.isCorrect) {
                  optBorderColor = AppColors.red;
                  optBgColor = AppColors.red.withValues(alpha: 0.15);
                }
              } else if (isSelected) {
                optBorderColor = AppColors.cyan;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: _isAnswered
                      ? null
                      : () {
                          setState(() {
                            _selectedOptionIndex = opt.id;
                            _isAnswered = true;
                          });
                          if (opt.isCorrect) {
                            Provider.of<UserProvider>(context, listen: false).addXp(50, category: 'Tactical');
                          }
                        },
                  backgroundColor: optBgColor,
                  borderColor: optBorderColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(opt.shotName, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(opt.description, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                      if (_isAnswered && (isSelected || opt.isCorrect)) ...[
                        const SizedBox(height: 10),
                        Text(
                          opt.explanation,
                          style: GoogleFonts.poppins(
                            color: opt.isCorrect ? AppColors.electricGreen : AppColors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),

            if (_isAnswered) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentPuzzleIndex = (_currentPuzzleIndex + 1) % _puzzles.length;
                    _selectedOptionIndex = null;
                    _isAnswered = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('NEXT TACTICAL PUZZLE ➔', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
