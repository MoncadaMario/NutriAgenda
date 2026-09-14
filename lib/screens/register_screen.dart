import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color verdePrincipal = Color(0xFF168B62);
  static const Color verdeOscuro = Color(0xFF173D2D);
  static const Color fondoClaro = Color(0xFFF4FBF7);

  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarContrasenaController = TextEditingController();

  bool _esNutricionista = false;
  bool _ocultarContrasena = true;
  bool _ocultarConfirmacion = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _contrasenaController.dispose();
    _confirmarContrasenaController.dispose();
    super.dispose();
  }

  InputDecoration _estiloCampo({
    required String texto,
    required IconData icono,
    Widget? iconoFinal,
  }) {
    return InputDecoration(
      labelText: texto,
      prefixIcon: Icon(icono, color: verdePrincipal),
      suffixIcon: iconoFinal,
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

  void _registrarUsuario() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tipoUsuario = _esNutricionista
        ? 'nutricionista pendiente de pago'
        : 'paciente';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cuenta de $tipoUsuario preparada. '
          'Luego la conectaremos con Supabase.',
        ),
        backgroundColor: verdePrincipal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: AppBar(
        backgroundColor: fondoClaro,
        elevation: 0,
        surfaceTintColor: fondoClaro,
        leading: IconButton(
          tooltip: 'Volver',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: verdeOscuro,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                elevation: 8,
                shadowColor: verdePrincipal.withOpacity(0.14),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/nutriagenda_logo.png',
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Crea tu cuenta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: verdeOscuro,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Comienza a llevar el control de tu bienestar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF61766C),
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _nombreController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _estiloCampo(
                            texto: 'Nombre completo',
                            icono: Icons.person_outline_rounded,
                          ),
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Ingresa tu nombre completo.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _correoController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _estiloCampo(
                            texto: 'Correo electrónico',
                            icono: Icons.email_outlined,
                          ),
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Ingresa tu correo electrónico.';
                            }

                            if (!valor.contains('@')) {
                              return 'Ingresa un correo válido.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefonoController,
                          keyboardType: TextInputType.phone,
                          decoration: _estiloCampo(
                            texto: 'Teléfono',
                            icono: Icons.phone_outlined,
                          ),
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Ingresa tu número de teléfono.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _contrasenaController,
                          obscureText: _ocultarContrasena,
                          decoration: _estiloCampo(
                            texto: 'Contraseña',
                            icono: Icons.lock_outline_rounded,
                            iconoFinal: IconButton(
                              tooltip: 'Mostrar u ocultar contraseña',
                              onPressed: () {
                                setState(() {
                                  _ocultarContrasena = !_ocultarContrasena;
                                });
                              },
                              icon: Icon(
                                _ocultarContrasena
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (valor) {
                            if (valor == null || valor.length < 6) {
                              return 'Usa una contraseña de al menos 6 caracteres.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmarContrasenaController,
                          obscureText: _ocultarConfirmacion,
                          decoration: _estiloCampo(
                            texto: 'Confirmar contraseña',
                            icono: Icons.lock_reset_outlined,
                            iconoFinal: IconButton(
                              tooltip: 'Mostrar u ocultar contraseña',
                              onPressed: () {
                                setState(() {
                                  _ocultarConfirmacion =
                                      !_ocultarConfirmacion;
                                });
                              },
                              icon: Icon(
                                _ocultarConfirmacion
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (valor) {
                            if (valor != _contrasenaController.text) {
                              return 'Las contraseñas no coinciden.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FAF4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: CheckboxListTile(
                            value: _esNutricionista,
                            activeColor: verdePrincipal,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                              '¿Eres nutricionista?',
                              style: TextStyle(
                                color: verdeOscuro,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              _esNutricionista
                                  ? 'Tu cuenta quedará pendiente de pago y aprobación.'
                                  : 'Tu cuenta será creada como paciente.',
                            ),
                            onChanged: (valor) {
                              setState(() {
                                _esNutricionista = valor ?? false;
                              });
                            },
                          ),
                        ),
                        if (_esNutricionista) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5E5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFFFD491),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF9B6517),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Por ahora el pago es solo una simulación. '
                                    'Luego agregaremos el cobro real.',
                                    style: TextStyle(
                                      color: Color(0xFF795116),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _registrarUsuario,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: verdePrincipal,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Crear cuenta',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Al registrarte como paciente podrás ver tus citas, '
                          'consultas y menú nutricional.',
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
        ),
      ),
    );
  }
}