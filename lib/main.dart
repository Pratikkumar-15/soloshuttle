import 'package:flutter/material.dart';

void main() {
  runApp(const SoloShuttleApp());
}

class SoloShuttleApp extends StatelessWidget {
  const SoloShuttleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SoloShuttle"),
        ),
        body: const Center(
          child: Text(
            "Welcome to SoloShuttle 🚀",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}