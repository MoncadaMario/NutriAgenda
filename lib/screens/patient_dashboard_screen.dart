import 'package:flutter/material.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  static const Color verdePrincipal = Color(0xFF168B62);
  static const Color verdeOscuro = Color(0xFF123F2E);
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
                'JM',
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
                  'Hola, Juan',
                  style: TextStyle(
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

                // Próxima cita
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: verdePrincipal,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 20,
                    children: [
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFBFEFD8),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: verdePrincipal,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tu próxima cita',
                                style: TextStyle(
                                  color: Color(0xFFDDF8E8),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '22 de septiembre · 10:00 a. m.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Consulta de seguimiento',
                                style: TextStyle(
                                  color: Color(0xFFDDF8E8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          _mostrarMensaje(
                            context,
                            'Aquí se mostrará el calendario para agendar una cita.',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: verdePrincipal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: const Text('Agendar nueva cita'),
                      ),
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

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    _MetricCard(
                      icono: Icons.monitor_weight_outlined,
                      titulo: 'Peso',
                      valor: '68.5 kg',
                    ),
                    _MetricCard(
                      icono: Icons.height_rounded,
                      titulo: 'Estatura',
                      valor: '1.68 m',
                    ),
                    _MetricCard(
                      icono: Icons.favorite_outline_rounded,
                      titulo: 'IMC',
                      valor: '24.3',
                    ),
                    _MetricCard(
                      icono: Icons.percent_rounded,
                      titulo: '% de grasa',
                      valor: '27%',
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
                      rows: const [
                        DataRow(
                          cells: [
                            DataCell(Text('08 sep. 2026')),
                            DataCell(Text('68.5 kg')),
                            DataCell(Text('1.68 m')),
                            DataCell(Text('Masculino')),
                            DataCell(Text('22 años')),
                            DataCell(Text('24.3')),
                            DataCell(Text('27%')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('11 ago. 2026')),
                            DataCell(Text('70.0 kg')),
                            DataCell(Text('1.68 m')),
                            DataCell(Text('Masculino')),
                            DataCell(Text('22 años')),
                            DataCell(Text('24.8')),
                            DataCell(Text('28%')),
                          ],
                        ),
                      ],
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
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Menú nutricional semanal',
                              style: TextStyle(
                                color: verdeOscuro,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Asignado el 8 de septiembre de 2026',
                              style: TextStyle(color: Color(0xFF62766D)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Vigente hasta el 22 de septiembre de 2026',
                              style: TextStyle(color: Color(0xFF62766D)),
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            _mostrarMensaje(
                              context,
                              'Aquí se abrirá o descargará el PDF del menú.',
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
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;

  const _MetricCard({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
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
              Icon(icono, color: PatientDashboardScreen.verdePrincipal),
              const SizedBox(height: 18),
              Text(
                titulo,
                style: const TextStyle(color: Color(0xFF62766D)),
              ),
              const SizedBox(height: 6),
              Text(
                valor,
                style: const TextStyle(
                  color: PatientDashboardScreen.verdeOscuro,
                  fontSize: 22,
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