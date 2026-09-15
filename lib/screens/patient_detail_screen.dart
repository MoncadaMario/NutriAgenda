import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'consultation_form_screen.dart';
import 'menu_assignment_screen.dart';
import 'schedule_appointment_screen.dart';

class PatientDetailScreen extends StatefulWidget {
  final String pacienteId;

  const PatientDetailScreen({super.key, required this.pacienteId});

  static const verde = Color(0xFF168B62);
  static const oscuro = Color(0xFF173D2D);

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  static const verde = PatientDetailScreen.verde;
  static const oscuro = PatientDetailScreen.oscuro;

  final _cliente = Supabase.instance.client;
  bool _cargando = true;
  Map<String, dynamic>? _perfil;
  List<Map<String, dynamic>> _historial = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final perfil = await _cliente
          .from('profiles')
          .select()
          .eq('id', widget.pacienteId)
          .single();

      final historial = await _cliente
          .from('consultations')
          .select()
          .eq('paciente_id', widget.pacienteId)
          .order('fecha', ascending: false);

      if (!mounted) return;

      setState(() {
        _perfil = perfil;
        _historial = List<Map<String, dynamic>>.from(historial);
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar el paciente: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _iniciales(String nombre) {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: verde)),
      );
    }

    if (_perfil == null) {
      return const Scaffold(
        body: Center(child: Text('No se encontró este paciente.')),
      );
    }

    final nombre = _perfil!['nombre'] as String? ?? 'Sin nombre';
    final ultimaConsulta = _historial.isNotEmpty ? _historial.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBF7),
        elevation: 0,
        title: const Text(
          'Perfil del paciente',
          style: TextStyle(color: oscuro, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: const Color(0xFFDDF8E8),
                            child: Text(
                              _iniciales(nombre),
                              style: const TextStyle(
                                color: verde,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nombre,
                                  style: const TextStyle(
                                    color: oscuro,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('${_perfil!['correo'] ?? ''}'),
                                Text('${_perfil!['telefono'] ?? ''}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Última consulta',
                    style: TextStyle(
                      color: oscuro,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (ultimaConsulta == null)
                    const Text(
                      'Este paciente no tiene consultas registradas.',
                      style: TextStyle(color: Color(0xFF62766D)),
                    )
                  else
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        _DataCard('Peso', '${ultimaConsulta['peso']} kg',
                            Icons.monitor_weight_outlined),
                        _DataCard('Estatura', '${ultimaConsulta['estatura']} m',
                            Icons.height_rounded),
                        _DataCard('IMC', '${ultimaConsulta['imc']}',
                            Icons.favorite_outline_rounded),
                        _DataCard('% grasa',
                            '${ultimaConsulta['porcentaje_grasa']}%',
                            Icons.percent_rounded),
                      ],
                    ),
                  const SizedBox(height: 28),
                  const Text(
                    'Acciones del paciente',
                    style: TextStyle(
                      color: oscuro,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConsultationFormScreen(
                                pacienteId: widget.pacienteId,
                                nombrePaciente: nombre,
                              ),
                            ),
                          );
                          _cargarDatos();
                        },
                        icon: const Icon(Icons.assignment_outlined),
                        label: const Text('Registrar consulta'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuAssignmentScreen(
                                pacienteId: widget.pacienteId,
                                nombrePaciente: nombre,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.menu_book_outlined),
                        label: const Text('Asignar menú'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScheduleAppointmentScreen(
                                pacienteId: widget.pacienteId,
                                nombrePaciente: nombre,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: const Text('Agendar cita'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Historial de consultas',
                    style: TextStyle(
                      color: oscuro,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_historial.isEmpty)
                    const Text(
                      'No hay consultas registradas.',
                      style: TextStyle(color: Color(0xFF62766D)),
                    )
                  else
                    Card(
                      elevation: 0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Peso')),
                            DataColumn(label: Text('IMC')),
                            DataColumn(label: Text('% grasa')),
                          ],
                          rows: _historial.map((c) {
                            final fecha = DateTime.parse(c['fecha']);
                            final fechaTexto =
                                '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
                            return DataRow(cells: [
                              DataCell(Text(fechaTexto)),
                              DataCell(Text('${c['peso']} kg')),
                              DataCell(Text('${c['imc']}')),
                              DataCell(Text('${c['porcentaje_grasa']}%')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _DataCard(this.titulo, this.valor, this.icono);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, color: const Color(0xFF168B62)),
              const SizedBox(height: 14),
              Text(titulo),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(
                  color: Color(0xFF173D2D),
                  fontSize: 20,
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