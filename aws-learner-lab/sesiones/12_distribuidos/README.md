# Sesión 12 — API confiable ante repeticiones y fallos

**Fecha:** 4 de noviembre de 2026, 6:00–10:00 p. m.
**Resultado:** hacer que la creación de reservas sea segura ante repeticiones y que la API comunique correctamente la disponibilidad de PostgreSQL.

## Alcance

Esta sesión continúa sobre la persistencia de la semana 11. No introduce mensajería, colas ni procesos distribuidos adicionales.

## Secuencia de cuatro horas

| Hora | Tema y acción |
|---|---|
| 6:00–6:20 | verificar migraciones y pruebas de integración |
| 6:20–7:10 | idempotencia, códigos de error y límites de transacción |
| 7:10–7:50 | vida, disponibilidad y dependencias |
| 8:00–9:25 | implementar clave de idempotencia y salud real |
| 9:25–9:50 | detener PostgreSQL, observar y recuperar |
| 9:50–10:00 | pull request y actualización del ADR |

## Taller

1. Acepte una clave de idempotencia al crear reservas.
2. Guarde la clave y el resultado en la misma transacción que la reserva.
3. Para la misma clave y el mismo contenido, devuelva el resultado anterior sin crear otra reserva.
4. Para la misma clave con contenido diferente, responda conflicto.
5. Mantenga `/salud/viva` como señal del proceso.
6. Cambie `/salud/lista` para comprobar realmente PostgreSQL.
7. Defina respuestas consistentes para validación, conflicto, dependencia no disponible y error inesperado.
8. Detenga PostgreSQL, compruebe la indisponibilidad y recupere el servicio sin perder datos.

## Matriz mínima

| Experimento | Resultado |
|---|---|
| repetir solicitud con la misma clave y contenido | no existe un segundo efecto |
| reutilizar la clave con contenido diferente | conflicto |
| detener PostgreSQL | vida puede responder; disponibilidad debe fallar |
| iniciar PostgreSQL nuevamente | disponibilidad se recupera y los datos continúan |

## Validación

Las pruebas deben distinguir duplicación de conflicto de negocio. Un endpoint de disponibilidad que devuelve un valor fijo no satisface el resultado.

**Evidencia:** migración de idempotencia, pruebas HTTP/integración, matriz ejecutada y logs de caída/recuperación.
