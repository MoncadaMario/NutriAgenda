import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/patient_detail_screen.dart';
import 'package:nutriagenda/data/patient_detail_repository.dart';

class RepositorioFalso implements PatientDetailRepository {
  @override
  Future<Map<String, dynamic>> obtenerPerfil(String pacienteId) async {
    return {
      'nombre': 'Carlos Ruiz',
      'correo': 'carlos@correo.com',
      'telefono': '9999-9999',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerHistorial(
      String pacienteId) async {
    return [
      {
        'peso': 80.0,
        'imc': 27.1,
        'porcentaje_grasa': 22.0,
        'fecha': '2029-11-01',
      },
    ];
  }
}

void main() {
  testWidgets('PatientDetailScreen muestra el perfil del paciente',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PatientDetailScreen(
          pacienteId: 'paciente-1',
          repositorioParaPruebas: RepositorioFalso(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Carlos Ruiz'), findsOneWidget);
    expect(find.text('80.0 kg'), findsWidgets);
    expect(find.text('27.1'), findsWidgets);
  });
}