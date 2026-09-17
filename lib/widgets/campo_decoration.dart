import 'package:flutter/material.dart';

const Color colorPrincipalCampo = Color(0xFF168B62);

InputDecoration estiloCampoTexto({
  required String texto,
  required IconData icono,
  Widget? iconoFinal,
}) {
  return InputDecoration(
    labelText: texto,
    prefixIcon: Icon(icono, color: colorPrincipalCampo),
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
        color: colorPrincipalCampo,
        width: 2,
      ),
    ),
  );
}