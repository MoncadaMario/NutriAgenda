import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'patients_screen.dart';
import '../widgets/logout_button.dart';
import '../utils/formatters.dart';
import '../widgets/dashboard_scaffold.dart';
import '../theme/app_colors.dart';
import '../widgets/mensajes.dart';
import '../data/nutritionist_dashboard_repository.dart';

class NutritionistDashboardScreen extends StatefulWidget {
  final NutritionistDashboardRepository? repositorioParaPruebas;
  final String? usuarioIdParaPruebas;

  const NutritionistDashboardScreen({
    super.key,
    this.repositorioParaPruebas,
    this.usuarioIdParaPruebas,
  });

  static const Color verdePrincipal = AppColors.verdePrincipal;
  static const Color verdeOscuro = AppColors.verdeOscuro;
  static const Color fondoClaro = AppColors.fondoClaro;

  @override
  State<NutritionistDashboardScreen> createState() =>
      _NutritionistDashboardScreenState();
}

class _NutritionistDashboardScreenState
    extends State<NutritionistDashboardScreen> {
  static const verdePrincipal = NutritionistDashboardScreen.verdePrincipal;
  static const verdeOscuro = NutritionistDashboardScreen.verdeOscuro;
  static const fondoClaro = NutritionistDashboardScreen.fondoClaro;

  late final _repositorio = widget.repositorioParaPruebas ??
      SupabaseNutritionistDashboardRepository();

  bool _cargando = true;
  String _nombre = '';
  int _pacientesActivos = 0;
  int _citasHoy = 0;
  int _porConfirmar = 0;
  int _consultasDelMes = 0;
  List<Map<String, dynamic>> _citasDeHoy = [];

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
      final pacientesActivos = await _repositorio.contarPacientes();
      final citasDeHoy = await _repositorio.obtenerCitasDeHoy(usuarioId);
      final porConfirmar =
          await _repositorio.contarCitasPendientes(usuarioId);
      final consultasDelMes =
          await _repositorio.contarConsultasDelMes(usuarioId);

      if (!mounted) return;

      setState(() {
        _nombre = perfil['nombre'] as String? ?? '';
        _pacientesActivos = pacientesActivos;
        _citasHoy = citasDeHoy.length;
        _porConfirmar = porConfirmar;
        _consultasDelMes = consultasDelMes;
        _citasDeHoy = citasDeHoy;
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar el panel: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _irAPacientes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PatientsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const LoadingScaffold(
        background: fondoClaro,
        indicatorColor: verdePrincipal,
      );
    }

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFDDF8E8),
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
            'Este es el resumen de tu agenda y pacientes.',
            style: TextStyle(
              color: Color(0xFF62766D),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _SummaryCard(
                icono: Icons.people_outline_rounded,
                titulo: 'Pacientes activos',
                valor: '$_pacientesActivos',
                colorIcono: verdePrincipal,
              ),
              _SummaryCard(
                icono: Icons.calendar_today_outlined,
                titulo: 'Citas para hoy',
                valor: '$_citasHoy',
                colorIcono: const Color(0xFF2E7CC2),
              ),
              _SummaryCard(
                icono: Icons.pending_actions_outlined,
                titulo: 'Por confirmar',
                valor: '$_porConfirmar',
                colorIcono: const Color(0xFFE59819),
              ),
              _SummaryCard(
                icono: Icons.check_circle_outline_rounded,
                titulo: 'Consultas del mes',
                valor: '$_consultasDelMes',
                colorIcono: const Color(0xFF8A57C8),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Acciones rápidas',
            style: TextStyle(
              color: verdeOscuro,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ActionCard(
                icono: Icons.add_circle_outline_rounded,
                titulo: 'Agendar cita',
                subtitulo: 'Elige un paciente para agendarle',
                onTap: _irAPacientes,
              ),
              _ActionCard(
                icono: Icons.person_search_outlined,
                titulo: 'Ver pacientes',
                subtitulo: 'Buscar y consultar pacientes',
                onTap: _irAPacientes,
              ),
              _ActionCard(
                icono: Icons.assignment_outlined,
                titulo: 'Nueva consulta',
                subtitulo: 'Elige un paciente para registrarle datos',
                onTap: _irAPacientes,
              ),
              _ActionCard(
                icono: Icons.menu_book_outlined,
                titulo: 'Asignar menú',
                subtitulo: 'Elige un paciente para asignarle un menú',
                onTap: _irAPacientes,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Citas de hoy',
                style: TextStyle(
                  color: verdeOscuro,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  mostrarMensaje(
                    context,
                    'La agenda completa se agregará después.',
                  );
                },
                child: const Text(
                  'Ver agenda completa',
                  style: TextStyle(
                    color: verdePrincipal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_citasDeHoy.isEmpty)
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE0EEE6)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No tienes citas programadas para hoy.',
                  style: TextStyle(color: Color(0xFF62766D)),
                ),
              ),
            )
          else
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE0EEE6)),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < _citasDeHoy.length; i++) ...[
                    _AppointmentTile(
                      hora: formatearHora12(_citasDeHoy[i]['hora']),
                      nombre: _citasDeHoy[i]['nombrePaciente'],
                      tipo: _citasDeHoy[i]['tipo'],
                      estado: _citasDeHoy[i]['estado'] == 'confirmada'
                          ? 'Confirmada'
                          : 'Pendiente',
                      colorEstado:
                          _citasDeHoy[i]['estado'] == 'confirmada'
                              ? verdePrincipal
                              : const Color(0xFFE59819),
                    ),
                    if (i != _citasDeHoy.length - 1)
                      const Divider(height: 1),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 32),
          const Text(
            'Solicitudes pendientes',
            style: TextStyle(
              color: verdeOscuro,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFF7D596),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFE59819),
                  size: 30,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _porConfirmar == 0
                        ? 'No tienes citas pendientes de confirmación.'
                        : 'Tienes $_porConfirmar cita(s) que requieren '
                            'confirmación por parte de los pacientes.',
                    style: const TextStyle(
                      color: Color(0xFF765116),
                      fontSize: 15,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    mostrarMensaje(
                      context,
                      'La vista de solicitudes pendientes se agregará después.',
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF9A6916),
                    side: const BorderSide(
                      color: Color(0xFFE59819),
                    ),
                  ),
                  child: const Text('Revisar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;
  final Color colorIcono;

  const _SummaryCard({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.colorIcono,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE0EEE6)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorIcono.withOpacity(0.12),
                child: Icon(icono, color: colorIcono),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: Color(0xFF62766D),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      valor,
                      style: const TextStyle(
                        color: NutritionistDashboardScreen.verdeOscuro,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE0EEE6)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFDDF8E8),
                  child: Icon(
                    icono,
                    color: NutritionistDashboardScreen.verdePrincipal,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  titulo,
                  style: const TextStyle(
                    color: NutritionistDashboardScreen.verdeOscuro,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    color: Color(0xFF62766D),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final String hora;
  final String nombre;
  final String tipo;
  final String estado;
  final Color colorEstado;

  const _AppointmentTile({
    required this.hora,
    required this.nombre,
    required this.tipo,
    required this.estado,
    required this.colorEstado,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 8,
      ),
      leading: Container(
        width: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF0FAF4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          hora,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: NutritionistDashboardScreen.verdePrincipal,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Text(
        nombre,
        style: const TextStyle(
          color: NutritionistDashboardScreen.verdeOscuro,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(tipo),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: colorEstado.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          estado,
          style: TextStyle(
            color: colorEstado,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}