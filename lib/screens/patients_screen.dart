import 'package:flutter/material.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  static const verde = Color(0xFF168B62);
  static const oscuro = Color(0xFF173D2D);

  final pacientes = [
    _Patient('Juan Martínez', 'juanm@email.com', 'Seguimiento: 22 sep.'),
    _Patient('María López', 'maria@email.com', 'Primera cita: 23 sep.'),
    _Patient('Carlos Hernández', 'carlos@email.com', 'Sin próxima cita'),
    _Patient('Sofía Ramírez', 'sofia@email.com', 'Seguimiento: 25 sep.'),
  ];

  String busqueda = '';

  @override
  Widget build(BuildContext context) {
    final resultados = pacientes.where((paciente) {
      return paciente.nombre.toLowerCase().contains(busqueda.toLowerCase());
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
      body: Padding(
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
              child: ListView.separated(
                itemCount: resultados.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final paciente = resultados[index];

                  return Card(
                    elevation: 0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFDDF8E8),
                        child: Text(
                          paciente.nombre.substring(0, 1),
                          style: const TextStyle(
                            color: verde,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        paciente.nombre,
                        style: const TextStyle(
                          color: oscuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${paciente.correo}\n${paciente.cita}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: verde,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Aquí se abrirá el perfil de ${paciente.nombre}.',
                            ),
                            backgroundColor: verde,
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
    );
  }
}

class _Patient {
  final String nombre;
  final String correo;
  final String cita;

  const _Patient(this.nombre, this.correo, this.cita);
}