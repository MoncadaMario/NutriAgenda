import 'package:flutter/material.dart';

class MenuAssignmentScreen extends StatefulWidget {
  const MenuAssignmentScreen({super.key});

  @override
  State<MenuAssignmentScreen> createState() => _MenuAssignmentScreenState();
}

class _MenuAssignmentScreenState extends State<MenuAssignmentScreen> {
  static const verde = Color(0xFF168B62);

  String paciente = 'Juan Martínez';
  bool adjuntarPdf = false;

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: verde,
      ),
    );
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: paciente,
                      decoration: const InputDecoration(
                        labelText: 'Paciente',
                        prefixIcon: Icon(Icons.person_outline, color: verde),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Juan Martínez',
                          child: Text('Juan Martínez'),
                        ),
                        DropdownMenuItem(
                          value: 'María López',
                          child: Text('María López'),
                        ),
                        DropdownMenuItem(
                          value: 'Carlos Hernández',
                          child: Text('Carlos Hernández'),
                        ),
                      ],
                      onChanged: (valor) {
                        setState(() {
                          paciente = valor!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nombre del menú',
                        prefixIcon: Icon(Icons.menu_book_outlined, color: verde),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: 'Indicaciones o menú escrito',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.restaurant_menu, color: verde),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      value: adjuntarPdf,
                      activeColor: verde,
                      title: const Text('Adjuntar menú en PDF'),
                      subtitle: const Text(
                        'Más adelante se subirá a Supabase Storage.',
                      ),
                      onChanged: (valor) {
                        setState(() {
                          adjuntarPdf = valor;
                        });
                      },
                    ),
                    if (adjuntarPdf)
                      OutlinedButton.icon(
                        onPressed: () {
                          _mostrarMensaje(
                            'Aquí se abrirá el selector de archivos PDF.',
                          );
                        },
                        icon: const Icon(Icons.upload_file_outlined),
                        label: const Text('Seleccionar archivo PDF'),
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _mostrarMensaje(
                          'Menú preparado para asignar a $paciente.',
                        );
                      },
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Asignar menú'),
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
    );
  }
}