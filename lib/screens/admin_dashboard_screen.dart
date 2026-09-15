import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const verde = Color(0xFF168B62);
  static const oscuro = Color(0xFF173D2D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'NutriAgenda Admin',
          style: TextStyle(color: oscuro, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: verde,
              child: Text(
                'AD',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Panel administrativo',
                  style: TextStyle(
                    color: oscuro,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _AdminStat('Usuarios registrados', '58', Icons.people),
                    _AdminStat('Pacientes', '42', Icons.person_outline),
                    _AdminStat(
                      'Nutricionistas',
                      '8',
                      Icons.medical_services_outlined,
                    ),
                    _AdminStat(
                      'Citas este mes',
                      '93',
                      Icons.calendar_today_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Acciones administrativas',
                  style: TextStyle(
                    color: oscuro,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.manage_accounts_outlined),
                      label: const Text('Gestionar usuarios'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: verde,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: const Text('Revisar citas'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.verified_user_outlined),
                      label: const Text('Solicitudes de nutricionistas'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminStat extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _AdminStat(this.titulo, this.valor, this.icono);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, color: const Color(0xFF168B62)),
              const SizedBox(height: 18),
              Text(titulo),
              const SizedBox(height: 6),
              Text(
                valor,
                style: const TextStyle(
                  color: Color(0xFF173D2D),
                  fontSize: 26,
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