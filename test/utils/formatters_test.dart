import 'package:flutter_test/flutter_test.dart';
import 'package:nutriagenda/utils/formatters.dart';

void main() {
  group('formatearFechaLarga', () {
    test('convierte una fecha de septiembre correctamente', () {
      expect(formatearFechaLarga('2026-09-16'), '16 de septiembre de 2026');
    });
    test('convierte una fecha de enero (mes 1) correctamente', () {
      expect(formatearFechaLarga('2026-01-05'), '5 de enero de 2026');
    });
    test('convierte una fecha de diciembre (mes 12) correctamente', () {
      expect(formatearFechaLarga('2026-12-25'), '25 de diciembre de 2026');
    });
  });

  group('formatearFechaCorta', () {
    test('agrega ceros a la izquierda en dia y mes', () {
      expect(formatearFechaCorta(DateTime(2026, 3, 5)), '05/03/2026');
    });
    test('no agrega ceros cuando no hacen falta', () {
      expect(formatearFechaCorta(DateTime(2026, 11, 20)), '20/11/2026');
    });
  });

  group('formatearHora12', () {
    test('convierte una hora de la manana', () {
      expect(formatearHora12('09:05:00'), '9:05 a. m.');
    });
    test('convierte una hora de la tarde', () {
      expect(formatearHora12('14:30:00'), '2:30 p. m.');
    });
    test('convierte el mediodia (12:00) como p. m.', () {
      expect(formatearHora12('12:00:00'), '12:00 p. m.');
    });
    test('convierte la medianoche (00:00) como 12 a. m.', () {
      expect(formatearHora12('00:00:00'), '12:00 a. m.');
    });
  });

  group('obtenerIniciales', () {
    test('devuelve 2 letras para nombre y apellido', () {
      expect(obtenerIniciales('Mario Moncada'), 'MM');
    });
    test('devuelve 1 letra para un solo nombre', () {
      expect(obtenerIniciales('Mario'), 'M');
    });
    test('ignora espacios extra entre palabras', () {
      expect(obtenerIniciales('Mario   Moncada'), 'MM');
    });
    test('devuelve vacio para texto vacio', () {
      expect(obtenerIniciales(''), '');
    });
  });
}