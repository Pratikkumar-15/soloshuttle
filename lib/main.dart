import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/training_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/ai_coach_provider.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TrainingProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AiCoachProvider()),
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
          home: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              if (!userProvider.isInitialized) {
                return const Scaffold(
                  backgroundColor: Color(0xFF0F172A),
                  body: Center(
                    child: CircularProgressIndicator(color: Color(0xFF10B981)),
                  ),
                );
              }
              if (!userProvider.hasCompletedOnboarding) {
                return const OnboardingScreen();
              }
              return const MainNavigationScreen();
            },
          ),
        );
      },
    );
  }
}
