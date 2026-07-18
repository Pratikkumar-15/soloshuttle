import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/drill.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import '../widgets/section_title.dart';

class ActiveDrillSessionScreen extends StatefulWidget {
  const ActiveDrillSessionScreen({
    super.key,
    required this.drill,
  });

  final Drill drill;

  @override
  State<ActiveDrillSessionScreen> createState() => _ActiveDrillSessionScreenState();
}

class _ActiveDrillSessionScreenState extends State<ActiveDrillSessionScreen> {
  late int _secondsRemaining;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isCompleted = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.drill.durationSeconds > 0 ? widget.drill.durationSeconds : 300;
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _onDrillCompleted();
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _timer?.cancel();
    } else {
      _startTimer();
    }
  }

  void _onDrillCompleted() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _isCompleted = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final trainingProvider = Provider.of<TrainingProvider>(context, listen: false);

    userProvider.addXp(widget.drill.xpReward);
    userProvider.updateMinutesTrained(widget.drill.durationSeconds ~/ 60);
    trainingProvider.logCompletedTraining(
      title: widget.drill.title,
      duration: widget.drill.duration,
      xpEarned: widget.drill.xpReward,
      category: widget.drill.categoryName,
    );
  }

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drill = widget.drill;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(drill.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              drill.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: drill.isFavorite ? AppColors.red : Colors.white,
            ),
            onPressed: () {
              Provider.of<TrainingProvider>(context, listen: false).toggleFavorite(drill.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(drill.emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drill.title,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                BadgeTag(label: drill.categoryName, color: AppColors.primaryGreen),
                                const SizedBox(width: 8),
                                BadgeTag(label: drill.difficulty, color: AppColors.cyan),
                                const SizedBox(width: 8),
                                BadgeTag(label: '+${drill.xpReward} XP', color: AppColors.orange),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Objective Card
            const SectionTitle(title: 'Objective'),
            const SizedBox(height: 8),
            AppCard(
              backgroundColor: AppColors.surface,
              borderColor: AppColors.primaryGreen.withValues(alpha: 0.3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.track_changes_rounded, color: AppColors.primaryGreen, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      drill.objective,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Timer Circle Card
            Center(
              child: Container(
                height: 200,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(
                    color: _isCompleted
                        ? AppColors.electricGreen
                        : _isRunning
                            ? AppColors.primaryGreen
                            : Colors.white24,
                    width: 6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.15),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isCompleted
                          ? Icons.check_circle_rounded
                          : _isPaused
                              ? Icons.pause_circle_rounded
                              : Icons.timer_rounded,
                      color: _isCompleted ? AppColors.electricGreen : AppColors.primaryGreen,
                      size: 32,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formattedTime,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      _isCompleted
                          ? 'Drill Finished!'
                          : _isPaused
                              ? 'Paused'
                              : _isRunning
                                  ? 'Active Workout'
                                  : 'Ready to Start',
                      style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Coaching Cue & Instructions
            if (drill.coachCue.isNotEmpty) ...[
              const SectionTitle(title: 'Coach Cue'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tips_and_updates_rounded, color: AppColors.electricGreen, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        drill.coachCue,
                        style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (drill.instructions.isNotEmpty) ...[
              const SectionTitle(title: 'Execution Steps'),
              const SizedBox(height: 8),
              ...drill.instructions.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        height: 28,
                        width: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text('${entry.key + 1}', style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(entry.value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 28),
            ],

            // Control Buttons
            if (_isCompleted)
              AppButton(
                text: 'FINISH & CLAIM REWARD',
                icon: Icons.check_circle_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('🎉 ${drill.title} Complete! +${drill.xpReward} XP Earned!')),
                  );
                  Navigator.pop(context);
                },
              )
            else if (!_isRunning)
              AppButton(
                text: 'START DRILL',
                icon: Icons.play_arrow_rounded,
                onPressed: _startTimer,
              )
            else
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: _isPaused ? 'RESUME' : 'PAUSE',
                      type: AppButtonType.outline,
                      icon: _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      onPressed: _togglePause,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'COMPLETE DRILL',
                      icon: Icons.check_rounded,
                      onPressed: _onDrillCompleted,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
