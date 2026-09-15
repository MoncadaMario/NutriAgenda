import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'patient_detail_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  static const verde = Color(0xFF168B62);
  static const oscuro = Color(0xFF173D2D);

  final _cliente = Supabase.instance.client;
  bool _cargando = true;
  List<Map<String, dynamic>> _pacientes = [];
  String busqueda = '';

  @override
  void initState() {
    super.initState();
    _cargarPacientes();
  }

  Future<void> _cargarPacientes() async {
    final usuario = _cliente.auth.currentUser;
    if (usuario == null) return;

    try {
      final perfiles = await _cliente
          .from('profiles')
          .select('id, nombre, correo')
          .eq('rol', 'paciente')
          .order('nombre', ascending: true);

      final citas = await _cliente
          .from('appointments')
          .select('paciente_id, fecha, hora, tipo')
          .eq('nutricionista_id', usuario.id)
          .neq('estado', 'cancelada')
          .order('fecha', ascending: true)
          .order('hora', ascending: true);

      final proximaCitaPorPaciente = <String, Map<String, dynamic>>{};
      for (final cita in citas) {
        final id = cita['paciente_id'] as String;
        if (!proximaCitaPorPaciente.containsKey(id)) {
          proximaCitaPorPaciente[id] = cita;
        }
      }

      if (!mounted) return;

      setState(() {
        _pacientes = List<Map<String, dynamic>>.from(perfiles).map((p) {
          final cita = proximaCitaPorPaciente[p['id']];
          String textoCita = 'Sin próxima cita';
          if (cita != null) {
            final fecha = DateTime.parse(cita['fecha']);
            textoCita =
                '${cita['tipo']}: ${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}';
          }
          return {
            'id': p['id'],
            'nombre': p['nombre'] ?? 'Sin nombre',
            'correo': p['correo'] ?? '',
            'cita': textoCita,
          };
        }).toList();
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar pacientes: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _pacientes.where((paciente) {
      return (paciente['nombre'] as String)
          .toLowerCase()
          .contains(busqueda.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBF7),
        elevation: 0,
        title: const Text(
          'Mis pacientes',
          style: TextStyle(color: oscuro, fontWeight: FontWeight.bold),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: verde))
          : RefreshIndicator(
              onRefresh: _cargarPacientes,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (valor) {
                        setState(() {
                          busqueda = valor;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar paciente por nombre',
                        prefixIcon: const Icon(Icons.search, color: verde),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: resultados.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 60),
                                Center(
                                  child: Text(
                                    'No hay pacientes registrados todavía.',
                                    style: TextStyle(color: Color(0xFF62766D)),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              itemCount: resultados.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final paciente = resultados[index];
                                final nombre = paciente['nombre'] as String;

                                return Card(
                                  elevation: 0,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          const Color(0xFFDDF8E8),
                                      child: Text(
                                        nombre.isNotEmpty
                                            ? nombre.substring(0, 1)
                                            : '?',
                                        style: const TextStyle(
                                          color: verde,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      nombre,
                                      style: const TextStyle(
                                        color: oscuro,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${paciente['correo']}\n${paciente['cita']}',
                                    ),
                                    isThreeLine: true,
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: verde,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PatientDetailScreen(
                                            pacienteId: paciente['id'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}