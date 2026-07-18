import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/action_card.dart';
import '../providers/user_provider.dart';
import '../providers/training_provider.dart';

class TrainingSessionScreen extends StatefulWidget {
  const TrainingSessionScreen({super.key});

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
  static const _activeSeconds = 45;
  static const _restSeconds = 15;
  static const _preparationSeconds = 20;

  static const _rounds = [
    _TrainingRound(
      title: 'Front Court Footwork',
      instruction:
          '1. Start in the middle.\n2. Take quick steps forward.\n3. Lunge toward the front court.\n4. Push back to the middle.',
      cue: 'Stay low and keep your balance.',
      icon: Icons.south_west_rounded,
    ),
    _TrainingRound(
      title: 'Rear-court recovery',
      instruction: 'Travel back with chasse steps, scissor-kick, and recover forward.',
      cue: 'Turn your hips before you move backwards.',
      icon: Icons.north_east_rounded,
    ),
    _TrainingRound(
      title: 'Six-corner flow',
      instruction: 'Move cleanly between imagined corners and return to base each time.',
      cue: 'Stay low so every first step is quick.',
      icon: Icons.grid_view_rounded,
    ),
  ];

  late final Timer _timer;
  int _roundIndex = 0;
  int _secondsRemaining = _preparationSeconds;
  bool _isBriefing = true;
  bool _isPreparing = true;
  bool _isResting = false;
  bool _isPaused = false;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _tick() {
    if (_isBriefing || _isPaused || _isComplete || !mounted) {
      return;
    }

    setState(() {
      if (_secondsRemaining > 1) {
        _secondsRemaining--;
      } else {
        _advancePhase();
      }
    });
  }

  void _advancePhase() {
    if (_isPreparing) {
      _isPreparing = false;
      _secondsRemaining = _activeSeconds;
      return;
    }

    if (_isResting) {
      _isResting = false;
      _roundIndex++;
      _secondsRemaining = _activeSeconds;
      return;
    }

    if (_roundIndex == _rounds.length - 1) {
      _isComplete = true;
      _secondsRemaining = 0;
      return;
    }

    _isResting = true;
    _secondsRemaining = _restSeconds;
  }

  void _startNow() {
    setState(_advancePhase);
  }

