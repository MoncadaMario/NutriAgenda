import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'patients_screen.dart';

class NutritionistDashboardScreen extends StatefulWidget {
  const NutritionistDashboardScreen({super.key});

  static const Color verdePrincipal = Color(0xFF168B62);
  static const Color verdeOscuro = Color(0xFF173D2D);
  static const Color fondoClaro = Color(0xFFF4FBF7);

  @override
  State<NutritionistDashboardScreen> createState() =>
      _NutritionistDashboardScreenState();
}

class _NutritionistDashboardScreenState
    extends State<NutritionistDashboardScreen> {
  static const verdePrincipal = NutritionistDashboardScreen.verdePrincipal;
  static const verdeOscuro = NutritionistDashboardScreen.verdeOscuro;
  static const fondoClaro = NutritionistDashboardScreen.fondoClaro;

  final _cliente = Supabase.instance.client;

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

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: verdePrincipal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _cargarDatos() async {
    final usuario = _cliente.auth.currentUser;
    if (usuario == null) return;

    try {
      final hoy = DateTime.now().toIso8601String().substring(0, 10);
      final inicioMes = DateTime(DateTime.now().year, DateTime.now().month, 1)
          .toIso8601String()
          .substring(0, 10);

      final perfil = await _cliente
          .from('profiles')
          .select('nombre')
          .eq('id', usuario.id)
          .single();

      final pacientes =
          await _cliente.from('profiles').select('id').eq('rol', 'paciente');

      final citasHoyData = await _cliente
          .from('appointments')
          .select()
          .eq('nutricionista_id', usuario.id)
          .eq('fecha', hoy)
          .neq('estado', 'cancelada')
          .order('hora', ascending: true);

      final pendientes = await _cliente
          .from('appointments')
          .select('id')
          .eq('nutricionista_id', usuario.id)
          .eq('estado', 'pendiente');

      final consultasMes = await _cliente
          .from('consultations')
          .select('id')
          .eq('nutricionista_id', usuario.id)
          .gte('fecha', inicioMes);

      // Buscamos los nombres de los pacientes de las citas de hoy
      final idsPacientes = citasHoyData
          .map((c) => c['paciente_id'] as String)
          .toSet()
          .toList();

      Map<String, String> nombresPorId = {};
      if (idsPacientes.isNotEmpty) {
        final perfilesPacientes = await _cliente
            .from('profiles')
            .select('id, nombre')
            .inFilter('id', idsPacientes);
        for (final p in perfilesPacientes) {
          nombresPorId[p['id']] = p['nombre'] ?? 'Paciente';
        }
      }

      if (!mounted) return;

      setState(() {
        _nombre = perfil['nombre'] as String? ?? '';
        _pacientesActivos = pacientes.length;
        _citasHoy = citasHoyData.length;
        _porConfirmar = pendientes.length;
        _consultasDelMes = consultasMes.length;
        _citasDeHoy = citasHoyData.map((cita) {
          return {
            ...cita,
            'nombrePaciente':
                nombresPorId[cita['paciente_id']] ?? 'Paciente',
          };
        }).toList();
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

  String _formatearHora(String hora) {
    final partes = hora.split(':');
    var h = int.parse(partes[0]);
    final m = partes[1];
    final periodo = h >= 12 ? 'p. m.' : 'a. m.';
    h = h % 12;
    if (h == 0) h = 12;
    return '$h:$m $periodo';
  }

  String _iniciales(String nombre) {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes[1][0]).toUpperCase();
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
      return const Scaffold(
        backgroundColor: fondoClaro,
        body: Center(child: CircularProgressIndicator(color: verdePrincipal)),
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
                  actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: verdeOscuro,
            ),
          ),
          IconButton(
            tooltip: 'Notificaciones',
            onPressed: () {
              _mostrarMensaje(context, 'No tienes notificaciones nuevas.');
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
                _iniciales(_nombre),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          _mostrarMensaje(
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
                              hora: _formatearHora(_citasDeHoy[i]['hora']),
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
                            _mostrarMensaje(
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
            ),
          ),
        ),
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