import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../domain/data/tactical_puzzles_catalog.dart';
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
  final _voiceCoach = VoiceCoachService();
  final List<TacticalPuzzle> _puzzles = TacticalPuzzlesCatalog.allPuzzles;

  int _currentPuzzleIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  bool _showDetailedExplanation = false;
  int _todayCompletedCount = 0;
  bool _isLoadingPrefs = true;

  static const int _dailyLimit = 5;

  @override
  void initState() {
    super.initState();
    _loadDailyProgress();
  }

  Future<void> _loadDailyProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      final savedDate = prefs.getString('tactical_puzzles_date');

      if (savedDate == todayStr) {
        _todayCompletedCount = prefs.getInt('tactical_puzzles_count') ?? 0;
        _currentPuzzleIndex = prefs.getInt('tactical_puzzles_index') ?? 0;
      } else {
        // New day: reset daily count
        await prefs.setString('tactical_puzzles_date', todayStr);
        await prefs.setInt('tactical_puzzles_count', 0);
        _todayCompletedCount = 0;
        // Rotate starting puzzle index based on day of year
        _currentPuzzleIndex = (DateTime.now().day * 3) % _puzzles.length;
        await prefs.setInt('tactical_puzzles_index', _currentPuzzleIndex);
      }
    } catch (e) {
      debugPrint('Error loading daily tactical puzzle progress: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingPrefs = false;
        });
      }
    }
  }

  Future<void> _saveDailyProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      await prefs.setString('tactical_puzzles_date', todayStr);
      await prefs.setInt('tactical_puzzles_count', _todayCompletedCount);
      await prefs.setInt('tactical_puzzles_index', _currentPuzzleIndex);
    } catch (e) {
      debugPrint('Error saving daily tactical puzzle progress: $e');
    }
  }

  void _speakQuestion(TacticalPuzzle puzzle) {
    HapticFeedback.lightImpact();
    _voiceCoach.speak('${puzzle.title}. ${puzzle.situationDescription}');
  }

  void _onAnswerSelected(TacticalPuzzleOption opt) {
    if (_isAnswered) return;
    HapticFeedback.mediumImpact();

    setState(() {
      _selectedOptionIndex = opt.id;
      _isAnswered = true;
      _showDetailedExplanation = false;
      _todayCompletedCount++;
    });

    if (opt.isCorrect) {
      _voiceCoach.speak('Correct shot selection! Excellent tactical analysis.');
      Provider.of<UserProvider>(context, listen: false)
          .addXp(50, category: 'Tactical');
    } else {
      _voiceCoach.speak('Incorrect choice. Tap Want Detailed Explanation below.');
    }

    _saveDailyProgress();
  }

  void _nextPuzzle() {
    HapticFeedback.mediumImpact();
    setState(() {
      _currentPuzzleIndex = (_currentPuzzleIndex + 1) % _puzzles.length;
      _selectedOptionIndex = null;
      _isAnswered = false;
      _showDetailedExplanation = false;
    });
    _saveDailyProgress();
  }

  String _getDetailedExplanationText(TacticalPuzzle puzzle) {
    if (puzzle.detailedExplanation != null &&
        puzzle.detailedExplanation!.isNotEmpty) {
      return puzzle.detailedExplanation!;
    }

    final correctOpt = puzzle.options.firstWhere(
      (o) => o.isCorrect,
      orElse: () => puzzle.options.first,
    );

    return '1. SHUTTLE GEOMETRY & TRAJECTORY:\n'
        'Executing ${correctOpt.shotName} leverages the ${puzzle.shuttleHeight.toLowerCase()} shuttle height from the ${puzzle.courtZone.toLowerCase()}. By placing the shuttle sharply away from opponent position (${puzzle.opponentPosition}), you force a steep defensive angle and eliminate opponent smash threats.\n\n'
        '2. FOOTWORK & RECOVERY MATH:\n'
        'This shot selection buys 1.2 to 1.8 seconds of air travel time. This grants you complete time to recover back to center base, while forcing your opponent to sprint 5 to 7 meters under heavy physical pressure.\n\n'
        '3. PRO BWF MATCHPLAY PRINCIPLE:\n'
        '${correctOpt.explanation} Under high pressure, high-percentage tactical strokes win rallies consistently over risky off-balance winners.';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPrefs) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    final isDailyLimitReached = _todayCompletedCount >= _dailyLimit && !_isAnswered;
    final puzzle = _puzzles[_currentPuzzleIndex % _puzzles.length];

    return Scaffold(
      backgroundColor: AppColors.courtBackground,
      appBar: AppBar(
        backgroundColor: AppColors.courtBackground,
        elevation: 0,
        title: Text(
          'Tactical IQ Puzzles (50+ Catalog)',
          style: GoogleFonts.poppins(
            color: AppColors.chalkWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: isDailyLimitReached
            ? _buildDailyLimitReachedCard()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Status & Daily Count Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BadgeTag(
                        label:
                            'DAILY PROGRESS: $_todayCompletedCount / $_dailyLimit',
                        color: AppColors.corkGold,
                      ),
                      Text(
                        'Pillar: Tactical • +50 XP',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppColors.limeGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Question Title with Audio Speaker Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          puzzle.title,
                          style: GoogleFonts.bebasNeue(
                            color: AppColors.chalkWhite,
                            fontSize: 26,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // VOICE BUTTON TO READ QUESTION OUT LOUD
                      IconButton(
                        icon: const Icon(
                          Icons.volume_up_rounded,
                          color: AppColors.corkGold,
                          size: 28,
                        ),
                        tooltip: 'Read Question Out Loud',
                        onPressed: () => _speakQuestion(puzzle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // BIGGER SITUATION DESCRIPTION TEXT
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.courtSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.skyBlue.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.psychology_rounded,
                              color: AppColors.skyBlue,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'COURT SITUATION',
                              style: GoogleFonts.jetBrainsMono(
                                color: AppColors.skyBlue,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          puzzle.situationDescription,
                          style: GoogleFonts.inter(
                            color: AppColors.chalkWhite,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Court Graphic Simulation
                  Container(
                    height: 190,
                    decoration: BoxDecoration(
                      color: AppColors.courtSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.sageGray.withValues(alpha: 0.2),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BadmintonCourtWidget(
                        activeDirection: puzzle.courtZone.contains('Rear')
                            ? 'REAR LEFT'
                            : 'FRONT RIGHT',
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'SELECT BEST TACTICAL SHOT:',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.corkGold,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tactical Shot Options
                  ...puzzle.options.map((opt) {
                    final isSelected = _selectedOptionIndex == opt.id;
                    Color optBorderColor =
                        AppColors.sageGray.withValues(alpha: 0.2);
                    Color optBgColor = AppColors.courtSurface;

                    if (_isAnswered) {
                      if (opt.isCorrect) {
                        optBorderColor = AppColors.limeGreen;
                        optBgColor =
                            AppColors.limeGreen.withValues(alpha: 0.15);
                      } else if (isSelected && !opt.isCorrect) {
                        optBorderColor = AppColors.coral;
                        optBgColor = AppColors.coral.withValues(alpha: 0.15);
                      }
                    } else if (isSelected) {
                      optBorderColor = AppColors.skyBlue;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        onTap: _isAnswered ? null : () => _onAnswerSelected(opt),
                        backgroundColor: optBgColor,
                        borderColor: optBorderColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    opt.shotName,
                                    style: GoogleFonts.inter(
                                      color: AppColors.chalkWhite,
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (_isAnswered && opt.isCorrect)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.limeGreen,
                                    size: 20,
                                  ),
                                if (_isAnswered && isSelected && !opt.isCorrect)
                                  const Icon(
                                    Icons.cancel_rounded,
                                    color: AppColors.coral,
                                    size: 20,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              opt.description,
                              style: GoogleFonts.inter(
                                color: AppColors.sageGray,
                                fontSize: 12.5,
                                height: 1.3,
                              ),
                            ),
                            if (_isAnswered && (isSelected || opt.isCorrect)) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.courtBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: opt.isCorrect
                                        ? AppColors.limeGreen.withValues(alpha: 0.3)
                                        : AppColors.coral.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      opt.isCorrect
                                          ? Icons.lightbulb_rounded
                                          : Icons.warning_amber_rounded,
                                      color: opt.isCorrect
                                          ? AppColors.limeGreen
                                          : AppColors.coral,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        opt.explanation,
                                        style: GoogleFonts.inter(
                                          color: opt.isCorrect
                                              ? AppColors.limeGreen
                                              : AppColors.coral,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),

                  if (_isAnswered) ...[
                    const SizedBox(height: 14),

                    // DEDICATED COACH TACTICAL DEBRIEF CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.courtSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.corkGold.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.psychology_rounded,
                                color: AppColors.corkGold,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'COACH TACTICAL ANALYSIS',
                                style: GoogleFonts.jetBrainsMono(
                                  color: AppColors.corkGold,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            puzzle.coachTip,
                            style: GoogleFonts.inter(
                              color: AppColors.chalkWhite,
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // "WANT DETAILED EXPLANATION?" INTERACTIVE TAB BUTTON
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _showDetailedExplanation = !_showDetailedExplanation;
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.skyBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.skyBlue.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,
                                  color: AppColors.skyBlue,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'WANT DETAILED EXPLANATION?',
                                  style: GoogleFonts.jetBrainsMono(
                                    color: AppColors.skyBlue,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              _showDetailedExplanation
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.skyBlue,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // EXPANDABLE DETAILED EXPLANATION CARD
                    if (_showDetailedExplanation) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.courtSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.skyBlue.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: AppColors.skyBlue,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'DETAILED TACTICAL BREAKDOWN',
                                  style: GoogleFonts.jetBrainsMono(
                                    color: AppColors.skyBlue,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _getDetailedExplanationText(puzzle),
                              style: GoogleFonts.inter(
                                color: AppColors.chalkWhite
                                    .withValues(alpha: 0.92),
                                fontSize: 12.5,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _nextPuzzle,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(
                          _todayCompletedCount >= _dailyLimit
                              ? 'VIEW DAILY SUMMARY ➔'
                              : 'NEXT TACTICAL PUZZLE ➔',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.limeGreen,
                          foregroundColor: AppColors.courtBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildDailyLimitReachedCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.courtSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.corkGold.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.corkGold.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.corkGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.corkGold, width: 2),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.corkGold,
              size: 38,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'DAILY LIMIT REACHED (5/5)',
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.corkGold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Great Tactical Practice Today!',
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(
              color: AppColors.chalkWhite,
              fontSize: 28,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You have completed your daily limit of 5 Tactical IQ Puzzles and earned +250 XP. Come back tomorrow for 5 new court situation challenges!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.sageGray,
              fontSize: 13.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(
                'RETURN TO TRAINING HUB',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.limeGreen,
                foregroundColor: AppColors.courtBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
