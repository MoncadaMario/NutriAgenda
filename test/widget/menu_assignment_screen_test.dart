import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/menu_assignment_screen.dart';

void main() {
  testWidgets('MenuAssignmentScreen muestra el nombre del paciente',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MenuAssignmentScreen(
        pacienteId: 'id-de-prueba',
        nombrePaciente: 'Paciente de Prueba',
      ),
    ));

    expect(find.text('Menú para Paciente de Prueba'), findsOneWidget);
    expect(find.text('Asignar menú'), findsOneWidget);
  });

  testWidgets('MenuAssignmentScreen valida campos vacios', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MenuAssignmentScreen(
        pacienteId: 'id-de-prueba',
        nombrePaciente: 'Paciente de Prueba',
      ),
    ));

    await tester.tap(find.text('Asignar menú'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa un nombre para el menú.'), findsOneWidget);
    expect(find.text('Escribe las indicaciones del menú.'), findsOneWidget);
  });
}