  void _startPreparation() {
    setState(() {
      _isBriefing = false;
      _isPreparing = true;
      _isPaused = false;
      _secondsRemaining = _preparationSeconds;
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
  }

  void _completeCurrentPhase() {
    setState(_advancePhase);
  }

  String get _timerLabel {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (_isComplete) {
      return 1;
    }

    if (_isPreparing) {
      return 0;
    }

    if (_isResting) {
      return (_roundIndex + 1) / _rounds.length;
    }

    final activeProgress = 1 - (_secondsRemaining / _activeSeconds);
    return (_roundIndex + activeProgress) / _rounds.length;
  }

  @override
  Widget build(BuildContext context) {
    final round = _rounds[_roundIndex];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Training Session',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'End',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: _isBriefing
              ? _briefingView()
              : _isComplete
                  ? _completionView(context)
                  : SingleChildScrollView(child: _sessionView(round)),
        ),
      ),
    );
  }

  Widget _sessionView(_TrainingRound round) {
    final title = _isPreparing
        ? 'Get ready: ${round.title}'
        : _isResting
            ? 'Rest and reset'
            : round.title;
    final instruction = _isPreparing
        ? round.instruction
        : _isResting
            ? 'Breathe, shake out your legs, and return to a balanced base position.'
            : round.instruction;
    final cue = _isPreparing
        ? 'You have $_secondsRemaining seconds to get ready. Tap Start Now when ready, or the 45-second round will begin automatically.'
        : _isResting
            ? 'Your next round begins automatically when the rest timer reaches zero.'
            : round.cue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _phasePill(),
            const Spacer(),
            Text(
              'Round ${_roundIndex + 1} of ${_rounds.length}',
              style: GoogleFonts.poppins(
                color: AppTheme.mutedText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(AppTheme.green),
          ),
        ),
        const SizedBox(height: 32),
        Center(child: _timerCircle(round.icon)),
        const SizedBox(height: 34),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              title,
              key: ValueKey(title),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          instruction,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppTheme.mutedText,
            fontSize: 14,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 24),
        ActionCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _isResting
                    ? Icons.self_improvement_rounded
                    : _isPreparing
                        ? Icons.menu_book_rounded
                        : Icons.tips_and_updates_rounded,
                color: Colors.greenAccent,
                size: 22,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  cue,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _togglePause,
                icon: Icon(_isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
                label: Text(
                  _isPaused ? 'RESUME' : 'PAUSE',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isPreparing ? _startNow : _completeCurrentPhase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _isPreparing
                      ? 'START NOW'
                      : _isResting
                          ? 'SKIP REST'
                          : 'COMPLETE ROUND',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _briefingView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [AppTheme.green, AppTheme.teal],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.directions_run_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(height: 14),
                Text(
                  'Front Court Footwork',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Learn to reach the front court quickly and recover to the middle after every shot.',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _briefingTitle('How this drill helps'),
          const SizedBox(height: 10),
          Text(
            'This drill helps you reach drop shots sooner, stay balanced when you lunge, and get back to the middle ready for the next shot.',
            style: GoogleFonts.poppins(
              color: AppTheme.mutedText,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 26),
          _briefingTitle('What you will do'),
          const SizedBox(height: 14),
          _stepCard('1', 'Start in the middle', 'Stand low with your knees slightly bent.'),
          const SizedBox(height: 10),
          _stepCard('2', 'Move forward', 'Take quick, small steps toward the front court.'),
          const SizedBox(height: 10),
          _stepCard('3', 'Lunge and reach', 'Step into a comfortable lunge as if taking a net shot.'),
          const SizedBox(height: 10),
          _stepCard('4', 'Push back to base', 'Use your front leg to return to the middle.'),
          const SizedBox(height: 26),
          _briefingTitle('Your session plan'),
          const SizedBox(height: 12),
          ActionCard(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                _sessionDetail(Icons.repeat_rounded, '3', 'Rounds'),
                _verticalDivider(),
                _sessionDetail(Icons.timer_outlined, '45 sec', 'Each round'),
                _verticalDivider(),
                _sessionDetail(Icons.self_improvement_rounded, '15 sec', 'Rest'),
              ],
            ),
          ),
          const SizedBox(height: 26),
          _briefingTitle('Coach cues'),
          const SizedBox(height: 12),
          _tipRow(
            Icons.height_rounded,
            'Stay low',
            'Keep your knees bent so you can move quickly.',
          ),
          const SizedBox(height: 12),
          _tipRow(
            Icons.north_east_rounded,
            'Move, then lunge',
            'Take small steps first. Do not jump into the lunge.',
          ),
          const SizedBox(height: 12),
          _tipRow(
            Icons.replay_rounded,
            'Always recover',
            'Push back to the middle after every lunge.',
          ),
          const SizedBox(height: 26),
          _briefingTitle('Common mistakes'),
          const SizedBox(height: 12),
          _mistakeRow(
            'Standing too tall',
            'Stay slightly low so your first step is faster.',
          ),
          const SizedBox(height: 10),
          _mistakeRow(
            'Stopping at the front',
            'Push back to the middle straight after the lunge.',
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _startPreparation,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                'I\'M READY',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.green,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'A 20-second preparation countdown starts next.',
              style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _briefingTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _stepCard(String number, String title, String detail) {
    return ActionCard(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.green.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: GoogleFonts.poppins(
                color: Colors.greenAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: GoogleFonts.poppins(
                    color: AppTheme.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionDetail(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 20),
          const SizedBox(height: 7),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(height: 42, width: 1, color: Colors.white12);
  }

  Widget _tipRow(IconData icon, String title, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppTheme.green.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.greenAccent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: GoogleFonts.poppins(
                  color: AppTheme.mutedText,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mistakeRow(String title, String detail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2630),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: .22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.orangeAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: GoogleFonts.poppins(
                    color: AppTheme.mutedText,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _phasePill() {
    final color = _isResting
        ? Colors.orangeAccent
        : _isPreparing
            ? Colors.lightBlueAccent
            : Colors.greenAccent;
    final icon = _isResting
        ? Icons.self_improvement_rounded
        : _isPreparing
            ? Icons.menu_book_rounded
            : Icons.play_arrow_rounded;
    final label = _isResting
        ? 'REST INTERVAL'
        : _isPreparing
            ? 'PREPARE'
            : 'ACTIVE ROUND';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: .6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerCircle(IconData activeIcon) {
    final color = _isResting
        ? Colors.orangeAccent
        : _isPreparing
            ? Colors.lightBlueAccent
            : AppTheme.green;
    final icon = _isResting
        ? Icons.self_improvement_rounded
        : _isPreparing
            ? Icons.menu_book_rounded
            : activeIcon;

    return Container(
      height: 200,
      width: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.surface,
        border: Border.all(color: color.withValues(alpha: .65), width: 7),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: .12), blurRadius: 28),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            _timerLabel,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          Text(
            _isPaused
                ? 'Paused'
                : _isPreparing
                    ? 'Read and prepare'
                    : _isResting
                        ? 'Rest time'
                        : 'Move now',
            style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _completionView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 82,
            width: 82,
            decoration: BoxDecoration(
              color: AppTheme.green.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.greenAccent, size: 44),
          ),
          const SizedBox(height: 24),
          Text(
            'All rounds complete',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Great work. Your recovery and movement quality matter more than speed.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 14, height: 1.55),
          ),
          const SizedBox(height: 28),
          ActionCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem('3', 'Rounds'),
                _summaryItem('2:45', 'Session'),
                _summaryItem('90', 'XP'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                final trainingProvider = Provider.of<TrainingProvider>(context, listen: false);
                userProvider.addXp(90);
                userProvider.updateMinutesTrained(15);
                trainingProvider.logCompletedTraining(
                  title: 'Front Court Footwork',
                  duration: '15 min',
                  xpEarned: 90,
                  category: 'Footwork',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Training Completed! +90 XP Awarded!'),
                    duration: Duration(seconds: 3),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.green,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('FINISH SESSION', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700)),
        Text(label, style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 12)),
      ],
    );
  }
}

class _TrainingRound {
  const _TrainingRound({
    required this.title,
    required this.instruction,
    required this.cue,
    required this.icon,
  });

  final String title;
  final String instruction;
  final String cue;
  final IconData icon;
}
