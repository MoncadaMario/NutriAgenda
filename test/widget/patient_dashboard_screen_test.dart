import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/patient_dashboard_screen.dart';
import 'package:nutriagenda/data/patient_dashboard_repository.dart';

class RepositorioFalso implements PatientDashboardRepository {
  @override
  Future<Map<String, dynamic>> obtenerPerfil(String usuarioId) async {
    return {'nombre': 'Ana Pérez'};
  }

  @override
  Future<Map<String, dynamic>?> obtenerProximaCita(String usuarioId) async {
    return {
      'tipo': 'Consulta de seguimiento',
      'fecha': '2030-01-01',
      'hora': '10:00:00',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerHistorial(
      String usuarioId) async {
    return [
      {
        'peso': 68.5,
        'estatura': 1.65,
        'genero': 'Femenino',
        'edad': 29,
        'imc': 25.2,
        'porcentaje_grasa': 28.4,
        'fecha': '2029-12-01',
      },
    ];
  }

  @override
  Future<Map<String, dynamic>?> obtenerUltimoMenu(String usuarioId) async {
    return {
      'contenido': 'Menú de prueba',
      'fecha': '2029-12-01',
    };
  }
}

void main() {
  testWidgets('PatientDashboardScreen muestra los datos del paciente',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PatientDashboardScreen(
          repositorioParaPruebas: RepositorioFalso(),
          usuarioIdParaPruebas: 'paciente-1',
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Hola, Ana Pérez'), findsOneWidget);
    expect(find.text('68.5 kg'), findsWidgets);
    expect(find.text('25.2'), findsWidgets);
  });
}