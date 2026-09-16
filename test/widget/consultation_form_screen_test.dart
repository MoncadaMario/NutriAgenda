import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/consultation_form_screen.dart';
import '../test_helpers.dart';

void main() {
  testWidgets('ConsultationFormScreen muestra el nombre del paciente',
      (tester) async {
    usarVentanaDePruebaGrande(tester);
    await tester.pumpWidget(const MaterialApp(
      home: ConsultationFormScreen(
        pacienteId: 'id-de-prueba',
        nombrePaciente: 'Paciente de Prueba',
      ),
    ));

    expect(find.text('Datos de Paciente de Prueba'), findsOneWidget);
    expect(find.text('Guardar consulta'), findsOneWidget);
  });

  testWidgets('ConsultationFormScreen valida campos vacios al guardar',
      (tester) async {
    usarVentanaDePruebaGrande(tester);
    await tester.pumpWidget(const MaterialApp(
      home: ConsultationFormScreen(
        pacienteId: 'id-de-prueba',
        nombrePaciente: 'Paciente de Prueba',
      ),
    ));

    await tester.tap(find.text('Guardar consulta'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa el peso.'), findsOneWidget);
    expect(find.text('Ingresa la estatura.'), findsOneWidget);
    expect(find.text('Ingresa la edad.'), findsOneWidget);
  });
}