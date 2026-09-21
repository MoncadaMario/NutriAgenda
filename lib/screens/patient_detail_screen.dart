import 'package:flutter/material.dart';
import 'consultation_form_screen.dart';
import 'menu_assignment_screen.dart';
import 'schedule_appointment_screen.dart';
import '../utils/formatters.dart';
import '../widgets/stat_card.dart';
import '../widgets/dashboard_scaffold.dart';
import '../theme/app_colors.dart';
import '../data/patient_detail_repository.dart';

class PatientDetailScreen extends StatefulWidget {
  final String pacienteId;
  final PatientDetailRepository? repositorioParaPruebas;

  const PatientDetailScreen({
    super.key,
    required this.pacienteId,
    this.repositorioParaPruebas,
  });

  static const verde = AppColors.verdePrincipal;
  static const oscuro = AppColors.verdeOscuro;

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  static const verde = PatientDetailScreen.verde;
  static const oscuro = PatientDetailScreen.oscuro;

  late final _repositorio =
      widget.repositorioParaPruebas ?? SupabasePatientDetailRepository();

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
      final perfil = await _repositorio.obtenerPerfil(widget.pacienteId);
      final historial =
          await _repositorio.obtenerHistorial(widget.pacienteId);

      if (!mounted) return;

      setState(() {
        _perfil = perfil;
        _historial = historial;
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

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const LoadingScaffold(
        background: Color(0xFFF4FBF7),
        indicatorColor: verde,
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
      body: RefreshableContent(
        onRefresh: _cargarDatos,
        maxWidth: 900,
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
                      obtenerIniciales(nombre),
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
                StatCard(
                  titulo: 'Peso',
                  valor: '${ultimaConsulta['peso']} kg',
                  icono: Icons.monitor_weight_outlined,
                  ancho: 170,
                  valorFontSize: 20,
                  conBorde: false,
                ),
                StatCard(
                  titulo: 'Estatura',
                  valor: '${ultimaConsulta['estatura']} m',
                  icono: Icons.height_rounded,
                  ancho: 170,
                  valorFontSize: 20,
                  conBorde: false,
                ),
                StatCard(
                  titulo: 'IMC',
                  valor: '${ultimaConsulta['imc']}',
                  icono: Icons.favorite_outline_rounded,
                  ancho: 170,
                  valorFontSize: 20,
                  conBorde: false,
                ),
                StatCard(
                  titulo: '% grasa',
                  valor: '${ultimaConsulta['porcentaje_grasa']}%',
                  icono: Icons.percent_rounded,
                  ancho: 170,
                  valorFontSize: 20,
                  conBorde: false,
                ),
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
                    final fechaTexto = formatearFechaCorta(fecha);
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
    );
  }
}