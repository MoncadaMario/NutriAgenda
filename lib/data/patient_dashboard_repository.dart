import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PatientDashboardRepository {
  Future<Map<String, dynamic>> obtenerPerfil(String usuarioId);
  Future<Map<String, dynamic>?> obtenerProximaCita(String usuarioId);
  Future<List<Map<String, dynamic>>> obtenerHistorial(String usuarioId);
  Future<Map<String, dynamic>?> obtenerUltimoMenu(String usuarioId);
}

class SupabasePatientDashboardRepository
    implements PatientDashboardRepository {
  final SupabaseClient _cliente;

  SupabasePatientDashboardRepository([SupabaseClient? cliente])
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
  Future<Map<String, dynamic>?> obtenerProximaCita(String usuarioId) async {
    final hoy = DateTime.now().toIso8601String().substring(0, 10);
    final citas = await _cliente
        .from('appointments')
        .select()
        .eq('paciente_id', usuarioId)
        .gte('fecha', hoy)
        .neq('estado', 'cancelada')
        .order('fecha', ascending: true)
        .order('hora', ascending: true)
        .limit(1);
    return citas.isNotEmpty ? citas.first : null;
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerHistorial(String usuarioId) {
    return _cliente
        .from('consultations')
        .select()
        .eq('paciente_id', usuarioId)
        .order('fecha', ascending: false);
  }

  @override
  Future<Map<String, dynamic>?> obtenerUltimoMenu(String usuarioId) async {
    final menus = await _cliente
        .from('menus')
        .select()
        .eq('paciente_id', usuarioId)
        .order('fecha', ascending: false)
        .limit(1);
    return menus.isNotEmpty ? menus.first : null;
  }
}