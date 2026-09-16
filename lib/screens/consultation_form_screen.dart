import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsultationFormScreen extends StatefulWidget {
  final String pacienteId;
  final String nombrePaciente;

  const ConsultationFormScreen({
    super.key,
    required this.pacienteId,
    required this.nombrePaciente,
  });

  @override
  State<ConsultationFormScreen> createState() =>
      _ConsultationFormScreenState();
}

class _ConsultationFormScreenState extends State<ConsultationFormScreen> {
  static const verde = Color(0xFF168B62);

  final _formKey = GlobalKey<FormState>();

  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();
  final _edadController = TextEditingController();
  final _imcController = TextEditingController();
  final _grasaController = TextEditingController();
  final _observacionesController = TextEditingController();

  String genero = 'Masculino';
  bool _guardando = false;

  @override
  void dispose() {
    _pesoController.dispose();
    _estaturaController.dispose();
    _edadController.dispose();
    _imcController.dispose();
    _grasaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _guardarConsulta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final usuario = _cliente.auth.currentUser;
    if (usuario == null) return;

    setState(() {
      _guardando = true;
    });

    try {
      await Supabase.instance.client.from('consultations').insert({
        'paciente_id': widget.pacienteId,
        'nutricionista_id': usuario.id,
        'peso': double.parse(_pesoController.text),
        'estatura': double.parse(_estaturaController.text),
        'genero': genero,
        'edad': int.parse(_edadController.text),
        'imc': double.parse(_imcController.text),
        'porcentaje_grasa': double.parse(_grasaController.text),
        'observaciones': _observacionesController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consulta guardada correctamente.'),
          backgroundColor: verde,
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar la consulta: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
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
                      Text(
                        'Datos de ${widget.nombrePaciente}',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173D2D),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _pesoController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: _campo(
                          'Peso en kilogramos',
                          Icons.monitor_weight_outlined,
                        ),
                        validator: (valor) =>
                            valor == null || valor.isEmpty
                                ? 'Ingresa el peso.'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _estaturaController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: _campo(
                          'Estatura en metros',
                          Icons.height_rounded,
                        ),
                        validator: (valor) =>
                            valor == null || valor.isEmpty
                                ? 'Ingresa la estatura.'
                                : null,
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
                        controller: _edadController,
                        keyboardType: TextInputType.number,
                        decoration: _campo('Edad', Icons.cake_outlined),
                        validator: (valor) =>
                            valor == null || valor.isEmpty
                                ? 'Ingresa la edad.'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imcController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: _campo('IMC', Icons.favorite_outline),
                        validator: (valor) =>
                            valor == null || valor.isEmpty
                                ? 'Ingresa el IMC.'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _grasaController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: _campo(
                          'Porcentaje de grasa',
                          Icons.percent_rounded,
                        ),
                        validator: (valor) =>
                            valor == null || valor.isEmpty
                                ? 'Ingresa el porcentaje.'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _observacionesController,
                        maxLines: 4,
                        decoration: _campo(
                          'Observaciones',
                          Icons.notes_rounded,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _guardando ? null : _guardarConsulta,
                        icon: _guardando
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          _guardando ? 'Guardando...' : 'Guardar consulta',
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