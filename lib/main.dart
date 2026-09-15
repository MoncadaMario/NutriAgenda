import 'package:flutter/material.dart';

import 'screens/admin_dashboard_screen.dart';
import 'screens/appointment_confirmation_screen.dart';
import 'screens/consultation_form_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_assignment_screen.dart';
import 'screens/nutritionist_dashboard_screen.dart';
import 'screens/patient_dashboard_screen.dart';
import 'screens/patient_detail_screen.dart';
import 'screens/patients_screen.dart';
import 'screens/register_screen.dart';
import 'screens/schedule_appointment_screen.dart';
import 'screens/user_management_screen.dart';

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
          seedColor: const Color(0xFF36B77A),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FCF9),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/patient-dashboard': (context) => PatientDashboardScreen(),
        '/nutritionist-dashboard': (context) => NutritionistDashboardScreen(),
        '/schedule-appointment': (context) => ScheduleAppointmentScreen(),
        '/patients': (context) => PatientsScreen(),
        '/patient-detail': (context) => PatientDetailScreen(),
        '/consultation-form': (context) => ConsultationFormScreen(),
        '/menu-assignment': (context) => MenuAssignmentScreen(),
        '/appointment-confirmation': (context) => AppointmentConfirmationScreen(),
        '/admin-dashboard': (context) => AdminDashboardScreen(),
        '/user-management': (context) => UserManagementScreen(),
      },
    );
  }
}