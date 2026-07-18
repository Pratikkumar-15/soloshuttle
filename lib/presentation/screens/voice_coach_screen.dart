import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/voice_coach_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/section_title.dart';
import '../widgets/badminton_court_widget.dart';
import 'voice_coach_onboarding_screen.dart';

class VoiceCoachScreen extends StatelessWidget {
  const VoiceCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/icons/voice_coach.png',
              width: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.record_voice_over_rounded, color: AppColors.purple),
            ),
            const SizedBox(width: 10),
            Text('Voice Coach Engine', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.primaryGreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VoiceCoachOnboardingScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<VoiceCoachProvider>(
        builder: (context, voiceCoach, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Onboarding Banner if not completed
                if (!voiceCoach.hasSeenOnboarding)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AppCard(
                      backgroundColor: AppColors.purple.withValues(alpha: 0.15),
                      borderColor: AppColors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VoiceCoachOnboardingScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, color: AppColors.purple, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('First Time Setup Guide', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text('Tap to review phone placement & safety tips.', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.purple, size: 16),
                        ],
                      ),
                    ),
                  ),

                _buildHeaderCard(voiceCoach),
                const SizedBox(height: 24),

                // Live Court Visualizer (6 Zones)
                BadmintonCourtWidget(activeDirection: voiceCoach.currentCallout),

                const SizedBox(height: 28),

                // Callout Pace / Interval
                const SectionTitle(title: 'Callout Interval'),
                const SizedBox(height: 12),
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pace (Seconds per call)',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: voiceCoach.isActive ? null : () => voiceCoach.setInterval(voiceCoach.intervalSeconds - 1),
                            icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.primaryGreen),
                          ),
                          Text(
                            '${voiceCoach.intervalSeconds}s',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: voiceCoach.isActive ? null : () => voiceCoach.setInterval(voiceCoach.intervalSeconds + 1),
                            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryGreen),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Target Court Corners (6 Positions: Front Left, Front Right, Mid Left, Mid Right, Back Left, Back Right)
                const SectionTitle(title: 'Target Court Positions'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: VoiceCoachProvider.courtCorners.map((corner) {
                    final isEnabled = voiceCoach.activeCornersMap[corner] ?? true;
                    return FilterChip(
                      selected: isEnabled,
                      label: Text(corner),
                      labelStyle: GoogleFonts.poppins(
                        color: isEnabled ? Colors.black : Colors.white70,
                        fontWeight: isEnabled ? FontWeight.bold : FontWeight.normal,
                      ),
                      selectedColor: AppColors.primaryGreen,
                      backgroundColor: AppColors.surface,
                      checkmarkColor: Colors.black,
                      onSelected: voiceCoach.isActive ? null : (_) => voiceCoach.toggleCornerFilter(corner),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // Voice Speech Clarity & Pitch Controls
                const SectionTitle(title: 'Voice Audio Tuning'),
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Speech Speed Rate', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                          Text('${(voiceCoach.ttsService.speechRate * 100).toInt()}%', style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Slider(
                        value: voiceCoach.ttsService.speechRate,
                        min: 0.2,
                        max: 1.0,
                        activeColor: AppColors.primaryGreen,
                        onChanged: (val) => voiceCoach.ttsService.setSpeechRate(val),
                      ),
                      const Divider(color: Colors.white12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Speech Voice Pitch', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                          Text('${(voiceCoach.ttsService.pitch * 100).toInt()}%', style: GoogleFonts.poppins(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Slider(
                        value: voiceCoach.ttsService.pitch,
                        min: 0.5,
                        max: 1.5,
                        activeColor: AppColors.cyan,
                        onChanged: (val) => voiceCoach.ttsService.setPitch(val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Platform Audio Notes
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.volume_up_rounded, color: AppColors.cyan, size: 20),
                          const SizedBox(width: 8),
                          Text('Audio Clarity Note', style: GoogleFonts.poppins(color: AppColors.cyan, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Voice callouts automatically duck background audio. For best court clarity, turn master phone media volume to 100% or pair Bluetooth speakers.',
                        style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // Control Buttons
                if (!voiceCoach.isActive)
                  AppButton(
                    text: 'START VOICE COACHING',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => voiceCoach.startSession(),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: voiceCoach.isPaused ? 'RESUME' : 'PAUSE',
                          type: AppButtonType.outline,
                          icon: voiceCoach.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                          onPressed: () => voiceCoach.togglePause(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: 'STOP',
                          type: AppButtonType.danger,
                          icon: Icons.stop_rounded,
                          onPressed: () => voiceCoach.stopSession(),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(VoiceCoachProvider voiceCoach) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppColors.voiceCoachGradient,
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            width: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: Icon(
              voiceCoach.isActive ? Icons.record_voice_over_rounded : Icons.graphic_eq_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            voiceCoach.currentCallout,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            voiceCoach.isActive ? 'Active Callouts: ${voiceCoach.totalCalloutsMade}' : 'AI voice commands for court footwork.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
