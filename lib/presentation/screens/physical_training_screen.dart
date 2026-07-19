import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../providers/user_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';

class PhysicalExercise {
  final String id;
  final String title;
  final String category; // Speed, Explosive Power, Agility, Strength, Endurance, Mobility
  final String description;
  final int durationSeconds;
  final int sets;
  final int reps;
  final int xpReward;
  final String coachCue;

  const PhysicalExercise({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.durationSeconds,
    required this.sets,
    required this.reps,
    required this.xpReward,
    required this.coachCue,
  });
}

class PhysicalTrainingScreen extends StatefulWidget {
  const PhysicalTrainingScreen({super.key});

  @override
  State<PhysicalTrainingScreen> createState() => _PhysicalTrainingScreenState();
}

class _PhysicalTrainingScreenState extends State<PhysicalTrainingScreen> {
  final _voiceCoach = VoiceCoachService();

  final List<PhysicalExercise> _exercises = const [
    PhysicalExercise(
      id: 'pe_speed',
      title: 'Court Shuttle Sprints',
      category: 'Speed',
      description: 'Explosive baseline to net shuttles focusing on immediate deceleration.',
      durationSeconds: 45,
      sets: 3,
      reps: 6,
      xpReward: 80,
      coachCue: 'Push off the back foot and stay low during direction changes.',
    ),
    PhysicalExercise(
      id: 'pe_power',
      title: 'Plyometric Jump Squats',
      category: 'Explosive Power',
      description: 'Vertical jump explosion simulating peak smash height and leg power.',
      durationSeconds: 30,
      sets: 4,
      reps: 12,
      xpReward: 90,
      coachCue: 'Explode upwards softly landing on the balls of your feet.',
    ),
    PhysicalExercise(
      id: 'pe_agility',
      title: 'Cone Hexagon Agility Shuffles',
      category: 'Agility',
      description: 'Multi-directional lateral chassé steps for court transition agility.',
      durationSeconds: 40,
      sets: 3,
      reps: 8,
      xpReward: 85,
      coachCue: 'Keep knees bent and maintain wide base stance.',
    ),
    PhysicalExercise(
      id: 'pe_strength',
      title: 'Lunges & Core Stability Hold',
      category: 'Strength',
      description: 'Single leg balance lunges strengthening quad and knee ligaments for net reach.',
      durationSeconds: 50,
      sets: 3,
      reps: 10,
      xpReward: 75,
      coachCue: 'Front knee must not extend past toes on lunges.',
    ),
    PhysicalExercise(
      id: 'pe_endurance',
      title: 'High Intensity Court Intervals',
      category: 'Endurance',
      description: 'Cardio interval training sustaining high rally endurance under fatigue.',
      durationSeconds: 60,
      sets: 4,
      reps: 5,
      xpReward: 100,
      coachCue: 'Maintain rhythmic breathing throughout high intensity intervals.',
    ),
    PhysicalExercise(
      id: 'pe_mobility',
      title: 'Hip & Shoulder Dynamic Mobility',
      category: 'Mobility',
      description: 'Thoracic spine rotations and hip opener mobility for injury prevention.',
      durationSeconds: 40,
      sets: 2,
      reps: 10,
      xpReward: 60,
      coachCue: 'Move through full comfortable range of motion smoothly.',
    ),
  ];

  PhysicalExercise? _activeExercise;
  int _secondsLeft = 0;
  bool _isRunning = false;
  Timer? _timer;

  void _startWorkout(PhysicalExercise exercise) {
    setState(() {
      _activeExercise = exercise;
      _secondsLeft = exercise.durationSeconds;
      _isRunning = true;
    });
    _voiceCoach.speak('Starting ${exercise.title}. ${exercise.coachCue}');

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
        });
        _voiceCoach.speak('${exercise.title} set complete! Excellent work.');
        Provider.of<UserProvider>(context, listen: false).addXp(exercise.xpReward, category: 'Physical');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exercise complete! +${exercise.xpReward} XP awarded to Physical pillar.'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Athletic & Physical Training', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Workout Widget if running
            if (_activeExercise != null && _isRunning) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.orange, width: 2),
                ),
                child: Column(
                  children: [
                    BadgeTag(label: 'WORKOUT IN PROGRESS • ${_activeExercise!.category.toUpperCase()}', color: AppColors.orange),
                    const SizedBox(height: 12),
                    Text(
                      _activeExercise!.title,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$_secondsLeft',
                      style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 56, fontWeight: FontWeight.bold),
                    ),
                    Text('SECONDS REMAINING', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          _isRunning = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
                      child: const Text('STOP EXERCISE'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              '6 Pillars of Badminton Fitness',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Sports-science conditioning directly mapped to badminton movement.',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 16),

            ..._exercises.map((exercise) {
              Color categoryColor;
              switch (exercise.category) {
                case 'Speed':
                  categoryColor = AppColors.cyan;
                  break;
                case 'Explosive Power':
                  categoryColor = AppColors.orange;
                  break;
                case 'Agility':
                  categoryColor = AppColors.primaryGreen;
                  break;
                case 'Strength':
                  categoryColor = AppColors.purple;
                  break;
                case 'Endurance':
                  categoryColor = AppColors.red;
                  break;
                default:
                  categoryColor = AppColors.electricGreen;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  onTap: () => _startWorkout(exercise),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.fitness_center_rounded, color: categoryColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BadgeTag(label: '${exercise.category} • +${exercise.xpReward} XP', color: categoryColor),
                            const SizedBox(height: 4),
                            Text(
                              exercise.title,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              exercise.description,
                              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.play_circle_fill_rounded, color: AppColors.electricGreen, size: 32),
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
}
