import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  static const Color verdePrincipal = AppColors.verdePrincipal;
  static const Color verdeOscuro = AppColors.verdeOscuro;
  static const Color fondoClaro = AppColors.fondoClaro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoClaro,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                color: verdePrincipal,
                size: 64,
              ),
              const SizedBox(height: 20),
              const Text(
                'Página no encontrada',
                style: TextStyle(
                  color: verdeOscuro,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'La página que buscas no existe o fue movida.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF61766C)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: verdePrincipal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}