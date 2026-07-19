import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../providers/user_provider.dart';
import '../widgets/badge_tag.dart';

class MirrorModeScreen extends StatefulWidget {
  const MirrorModeScreen({super.key});

  @override
  State<MirrorModeScreen> createState() => _MirrorModeScreenState();
}

class _MirrorModeScreenState extends State<MirrorModeScreen> {
  final _voiceCoach = VoiceCoachService();
  bool _isActive = false;
  int _secondsLeft = 60;
  String _currentCallout = 'GET READY';
  int _repCount = 0;
  Timer? _timer;
  Timer? _calloutTimer;

  final List<String> _callouts = const [
    'Front Right... Net Lunge!',
    'Recover to Base Center!',
    'Rear Left... Backhand Clear!',
    'Split Step... Pre-hop!',
    'Front Left... Hairpin Net Roll!',
    'Rear Right... Jump Smash!',
    'Midcourt... Flat Drive Push!',
  ];

  void _startMirrorSession() {
    setState(() {
      _isActive = true;
      _secondsLeft = 60;
      _repCount = 0;
      _currentCallout = 'Get Ready... Split!';
    });
    _voiceCoach.speak('Mirror Mode Active. Stand facing your mirror. Follow my direction callouts!');

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _finishMirrorSession();
      }
    });

    _calloutTimer?.cancel();
    _calloutTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_isActive) return;
      final nextCall = _callouts[_repCount % _callouts.length];
      setState(() {
        _currentCallout = nextCall;
        _repCount++;
      });
      _voiceCoach.speak(nextCall);
    });
  }

  void _finishMirrorSession() {
    _timer?.cancel();
    _calloutTimer?.cancel();
    setState(() {
      _isActive = false;
    });
    _voiceCoach.speak('Mirror Mode drill complete! Total $_repCount directional shadow reps executed.');
    Provider.of<UserProvider>(context, listen: false).addXp(75, category: 'Footwork');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mirror Mode Complete! $_repCount reps recorded. +75 XP earned!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _calloutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Mirror Mode (Wall Shadow)', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              BadgeTag(label: 'REVOLUTIONARY WALL SHADOW MODE', color: AppColors.electricGreen),
              const SizedBox(height: 16),
              Text(
                'Stand facing a wall or mirror. The Voice Coach will call directions in real-time.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
              ),

              const Spacer(),

              if (_isActive) ...[
                Text(
                  '$_secondsLeft s',
                  style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 64, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primaryGreen, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text('VOICE CALLOUT', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        _currentCallout,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Reps Executed: $_repCount', style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 16, fontWeight: FontWeight.bold)),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 3),
                  ),
                  child: const Icon(Icons.flip_camera_android_rounded, color: AppColors.electricGreen, size: 72),
                ),
              ],

              const Spacer(),

              ElevatedButton(
                onPressed: _isActive ? _finishMirrorSession : _startMirrorSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isActive ? AppColors.red : AppColors.primaryGreen,
                  foregroundColor: _isActive ? Colors.white : Colors.black,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _isActive ? 'END MIRROR DRILL' : 'START 60s MIRROR DRILL',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
