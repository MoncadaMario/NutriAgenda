import 'package:web/web.dart' as web;

const String _cookieBase = 'na_session=1; path=/; max-age=';

void marcarSesionActiva() {
  web.document.cookie = '${_cookieBase}2592000';
}

void limpiarSesionActiva() {
  web.document.cookie = '${_cookieBase}0';
}