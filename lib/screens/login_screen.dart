import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../widgets/campo_decoration.dart';
import '../utils/session_cookie.dart';
import '../theme/app_colors.dart';
import '../widgets/mensajes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color verdePrincipal = AppColors.verdePrincipal;
  static const Color verdeMenta = AppColors.verdeMenta;
  static const Color fondoClaro = AppColors.fondoClaro;
  static const Color textoOscuro = AppColors.verdeOscuro;

  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (_correoController.text.trim().isEmpty ||
        _contrasenaController.text.isEmpty) {
      mostrarMensaje(context, 'Ingresa tu correo y contraseña.', esError: true);
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      final respuesta = await Supabase.instance.client.auth.signInWithPassword(
        email: _correoController.text.trim(),
        password: _contrasenaController.text,
      );

      if (!mounted) return;

      final usuario = respuesta.user;
      if (usuario == null) {
        mostrarMensaje(context, 'No se pudo iniciar sesión.', esError: true);
        return;
      }

      marcarSesionActiva();

      final perfil = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', usuario.id)
          .single();

      if (!mounted) return;

      final rol = perfil['rol'] as String;

      switch (rol) {
        case 'nutricionista':
          Navigator.pushReplacementNamed(context, '/nutritionist-dashboard');
          break;
        case 'administrador':
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
          break;
        default:
          Navigator.pushReplacementNamed(context, '/patient-dashboard');
      }
    } on AuthException catch (error) {
      if (!mounted) return;
      mostrarMensaje(context, error.message, esError: true);
    } catch (error) {
      if (!mounted) return;
      mostrarMensaje(context, 'Ocurrió un error: $error', esError: true);
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoClaro,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -130,
              right: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  color: verdeMenta,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -170,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDF7E8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Card(
                    elevation: 8,
                    shadowColor: const Color(0xFF0E6D4C).withOpacity(0.16),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/nutriagenda_logo.png',
                              height: 130,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '¡Bienvenido!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textoOscuro,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Inicia sesión para continuar con tu bienestar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF61766C),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 28),
                          TextField(
                            controller: _correoController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: estiloCampoTexto(
                              texto: 'Correo electrónico',
                              icono: Icons.email_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _contrasenaController,
                            obscureText: true,
                            decoration: estiloCampoTexto(
                              texto: 'Contraseña',
                              icono: Icons.lock_outline_rounded,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordScreen()
                                  ),
                                );
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: verdePrincipal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _cargando ? null : _iniciarSesion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: verdePrincipal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _cargando
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Iniciar sesión',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'o',
                                  style: TextStyle(
                                    color: Color(0xFF71827A),
                                  ),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.person_add_alt_1_rounded,
                              ),
                              label: const Text(
                                'Registrarme como nuevo usuario',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: verdePrincipal,
                                side: const BorderSide(
                                  color: verdePrincipal,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'Los roles de paciente, nutricionista y administrador '
                            'serán asignados por el administrador.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF71827A),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Código de verificación: LEARN-CAP-C8E615E4',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFB7C4BE),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}