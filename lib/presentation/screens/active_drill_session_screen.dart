import 'package:flutter/material.dart';
import '../../domain/entities/drill.dart';
import 'premium_training_session_screen.dart';

class ActiveDrillSessionScreen extends StatelessWidget {
  const ActiveDrillSessionScreen({
    super.key,
    required this.drill,
  });

  final Drill drill;

  @override
  Widget build(BuildContext context) {
    return PremiumTrainingSessionScreen(drill: drill);
  }
}
