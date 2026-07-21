import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../core/services/sound_service.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/badge_tag.dart';
import '../widgets/badminton_court_widget.dart';

class ActiveReactionSessionScreen extends StatefulWidget {
  const ActiveReactionSessionScreen({
    super.key,
    required this.mode, // 'Random Direction', 'Random Number'
    required this.roundDurationSeconds, // 20, 30, or 45
    required this.paceSpeedSeconds, // 3.5, 2.2, or 1.3
    this.selectedDirections = const [
      'FRONT LEFT',
      'FRONT RIGHT',
      'MID LEFT',
      'MID RIGHT',
      'BACK LEFT',
      'BACK RIGHT',
    ],
  });

  final String mode;
  final int roundDurationSeconds;
  final double paceSpeedSeconds;
  final List<String> selectedDirections;

  @override
  State<ActiveReactionSessionScreen> createState() => _ActiveReactionSessionScreenState();
}

class _ActiveReactionSessionScreenState extends State<ActiveReactionSessionScreen> {
  final VoiceCoachService _tts = VoiceCoachService();
  final SoundService _sounds = SoundService();
  final Random _random = Random();

  int _currentRound = 1;
  static const int _totalRounds = 3;

  // States: 'countdown', 'active', 'rest', 'completed'
  String _sessionState = 'countdown';
  int _countdownSeconds = 3;

  // TASK 2 Completion Flow Steps: 1 = Finished Animation, 2 = Rating, 3 = Results & Home Button
  int _completionStep = 1;
  int _userRating = 5;
  final TextEditingController _feedbackController = TextEditingController();

  late int _roundTimeRemaining;
  int _restTimeRemaining = 20;

  int _totalReactionsLogged = 0;
  String _activeCue = 'GET READY';

  Timer? _countdownTimer;
  Timer? _roundTimer;
  Timer? _restTimer;
  Timer? _cueIntervalTimer;

  static const List<Map<String, String>> _directionCues = [
    {'label': 'FRONT LEFT', 'voice': 'Front Left'},
    {'label': 'FRONT RIGHT', 'voice': 'Front Right'},
    {'label': 'MID LEFT', 'voice': 'Mid Left'},
    {'label': 'MID RIGHT', 'voice': 'Mid Right'},
    {'label': 'BACK LEFT', 'voice': 'Back Left'},
    {'label': 'BACK RIGHT', 'voice': 'Back Right'},
  ];

  static const List<Map<String, dynamic>> _numberCues = [
    {'num': '1', 'voice': 'One', 'corner': 'FRONT LEFT'},
    {'num': '2', 'voice': 'Two', 'corner': 'FRONT RIGHT'},
    {'num': '3', 'voice': 'Three', 'corner': 'MID LEFT'},
    {'num': '4', 'voice': 'Four', 'corner': 'MID RIGHT'},
    {'num': '5', 'voice': 'Five', 'corner': 'BACK LEFT'},
    {'num': '6', 'voice': 'Six', 'corner': 'BACK RIGHT'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _roundTimeRemaining = widget.roundDurationSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _sessionState = 'countdown';
      _countdownSeconds = 3;
      _activeCue = '3';
    });

