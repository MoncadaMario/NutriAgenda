import 'package:flutter/material.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key});

  static const verde = Color(0xFF168B62);
  static const oscuro = Color(0xFF173D2D);

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                        const CircleAvatar(
                          radius: 34,
                          backgroundColor: Color(0xFFDDF8E8),
                          child: Text(
                            'JM',
                            style: TextStyle(
                              color: verde,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Juan Martínez',
                                style: TextStyle(
                                  color: oscuro,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text('juanm@email.com'),
                              Text('+502 5555-5555'),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Editar'),
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
                const Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _DataCard('Peso', '68.5 kg', Icons.monitor_weight_outlined),
                    _DataCard('Estatura', '1.68 m', Icons.height_rounded),
                    _DataCard('IMC', '24.3', Icons.favorite_outline_rounded),
                    _DataCard('% grasa', '27%', Icons.percent_rounded),
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
                      onPressed: () {},
                      icon: const Icon(Icons.assignment_outlined),
                      label: const Text('Registrar consulta'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_book_outlined),
                      label: const Text('Asignar menú'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
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
                      rows: const [
                        DataRow(cells: [
                          DataCell(Text('08/09/2026')),
                          DataCell(Text('68.5 kg')),
                          DataCell(Text('24.3')),
                          DataCell(Text('27%')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('11/08/2026')),
                          DataCell(Text('70.0 kg')),
                          DataCell(Text('24.8')),
                          DataCell(Text('28%')),
                        ]),
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