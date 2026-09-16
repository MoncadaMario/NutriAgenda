import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> cita;

  const AppointmentConfirmationScreen({super.key, required this.cita});

  @override
  State<AppointmentConfirmationScreen> createState() =>
      _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen> {
  static const verde = Color(0xFF168B62);
  static const rojo = Color(0xFFB34732);
  static const naranja = Color(0xFFE59819);
  static const _meses = [
    '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  late String _estado;
  bool _actualizando = false;

  @override
  void initState() {
    super.initState();
    _estado = widget.cita['estado'] as String? ?? 'pendiente';
  }

  DateTime _fechaHoraCita() {
    final fecha = DateTime.parse(widget.cita['fecha']);
    final horaPartes = (widget.cita['hora'] as String).split(':');
    return DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      int.parse(horaPartes[0]),
      int.parse(horaPartes[1]),
    );
  }

  bool get _dentroDeVentanaDeConfirmacion {
    final citaEn = _fechaHoraCita();
    final faltan24h = citaEn.subtract(const Duration(hours: 24));
    return DateTime.now().isAfter(faltan24h);
  }

  String _formatearFechaHora() {
    final fecha = DateTime.parse(widget.cita['fecha']);
    final fechaTexto =
        '${fecha.day} de ${_meses[fecha.month]} de ${fecha.year}';

    final horaPartes = (widget.cita['hora'] as String).split(':');
    var h = int.parse(horaPartes[0]);
    final m = horaPartes[1];
    final periodo = h >= 12 ? 'p. m.' : 'a. m.';
    h = h % 12;
    if (h == 0) h = 12;

    return '$fechaTexto\n$h:$m $periodo';
  }

  Future<void> _actualizarEstado(String nuevoEstado) async {
    setState(() {
      _actualizando = true;
    });

    try {
      await Supabase.instance.client.from('appointments')
          .update({'estado': nuevoEstado})
          .eq('id', widget.cita['id']);

      if (!mounted) return;

      setState(() {
        _estado = nuevoEstado;
        _actualizando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _actualizando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la cita: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cancelada = _estado == 'cancelada';
    final confirmada = _estado == 'confirmada';
    final puedeConfirmar =
        !cancelada && !confirmada && _dentroDeVentanaDeConfirmacion;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBF7),
        elevation: 0,
        title: const Text(
          'Tu cita',
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
                      backgroundColor: cancelada
                          ? const Color(0xFFFFE5E0)
                          : const Color(0xFFDDF8E8),
                      child: Icon(
                        cancelada
                            ? Icons.cancel_outlined
                            : confirmada
                                ? Icons.check_circle_outline
                                : Icons.calendar_month_rounded,
                        color: cancelada ? rojo : verde,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      cancelada
                          ? 'Cita cancelada'
                          : confirmada
                              ? 'Cita confirmada'
                              : 'Detalle de tu cita',
                      style: const TextStyle(
                        color: Color(0xFF173D2D),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${widget.cita['tipo']}\n${_formatearFechaHora()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF61766C),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (!cancelada && !confirmada && !puedeConfirmar)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7E8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFF7D596)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: naranja),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Podrás confirmar tu asistencia 24 horas '
                                'antes de la cita. Mientras tanto, puedes '
                                'cancelarla si no vas a poder asistir.',
                                style: TextStyle(
                                  color: Color(0xFF765116),
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (confirmada)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Gracias por confirmar. Tu nutricionista ya lo sabe.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF61766C)),
                        ),
                      ),

                    if (cancelada)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Tu nutricionista será notificada de la cancelación.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF61766C)),
                        ),
                      ),

                    if (!cancelada) ...[
                      if (puedeConfirmar) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _actualizando
                                ? null
                                : () => _actualizarEstado('confirmada'),
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
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _actualizando
                              ? null
                              : () => _actualizarEstado('cancelada'),
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Cancelar cita'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: rojo,
                            side: const BorderSide(color: rojo),
                            minimumSize: const Size.fromHeight(52),
                          ),
                        ),
                      ),
                    ] else
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: verde,
                            side: const BorderSide(color: verde),
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('Volver'),
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