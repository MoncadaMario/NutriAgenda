import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PatientDetailRepository {
  Future<Map<String, dynamic>> obtenerPerfil(String pacienteId);
  Future<List<Map<String, dynamic>>> obtenerHistorial(String pacienteId);
}

class SupabasePatientDetailRepository implements PatientDetailRepository {
  final SupabaseClient _cliente;

  SupabasePatientDetailRepository([SupabaseClient? cliente])
      : _cliente = cliente ?? Supabase.instance.client;

  @override
  Future<Map<String, dynamic>> obtenerPerfil(String pacienteId) {
    return _cliente.from('profiles').select().eq('id', pacienteId).single();
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerHistorial(String pacienteId) {
    return _cliente
        .from('consultations')
        .select()
        .eq('paciente_id', pacienteId)
        .order('fecha', ascending: false);
  }
}