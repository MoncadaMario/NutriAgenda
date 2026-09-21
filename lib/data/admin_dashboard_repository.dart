import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AdminDashboardRepository {
  Future<Map<String, dynamic>> obtenerPerfil(String usuarioId);
  Future<List<Map<String, dynamic>>> obtenerTodosLosUsuarios();
  Future<int> contarCitasDelMes();
}

class SupabaseAdminDashboardRepository implements AdminDashboardRepository {
  final SupabaseClient _cliente;

  SupabaseAdminDashboardRepository([SupabaseClient? cliente])
      : _cliente = cliente ?? Supabase.instance.client;

  @override
  Future<Map<String, dynamic>> obtenerPerfil(String usuarioId) {
    return _cliente
        .from('profiles')
        .select('nombre')
        .eq('id', usuarioId)
        .single();
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerTodosLosUsuarios() {
    return _cliente.from('profiles').select('id, rol');
  }

  @override
  Future<int> contarCitasDelMes() async {
    final inicioMes = DateTime(DateTime.now().year, DateTime.now().month, 1)
        .toIso8601String()
        .substring(0, 10);
    final citasMes = await _cliente
        .from('appointments')
        .select('id')
        .gte('fecha', inicioMes);
    return citasMes.length;
  }
}