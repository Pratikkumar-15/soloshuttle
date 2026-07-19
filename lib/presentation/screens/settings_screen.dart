import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';

import '../../core/services/voice_coach_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<Map<String, String>> _voiceProfiles = [
    {
      'id': 'male_normal',
      'name': 'Coach Alex',
      'tag': 'Normal Pitch',
      'desc': 'Energetic & clear sports coach',
      'sample': 'Ready position. Move quickly to the corner!',
    },
    {
      'id': 'male_deep',
      'name': 'Coach Marcus',
      'tag': 'Deep Tone',
      'desc': 'Deep & commanding power voice',
      'sample': 'Focus. Explode to the court corner!',
    },
    {
      'id': 'female_normal',
      'name': 'Coach Sarah',
      'tag': 'Normal Pitch',
      'desc': 'Crisp & dynamic athletic guide',
      'sample': 'Stay light on your feet. Recover fast!',
    },
    {
      'id': 'female_deep',
      'name': 'Coach Elena',
      'tag': 'Deep Tone',
      'desc': 'Warm & calm deep coaching voice',
      'sample': 'Stay low. Drive through the shuttle!',
    },
  ];

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
        title: Text('Settings Suite', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionHeader('PREFERENCES'),
              AppCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      activeTrackColor: AppColors.primaryGreen,
                      title: Text('Dark Mode', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      subtitle: Text('Default dark sports aesthetic', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                      value: settings.isDarkMode,
                      onChanged: null, // Always dark mode as per requirements
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      activeTrackColor: AppColors.primaryGreen,
                      title: Text('Sound FX & Audio Beeps', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      value: settings.isSoundEnabled,
                      onChanged: (v) => settings.setSoundEnabled(v),
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      activeTrackColor: AppColors.primaryGreen,
                      title: Text('Voice Guidance Speech', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      value: settings.isVoiceGuidanceEnabled,
                      onChanged: (v) => settings.setVoiceGuidanceEnabled(v),
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      activeTrackColor: AppColors.primaryGreen,
                      title: Text('Daily Workout Notifications', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      value: settings.isNotificationsEnabled,
                      onChanged: (v) => settings.setNotificationsEnabled(v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // AI COACH VOICE SELECTOR
              _buildSectionHeader('AI COACH VOICE SELECTOR'),
              Column(
                children: _voiceProfiles.map((v) {
                  final isSelected = settings.voiceProfile == v['id'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      onTap: () {
                        settings.setVoiceProfile(v['id']!);
                        VoiceCoachService().speak(v['sample']!);
                      },
                      borderColor: isSelected ? AppColors.primaryGreen : Colors.white12,
                      backgroundColor: isSelected
                          ? AppColors.primaryGreen.withValues(alpha: 0.12)
                          : AppColors.surface,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryGreen.withValues(alpha: 0.25)
                                  : Colors.white10,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.record_voice_over_rounded,
                              color: isSelected ? AppColors.primaryGreen : Colors.white70,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      v['name']!,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.cyan.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                                      ),
                                      child: Text(
                                        v['tag']!,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.cyan,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  v['desc']!,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, color: AppColors.electricGreen, size: 22),
                            tooltip: 'Preview Voice',
                            onPressed: () {
                              settings.setVoiceProfile(v['id']!);
                              VoiceCoachService().speak(v['sample']!);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              _buildSectionHeader('VOICE VOLUME'),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Coach Speech Volume', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        Text('${(settings.voiceVolume * 100).toInt()}%', style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: settings.voiceVolume,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (v) => settings.setVoiceVolume(v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              AppButton(
                text: 'CLEAR CACHE',
                type: AppButtonType.outline,
                icon: Icons.cleaning_services_rounded,
                onPressed: () => _clearTemporaryCache(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1),
      ),
    );
  }

  void _clearTemporaryCache(BuildContext context) {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared successfully.'),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
