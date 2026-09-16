import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Agranda la ventana simulada de la prueba para que formularios largos
/// quepan completos y sus botones no queden fuera del area visible.
void usarVentanaDePruebaGrande(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}