import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../providers/user_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<String> units = ['Metric (km/m)', 'Imperial (mi/ft)'];
  static const List<String> languages = ['English', 'Spanish', 'French', 'German', 'Mandarin', 'Bahasa Indonesia'];

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
                      activeColor: AppColors.primaryGreen,
                      title: Text('Dark Mode', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      subtitle: Text('Default dark sports aesthetic', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                      value: settings.isDarkMode,
                      onChanged: null, // Always dark mode as per requirements
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      activeColor: AppColors.primaryGreen,
                      title: Text('Sound FX & Audio Beeps', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      value: settings.isSoundEnabled,
                      onChanged: (v) => settings.setSoundEnabled(v),
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      activeColor: AppColors.primaryGreen,
                      title: Text('Voice Guidance Speech', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      value: settings.isVoiceGuidanceEnabled,
                      onChanged: (v) => settings.setVoiceGuidanceEnabled(v),
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      activeColor: AppColors.primaryGreen,
                      title: Text('Daily Workout Notifications', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      value: settings.isNotificationsEnabled,
                      onChanged: (v) => settings.setNotificationsEnabled(v),
                    ),
                  ],
                ),
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

              const SizedBox(height: 24),

              _buildSectionHeader('UNITS & LANGUAGE'),
              AppCard(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Units System', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(settings.unitSystem, style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 14),
                        ],
                      ),
                      onTap: () => _showPickerModal(context, 'Select Units System', units, settings.unitSystem, (u) => settings.setUnitSystem(u)),
                    ),
                    const Divider(color: Colors.white12),
                    ListTile(
                      title: Text('App Language', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(settings.language, style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 14),
                        ],
                      ),
                      onTap: () => _showPickerModal(context, 'Select Language', languages, settings.language, (l) => settings.setLanguage(l)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              AppButton(
                text: 'RESET ALL APP DATA',
                type: AppButtonType.danger,
                icon: Icons.restore_rounded,
                onPressed: () => _showResetConfirmation(context),
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

  void _showPickerModal(BuildContext context, String title, List<String> options, String currentSelection, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              ...options.map((opt) {
                final isSelected = opt == currentSelection;
                return ListTile(
                  title: Text(opt, style: GoogleFonts.poppins(color: isSelected ? AppColors.primaryGreen : Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.primaryGreen) : null,
                  onTap: () {
                    onSelect(opt);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Reset App Data?', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text('This will reset your local stats, XP, and training history.', style: GoogleFonts.poppins(color: AppColors.textMuted)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App data reset successfully.')),
                  );
                }
              },
              child: const Text('RESET DATA'),
            ),
          ],
        );
      },
    );
  }
}
