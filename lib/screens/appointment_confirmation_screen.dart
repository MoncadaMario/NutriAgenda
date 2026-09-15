import 'package:flutter/material.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  const AppointmentConfirmationScreen({super.key});

  @override
  State<AppointmentConfirmationScreen> createState() =>
      _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen> {
  static const verde = Color(0xFF168B62);
  String estado = 'pendiente';

  void _actualizarEstado(String nuevoEstado) {
    setState(() {
      estado = nuevoEstado;
    });
  }

  @override
  Widget build(BuildContext context) {
    final respondida = estado != 'pendiente';

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBF7),
        elevation: 0,
        title: const Text(
          'Confirmar cita',
          style: TextStyle(
            color: Color(0xFF173D2D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: estado == 'cancelada'
                          ? const Color(0xFFFFE5E0)
                          : const Color(0xFFDDF8E8),
                      child: Icon(
                        respondida && estado == 'cancelada'
                            ? Icons.cancel_outlined
                            : Icons.calendar_month_rounded,
                        color: estado == 'cancelada'
                            ? const Color(0xFFB34732)
                            : verde,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      respondida
                          ? estado == 'confirmada'
                              ? 'Cita confirmada'
                              : 'Cita cancelada'
                          : 'Confirma tu asistencia',
                      style: const TextStyle(
                        color: Color(0xFF173D2D),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Consulta de seguimiento\n22 de septiembre de 2026\n10:00 a. m.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF61766C),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (!respondida) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _actualizarEstado('confirmada');
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Confirmar asistencia'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: verde,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(52),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _actualizarEstado('cancelada');
                          },
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Cancelar cita'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB34732),
                            side: const BorderSide(
                              color: Color(0xFFB34732),
                            ),
                            minimumSize: const Size.fromHeight(52),
                          ),
                        ),
                      ),
                    ] else
                      Text(
                        estado == 'confirmada'
                            ? 'Tu nutricionista recibirá la confirmación.'
                            : 'Tu nutricionista será notificada de la cancelación.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF61766C),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}