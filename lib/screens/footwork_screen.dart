import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/action_card.dart';

class FootworkScreen extends StatelessWidget {
  const FootworkScreen({super.key});

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
        title: Row(
          children: [
            Image.asset('assets/images/icons/footwork.png', width: 30),
            const SizedBox(width: 10),
            Text('Footwork', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Move with purpose.',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Build faster recovery, balance, and court coverage.',
              style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 15),
            ),
            const SizedBox(height: 28),
            _recommendedSession(),
            const SizedBox(height: 32),
            Text(
              'Train your movement',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _trainingOption(Icons.grid_view_rounded, 'Shadow Movement', 'Learn efficient movement to all six corners.', '15 min'),
            const SizedBox(height: 14),
            _trainingOption(Icons.swap_horiz_rounded, 'Recovery Steps', 'Return to base quickly after every shot.', '10 min'),
            const SizedBox(height: 14),
            _trainingOption(Icons.bolt_rounded, 'Split-Step Timing', 'React earlier and stay balanced on the court.', '8 min'),
            const SizedBox(height: 32),
            _weeklyGoal(),
          ],
        ),
      ),
    );
  }

  Widget _recommendedSession() {
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
          Text('TODAY\'S FOCUS', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.1)),
          const SizedBox(height: 8),
          Text('Six-Corner Foundation', style: GoogleFonts.poppins(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('15 minutes · Beginner to Intermediate', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('START SESSION', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trainingOption(IconData icon, String title, String subtitle, String duration) {
    return ActionCard(
      onTap: () {},
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(color: AppTheme.green.withValues(alpha: .14), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: Colors.greenAccent),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle, style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(duration, style: GoogleFonts.poppins(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weeklyGoal() {
    return ActionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded, color: Colors.orangeAccent, size: 25),
              const SizedBox(width: 10),
              Text('Weekly movement goal', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          Text('2 of 4 footwork sessions complete', style: GoogleFonts.poppins(color: AppTheme.mutedText, fontSize: 13)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: .5,
              minHeight: 9,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(AppTheme.green),
            ),
          ),
        ],
      ),
    );
  }
}