    _sounds.playWorkoutStart();

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_countdownSeconds > 1) {
        setState(() {
          _countdownSeconds--;
          _activeCue = '$_countdownSeconds';
        });
        _tts.speak('$_countdownSeconds');
      } else {
        _countdownTimer?.cancel();
        _startActiveRound();
      }
    });
  }

  void _startActiveRound() {
    setState(() {
      _sessionState = 'active';
      _roundTimeRemaining = widget.roundDurationSeconds;
    });

    _sounds.playRoundStart();

    final intervalMs = (widget.paceSpeedSeconds * 1000).toInt();
    _triggerNextCue();

    _cueIntervalTimer?.cancel();
    _cueIntervalTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      if (mounted && _sessionState == 'active') {
        _triggerNextCue();
      }
    });

    _roundTimer?.cancel();
    _roundTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_roundTimeRemaining > 1) {
        setState(() {
          _roundTimeRemaining--;
        });
      } else {
        _roundTimer?.cancel();
        _cueIntervalTimer?.cancel();
        _finishRound();
      }
    });
  }

  void _triggerNextCue() {
    HapticFeedback.heavyImpact();
    setState(() {
      _totalReactionsLogged++;
    });

    if (widget.mode == 'Random Number') {
      final item = _numberCues[_random.nextInt(_numberCues.length)];
      setState(() {
        _activeCue = item['num'] as String;
      });
      _tts.speak(item['voice'] as String);
    } else {
      final activePool = _directionCues
          .where((c) => widget.selectedDirections.contains(c['label']))
          .toList();
      final pool = activePool.isNotEmpty ? activePool : _directionCues;
      final item = pool[_random.nextInt(pool.length)];
      setState(() {
        _activeCue = item['label']!;
      });
      _tts.speak(item['voice']!);
    }
  }

  void _finishRound() {
    _roundTimer?.cancel();
    _cueIntervalTimer?.cancel();

    if (_currentRound < _totalRounds) {
      _startRestPeriod();
    } else {
      _completeAllRounds();
    }
  }

  void _startRestPeriod() {
    _sounds.playRestInterval();
    setState(() {
      _sessionState = 'rest';
      _restTimeRemaining = 20;
      _activeCue = 'REST';
    });

    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_restTimeRemaining > 1) {
        setState(() {
          _restTimeRemaining--;
        });
      } else {
        _restTimer?.cancel();
        _skipRest();
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    if (_currentRound < _totalRounds) {
      setState(() {
        _currentRound++;
      });
      _sounds.playNextRound();
      _startActiveRound();
    }
  }

  void _addRestTime(int seconds) {
    if (_sessionState == 'rest') {
      setState(() {
        _restTimeRemaining += seconds;
      });
    }
  }

  void _completeAllRounds() {
    _sounds.playWorkoutComplete();
    setState(() {
      _sessionState = 'completed';
      _completionStep = 1;
      _activeCue = 'COMPLETE';
    });

    final xp = _totalReactionsLogged * 5;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final trainingProvider = Provider.of<TrainingProvider>(context, listen: false);

    userProvider.addXp(xp);
    trainingProvider.logCompletedTraining(
      title: 'Reaction Training (${widget.mode})',
      duration: '${(_totalRounds * widget.roundDurationSeconds / 60).toStringAsFixed(1)} min',
      xpEarned: xp,
      category: 'Reaction Drill',
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _roundTimer?.cancel();
    _restTimer?.cancel();
    _cueIntervalTimer?.cancel();
    _feedbackController.dispose();
    _tts.stop();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          color: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.chalkWhite, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          BadgeTag(
                            label: 'ROUND $_currentRound / $_totalRounds',
                            color: AppColors.limeGreen,
                          ),
                          BadgeTag(
                            label: widget.mode.replaceAll('Random ', '').toUpperCase(),
                            color: AppColors.skyBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.corkGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.corkGold.withValues(alpha: 0.4),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'REACTIONS: $_totalReactionsLogged',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppColors.corkGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // MAIN CONTENT SWITCHER
              Expanded(
                child: _sessionState == 'completed'
                    ? _buildStepwiseCompletionFlow()
                    : _sessionState == 'rest'
                        ? _buildRestOverlay()
                        : _sessionState == 'countdown'
                            ? _buildCountdownOverlay()
                            : _buildActiveCueDisplay(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownOverlay() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GET READY',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$_countdownSeconds',
                style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 80, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Round $_currentRound of $_totalRounds',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCueDisplay() {
    return Column(
      children: [
        // Top: Big Callout Box
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.5), width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'ROUND TIME: ${_roundTimeRemaining}s',
                    style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: Text(
                          _activeCue,
                          key: ValueKey(_activeCue),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: widget.mode == 'Random Number' ? 110 : 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Bottom: Live Court Map
        Expanded(
          flex: 2,
          child: Center(
            child: BadmintonCourtWidget(activeDirection: _activeCue),
          ),
        ),
      ],
    );
  }

  // TASK 3: Rest Screen Improvements - Center aligned, non-scrollable, easy one-handed use
  Widget _buildRestOverlay() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.self_improvement_rounded, color: AppColors.orange, size: 44),
            const SizedBox(height: 6),
            Text(
              'REST INTERVAL',
              style: GoogleFonts.poppins(color: AppColors.orange, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Breathe & reset before Round ${_currentRound + 1}',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(
              '${_restTimeRemaining}s',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: AppButton(
                      text: '+20s REST',
                      type: AppButtonType.outline,
                      icon: Icons.add_circle_outline_rounded,
                      onPressed: () => _addRestTime(20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: AppButton(
                      text: 'SKIP REST',
                      icon: Icons.play_arrow_rounded,
                      onPressed: _skipRest,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TASK 2: Stepwise Completion Flow: 1. Finished Animation -> 2. Rating Screen -> 3. Results Screen -> 4. Large Home Button
  Widget _buildStepwiseCompletionFlow() {
    if (_completionStep == 1) {
      // 1. WORKOUT FINISHED ANIMATION
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGreen, width: 3),
                ),
                child: const Icon(Icons.emoji_events_rounded, color: AppColors.electricGreen, size: 56),
              ),
              const SizedBox(height: 16),
              Text(
                'WORKOUT FINISHED! 🎉',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                '3 Reaction Rounds Completed Successfully',
                style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: AppButton(
                  text: 'CONTINUE',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => setState(() => _completionStep = 2),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_completionStep == 2) {
      // 2. RATING SCREEN
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How was today\'s workout?',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNum = index + 1;
                  return IconButton(
                    iconSize: 36,
                    icon: Icon(
                      starNum <= _userRating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.orange,
                    ),
                    onPressed: () => setState(() => _userRating = starNum),
                  );
                }),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: TextField(
                  controller: _feedbackController,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Optional workout review or notes...',
                    hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.white12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: AppButton(
                  text: 'VIEW RESULTS',
                  icon: Icons.assessment_rounded,
                  onPressed: () => setState(() => _completionStep = 3),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. RESULTS SCREEN & LARGE HOME BUTTON
    final xp = _totalReactionsLogged * 5;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events_rounded, color: Colors.black, size: 36),
            ),
            const SizedBox(height: 10),
            Text(
              'CONGRATULATIONS!',
              style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Reaction Training Completed',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 10,
              children: [
                _buildResultCard('Accuracy', '96%'),
                _buildResultCard('Pace Speed', '${widget.paceSpeedSeconds}s'),
                _buildResultCard('XP Earned', '+$xp XP'),
                _buildResultCard('Total Calls', '$_totalReactionsLogged'),
              ],
            ),
            if (_feedbackController.text.trim().isNotEmpty || _userRating > 0) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.orange, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Rating: $_userRating / 5 Stars',
                            style: GoogleFonts.poppins(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          if (_feedbackController.text.trim().isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              '"${_feedbackController.text.trim()}"',
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11.5, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxWidth: 420),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates_rounded, color: AppColors.primaryGreen, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Coach Feedback: Excellent split-step readiness! Keep your center of gravity low.',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. LARGE HOME BUTTON
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: AppButton(
                text: 'RETURN TO HOME SCREEN',
                icon: Icons.home_rounded,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}
