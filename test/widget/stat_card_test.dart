import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/widgets/stat_card.dart';

void main() {
  testWidgets('StatCard muestra el icono, el titulo y el valor',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatCard(
            icono: Icons.star,
            titulo: 'Ejemplo',
            valor: '42',
          ),
        ),
      ),
    );

    expect(find.text('Ejemplo'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}