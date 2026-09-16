# ADR-001: Backend como servicio en vez de servidor propio

## Contexto

NutriAgenda necesita autenticación de usuarios con 3 roles distintos (paciente, nutricionista, administrador), una base de datos relacional para citas, consultas y menús, y reglas de acceso donde cada usuario solo vea la información que le corresponde. El proyecto lo desarrolla una sola persona.

## Decisión

Usar Supabase como backend en vez de un servidor propio.

En vez de construir una API REST propia (por ejemplo con Node.js o Django) más una base de datos administrada aparte, se decidió usar Supabase: una plataforma que da autenticación, base de datos PostgreSQL y una API REST autogenerada, todo en un solo servicio.

## Consecuencias

Positivas:
- Se eliminó por completo la necesidad de escribir y mantener un servidor backend.
- La seguridad de los datos se resuelve con Row Level Security (RLS) directamente en la base de datos, en vez de validar permisos manualmente en cada endpoint.


Negativas / trade-offs:
- Se pierde control total sobre la lógica del servidor: no hay forma de correr código personalizado sin usar funciones de PostgreSQL o Edge Functions de Supabase.
- El proyecto queda dependiente de un proveedor externo (vendor lock-in): migrar a otro backend en el futuro implicaría reescribir toda la capa de datos.
