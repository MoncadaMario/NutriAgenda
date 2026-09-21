# NutriAgenda
Sistema de gestión para facilitar la administración de pacientes y consultas de una nutricionista independiente.

# Código de verificación
LEARN-CAP-C8E615E4

## Problema que resuelve

Una nutricionista independiente suele gestionar su consultorio con hojas de cálculo, un cuaderno de notas y WhatsApp. Funciona con pocos pacientes, pero no escala: no hay control de acceso real, buscar el historial de alguien implica revisar archivos sueltos, y el paciente no tiene forma de consultar su propio progreso sin preguntar.

## Roles

- Paciente: ve sus citas, su historial de consultas y el menú que le asignaron.
- Nutricionista: gestiona su lista de pacientes, registra consultas, agenda citas y asigna menús.
- Administrador: aprueba cuentas de nutricionistas nuevas y gestiona los roles de todos los usuarios.

## Tecnologías

- Cliente: Flutter Web
- Backend: Supabase (Auth, PostgreSQL, Row Level Security)
- Hosting: Vercel, con middleware que protege rutas privadas a nivel de servidor
- CI/CD: GitHub Actions (análisis, pruebas, cobertura)
- Calidad de código: SonarCloud

## Arquitectura

El control de acceso vive en la base de datos, no en la interfaz: las políticas de Row Level Security deciden qué puede leer o escribir cada usuario según su rol, así que ni siquiera manipulando el cliente se puede acceder a información ajena. El detalle completo está en [`docs/arquitectura.md`](docs/arquitectura.md) y las decisiones de diseño en [`docs/adr/`](docs/adr/).
