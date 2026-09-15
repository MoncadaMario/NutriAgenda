import 'package:flutter/material.dart';

class ConsultationFormScreen extends StatefulWidget {
  const ConsultationFormScreen({super.key});

  @override
  State<ConsultationFormScreen> createState() =>
      _ConsultationFormScreenState();
}

class _ConsultationFormScreenState extends State<ConsultationFormScreen> {
  static const verde = Color(0xFF168B62);

  final _formKey = GlobalKey<FormState>();
  String genero = 'Masculino';

  void _guardarConsulta() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consulta preparada para guardarse en Supabase.'),
          backgroundColor: verde,
        ),
      );
    }
  }

  InputDecoration _campo(String texto, IconData icono) {
    return InputDecoration(
      labelText: texto,
      prefixIcon: Icon(icono, color: verde),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
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
          'Registrar consulta',
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
                      const Text(
                        'Datos de Juan Martínez',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D2D),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: _campo(
                          'Peso en kilogramos',
                          Icons.monitor_weight_outlined,
                        ),
                        validator: (valor) =>
                            valor!.isEmpty ? 'Ingresa el peso.' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: _campo(
                          'Estatura en metros',
                          Icons.height_rounded,
                        ),
                        validator: (valor) =>
                            valor!.isEmpty ? 'Ingresa la estatura.' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: genero,
                        decoration: _campo('Género', Icons.person_outline),
                        items: const [
                          DropdownMenuItem(
                            value: 'Masculino',
                            child: Text('Masculino'),
                          ),
                          DropdownMenuItem(
                            value: 'Femenino',
                            child: Text('Femenino'),
                          ),
                          DropdownMenuItem(
                            value: 'Otro',
                            child: Text('Otro'),
                          ),
                        ],
                        onChanged: (valor) {
                          setState(() {
                            genero = valor!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: _campo('Edad', Icons.cake_outlined),
                        validator: (valor) =>
                            valor!.isEmpty ? 'Ingresa la edad.' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: _campo('IMC', Icons.favorite_outline),
                        validator: (valor) =>
                            valor!.isEmpty ? 'Ingresa el IMC.' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: _campo(
                          'Porcentaje de grasa',
                          Icons.percent_rounded,
                        ),
                        validator: (valor) =>
                            valor!.isEmpty ? 'Ingresa el porcentaje.' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        maxLines: 4,
                        decoration: _campo(
                          'Observaciones',
                          Icons.notes_rounded,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _guardarConsulta,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Guardar consulta'),
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