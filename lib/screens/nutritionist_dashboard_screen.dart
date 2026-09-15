import 'package:flutter/material.dart';

class NutritionistDashboardScreen extends StatelessWidget {
  const NutritionistDashboardScreen({super.key});

  static const Color verdePrincipal = Color(0xFF168B62);
  static const Color verdeOscuro = Color(0xFF173D2D);
  static const Color fondoClaro = Color(0xFFF4FBF7);

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: verdePrincipal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: verdePrincipal,
              child: Text(
                'AL',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buenos días, Dra. Ana',
                  style: TextStyle(
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
                const Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _SummaryCard(
                      icono: Icons.people_outline_rounded,
                      titulo: 'Pacientes activos',
                      valor: '24',
                      colorIcono: verdePrincipal,
                    ),
                    _SummaryCard(
                      icono: Icons.calendar_today_outlined,
                      titulo: 'Citas para hoy',
                      valor: '5',
                      colorIcono: Color(0xFF2E7CC2),
                    ),
                    _SummaryCard(
                      icono: Icons.pending_actions_outlined,
                      titulo: 'Por confirmar',
                      valor: '3',
                      colorIcono: Color(0xFFE59819),
                    ),
                    _SummaryCard(
                      icono: Icons.check_circle_outline_rounded,
                      titulo: 'Consultas del mes',
                      valor: '42',
                      colorIcono: Color(0xFF8A57C8),
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
                      subtitulo: 'Crear una cita para un paciente',
                      onTap: () {
                        Navigator.pushNamed(context, '/schedule-appointment');
                      },
                    ),
                    _ActionCard(
                      icono: Icons.person_search_outlined,
                      titulo: 'Ver pacientes',
                      subtitulo: 'Buscar y consultar pacientes',
                      onTap: () {
                        Navigator.pushNamed(context, '/patients');
                      },
                    ),
                    _ActionCard(
                      icono: Icons.assignment_outlined,
                      titulo: 'Nueva consulta',
                      subtitulo: 'Registrar datos nutricionales',
                      onTap: () {
                        Navigator.pushNamed(context, '/consultation-form');
                      },
                    ),
                    _ActionCard(
                      icono: Icons.menu_book_outlined,
                      titulo: 'Asignar menú',
                      subtitulo: 'Crear o subir un menú nutricional',
                      onTap: () {
                        Navigator.pushNamed(context, '/menu-assignment');
                      },
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
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFE0EEE6)),
                  ),
                  child: const Column(
                    children: [
                      _AppointmentTile(
                        hora: '09:00 a. m.',
                        nombre: 'Juan Martínez',
                        tipo: 'Consulta de seguimiento',
                        estado: 'Confirmada',
                        colorEstado: verdePrincipal,
                      ),
                      Divider(height: 1),
                      _AppointmentTile(
                        hora: '10:30 a. m.',
                        nombre: 'María López',
                        tipo: 'Primera consulta',
                        estado: 'Pendiente',
                        colorEstado: Color(0xFFE59819),
                      ),
                      Divider(height: 1),
                      _AppointmentTile(
                        hora: '02:00 p. m.',
                        nombre: 'Carlos Hernández',
                        tipo: 'Consulta de seguimiento',
                        estado: 'Confirmada',
                        colorEstado: verdePrincipal,
                      ),
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
                      const Expanded(
                        child: Text(
                          'Tienes 3 citas que requieren confirmación '
                          'por parte de los pacientes.',
                          style: TextStyle(
                            color: Color(0xFF765116),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _mostrarMensaje(
                            context,
                            'Aquí se mostrarán las solicitudes pendientes.',
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