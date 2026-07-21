import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/training_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/ai_coach_provider.dart';
import 'providers/notification_provider.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>(create: (_) => SharedPreferencesStorageService()),
        ChangeNotifierProxyProvider<StorageService, UserProvider>(
          create: (context) => UserProvider(context.read<StorageService>()),
          update: (context, storage, previous) => previous ?? UserProvider(storage),
        ),
        ChangeNotifierProxyProvider<StorageService, TrainingProvider>(
          create: (context) => TrainingProvider(context.read<StorageService>()),
          update: (context, storage, previous) => previous ?? TrainingProvider(storage),
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider2<StorageService, UserProvider, GoalProvider>(
          create: (context) => GoalProvider(
            context.read<StorageService>(),
            Provider.of<UserProvider>(context, listen: false),
          ),
          update: (context, storage, user, previous) => previous ?? GoalProvider(
            storage,
            user,
          ),
        ),
        ChangeNotifierProvider(create: (_) => AiCoachProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
                return Scaffold(
                  backgroundColor: AppColors.background,
                  body: Center(
                    child: CircularProgressIndicator(color: AppColors.primaryGreen),
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
