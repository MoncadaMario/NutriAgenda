import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen muestra los campos y el boton principal',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('¡Bienvenido!'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Registrarme como nuevo usuario'), findsOneWidget);
  });

  testWidgets('LoginScreen avisa si intenta entrar sin datos', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();

    expect(find.text('Ingresa tu correo y contraseña.'), findsOneWidget);
  });
}