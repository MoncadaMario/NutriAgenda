import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NutriAgendaApp());
}

class NutriAgendaApp extends StatelessWidget {
  const NutriAgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriAgenda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}