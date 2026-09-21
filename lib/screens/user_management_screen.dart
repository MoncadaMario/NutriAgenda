import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  static const verde = AppColors.verdePrincipal;
  static const naranja = AppColors.naranja;

  final _cliente = Supabase.instance.client;
  bool _cargando = true;
  List<Map<String, dynamic>> _usuarios = [];
  String? _miId;

  @override
  void initState() {
    super.initState();
    _miId = _cliente.auth.currentUser?.id;
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    try {
      final usuarios = await _cliente
          .from('profiles')
          .select()
          .order('rol', ascending: true)
          .order('nombre', ascending: true);

      if (!mounted) return;

      setState(() {
        _usuarios = List<Map<String, dynamic>>.from(usuarios);
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar usuarios: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _capitalizar(String rol) {
    switch (rol) {
      case 'paciente':
        return 'Paciente';
      case 'nutricionista':
        return 'Nutricionista';
      case 'administrador':
        return 'Administrador';
      default:
        return rol;
    }
  }

  Future<void> _cambiarRol(String id, String nuevoRol, String nombre) async {
    try {
      await _cliente.from('profiles').update({'rol': nuevoRol}).eq('id', id);

      if (!mounted) return;

      setState(() {
        final index = _usuarios.indexWhere((u) => u['id'] == id);
        if (index != -1) {
          _usuarios[index]['rol'] = nuevoRol;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Rol actualizado a ${_capitalizar(nuevoRol)} para $nombre.'),
          backgroundColor: verde,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar el rol: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _activarCuenta(String id, String nombre) async {
    try {
      await _cliente.from('profiles').update({'estado': 'activo'}).eq('id', id);

      if (!mounted) return;

      setState(() {
        final index = _usuarios.indexWhere((u) => u['id'] == id);
        if (index != -1) {
          _usuarios[index]['estado'] = 'activo';
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cuenta de $nombre activada.'),
          backgroundColor: verde,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al activar la cuenta: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBF7),
        elevation: 0,
        title: const Text(
          'Gestión de usuarios',
          style: TextStyle(
            color: Color(0xFF173D2D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: verde))
          : RefreshIndicator(
              onRefresh: _cargarUsuarios,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                itemCount: _usuarios.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final usuario = _usuarios[index];
                  final nombre = usuario['nombre'] as String? ?? 'Sin nombre';
                  final esMiCuenta = usuario['id'] == _miId;
                  final pendiente = usuario['estado'] == 'pendiente_pago';

                  return Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFDDF8E8),
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
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nombre,
                                      style: const TextStyle(
                                        color: Color(0xFF173D2D),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('${usuario['correo'] ?? ''}'),
                                  ],
                                ),
                              ),
                              if (esMiCuenta)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FAF4),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Tú · ${_capitalizar(usuario['rol'])}',
                                    style: const TextStyle(
                                      color: verde,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              else
                                DropdownButton<String>(
                                  value: usuario['rol'],
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'paciente',
                                      child: Text('Paciente'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'nutricionista',
                                      child: Text('Nutricionista'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'administrador',
                                      child: Text('Administrador'),
                                    ),
                                  ],
                                  onChanged: (nuevoRol) {
                                    _cambiarRol(
                                        usuario['id'], nuevoRol!, nombre);
                                  },
                                ),
                            ],
                          ),
                          if (pendiente) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7E8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFF7D596),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.pending_outlined,
                                      color: naranja, size: 20),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Pago pendiente de aprobación.',
                                      style: TextStyle(
                                        color: Color(0xFF765116),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        _activarCuenta(usuario['id'], nombre),
                                    child: const Text('Activar'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}