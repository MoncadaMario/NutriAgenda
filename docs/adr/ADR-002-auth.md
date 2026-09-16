# ADR-002: Autenticación y control de acceso basado en roles con RLS

## Contexto

La aplicación tiene 3 tipos de usuario con permisos muy distintos: un paciente solo debe ver sus propios datos, un nutricionista debe ver los datos de sus pacientes, y un administrador debe poder gestionar a todos los usuarios. Además, como la aplicación es una SPA (Single Page Application) que corre completamente en el navegador, cualquier restricción hecha solo en el código Flutter podría evadirse manipulando las peticiones directamente.

## Decisión

Usar Supabase Auth para la identidad de los usuarios, una tabla `profiles` con un campo `rol`, y políticas de Row Level Security en cada tabla para reforzar los permisos directamente en la base de datos, en vez de confiar únicamente en la lógica del cliente Flutter.

## Consecuencias

Positivas:
- La seguridad no depende de que el código del cliente esté bien escrito: aunque alguien intercepte y modifique una petición, la base de datos la rechaza si no cumple la política.
- Los roles se asignan automáticamente al registrarse, mediante un trigger de PostgreSQL, sin pasos manuales adicionales.
- El mismo mecanismo de RLS protegería a cualquier otro cliente que en el futuro consuma la misma base de datos, no solo a la app Flutter.

Negativas / trade-offs:
- Escribir políticas de RLS mal diseñadas puede generar errores difíciles de diagnosticar, como la recursión infinita que se presentó al permitir que un nutricionista viera la lista de pacientes (se resolvió con una función `security definer`).
- Al ser una aplicación 100% renderizada en el cliente (SPA), la protección de rutas por sesión ocurre después de que el navegador ya cargó el "cascarón" de la aplicación — por eso fue necesario reforzarlo también con un Edge Middleware en el hosting.