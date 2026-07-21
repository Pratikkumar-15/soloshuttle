import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _selectedMode = 'Random Direction'; // 'Random Direction', 'Random Number'
  int _roundTimeSeconds = 30; // 20, 30, 45
  String _difficulty = 'Medium'; // Easy (3.5s), Medium (2.2s), Pro (1.3s)

  // Custom Direction Selector State
  final Set<String> _selectedDirections = {
    'FRONT LEFT',
    'FRONT RIGHT',
    'MID LEFT',
    'MID RIGHT',
    'BACK LEFT',
    'BACK RIGHT',
  };

  static const List<String> _modes = [
    'Random Direction',
    'Random Number',
  ];

  static const Map<String, double> _speeds = {
    'Easy': 3.5,
    'Medium': 2.2,
    'Pro': 1.3,
  };

  static const List<Map<String, String>> _allDirectionsInfo = [
    {'code': 'FRONT LEFT', 'label': 'Front Left Net', 'icon': '↖️'},
    {'code': 'FRONT RIGHT', 'label': 'Front Right Net', 'icon': '↗️'},
    {'code': 'MID LEFT', 'label': 'Midcourt Left', 'icon': '⬅️'},
    {'code': 'MID RIGHT', 'label': 'Midcourt Right', 'icon': '➡️'},
    {'code': 'BACK LEFT', 'label': 'Backhand Rear', 'icon': '↙️'},
    {'code': 'BACK RIGHT', 'label': 'Forehand Rear', 'icon': '↘️'},
  ];

  static const List<Map<String, String>> _numberMappings = [
    {'num': '1', 'corner': 'Front Left'},
    {'num': '2', 'corner': 'Front Right'},
    {'num': '3', 'corner': 'Mid Left'},
    {'num': '4', 'corner': 'Mid Right'},
    {'num': '5', 'corner': 'Back Left'},
    {'num': '6', 'corner': 'Back Right'},
  ];

  void _startSession() {
    if (_selectedMode == 'Random Direction' && _selectedDirections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least 1 court direction to train!',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: AppColors.coral,
        ),
      );
      return;
    }

    final pace = _speeds[_difficulty] ?? 2.2;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveReactionSessionScreen(
          mode: _selectedMode,
          roundDurationSeconds: _roundTimeSeconds,
          paceSpeedSeconds: pace,
          selectedDirections: _selectedDirections.toList(),
        ),
      ),
    );
  }

  void _selectPreset(String preset) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedDirections.clear();
      switch (preset) {
        case 'ALL':
          _selectedDirections.addAll([
            'FRONT LEFT',
            'FRONT RIGHT',
            'MID LEFT',
            'MID RIGHT',
            'BACK LEFT',
            'BACK RIGHT',
          ]);
          break;
        case 'FRONT':
          _selectedDirections.addAll(['FRONT LEFT', 'FRONT RIGHT']);
          break;
        case 'REAR':
          _selectedDirections.addAll(['BACK LEFT', 'BACK RIGHT']);
          break;
        case 'MID':
          _selectedDirections.addAll(['MID LEFT', 'MID RIGHT']);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.courtBackground,
      appBar: AppBar(
        backgroundColor: AppColors.courtBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.chalkWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reaction Training Suite',
          style: GoogleFonts.poppins(
            color: AppColors.chalkWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                borderRadius: BorderRadius.circular(22),
                gradient: AppColors.reactionGradient,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
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
                    style: GoogleFonts.bebasNeue(
                      color: Colors.white,
                      fontSize: 26,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Customize court directions & voice callouts. Place your phone on a stand or court line.',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
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
                      backgroundColor:
                          isSelected ? AppColors.limeGreen : AppColors.courtSurface,
                      borderColor: isSelected
                          ? AppColors.limeGreen
                          : AppColors.sageGray.withValues(alpha: 0.2),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedMode = mode);
                      },
                      child: Text(
                        mode.replaceAll('Random ', ''),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(
                          color: isSelected
                              ? AppColors.courtBackground
                              : AppColors.chalkWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // CUSTOM DIRECTION SELECTOR (Shown when Random Direction mode is active)
            if (_selectedMode == 'Random Direction') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: SectionTitle(title: 'Selected Court Directions'),
                  ),
                  const SizedBox(width: 8),
                  BadgeTag(
                    label: '${_selectedDirections.length} / 6 ACTIVE',
                    color: AppColors.corkGold,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Select which directions the voice coach will call out during your workout:',
                style: GoogleFonts.inter(
                  color: AppColors.sageGray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),

              // Quick Presets
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildPresetChip('ALL (6)', () => _selectPreset('ALL')),
                  _buildPresetChip('NET ONLY', () => _selectPreset('FRONT')),
                  _buildPresetChip('MIDCOURT', () => _selectPreset('MID')),
                  _buildPresetChip('REAR ONLY', () => _selectPreset('REAR')),
                ],
              ),

              const SizedBox(height: 12),

              // 6 Grid Checkbox Cards for Directions
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _allDirectionsInfo.length,
                itemBuilder: (context, index) {
                  final dir = _allDirectionsInfo[index];
                  final code = dir['code']!;
                  final isChecked = _selectedDirections.contains(code);

                  return InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        if (isChecked) {
                          if (_selectedDirections.length > 1) {
                            _selectedDirections.remove(code);
                          }
                        } else {
                          _selectedDirections.add(code);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isChecked
                            ? AppColors.limeGreen.withValues(alpha: 0.15)
                            : AppColors.courtSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isChecked
                              ? AppColors.limeGreen
                              : AppColors.sageGray.withValues(alpha: 0.2),
                          width: isChecked ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isChecked
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_rounded,
                            color: isChecked
                                ? AppColors.limeGreen
                                : AppColors.sageGray,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  code,
                                  style: GoogleFonts.jetBrainsMono(
                                    color: isChecked
                                        ? AppColors.chalkWhite
                                        : AppColors.sageGray,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  dir['label']!,
                                  style: GoogleFonts.inter(
                                    color: AppColors.sageGray,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],

            // NUMBER MAPPING EXPLANATION (Only shown if Random Number mode selected)
            if (_selectedMode == 'Random Number') ...[
              const SectionTitle(title: 'Corner Number Mapping'),
              const SizedBox(height: 8),
              AppCard(
                backgroundColor: AppColors.courtSurface,
                borderColor: AppColors.limeGreen.withValues(alpha: 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Memorize corner numbers before starting:',
                      style: GoogleFonts.inter(
                        color: AppColors.limeGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _numberMappings.length,
                      itemBuilder: (context, index) {
                        final item = _numberMappings[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.courtBackground,
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
                                  color: AppColors.limeGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  item['num']!,
                                  style: GoogleFonts.jetBrainsMono(
                                    color: AppColors.courtBackground,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                item['corner']!,
                                style: GoogleFonts.inter(
                                  color: AppColors.chalkWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
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
                      backgroundColor:
                          isSelected ? AppColors.corkGold : AppColors.courtSurface,
                      borderColor: isSelected
                          ? AppColors.corkGold
                          : AppColors.sageGray.withValues(alpha: 0.2),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _roundTimeSeconds = sec);
                      },
                      child: Text(
                        '${sec}s / round',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(
                          color: isSelected
                              ? AppColors.courtBackground
                              : AppColors.chalkWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
                      backgroundColor:
                          isSelected ? AppColors.skyBlue : AppColors.courtSurface,
                      borderColor: isSelected
                          ? AppColors.skyBlue
                          : AppColors.sageGray.withValues(alpha: 0.2),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _difficulty = level);
                      },
                      child: Column(
                        children: [
                          Text(
                            level,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.jetBrainsMono(
                              color: isSelected
                                  ? AppColors.courtBackground
                                  : AppColors.chalkWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_speeds[level]}s',
                            style: GoogleFonts.inter(
                              color: isSelected
                                  ? AppColors.courtBackground
                                  : AppColors.sageGray,
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

            const SizedBox(height: 32),

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

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.courtSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.corkGold.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: AppColors.corkGold,
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
