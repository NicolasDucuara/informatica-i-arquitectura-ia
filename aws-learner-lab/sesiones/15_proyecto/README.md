# Sesión 15 — Jornada autónoma de integración

**Fecha:** 25 de noviembre de 2026, cuatro horas de trabajo autónomo, sin encuentro sincrónico.
**Resultado:** producir una versión candidata de LibreReserva desde un clon limpio, sin introducir tecnologías ni funcionalidades nuevas.

## Plan de cuatro horas

| Tiempo | Actividad |
|---:|---|
| 0:00–0:30 | clonar la revisión, revisar variables y comprobar prerrequisitos |
| 0:30–1:15 | ejecutar pruebas y levantar PostgreSQL |
| 1:15–2:00 | aplicar migraciones, construir imagen y levantar la API |
| 2:00–2:45 | ejecutar caso feliz, concurrencia e idempotencia |
| 2:45–3:25 | provocar caída de PostgreSQL y recuperar el servicio |
| 3:25–3:45 | restaurar el respaldo en un volumen limpio |
| 3:45–4:00 | registrar resultados, defectos y versión candidata |

## Lista obligatoria

- El repositorio no tiene cambios locales desconocidos al comenzar.
- Las instrucciones funcionan desde un clon limpio.
- Todas las pruebas pasan.
- La imagen se relaciona con un commit.
- API y PostgreSQL se levantan con comandos documentados.
- Las migraciones se aplican de manera reproducible.
- Una reserva sobrevive al reinicio de la API.
- La prueba concurrente confirma una sola reserva incompatible.
- La repetición idempotente no duplica efectos.
- La caída de PostgreSQL cambia la disponibilidad.
- El servicio se recupera después de iniciar PostgreSQL.
- El respaldo se restaura en un volumen limpio.
- Los ADR y el diagrama representan la implementación real.

## Restricción de alcance

No se añaden colas, funciones, Kubernetes, otra base de datos, otra forja ni una pila de observabilidad. Si aparece un defecto, se corrige dentro de la arquitectura existente o se registra como deuda con impacto y responsable.

**Entrega:** versión candidata, bitácora de cuatro horas, pruebas, identificador de imagen, resultados de fallo/recuperación y defectos pendientes.
