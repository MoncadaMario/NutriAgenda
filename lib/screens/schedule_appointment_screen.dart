import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  final String? pacienteId;
  final String? nombrePaciente;

  const ScheduleAppointmentScreen({
    super.key,
    this.pacienteId,
    this.nombrePaciente,
  });

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  static const Color verdePrincipal = Color(0xFF168B62);
  static const Color verdeOscuro = Color(0xFF173D2D);
  static const Color fondoClaro = Color(0xFFF4FBF7);

  final _formKey = GlobalKey<FormState>();
  final _notasController = TextEditingController();

  String _tipoCita = 'Primera consulta';
  String _duracion = '60 minutos';
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  bool _guardando = false;

  bool get _esNutricionistaAgendando => widget.pacienteId != null;

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      helpText: 'Selecciona la fecha de la cita',
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  Future<void> _seleccionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Selecciona la hora de la cita',
    );

    if (hora != null) {
      setState(() {
        _horaSeleccionada = hora;
      });
    }
  }

  Future<void> _agendarCita() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_fechaSeleccionada == null || _horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona la fecha y la hora de la cita.'),
          backgroundColor: Color(0xFFB34732),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final usuario = Supabase.instance.client.auth.currentUser;
    if (usuario == null) return;

    setState(() {
      _guardando = true;
    });

    try {
      final fechaIso =
          '${_fechaSeleccionada!.year.toString().padLeft(4, '0')}-'
          '${_fechaSeleccionada!.month.toString().padLeft(2, '0')}-'
          '${_fechaSeleccionada!.day.toString().padLeft(2, '0')}';
      final horaIso =
          '${_horaSeleccionada!.hour.toString().padLeft(2, '0')}:'
          '${_horaSeleccionada!.minute.toString().padLeft(2, '0')}:00';

      await Supabase.instance.client.from('appointments').insert({
        'paciente_id': widget.pacienteId ?? usuario.id,
        'nutricionista_id': _esNutricionistaAgendando ? usuario.id : null,
        'tipo': _tipoCita,
        'duracion': _duracion,
        'fecha': fechaIso,
        'hora': horaIso,
        'notas': _notasController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita agendada correctamente.'),
          backgroundColor: verdePrincipal,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agendar la cita: $error'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  InputDecoration _estiloCampo({
    required String texto,
    required IconData icono,
  }) {
    return InputDecoration(
      labelText: texto,
      prefixIcon: Icon(icono, color: verdePrincipal),
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
        title: const Text(
          'Agendar cita',
          style: TextStyle(
            color: verdeOscuro,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Card(
              elevation: 4,
              shadowColor: verdePrincipal.withOpacity(0.12),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFDDF8E8),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: verdePrincipal,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Nueva cita',
                                  style: TextStyle(
                                    color: verdeOscuro,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _esNutricionistaAgendando
                                      ? 'Cita para ${widget.nombrePaciente}.'
                                      : 'Selecciona los datos de tu cita.',
                                  style: const TextStyle(
                                    color: Color(0xFF61766C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (_esNutricionistaAgendando)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FAF4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline_rounded,
                                  color: verdePrincipal),
                              const SizedBox(width: 10),
                              Text(
                                'Paciente: ${widget.nombrePaciente}',
                                style: const TextStyle(
                                  color: verdeOscuro,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<String>(
                        value: _tipoCita,
                        decoration: _estiloCampo(
                          texto: 'Tipo de cita',
                          icono: Icons.medical_services_outlined,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Primera consulta',
                            child: Text('Primera consulta'),
                          ),
                          DropdownMenuItem(
                            value: 'Consulta de seguimiento',
                            child: Text('Consulta de seguimiento'),
                          ),
                        ],
                        onChanged: (valor) {
                          setState(() {
                            _tipoCita = valor!;
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _seleccionarFecha,
                              borderRadius: BorderRadius.circular(14),
                              child: InputDecorator(
                                decoration: _estiloCampo(
                                  texto: 'Fecha',
                                  icono: Icons.calendar_today_outlined,
                                ),
                                child: Text(
                                  _fechaSeleccionada == null
                                      ? 'Seleccionar fecha'
                                      : _formatearFecha(_fechaSeleccionada!),
                                  style: TextStyle(
                                    color: _fechaSeleccionada == null
                                        ? const Color(0xFF62766D)
                                        : verdeOscuro,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: _seleccionarHora,
                              borderRadius: BorderRadius.circular(14),
                              child: InputDecorator(
                                decoration: _estiloCampo(
                                  texto: 'Hora',
                                  icono: Icons.access_time_rounded,
                                ),
                                child: Text(
                                  _horaSeleccionada == null
                                      ? 'Seleccionar hora'
                                      : _horaSeleccionada!.format(context),
                                  style: TextStyle(
                                    color: _horaSeleccionada == null
                                        ? const Color(0xFF62766D)
                                        : verdeOscuro,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<String>(
                        value: _duracion,
                        decoration: _estiloCampo(
                          texto: 'Duración estimada',
                          icono: Icons.timer_outlined,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: '30 minutos',
                            child: Text('30 minutos'),
                          ),
                          DropdownMenuItem(
                            value: '45 minutos',
                            child: Text('45 minutos'),
                          ),
                          DropdownMenuItem(
                            value: '60 minutos',
                            child: Text('60 minutos'),
                          ),
                        ],
                        onChanged: (valor) {
                          setState(() {
                            _duracion = valor!;
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _notasController,
                        maxLines: 4,
                        decoration: _estiloCampo(
                          texto: 'Notas para la cita (opcional)',
                          icono: Icons.notes_rounded,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FAF4),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: verdePrincipal,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'El paciente recibirá una solicitud para confirmar '
                                'o cancelar la cita 24 horas antes.',
                                style: TextStyle(
                                  color: Color(0xFF366452),
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _guardando ? null : _agendarCita,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: verdePrincipal,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: _guardando
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Icon(Icons.event_available_rounded),
                          label: Text(
                            _guardando ? 'Agendando...' : 'Agendar cita',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}