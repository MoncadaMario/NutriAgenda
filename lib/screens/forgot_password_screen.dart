import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/campo_decoration.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const Color verdePrincipal = Color(0xFF168B62);
  static const Color verdeOscuro = Color(0xFF173D2D);
  static const Color fondoClaro = Color(0xFFF4FBF7);

  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();

  bool _correoEnviado = false;
  bool _enviando = false;

  @override
  void dispose() {
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _enviarEnlace() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _enviando = true;
    });

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _correoController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _enviando = false;
        _correoEnviado = true;
      });
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo enviar el correo: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 8,
                shadowColor: verdePrincipal.withOpacity(0.14),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: _correoEnviado
                      ? _mensajeCorreoEnviado(context)
                      : _formularioRecuperacion(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formularioRecuperacion() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              'assets/images/nutriagenda_logo.png',
              height: 105,
            ),
          ),
          const SizedBox(height: 18),
          const Icon(
            Icons.lock_reset_rounded,
            color: verdePrincipal,
            size: 46,
          ),
          const SizedBox(height: 14),
          const Text(
            'Recupera tu contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: verdeOscuro,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Ingresa tu correo y te enviaremos un enlace para crear una nueva contraseña.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF61766C),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          TextFormField(
            controller: _correoController,
            keyboardType: TextInputType.emailAddress,
            decoration: estiloCampoTexto(
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
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _enviando ? null : _enviarEnlace,
              style: ElevatedButton.styleFrom(
                backgroundColor: verdePrincipal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: _enviando
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(
                _enviando ? 'Enviando...' : 'Enviar enlace de recuperación',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Por seguridad, no indicaremos si el correo tiene una cuenta registrada.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF71827A),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mensajeCorreoEnviado(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        const CircleAvatar(
          radius: 38,
          backgroundColor: Color(0xFFDDF8E8),
          child: Icon(
            Icons.mark_email_read_outlined,
            color: verdePrincipal,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Revisa tu correo',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: verdeOscuro,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Si existe una cuenta asociada a ${_correoController.text.trim()}, '
          'recibirás un enlace para restablecer tu contraseña.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF61766C),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
              'Volver al inicio de sesión',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              _correoEnviado = false;
            });
          },
          child: const Text(
            'Usar otro correo',
            style: TextStyle(
              color: verdePrincipal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}