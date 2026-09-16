import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/appointment_confirmation_screen.dart';

Map<String, dynamic> _citaDentroDe(Duration desdeAhora,
    {String estado = 'pendiente'}) {
  final momento = DateTime.now().add(desdeAhora);
  return {
    'id': 'cita-de-prueba',
    'tipo': 'Consulta de seguimiento',
    'fecha': '${momento.year.toString().padLeft(4, '0')}-'
        '${momento.month.toString().padLeft(2, '0')}-'
        '${momento.day.toString().padLeft(2, '0')}',
    'hora': '${momento.hour.toString().padLeft(2, '0')}:'
        '${momento.minute.toString().padLeft(2, '0')}:00',
    'estado': estado,
  };
}

void main() {
  testWidgets('Cita lejana solo muestra el boton de cancelar', (tester) async {
    final cita = _citaDentroDe(const Duration(days: 5));

    await tester.pumpWidget(MaterialApp(
      home: AppointmentConfirmationScreen(cita: cita),
    ));

    expect(find.text('Cancelar cita'), findsOneWidget);
    expect(find.text('Confirmar asistencia'), findsNothing);
    expect(
        find.textContaining('Podrás confirmar tu asistencia'), findsOneWidget);
  });

  testWidgets('Cita dentro de 24 horas muestra confirmar y cancelar',
      (tester) async {
    final cita = _citaDentroDe(const Duration(hours: 5));

    await tester.pumpWidget(MaterialApp(
      home: AppointmentConfirmationScreen(cita: cita),
    ));

    expect(find.text('Confirmar asistencia'), findsOneWidget);
    expect(find.text('Cancelar cita'), findsOneWidget);
  });

  testWidgets('Cita cancelada muestra el estado de cancelada', (tester) async {
    final cita = _citaDentroDe(const Duration(days: 5), estado: 'cancelada');

    await tester.pumpWidget(MaterialApp(
      home: AppointmentConfirmationScreen(cita: cita),
    ));

    expect(find.text('Cita cancelada'), findsOneWidget);
    expect(find.text('Volver'), findsOneWidget);
    expect(find.text('Cancelar cita'), findsNothing);
  });
}