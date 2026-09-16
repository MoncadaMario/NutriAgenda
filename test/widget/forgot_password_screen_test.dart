import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/forgot_password_screen.dart';

void main() {
  testWidgets('ForgotPasswordScreen muestra el formulario inicial',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));

    expect(find.text('Recupera tu contraseña'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Enviar enlace de recuperación'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen valida correo vacio', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));

    await tester.tap(find.text('Enviar enlace de recuperación'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa tu correo electrónico.'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen valida formato de correo invalido',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));

    await tester.enterText(find.byType(TextFormField), 'correo-sin-arroba');
    await tester.tap(find.text('Enviar enlace de recuperación'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa un correo válido.'), findsOneWidget);
  });
}