// ignore_for_file: deprecated_member_use
import 'dart:html' as html;

void marcarSesionActiva() {
  html.document.cookie = 'na_session=1; path=/; max-age=2592000';
}

void limpiarSesionActiva() {
  html.document.cookie = 'na_session=1; path=/; max-age=0';
}