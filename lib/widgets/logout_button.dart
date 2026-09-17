import 'package:flutter/material.dart';
import '../utils/session_cookie.dart';

class LogoutButton extends StatelessWidget {
  final Color color;
  final VoidCallback onLogout;

  const LogoutButton({
    super.key,
    required this.onLogout,
    this.color = const Color(0xFF173D2D),
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Cerrar sesión',
      onPressed: () {
        limpiarSesionActiva();
        onLogout();
      },
      icon: Icon(Icons.logout_rounded, color: color),
    );
  }
}