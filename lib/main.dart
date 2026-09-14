import 'package:flutter/material.dart';

import 'screens/patient_dashboard_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF36B77A)),
        scaffoldBackgroundColor: const Color(0xFFF7FCF9),
        useMaterial3: true,
      ),
      home: const PatientDashboardScreen(),
    );
  }
}
