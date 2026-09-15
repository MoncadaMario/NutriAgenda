import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  static const verde = Color(0xFF168B62);

  final usuarios = [
    _User('Juan Martínez', 'juanm@email.com', 'Paciente'),
    _User('María López', 'maria@email.com', 'Paciente'),
    _User('Ana López', 'ana@nutriagenda.com', 'Nutricionista'),
    _User('Mario Moncada', 'admin@nutriagenda.com', 'Administrador'),
  ];

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
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: usuarios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final usuario = usuarios[index];

          return Card(
            elevation: 0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFDDF8E8),
                child: Text(
                  usuario.nombre.substring(0, 1),
                  style: const TextStyle(
                    color: verde,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                usuario.nombre,
                style: const TextStyle(
                  color: Color(0xFF173D2D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(usuario.correo),
              trailing: DropdownButton<String>(
                value: usuario.rol,
                items: const [
                  DropdownMenuItem(
                    value: 'Paciente',
                    child: Text('Paciente'),
                  ),
                  DropdownMenuItem(
                    value: 'Nutricionista',
                    child: Text('Nutricionista'),
                  ),
                  DropdownMenuItem(
                    value: 'Administrador',
                    child: Text('Administrador'),
                  ),
                ],
                onChanged: (nuevoRol) {
                  setState(() {
                    usuario.rol = nuevoRol!;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Rol actualizado a $nuevoRol para ${usuario.nombre}.',
                      ),
                      backgroundColor: verde,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _User {
  final String nombre;
  final String correo;
  String rol;

  _User(this.nombre, this.correo, this.rol);
}