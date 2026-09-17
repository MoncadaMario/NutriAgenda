import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;
  final Color colorIcono;
  final double ancho;
  final double padding;
  final double valorFontSize;
  final bool conBorde;

  const StatCard({
    super.key,
    required this.icono,
    required this.titulo,
    required this.valor,
    this.colorIcono = const Color(0xFF168B62),
    this.ancho = 200,
    this.padding = 20,
    this.valorFontSize = 22,
    this.conBorde = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: conBorde
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE0EEE6)),
              )
            : null,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, color: colorIcono),
              const SizedBox(height: 18),
              Text(titulo, style: const TextStyle(color: Color(0xFF62766D))),
              const SizedBox(height: 6),
              Text(
                valor,
                style: TextStyle(
                  color: const Color(0xFF173D2D),
                  fontSize: valorFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}