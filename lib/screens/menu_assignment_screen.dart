import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuAssignmentScreen extends StatefulWidget {
  final String pacienteId;
  final String nombrePaciente;

  const MenuAssignmentScreen({
    super.key,
    required this.pacienteId,
    required this.nombrePaciente,
  });

  @override
  State<MenuAssignmentScreen> createState() => _MenuAssignmentScreenState();
}

class _MenuAssignmentScreenState extends State<MenuAssignmentScreen> {
  static const verde = Color(0xFF168B62);

  final _formKey = GlobalKey<FormState>();
  final _cliente = Supabase.instance.client;

  final _nombreMenuController = TextEditingController();
  final _indicacionesController = TextEditingController();

  bool _guardando = false;

  @override
  void dispose() {
    _nombreMenuController.dispose();
    _indicacionesController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.redAccent : verde,
      ),
    );
  }

  Future<void> _asignarMenu() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final usuario = _cliente.auth.currentUser;
    if (usuario == null) return;

    setState(() {
      _guardando = true;
    });

    try {
      final contenido =
          '${_nombreMenuController.text.trim()}\n\n${_indicacionesController.text.trim()}';

      await _cliente.from('menus').insert({
        'paciente_id': widget.pacienteId,
        'nutricionista_id': usuario.id,
        'contenido': contenido,
      });

      if (!mounted) return;

      _mostrarMensaje('Menú asignado a ${widget.nombrePaciente} correctamente.');
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      _mostrarMensaje('Error al asignar el menú: $error', esError: true);
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
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
          'Asignar menú nutricional',
          style: TextStyle(
            color: Color(0xFF173D2D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Menú para ${widget.nombrePaciente}',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D2D),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nombreMenuController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del menú',
                          prefixIcon:
                              Icon(Icons.menu_book_outlined, color: verde),
                        ),
                        validator: (valor) =>
                            valor == null || valor.trim().isEmpty
                                ? 'Ingresa un nombre para el menú.'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _indicacionesController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Indicaciones o menú escrito',
                          alignLabelWithHint: true,
                          prefixIcon:
                              Icon(Icons.restaurant_menu, color: verde),
                        ),
                        validator: (valor) =>
                            valor == null || valor.trim().isEmpty
                                ? 'Escribe las indicaciones del menú.'
                                : null,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FAF4),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: verde),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'La opción de adjuntar PDF estará disponible '
                                'próximamente con Supabase Storage. Por ahora '
                                'usa el menú escrito.',
                                style: TextStyle(
                                  color: Color(0xFF366452),
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _guardando ? null : _asignarMenu,
                        icon: _guardando
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Icon(Icons.send_outlined),
                        label: Text(
                          _guardando ? 'Asignando...' : 'Asignar menú',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verde,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}