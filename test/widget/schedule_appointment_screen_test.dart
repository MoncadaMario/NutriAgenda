import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/schedule_appointment_screen.dart';

void main() {
  testWidgets('ScheduleAppointmentScreen muestra el nombre del paciente',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ScheduleAppointmentScreen(
        pacienteId: 'id-de-prueba',
        nombrePaciente: 'Paciente de Prueba',
      ),
    ));

    expect(find.textContaining('Paciente de Prueba'), findsWidgets);
    expect(find.widgetWithText(ElevatedButton, 'Agendar cita'), findsOneWidget);
  });

  testWidgets('ScheduleAppointmentScreen avisa si falta fecha y hora',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ScheduleAppointmentScreen(
        pacienteId: 'id-de-prueba',
        nombrePaciente: 'Paciente de Prueba',
      ),
    ));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Agendar cita'));
    await tester.pump();

    expect(find.text('Selecciona la fecha y la hora de la cita.'),
        findsOneWidget);
  });
}