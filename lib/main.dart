import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/admin_dashboard_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/nutritionist_dashboard_screen.dart';
import 'screens/patient_dashboard_screen.dart';
import 'screens/register_screen.dart';
import 'screens/user_management_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
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
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/patient-dashboard': (context) =>
            const AuthGuard(child: PatientDashboardScreen()),
        '/nutritionist-dashboard': (context) =>
            const AuthGuard(child: NutritionistDashboardScreen()),
        '/admin-dashboard': (context) =>
            const AuthGuard(child: AdminDashboardScreen()),
        '/user-management': (context) =>
            const AuthGuard(child: UserManagementScreen()),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        );
      },
    );
  }
}

/// Envuelve cualquier pantalla privada: si no hay sesión activa,
/// redirige al login en vez de mostrar la pantalla.
class AuthGuard extends StatefulWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  @override
  void initState() {
    super.initState();
    if (Supabase.instance.client.auth.currentSession == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Supabase.instance.client.auth.currentSession == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4FBF7),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF168B62)),
        ),
      );
    }
    return widget.child;
  }
}