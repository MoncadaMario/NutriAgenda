import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/admin_dashboard_screen.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const NutriAgendaApp());
}

final supabase = Supabase.instance.client;

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
        '/admin-dashboard': (context) => AdminDashboardScreen(),
        '/user-management': (context) => UserManagementScreen(),
      },
    );
  }
}