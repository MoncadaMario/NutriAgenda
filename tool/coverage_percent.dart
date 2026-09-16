import 'dart:io';

void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    print('No se encontro coverage/lcov.info. Corre "flutter test --coverage" primero.');
    return;
  }

  int lineasEncontradas = 0;
  int lineasCubiertas = 0;

  for (final linea in file.readAsLinesSync()) {
    if (linea.startsWith('LF:')) {
      lineasEncontradas += int.parse(linea.substring(3));
    } else if (linea.startsWith('LH:')) {
      lineasCubiertas += int.parse(linea.substring(3));
    }
  }

  final porcentaje = (lineasCubiertas / lineasEncontradas) * 100;
  print('Lineas cubiertas: $lineasCubiertas de $lineasEncontradas');
  print('Cobertura total: ${porcentaje.toStringAsFixed(1)}%');
}