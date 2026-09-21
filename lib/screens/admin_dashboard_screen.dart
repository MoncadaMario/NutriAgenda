import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_management_screen.dart';
import '../utils/formatters.dart';
import '../widgets/logout_button.dart';
import '../widgets/stat_card.dart';
import '../widgets/dashboard_scaffold.dart';
import '../theme/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  static const verde = AppColors.verdePrincipal;
  static const oscuro = AppColors.verdeOscuro;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const verde = AdminDashboardScreen.verde;
  static const oscuro = AdminDashboardScreen.oscuro;

  final _cliente = Supabase.instance.client;
  bool _cargando = true;
  String _iniciales = 'AD';
  int _totalUsuarios = 0;
  int _totalPacientes = 0;
  int _totalNutricionistas = 0;
  int _citasDelMes = 0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: verde),
    );
  }

  Future<void> _cargarDatos() async {
    final usuario = _cliente.auth.currentUser;
    if (usuario == null) return;

    try {
      final inicioMes = DateTime(DateTime.now().year, DateTime.now().month, 1)
          .toIso8601String()
          .substring(0, 10);

      final miPerfil = await _cliente
          .from('profiles')
          .select('nombre')
          .eq('id', usuario.id)
          .single();

      final todos = await _cliente.from('profiles').select('id, rol');
      final citasMes = await _cliente
          .from('appointments')
          .select('id')
          .gte('fecha', inicioMes);

      if (!mounted) return;

      final nombre = miPerfil['nombre'] as String? ?? '';
      final inicialesCalculadas = obtenerIniciales(nombre);
      final iniciales =
          inicialesCalculadas.isEmpty ? 'AD' : inicialesCalculadas;

      setState(() {
        _iniciales = iniciales;
        _totalUsuarios = todos.length;
        _totalPacientes =
            todos.where((u) => u['rol'] == 'paciente').length;
        _totalNutricionistas =
            todos.where((u) => u['rol'] == 'nutricionista').length;
        _citasDelMes = citasMes.length;
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

  void _irAGestionUsuarios() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserManagementScreen()),
    ).then((_) => _cargarDatos());
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const LoadingScaffold(
        background: Color(0xFFF4FBF7),
        indicatorColor: verde,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'NutriAgenda Admin',
          style: TextStyle(color: oscuro, fontWeight: FontWeight.bold),
        ),
        actions: [
          LogoutButton(
            color: oscuro,
            onLogout: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: verde,
              child: Text(
                _iniciales,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: RefreshableContent(
        onRefresh: _cargarDatos,
        maxWidth: 1100,
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
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              StatCard(
                titulo: 'Usuarios registrados',
                valor: '$_totalUsuarios',
                icono: Icons.people,
                ancho: 220,
                valorFontSize: 26,
                conBorde: false,
              ),
              StatCard(
                titulo: 'Pacientes',
                valor: '$_totalPacientes',
                icono: Icons.person_outline,
                ancho: 220,
                valorFontSize: 26,
                conBorde: false,
              ),
              StatCard(
                titulo: 'Nutricionistas',
                valor: '$_totalNutricionistas',
                icono: Icons.medical_services_outlined,
                ancho: 220,
                valorFontSize: 26,
                conBorde: false,
              ),
              StatCard(
                titulo: 'Citas este mes',
                valor: '$_citasDelMes',
                icono: Icons.calendar_today_outlined,
                ancho: 220,
                valorFontSize: 26,
                conBorde: false,
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
                onPressed: _irAGestionUsuarios,
                icon: const Icon(Icons.manage_accounts_outlined),
                label: const Text('Gestionar usuarios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _mostrarMensaje(
                    'La vista de todas las citas se agregará después.',
                  );
                },
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('Revisar citas'),
              ),
              OutlinedButton.icon(
                onPressed: _irAGestionUsuarios,
                icon: const Icon(Icons.verified_user_outlined),
                label: const Text('Solicitudes de nutricionistas'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}