import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NutritionistDashboardRepository {
  Future<Map<String, dynamic>> obtenerPerfil(String usuarioId);
  Future<int> contarPacientes();
  Future<List<Map<String, dynamic>>> obtenerCitasDeHoy(String usuarioId);
  Future<int> contarCitasPendientes(String usuarioId);
  Future<int> contarConsultasDelMes(String usuarioId);
}

class SupabaseNutritionistDashboardRepository
    implements NutritionistDashboardRepository {
  final SupabaseClient _cliente;

  SupabaseNutritionistDashboardRepository([SupabaseClient? cliente])
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
  Future<int> contarPacientes() async {
    final pacientes =
        await _cliente.from('profiles').select('id').eq('rol', 'paciente');
    return pacientes.length;
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerCitasDeHoy(
      String usuarioId) async {
    final hoy = DateTime.now().toIso8601String().substring(0, 10);

    final citasHoyData = await _cliente
        .from('appointments')
        .select()
        .eq('nutricionista_id', usuarioId)
        .eq('fecha', hoy)
        .neq('estado', 'cancelada')
        .order('hora', ascending: true);

    final idsPacientes = citasHoyData
        .map((c) => c['paciente_id'] as String)
        .toSet()
        .toList();

    Map<String, String> nombresPorId = {};
    if (idsPacientes.isNotEmpty) {
      final perfilesPacientes = await _cliente
          .from('profiles')
          .select('id, nombre')
          .inFilter('id', idsPacientes);
      for (final p in perfilesPacientes) {
        nombresPorId[p['id']] = p['nombre'] ?? 'Paciente';
      }
    }

    return citasHoyData.map((cita) {
      return {
        ...cita,
        'nombrePaciente': nombresPorId[cita['paciente_id']] ?? 'Paciente',
      };
    }).toList();
  }

  @override
  Future<int> contarCitasPendientes(String usuarioId) async {
    final pendientes = await _cliente
        .from('appointments')
        .select('id')
        .eq('nutricionista_id', usuarioId)
        .eq('estado', 'pendiente');
    return pendientes.length;
  }

  @override
  Future<int> contarConsultasDelMes(String usuarioId) async {
    final inicioMes = DateTime(DateTime.now().year, DateTime.now().month, 1)
        .toIso8601String()
        .substring(0, 10);
    final consultasMes = await _cliente
        .from('consultations')
        .select('id')
        .eq('nutricionista_id', usuarioId)
        .gte('fecha', inicioMes);
    return consultasMes.length;
  }
}