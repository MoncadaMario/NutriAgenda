import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ForgotPasswordRepository {
  Future<void> enviarEnlaceRecuperacion(String correo);
}

class SupabaseForgotPasswordRepository implements ForgotPasswordRepository {
  final SupabaseClient _cliente;

  SupabaseForgotPasswordRepository([SupabaseClient? cliente])
      : _cliente = cliente ?? Supabase.instance.client;

  @override
  Future<void> enviarEnlaceRecuperacion(String correo) {
    return _cliente.auth.resetPasswordForEmail(correo);
  }
}