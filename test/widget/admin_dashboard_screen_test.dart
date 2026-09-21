import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/screens/admin_dashboard_screen.dart';
import 'package:nutriagenda/data/admin_dashboard_repository.dart';

class RepositorioFalso implements AdminDashboardRepository {
  @override
  Future<Map<String, dynamic>> obtenerPerfil(String usuarioId) async {
    return {'nombre': 'Admin Principal'};
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerTodosLosUsuarios() async {
    return [
      {'id': '1', 'rol': 'paciente'},
      {'id': '2', 'rol': 'paciente'},
      {'id': '3', 'rol': 'nutricionista'},
    ];
  }

  @override
  Future<int> contarCitasDelMes() async {
    return 15;
  }
}

void main() {
  testWidgets('AdminDashboardScreen muestra los conteos del panel',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AdminDashboardScreen(
          repositorioParaPruebas: RepositorioFalso(),
          usuarioIdParaPruebas: 'admin-1',
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Panel administrativo'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
  });
}