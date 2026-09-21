import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/utils/session_cookie.dart';

void main() {
  test('marcarSesionActiva y limpiarSesionActiva no lanzan errores', () {
    expect(marcarSesionActiva, returnsNormally);
    expect(limpiarSesionActiva, returnsNormally);
  });
}