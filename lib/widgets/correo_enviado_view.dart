import 'package:flutter/material.dart';

class CorreoEnviadoView extends StatelessWidget {
  final String correo;
  final Color colorPrincipal;
  final Color colorOscuro;
  final VoidCallback onVolver;
  final VoidCallback onOtroCorreo;

  const CorreoEnviadoView({
    super.key,
    required this.correo,
    required this.onVolver,
    required this.onOtroCorreo,
    this.colorPrincipal = const Color(0xFF168B62),
    this.colorOscuro = const Color(0xFF173D2D),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        CircleAvatar(
          radius: 38,
          backgroundColor: const Color(0xFFDDF8E8),
          child: Icon(
            Icons.mark_email_read_outlined,
            color: colorPrincipal,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Revisa tu correo',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorOscuro,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Si existe una cuenta asociada a $correo, '
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
            onPressed: onVolver,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrincipal,
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
          onPressed: onOtroCorreo,
          child: Text(
            'Usar otro correo',
            style: TextStyle(
              color: colorPrincipal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}