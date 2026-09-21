import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/widgets/correo_enviado_view.dart';

void main() {
  testWidgets('CorreoEnviadoView muestra el correo y responde a los botones',
      (tester) async {
    var volvioAlLogin = false;
    var quisoOtroCorreo = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CorreoEnviadoView(
            correo: 'prueba@correo.com',
            onVolver: () => volvioAlLogin = true,
            onOtroCorreo: () => quisoOtroCorreo = true,
          ),
        ),
      ),
    );

    expect(find.textContaining('prueba@correo.com'), findsOneWidget);

    await tester.tap(find.text('Volver al inicio de sesión'));
    await tester.pump();
    expect(volvioAlLogin, isTrue);

    await tester.tap(find.text('Usar otro correo'));
    await tester.pump();
    expect(quisoOtroCorreo, isTrue);
  });
}