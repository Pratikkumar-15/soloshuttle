import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SoloShuttleApp());
}

class SoloShuttleApp extends StatelessWidget {
  const SoloShuttleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D0D0D),
    useMaterial3: true,
  ),
  home: const HomeScreen(),
);
  }
}