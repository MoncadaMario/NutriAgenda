import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/menu_assignment_screen.dart';
import 'package:nutriagenda/data/menu_assignment_repository.dart';
import '../test_helpers.dart';

class RepositorioFalso implements MenuAssignmentRepository {
  bool seLlamo = false;
  String? contenidoRecibido;

  @override
  Future<void> asignarMenu({
    required String pacienteId,
    required String nutricionistaId,
    required String contenido,
  }) async {
    seLlamo = true;
    contenidoRecibido = contenido;
  }
}

void main() {
  testWidgets('MenuAssignmentScreen valida campos vacíos', (tester) async {
    usarVentanaDePruebaGrande(tester);

    await tester.pumpWidget(
      MaterialApp(
        home: MenuAssignmentScreen(
          pacienteId: 'paciente-1',
          nombrePaciente: 'Ana Pérez',
        ),
      ),
    );

    await tester.tap(find.text('Asignar menú'));
    await tester.pump();

    expect(find.text('Ingresa un nombre para el menú.'), findsOneWidget);
  });

  testWidgets('MenuAssignmentScreen guarda el menú correctamente',
      (tester) async {
    usarVentanaDePruebaGrande(tester);
    final repositorio = RepositorioFalso();

    await tester.pumpWidget(
      MaterialApp(
        home: MenuAssignmentScreen(
          pacienteId: 'paciente-1',
          nombrePaciente: 'Ana Pérez',
          repositorioParaPruebas: repositorio,
          usuarioIdParaPruebas: 'nutri-1',
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre del menú'),
      'Menú semanal',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Indicaciones o menú escrito'),
      'Desayuno: avena. Almuerzo: pollo.',
    );

    await tester.tap(find.text('Asignar menú'));
    await tester.pumpAndSettle();

    expect(repositorio.seLlamo, isTrue);
    expect(repositorio.contenidoRecibido, contains('Menú semanal'));
  });
}