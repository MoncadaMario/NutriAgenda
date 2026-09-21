import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MenuAssignmentRepository {
  Future<void> asignarMenu({
    required String pacienteId,
    required String nutricionistaId,
    required String contenido,
  });
}

class SupabaseMenuAssignmentRepository implements MenuAssignmentRepository {
  final SupabaseClient _cliente;

  SupabaseMenuAssignmentRepository([SupabaseClient? cliente])
      : _cliente = cliente ?? Supabase.instance.client;

  @override
  Future<void> asignarMenu({
    required String pacienteId,
    required String nutricionistaId,
    required String contenido,
  }) {
    return _cliente.from('menus').insert({
      'paciente_id': pacienteId,
      'nutricionista_id': nutricionistaId,
      'contenido': contenido,
    });
  }
}