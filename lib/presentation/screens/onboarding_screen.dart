import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import 'main_navigation_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form Controllers & State
  final _nameController = TextEditingController(text: '');
  final _usernameController = TextEditingController(text: '');
  
  String _selectedAvatar = 'assets/images/avatars/avatar_smash_pro.jpg';
  DateTime? _dateOfBirth;
  String? _selectedGender;
  String _dominantHand = 'Right-handed';

  String _playingLevel = 'Intermediate';
  String _primaryGoal = 'Improve Footwork';
  String _playingStyle = 'Both';

  bool _dailyReminder = true;
  bool _restDayReminder = true;
  bool _weeklyReport = true;

  final List<String> _avatarPresets = [
    'assets/images/avatars/avatar_smash_pro.jpg',
    'assets/images/avatars/avatar_speed_queen.jpg',
    'assets/images/avatars/avatar_tactical_master.jpg',
    'assets/images/avatars/avatar_court_ninja.jpg',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final status = await Permission.notification.request();
    if (!status.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must allow notifications to proceed.'),
          duration: Duration(seconds: 3),
        ),
      );
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final trainingProvider = Provider.of<TrainingProvider>(context, listen: false);

    final finalName = _nameController.text.trim().isEmpty ? 'Athlete' : _nameController.text.trim();
    final finalUsername = _usernameController.text.trim().isEmpty
        ? 'athlete_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'
        : _usernameController.text.trim().replaceAll('@', '');

    final newProfile = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: finalName,
      username: finalUsername,
      avatarUrl: _selectedAvatar,
      dateOfBirth: _dateOfBirth,
      gender: _selectedGender,
      dominantHand: _dominantHand,
      playingLevel: _playingLevel,
      primaryGoal: _primaryGoal,
      playingStyle: _playingStyle,
      dailyReminder: _dailyReminder,
      restDayReminder: _restDayReminder,
      weeklyReport: _weeklyReport,
      level: 1,
      currentXp: 0,
      xpNeededForNextLevel: 500,
      currentStreak: 0,
      completedSessions: 0,
      totalMinutes: 0,
      favoriteDrill: 'None yet',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isCloudSynced: false,
    );

    // Save profile locally and mark onboarding complete
    await userProvider.completeOnboarding(newProfile);
    
    // Clear initial demo logs for brand new user profile
    await trainingProvider.clearLogs();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Step Indicator & Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  if (_currentPage > 0 && _currentPage < 4)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                      onPressed: _previousPage,
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final isActive = index == _currentPage;
                        final isCompleted = index < _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 6,
                          width: isActive ? 28 : 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryGreen
                                : isCompleted
                                    ? AppColors.primaryGreen.withValues(alpha: 0.5)
                                    : Colors.white24,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Control via buttons
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage1Welcome(),
                  _buildPage2AthleteProfile(),
                  _buildPage3BadmintonProfile(),
                  _buildPage4Notifications(),
                  _buildPage5Ready(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // PAGE 1: WELCOME
  // ----------------------------------------------------
  Widget _buildPage1Welcome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.35),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen, size: 80),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Welcome to SoloShuttle',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Train Smarter. Play Better.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.primaryGreen,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your ultimate solo badminton training partner. Master shadow footwork, sharpen your reaction speed with AI voice calls, and track your progress.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          // Feature bullets
          _buildFeatureBullet(Icons.record_voice_over_rounded, 'AI Voice Coach', 'Audio-guided reaction and shadow callouts'),
          const SizedBox(height: 14),
          _buildFeatureBullet(Icons.directions_run_rounded, '6-Corner Footwork', 'Custom court routines & interval timer'),
          const SizedBox(height: 14),
          _buildFeatureBullet(Icons.insights_rounded, 'Skill Analytics', 'XP system & performance stats tracking'),
          const SizedBox(height: 40),
          AppButton(
            text: 'GET STARTED',
            icon: Icons.arrow_forward_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBullet(IconData icon, String title, String subtitle) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // PAGE 2: ATHLETE PROFILE
  // ----------------------------------------------------
  Widget _buildPage2AthleteProfile() {
    int? age;
    if (_dateOfBirth != null) {
      final today = DateTime.now();
      age = today.year - _dateOfBirth!.year;
      if (today.month < _dateOfBirth!.month || (today.month == _dateOfBirth!.month && today.day < _dateOfBirth!.day)) {
        age--;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Athlete Profile',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Tell us about yourself so we can set up your player profile.',
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Profile Avatar Picker
          Center(
            child: Column(
              children: [
                Container(
                  height: 84,
                  width: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGreen, width: 3),
                    image: DecorationImage(image: AssetImage(_selectedAvatar), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Select Avatar', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _avatarPresets.map((asset) {
                    final isSelected = _selectedAvatar == asset;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatar = asset),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.surfaceLight,
                          backgroundImage: AssetImage(asset),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Full Name
          Text('Full Name *', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. Keshav Sharma',
              hintStyle: GoogleFonts.poppins(color: Colors.white30),
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryGreen),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen)),
            ),
          ),

          const SizedBox(height: 16),

          // Username
          Text('Username *', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: _usernameController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. keshav_shuttler',
              hintStyle: GoogleFonts.poppins(color: Colors.white30),
              prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.primaryGreen),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen)),
            ),
          ),

          const SizedBox(height: 16),

          // Date of Birth
          Text('Date of Birth', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2002, 5, 15),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.primaryGreen,
                        onPrimary: Colors.black,
                        surface: AppColors.surface,
                        onSurface: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  _dateOfBirth = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: AppColors.primaryGreen, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _dateOfBirth != null
                            ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                            : 'Select Date of Birth',
                        style: GoogleFonts.poppins(color: _dateOfBirth != null ? Colors.white : Colors.white30),
                      ),
                    ],
                  ),
                  if (age != null && age >= 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$age yrs old',
                        style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Gender (Optional)
          Text('Gender (Optional)', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ['Male', 'Female', 'Other', 'Prefer not to say'].map((g) {
              final isSelected = _selectedGender == g;
              return ChoiceChip(
                label: Text(g, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 12)),
                selected: isSelected,
                selectedColor: AppColors.primaryGreen,
                backgroundColor: AppColors.surface,
                onSelected: (_) {
                  setState(() {
                    _selectedGender = isSelected ? null : g;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Dominant Racket Hand
          Text('Dominant Racket Hand *', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: ['Right-handed', 'Left-handed'].map((hand) {
              final isSelected = _dominantHand == hand;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    label: Center(
                      child: Text(
                        hand,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.surface,
                    onSelected: (_) {
                      setState(() {
                        _dominantHand = hand;
                      });
                    },
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          AppButton(
            text: 'CONTINUE',
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              if (_nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your full name')),
                );
                return;
              }
              _nextPage();
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // PAGE 3: BADMINTON PROFILE
  // ----------------------------------------------------
  Widget _buildPage3BadmintonProfile() {
    final levels = [
      {'title': 'Beginner', 'desc': 'Learning fundamental strokes and court movement.', 'emoji': '🌱'},
      {'title': 'Intermediate', 'desc': 'Consistent on strokes, building speed & tactical footwork.', 'emoji': '⚡'},
      {'title': 'Advanced', 'desc': 'High intensity player, fast reaction & match strategy.', 'emoji': '🔥'},
    ];

    final goals = [
      {'title': 'Improve Footwork', 'emoji': '👟'},
      {'title': 'Improve Reaction', 'emoji': '⚡'},
      {'title': 'Learn Strokes', 'emoji': '🏸'},
      {'title': 'General Fitness', 'emoji': '💪'},
      {'title': 'Competitive Training', 'emoji': '🏆'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Badminton Profile',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Help us customize your training recommendations.',
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Playing Level
          Text('Playing Level *', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 10),
          ...levels.map((lvl) {
            final isSelected = _playingLevel == lvl['title'];
            return GestureDetector(
              onTap: () => setState(() => _playingLevel = lvl['title']!),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.15) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryGreen : Colors.white10,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(lvl['emoji']!, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lvl['title']!, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(lvl['desc']!, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // Primary Goal
          Text('Primary Goal *', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goals.map((g) {
              final isSelected = _primaryGoal == g['title'];
              return ChoiceChip(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                avatar: Text(g['emoji']!),
                label: Text(
                  g['title']!,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primaryGreen,
                backgroundColor: AppColors.surface,
                onSelected: (_) => setState(() => _primaryGoal = g['title']!),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Playing Style (Optional)
          Text('Playing Style (Optional)', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: ['Singles', 'Doubles', 'Both'].map((style) {
              final isSelected = _playingStyle == style;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    label: Text(
                      style,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.surface,
                    onSelected: (_) => setState(() => _playingStyle = style),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          AppButton(
            text: 'CONTINUE',
            icon: Icons.arrow_forward_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // PAGE 4: NOTIFICATIONS
  // ----------------------------------------------------
  Widget _buildPage4Notifications() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications & Reminders',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Stay accountable with tailored training notifications.',
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 24),

          _buildNotificationToggleTile(
            icon: Icons.alarm_rounded,
            title: 'Daily Training Reminder',
            subtitle: 'Get a daily alert at your preferred time to keep your streak going.',
            value: _dailyReminder,
            onChanged: (val) => setState(() => _dailyReminder = val),
          ),
          const SizedBox(height: 14),

          _buildNotificationToggleTile(
            icon: Icons.self_improvement_rounded,
            title: 'Rest Day Reminder',
            subtitle: 'Receive reminders to take rest days and prevent overtraining.',
            value: _restDayReminder,
            onChanged: (val) => setState(() => _restDayReminder = val),
          ),
          const SizedBox(height: 14),

          _buildNotificationToggleTile(
            icon: Icons.bar_chart_rounded,
            title: 'Weekly Progress Report',
            subtitle: 'Get a Sunday summary of your weekly XP, drills completed & footwork count.',
            value: _weeklyReport,
            onChanged: (val) => setState(() => _weeklyReport = val),
          ),

          const SizedBox(height: 40),

          AppButton(
            text: 'CONTINUE',
            icon: Icons.arrow_forward_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11.5)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primaryGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // PAGE 5: READY
  // ----------------------------------------------------
  Widget _buildPage5Ready() {
    final name = _nameController.text.trim().isEmpty ? 'Athlete' : _nameController.text.trim();
    final username = _usernameController.text.trim().isEmpty ? 'athlete' : _usernameController.text.trim().replaceAll('@', '');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withValues(alpha: 0.15),
              border: Border.all(color: AppColors.primaryGreen, width: 3),
            ),
            child: const Center(
              child: Icon(Icons.emoji_events_rounded, color: AppColors.primaryGreen, size: 54),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome, $name!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Your athlete profile has been initialized.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),

          // Profile Overview Card
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.surfaceLight,
                      backgroundImage: AssetImage(_selectedAvatar),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('@$username', style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Level 1', style: GoogleFonts.poppins(color: AppColors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 24),
                _buildSummaryRow('Skill Rank', _playingLevel),
                _buildSummaryRow('Racket Hand', _dominantHand),
                _buildSummaryRow('Primary Goal', _primaryGoal),
                _buildSummaryRow('Match Style', _playingStyle),
              ],
            ),
          ),

          const SizedBox(height: 36),

          AppButton(
            text: 'BEGIN TRAINING',
            icon: Icons.sports_tennis_rounded,
            onPressed: _completeOnboarding,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13)),
          Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
