import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/register_screen.dart';

void main() {
  testWidgets('RegisterScreen muestra el formulario completo', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    expect(find.text('Crea tu cuenta'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.text('¿Eres nutricionista?'), findsOneWidget);
  });

  testWidgets('RegisterScreen muestra errores con campos vacios',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa tu nombre completo.'), findsOneWidget);
    expect(find.text('Ingresa tu correo electrónico.'), findsOneWidget);
    expect(find.text('Ingresa tu número de teléfono.'), findsOneWidget);
  });

  testWidgets('RegisterScreen muestra aviso al marcar nutricionista',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    await tester.tap(find.text('¿Eres nutricionista?'));
    await tester.pumpAndSettle();

    expect(find.textContaining('quedará pendiente de pago'), findsOneWidget);
  });
}