import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/training_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/voice_coach_provider.dart';
import 'screens/home_screen.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TrainingProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => VoiceCoachProvider()),
      ],
      child: const SoloShuttleApp(),
    ),
  );
}

class SoloShuttleApp extends StatelessWidget {
  const SoloShuttleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'SoloShuttle',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
