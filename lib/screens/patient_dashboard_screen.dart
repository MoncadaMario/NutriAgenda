import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'appointment_confirmation_screen.dart';
import '../widgets/logout_button.dart';
import '../utils/formatters.dart';
import '../widgets/stat_card.dart';
import '../widgets/dashboard_scaffold.dart';
import '../theme/app_colors.dart';
import '../widgets/mensajes.dart';
import '../data/patient_dashboard_repository.dart';

class PatientDashboardScreen extends StatefulWidget {
  final PatientDashboardRepository? repositorioParaPruebas;
  final String? usuarioIdParaPruebas;

  const PatientDashboardScreen({
    super.key,
    this.repositorioParaPruebas,
    this.usuarioIdParaPruebas,
  });

  static const Color verdePrincipal = AppColors.verdePrincipal;
  static const Color verdeOscuro = AppColors.verdeOscuroAlt;
  static const Color fondoClaro = AppColors.fondoClaro;

  @override
  State<PatientDashboardScreen> createState() =>
      _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  static const Color verdePrincipal = PatientDashboardScreen.verdePrincipal;
  static const Color verdeOscuro = PatientDashboardScreen.verdeOscuro;
  static const Color fondoClaro = PatientDashboardScreen.fondoClaro;

  late final _repositorio =
      widget.repositorioParaPruebas ?? SupabasePatientDashboardRepository();

  bool _cargando = true;
  String _nombre = '';
  Map<String, dynamic>? _proximaCita;
  List<Map<String, dynamic>> _historial = [];
  Map<String, dynamic>? _ultimoMenu;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final usuarioId = widget.usuarioIdParaPruebas ??
        Supabase.instance.client.auth.currentUser?.id;
    if (usuarioId == null) return;

    try {
      final perfil = await _repositorio.obtenerPerfil(usuarioId);
      final proximaCita = await _repositorio.obtenerProximaCita(usuarioId);
      final historial = await _repositorio.obtenerHistorial(usuarioId);
      final ultimoMenu = await _repositorio.obtenerUltimoMenu(usuarioId);

      if (!mounted) return;

      setState(() {
        _nombre = perfil['nombre'] as String? ?? '';
        _proximaCita = proximaCita;
        _historial = historial;
        _ultimoMenu = ultimoMenu;
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar tu información: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const LoadingScaffold(
        background: fondoClaro,
        indicatorColor: verdePrincipal,
      );
    }

    final ultimaConsulta = _historial.isNotEmpty ? _historial.first : null;

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFD9F5E5),
              child: Icon(
                Icons.spa_rounded,
                color: verdePrincipal,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'NutriAgenda',
              style: TextStyle(
                color: verdeOscuro,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          LogoutButton(
            color: verdeOscuro,
            onLogout: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
          IconButton(
            tooltip: 'Notificaciones',
            onPressed: () {
              mostrarMensaje(context, 'No tienes notificaciones nuevas.');
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: verdeOscuro,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: verdePrincipal,
              child: Text(
                obtenerIniciales(_nombre),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshableContent(
        onRefresh: _cargarDatos,
        maxWidth: 1200,
        children: [
          Text(
            'Hola, $_nombre',
            style: const TextStyle(
              color: verdeOscuro,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Aquí puedes consultar tus citas, progreso y plan nutricional.',
            style: TextStyle(
              color: Color(0xFF62766D),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: verdePrincipal,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFBFEFD8),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: verdePrincipal,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tu próxima cita',
                          style: TextStyle(
                            color: Color(0xFFDDF8E8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _proximaCita == null
                              ? 'No tienes citas agendadas'
                              : '${formatearFechaLarga(_proximaCita!['fecha'])} · ${formatearHora12(_proximaCita!['hora'])}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _proximaCita == null
                              ? 'Tu nutricionista te asignará una próxima cita.'
                              : _proximaCita!['tipo'] as String,
                          style: const TextStyle(
                            color: Color(0xFFDDF8E8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_proximaCita != null) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AppointmentConfirmationScreen(
                            cita: _proximaCita!,
                          ),
                        ),
                      );
                      _cargarDatos();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.event_available_outlined),
                    label: const Text('Ver detalles de mi cita'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),

          const Text(
            'Resumen de tu última consulta',
            style: TextStyle(
              color: verdeOscuro,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (ultimaConsulta == null)
            const Text(
              'Aún no tienes consultas registradas.',
              style: TextStyle(color: Color(0xFF62766D)),
            )
          else
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                StatCard(
                  icono: Icons.monitor_weight_outlined,
                  titulo: 'Peso',
                  valor: '${ultimaConsulta['peso']} kg',
                ),
                StatCard(
                  icono: Icons.height_rounded,
                  titulo: 'Estatura',
                  valor: '${ultimaConsulta['estatura']} m',
                ),
                StatCard(
                  icono: Icons.favorite_outline_rounded,
                  titulo: 'IMC',
                  valor: '${ultimaConsulta['imc']}',
                ),
                StatCard(
                  icono: Icons.percent_rounded,
                  titulo: '% de grasa',
                  valor: '${ultimaConsulta['porcentaje_grasa']}%',
                ),
              ],
            ),
          const SizedBox(height: 32),

          const Text(
            'Historial de consultas',
            style: TextStyle(
              color: verdeOscuro,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Los datos son registrados por tu nutricionista.',
            style: TextStyle(color: Color(0xFF62766D)),
          ),
          const SizedBox(height: 16),

          if (_historial.isEmpty)
            const Text(
              'No hay consultas registradas todavía.',
              style: TextStyle(color: Color(0xFF62766D)),
            )
          else
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE0EEE6)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFFF0FAF4),
                  ),
                  columns: const [
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Peso')),
                    DataColumn(label: Text('Estatura')),
                    DataColumn(label: Text('Género')),
                    DataColumn(label: Text('Edad')),
                    DataColumn(label: Text('IMC')),
                    DataColumn(label: Text('% grasa')),
                  ],
                  rows: _historial.map((consulta) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                            formatearFechaLarga(consulta['fecha']))),
                        DataCell(Text('${consulta['peso']} kg')),
                        DataCell(Text('${consulta['estatura']} m')),
                        DataCell(Text('${consulta['genero'] ?? '-'}')),
                        DataCell(Text('${consulta['edad'] ?? '-'} años')),
                        DataCell(Text('${consulta['imc']}')),
                        DataCell(
                            Text('${consulta['porcentaje_grasa']}%')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 32),

          const Text(
            'Mi menú nutricional',
            style: TextStyle(
              color: verdeOscuro,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (_ultimoMenu == null)
            const Text(
              'Aún no tienes un menú asignado.',
              style: TextStyle(color: Color(0xFF62766D)),
            )
          else
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE0EEE6)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF8E8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: verdePrincipal,
                        size: 32,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Menú nutricional',
                          style: TextStyle(
                            color: verdeOscuro,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Asignado el ${formatearFechaLarga(_ultimoMenu!['fecha'])}',
                          style: const TextStyle(color: Color(0xFF62766D)),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        mostrarMensaje(
                          context,
                          _ultimoMenu!['contenido'] ??
                              'Este menú no tiene contenido adicional.',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: verdePrincipal,
                        side: const BorderSide(color: verdePrincipal),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: const Text('Ver menú'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}