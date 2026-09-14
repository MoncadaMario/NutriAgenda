import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const Color verdePrincipal = Color(0xFF168B62);
  static const Color verdeMenta = Color(0xFFBFEFD8);
  static const Color fondoClaro = Color(0xFFF4FBF7);
  static const Color textoOscuro = Color(0xFF173D2D);

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
        backgroundColor: verdePrincipal,
      ),
    );
  }

  InputDecoration _estiloCampo({
    required String texto,
    required IconData icono,
  }) {
    return InputDecoration(
      labelText: texto,
      prefixIcon: Icon(icono, color: verdePrincipal),
      filled: true,
      fillColor: const Color(0xFFFCFFFD),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD4E8DC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD4E8DC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: verdePrincipal,
          width: 2,
        ),
      ),
    );
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: _estiloCampo(
                              texto: 'Correo electrónico',
                              icono: Icons.email_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            obscureText: true,
                            decoration: _estiloCampo(
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
                                    builder: (context) => ForgotPasswordScreen()
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
                              onPressed: () {
                                _mostrarMensaje(
                                  context,
                                  'Aquí conectaremos el inicio de sesión con Supabase.',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: verdePrincipal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
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
                                    builder: (context) => RegisterScreen(),
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