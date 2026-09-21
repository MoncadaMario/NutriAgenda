import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/nutritionist_dashboard_screen.dart';
import 'package:nutriagenda/data/nutritionist_dashboard_repository.dart';

class RepositorioFalso implements NutritionistDashboardRepository {
  @override
  Future<Map<String, dynamic>> obtenerPerfil(String usuarioId) async {
    return {'nombre': 'Dra. Gómez'};
  }

  @override
  Future<int> contarPacientes() async {
    return 12;
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerCitasDeHoy(
      String usuarioId) async {
    return [
      {
        'hora': '10:00:00',
        'tipo': 'Consulta de seguimiento',
        'estado': 'pendiente',
        'nombrePaciente': 'Ana Pérez',
      },
    ];
  }

  @override
  Future<int> contarCitasPendientes(String usuarioId) async {
    return 3;
  }

  @override
  Future<int> contarConsultasDelMes(String usuarioId) async {
    return 8;
  }
}

void main() {
  testWidgets('NutritionistDashboardScreen muestra el resumen del panel',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NutritionistDashboardScreen(
          repositorioParaPruebas: RepositorioFalso(),
          usuarioIdParaPruebas: 'nutri-1',
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Hola, Dra. Gómez'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Ana Pérez'), findsOneWidget);
  });
}