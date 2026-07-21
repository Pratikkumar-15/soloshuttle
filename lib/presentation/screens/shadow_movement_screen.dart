import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/app_card.dart';
import 'premium_training_session_screen.dart';

class ShadowMovementScreen extends StatelessWidget {
  const ShadowMovementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Shadow Movement',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroCard(),
            const SizedBox(height: 28),
            _sectionTitle('Your objective'),
            const SizedBox(height: 12),
            Text(
              'Learn a balanced split step, move efficiently to each court corner, and recover to base after every imagined shot.',
              style: GoogleFonts.poppins(
                color: AppTheme.mutedText,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            _sectionTitle('Session structure'),
            const SizedBox(height: 14),
            _structureCard('1', 'Set your base', 'Start centred, knees soft, racket hand ready.'),
            const SizedBox(height: 12),
            _structureCard('2', 'Move to the corner', 'Use controlled chasse steps, then lunge or jump as needed.'),
            const SizedBox(height: 12),
            _structureCard('3', 'Recover with intent', 'Push back to base before moving to the next corner.'),
            const SizedBox(height: 28),
            _sectionTitle('Coach cues'),
            const SizedBox(height: 14),
            _coachCue(Icons.center_focus_strong_rounded, 'Stay low', 'Keep your hips loaded so you can change direction quickly.'),
            const SizedBox(height: 12),
            _coachCue(Icons.speed_rounded, 'Quality before speed', 'Move cleanly first; increase pace only when your balance stays stable.'),
            const SizedBox(height: 12),
            _coachCue(Icons.replay_rounded, 'Recover every time', 'Never admire the shot—return to base after each movement.'),
            const SizedBox(height: 28),
            _sectionTitle('Avoid these mistakes'),
            const SizedBox(height: 14),
            _mistakeCard('Crossing your feet too early', 'Use chasse steps for lateral travel to stay balanced.'),
            const SizedBox(height: 12),
            _mistakeCard('Standing tall on recovery', 'Stay low as you push back to base so your next move is immediate.'),
            const SizedBox(height: 28),
            _progressionCard(),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PremiumTrainingSessionScreen(
                        customTitle: 'Shadow Routine',
                        customPhases: [],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  'START TRAINING',
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
          ],
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [AppTheme.green, AppTheme.teal]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 27),
          ),
          const SizedBox(height: 18),
          Text(
            'Shadow Movement',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            'Build your movement foundation without a shuttle.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _detail(Icons.timer_outlined, '15 min'),
              const SizedBox(width: 22),
              _detail(Icons.trending_up_rounded, 'Intermediate'),
              const SizedBox(width: 22),
              _detail(Icons.local_fire_department_outlined, '90 XP'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detail(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 17),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
    );
  }

  Widget _structureCard(String number, String title, String description) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppTheme.green.withValues(alpha: .16), shape: BoxShape.circle),
            child: Text(number, style: GoogleFonts.poppins(color: Colors.greenAccent, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(description, style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 12, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _coachCue(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(color: AppTheme.green.withValues(alpha: .14), borderRadius: BorderRadius.circular(13)),
          child: Icon(icon, color: Colors.greenAccent, size: 21),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(description, style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 12, height: 1.45)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mistakeCard(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2630),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.withValues(alpha: .22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.orangeAccent, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(description, style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 12, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressionCard() {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stairs_rounded, color: Colors.greenAccent),
              const SizedBox(width: 10),
              Text('Progression', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Complete 3 rounds at a controlled pace. When every recovery feels balanced, add random corner calls or increase your speed.',
            style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 13, height: 1.55),
          ),
        ],
      ),
    );
  }
}
