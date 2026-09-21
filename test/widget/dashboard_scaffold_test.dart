import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/widgets/dashboard_scaffold.dart';

void main() {
  testWidgets('LoadingScaffold muestra el indicador de progreso',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoadingScaffold(
          background: Colors.white,
          indicatorColor: Colors.green,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('RefreshableContent muestra el contenido que recibe',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RefreshableContent(
            onRefresh: () async {},
            children: const [Text('Contenido de prueba')],
          ),
        ),
      ),
    );

    expect(find.text('Contenido de prueba'), findsOneWidget);
  });
}