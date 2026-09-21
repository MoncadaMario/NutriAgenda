import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/forgot_password_screen.dart';
import 'package:nutriagenda/data/forgot_password_repository.dart';

class RepositorioFalso implements ForgotPasswordRepository {
  bool seLlamo = false;

  @override
  Future<void> enviarEnlaceRecuperacion(String correo) async {
    seLlamo = true;
  }
}

void main() {
  testWidgets('ForgotPasswordScreen muestra el formulario inicial',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ForgotPasswordScreen()),
    );

    expect(find.text('Recupera tu contraseña'), findsOneWidget);
    expect(find.text('Enviar enlace de recuperación'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen avisa si el correo esta vacio',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ForgotPasswordScreen()),
    );

    await tester.tap(find.text('Enviar enlace de recuperación'));
    await tester.pump();

    expect(find.text('Ingresa tu correo electrónico.'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen envia el enlace y muestra confirmación',
      (tester) async {
    final repositorio = RepositorioFalso();

    await tester.pumpWidget(
      MaterialApp(
        home: ForgotPasswordScreen(repositorioParaPruebas: repositorio),
      ),
    );

    await tester.enterText(
      find.byType(TextFormField),
      'correo@prueba.com',
    );

    await tester.tap(find.text('Enviar enlace de recuperación'));
    await tester.pumpAndSettle();

    expect(repositorio.seLlamo, isTrue);
    expect(find.text('Revisa tu correo'), findsOneWidget);
  });
}