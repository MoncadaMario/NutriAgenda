import 'session_cookie_stub.dart'
    if (dart.library.html) 'session_cookie_web.dart' as impl;

void marcarSesionActiva() => impl.marcarSesionActiva();
void limpiarSesionActiva() => impl.limpiarSesionActiva();