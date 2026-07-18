import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../../core/services/voice_coach_service.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import '../widgets/section_title.dart';
import '../widgets/badminton_court_widget.dart';

class ReactionTrainingScreen extends StatefulWidget {
  const ReactionTrainingScreen({super.key});

  @override
  State<ReactionTrainingScreen> createState() => _ReactionTrainingScreenState();
}

class _ReactionTrainingScreenState extends State<ReactionTrainingScreen> {
  final VoiceCoachService _ttsService = VoiceCoachService();
  bool _isRunning = false;
  String _selectedMode = 'Random Direction'; // 'Random Direction', 'Random Color', 'Random Number', 'Voice Commands'
  String _difficulty = 'Medium'; // Easy (3.5s), Medium (2.2s), Pro (1.3s)
  String _activeCue = 'READY';
  Color _activeColor = AppColors.surface;
  int _score = 0;
  Timer? _timer;
  final Random _random = Random();

  static const List<String> _modes = [
    'Random Direction',
    'Random Color',
    'Random Number',
    'Voice Commands',
  ];

  static const Map<String, double> _speeds = {
    'Easy': 3.5,
    'Medium': 2.2,
    'Pro': 1.3,
  };

  static const List<String> _directions = [
    'FRONT LEFT',
    'FRONT RIGHT',
    'MID LEFT',
    'MID RIGHT',
    'BACK LEFT',
    'BACK RIGHT',
  ];

  static const List<Map<String, dynamic>> _colorsList = [
    {'name': '🔴 RED - FRONT LEFT', 'color': Color(0xFFFF5252)},
    {'name': '🟢 GREEN - FRONT RIGHT', 'color': Color(0xFF2ECC71)},
    {'name': '🔵 BLUE - BACK LEFT', 'color': Color(0xFF00CEC9)},
    {'name': '🟡 YELLOW - BACK RIGHT', 'color': Color(0xFFFF9F43)},
  ];

  void _startTraining() {
    setState(() {
      _isRunning = true;
      _score = 0;
      _activeCue = 'GET READY';
      _activeColor = AppColors.surface;
    });

    if (_selectedMode == 'Voice Commands') {
      _ttsService.speak('Get ready for voice command reaction');
    }

    _timer?.cancel();
    final intervalMs = ((_speeds[_difficulty] ?? 2.2) * 1000).toInt();

    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      if (mounted && _isRunning) {
        setState(() {
          _score++;
          if (_selectedMode == 'Random Direction') {
            _activeCue = _directions[_random.nextInt(_directions.length)];
            _activeColor = AppColors.surface;
          } else if (_selectedMode == 'Random Color') {
            final colObj = _colorsList[_random.nextInt(_colorsList.length)];
            _activeCue = colObj['name'] as String;
            _activeColor = colObj['color'] as Color;
          } else if (_selectedMode == 'Random Number') {
            final num = _random.nextInt(6) + 1;
            _activeCue = 'CORNER TARGET #$num';
            _activeColor = AppColors.surface;
          } else if (_selectedMode == 'Voice Commands') {
            _activeCue = _directions[_random.nextInt(_directions.length)];
            _activeColor = AppColors.surface;
            _ttsService.speak(_activeCue);
          }
        });
      }
    });
  }

  void _stopTraining() {
    _timer?.cancel();
    _ttsService.stop();

    final xpEarned = _score * 5;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final trainingProvider = Provider.of<TrainingProvider>(context, listen: false);

    if (_score > 0) {
      userProvider.addXp(xpEarned);
      trainingProvider.logCompletedTraining(
        title: 'Reaction Drill ($_selectedMode)',
        duration: '${(_score * (_speeds[_difficulty] ?? 2.2) / 60).toStringAsFixed(1)} min',
        xpEarned: xpEarned,
        category: 'Reaction Drill',
      );
    }

    setState(() {
      _isRunning = false;
      _activeCue = 'COMPLETE';
      _activeColor = AppColors.surface;
    });

    _showCompletionDialog(xpEarned);
  }

  void _showCompletionDialog(int xpEarned) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Drill Finished! ⚡', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mode: $_selectedMode', style: GoogleFonts.poppins(color: Colors.white70)),
              const SizedBox(height: 4),
              Text('Reactions Logged: $_score', style: GoogleFonts.poppins(color: Colors.white70)),
              const SizedBox(height: 12),
              Text('+ $xpEarned XP Earned!', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.black),
              child: const Text('GREAT!'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ttsService.stop();
    super.dispose();
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
            // Display Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: _activeColor == AppColors.surface ? null : _activeColor.withValues(alpha: 0.8),
                gradient: _activeColor == AppColors.surface ? AppColors.reactionGradient : null,
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BadgeTag(label: _selectedMode, color: Colors.white),
                      Text('REACTIONS: $_score', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _activeCue,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Live Court Map Indicator
            BadmintonCourtWidget(activeDirection: _activeCue),

            const SizedBox(height: 28),

            // Reaction Mode Selector (Direction, Color, Number, Voice)
            const SectionTitle(title: 'Reaction Mode'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _modes.map((mode) {
                final isSelected = _selectedMode == mode;
                return ChoiceChip(
                  selected: isSelected,
                  label: Text(mode),
                  labelStyle: GoogleFonts.poppins(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  selectedColor: AppColors.orange,
                  backgroundColor: AppColors.surface,
                  onSelected: _isRunning ? null : (_) => setState(() => _selectedMode = mode),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Difficulty Speed Selector
            const SectionTitle(title: 'Pace Speed'),
            const SizedBox(height: 12),
            Row(
              children: ['Easy', 'Medium', 'Pro'].map((level) {
                final isSelected = _difficulty == level;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: isSelected ? AppColors.primaryGreen : AppColors.surface,
                      onTap: _isRunning ? null : () => setState(() => _difficulty = level),
                      child: Text(
                        level,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 35),

            if (!_isRunning)
              AppButton(
                text: 'START REACTION DRILL',
                icon: Icons.bolt_rounded,
                onPressed: _startTraining,
              )
            else
              AppButton(
                text: 'FINISH & LOG DRILL',
                type: AppButtonType.danger,
                icon: Icons.stop_rounded,
                onPressed: _stopTraining,
              ),
          ],
        ),
      ),
    );
  }
}
