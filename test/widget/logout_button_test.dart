import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/widgets/logout_button.dart';

void main() {
  testWidgets('LogoutButton muestra el icono y responde al toque',
      (tester) async {
    var tocado = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: LogoutButton(
          onLogout: () {
            tocado = true;
          },
        ),
      ),
    ));

    expect(find.byIcon(Icons.logout_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pump();

    expect(tocado, isTrue);
  });
}