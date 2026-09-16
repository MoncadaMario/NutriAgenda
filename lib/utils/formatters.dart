const List<String> mesesEnEspanol = [
  '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

/// Convierte una fecha ISO a texto largo en español. Ej: "16 de septiembre de 2026".
String formatearFechaLarga(String fechaIso) {
  final fecha = DateTime.parse(fechaIso);
  return '${fecha.day} de ${mesesEnEspanol[fecha.month]} de ${fecha.year}';
}

/// Convierte una fecha a formato corto dd/MM/yyyy.
String formatearFechaCorta(DateTime fecha) {
  return '${fecha.day.toString().padLeft(2, '0')}/'
      '${fecha.month.toString().padLeft(2, '0')}/'
      '${fecha.year}';
}

/// Convierte una hora "HH:mm:ss" a formato de 12 horas en español.
String formatearHora12(String hora) {
  final partes = hora.split(':');
  var h = int.parse(partes[0]);
  final m = partes[1];
  final periodo = h >= 12 ? 'p. m.' : 'a. m.';
  h = h % 12;
  if (h == 0) h = 12;
  return '$h:$m $periodo';
}

/// Obtiene las iniciales (1 o 2 letras) de un nombre completo.
String obtenerIniciales(String nombre) {
  final partes = nombre.trim().split(RegExp(r'\s+'));
  if (partes.isEmpty || partes.first.isEmpty) return '';
  if (partes.length == 1) return partes.first[0].toUpperCase();
  return (partes.first[0] + partes[1][0]).toUpperCase();
}