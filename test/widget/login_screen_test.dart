import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/login_screen.dart';
import 'package:nutriagenda/data/login_repository.dart';

class RepositorioFalso implements LoginRepository {
  final String rolARetornar;

  RepositorioFalso({this.rolARetornar = 'paciente'});

  @override
  Future<String> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    return 'usuario-1';
  }

  @override
  Future<String> obtenerRol(String usuarioId) async {
    return rolARetornar;
  }
}

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

  testWidgets('LoginScreen inicia sesion y navega segun el rol',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          repositorioParaPruebas:
              RepositorioFalso(rolARetornar: 'nutricionista'),
        ),
        routes: {
          '/nutritionist-dashboard': (context) =>
              const Scaffold(body: Text('Panel del nutricionista')),
        },
      ),
    );

    await tester.enterText(
      find.byType(TextField).first,
      'correo@prueba.com',
    );
    await tester.enterText(
      find.byType(TextField).last,
      'contrasena123',
    );

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Panel del nutricionista'), findsOneWidget);
  });
}