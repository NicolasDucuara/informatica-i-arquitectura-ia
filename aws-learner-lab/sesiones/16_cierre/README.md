# Sesión 16 — Demostración de robustez y cierre

**Fecha:** 2 de diciembre de 2026, 6:00–10:00 p. m.
**Resultado:** reproducir LibreReserva desde una revisión identificable y defender con evidencia sus garantías y límites.

La sesión no introduce tecnologías ni cambia la arquitectura. Se demuestra la versión candidata producida en la jornada autónoma.

## Secuencia de cuatro horas

| Hora | Tema y acción |
|---|---|
| 6:00–6:20 | congelar alcance, identificar commit y comprobar ambientes |
| 6:20–7:00 | reconstrucción desde clon limpio |
| 7:00–8:50 | demostraciones de equipos |
| 8:50–9:20 | preguntas cruzadas y revisión de ADR |
| 9:20–9:40 | entrega final y deuda reconocida |
| 9:40–10:00 | limpieza de ambientes y, si aplica, recursos AWS oficiales |

## Guion obligatorio

1. Mostrar commit, imagen y arquitectura vigente.
2. Ejecutar pruebas.
3. Levantar PostgreSQL, aplicar migraciones y ejecutar la API.
4. Crear y consultar una reserva.
5. Reiniciar la API y comprobar que la reserva continúa.
6. Ejecutar el conflicto concurrente.
7. Repetir una solicitud con clave de idempotencia.
8. Detener PostgreSQL y mostrar vida/disponibilidad.
9. Recuperar PostgreSQL y validar el servicio.
10. Relacionar una solicitud con sus logs.
11. Restaurar un respaldo o mostrar la evidencia reproducible de la restauración realizada.
12. Relacionar los resultados con los escenarios y ADR.

## Criterio de cierre

Una capacidad que no pueda demostrarse se registra como deuda; no se presenta como terminada. Si se usó Learner Lab para actividades oficiales de Cloud Foundations, el equipo confirma la eliminación de sus recursos sin borrar recursos ajenos.

**Evidencia final:** instrucciones de reproducción, pruebas, imagen, migraciones, caso feliz, concurrencia, idempotencia, fallo, recuperación, restauración, logs, ADR y deuda reconocida.
