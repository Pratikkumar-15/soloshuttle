import 'package:flutter/material.dart';
import '../presentation/screens/premium_training_session_screen.dart';

class TrainingSessionScreen extends StatelessWidget {
  const TrainingSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PremiumTrainingSessionScreen(
      customTitle: 'Shadow Drill Routine',
    );
  }
}
