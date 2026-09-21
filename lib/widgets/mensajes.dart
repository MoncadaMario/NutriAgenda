import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

void mostrarMensaje(
  BuildContext context,
  String mensaje, {
  bool esError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      backgroundColor: esError ? Colors.redAccent : AppColors.verdePrincipal,
      behavior: SnackBarBehavior.floating,
    ),
  );
}