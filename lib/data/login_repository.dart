import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LoginRepository {
  Future<String> iniciarSesion({
    required String correo,
    required String contrasena,
  });
  Future<String> obtenerRol(String usuarioId);
}

class SupabaseLoginRepository implements LoginRepository {
  final SupabaseClient _cliente;

  SupabaseLoginRepository([SupabaseClient? cliente])
      : _cliente = cliente ?? Supabase.instance.client;

  @override
  Future<String> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    final respuesta = await _cliente.auth.signInWithPassword(
      email: correo,
      password: contrasena,
    );

    final usuario = respuesta.user;
    if (usuario == null) {
      throw const AuthException('No se pudo iniciar sesión.');
    }

    return usuario.id;
  }

  @override
  Future<String> obtenerRol(String usuarioId) async {
    final perfil = await _cliente
        .from('profiles')
        .select()
        .eq('id', usuarioId)
        .single();
    return perfil['rol'] as String;
  }
}