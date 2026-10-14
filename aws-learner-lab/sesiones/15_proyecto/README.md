# Sesión 15 — Jornada autónoma de proyecto

**Fecha:** 25 de noviembre de 2026, cuatro horas de trabajo autónomo, sin encuentro sincrónico.
**Resultado:** integrar un incremento demostrable de LibreReserva con herramientas preparadas y sin trasladar deuda de limpieza a la sesión final.

## Elección de una ampliación

El equipo y el docente eligen **una** capacidad, con criterio de aceptación que quepa en cuatro horas:

- Un incremento funcional de [persistencia o eventos](../../../modules/06_apis_datos_eventos/LABORATORIO.md).
- [Escalado/actualización/rollback o demo de configuración/almacenamiento](../../../modules/08_entrega_plataforma/OPERACION.md), con las limitaciones de la API en RAM explícitas.
- [Ensayo local de proxy TLS y decisión de ambientes](../../../modules/08_entrega_plataforma/DESPLIEGUE.md).
- [Diagnóstico ligero o telemetría](../../../modules/09_observabilidad/README.md), con la infraestructura preparada antes de la jornada.

Las alternativas son excluyentes como carga mínima. No exija TLS, varias plataformas, Forgejo, bases de datos integradas y observabilidad completa al mismo equipo en esta jornada. El docente anuncia las alternativas al cerrar sesión 14 y comprueba sus prerrequisitos; los ejemplos opcionales se revisan antes, no se instalan por primera vez durante la defensa final.

## Montaje docente en AWS Academy

Publique `S15 — LibreReserva — jornada autónoma` al menos 48 horas antes. Mantenga Learner Lab disponible durante la franja acordada y adjunte este archivo, la evidencia y la rúbrica. Habilite un canal institucional de consultas y anuncie dos puntos de control asincrónicos. No añada una plantilla nueva: cada equipo reutiliza únicamente servicios ya probados en sesiones 9–14.

## Plan de cuatro horas

| Tiempo | Actividad y evidencia |
|---:|---|
| 0:00–0:20 | seleccionar una historia, criterio de aceptación y riesgo |
| 0:20–1:00 | diseñar cambio y actualizar ADR/diagrama |
| 1:00–2:30 | implementar en rama corta con pruebas |
| 2:30–3:15 | integrar, desplegar localmente o en Learner Lab y ejecutar caso de fallo |
| 3:15–3:40 | revisar seguridad, logs, consumo y reproducibilidad |
| 3:40–4:00 | entregar bitácora, limpiar AWS y preparar demo final |

## Ejercicio propuesto

Cada equipo selecciona una capacidad funcional u operativa de la lista anterior. Un cambio funcional debe relacionar dominio, adaptador, API y pruebas. Un cambio operativo debe demostrar comportamiento anterior/posterior y un procedimiento reproducible de recuperación. En ambos casos se registra lo que permanece pendiente.

Si usa AWS:

1. inicie una sesión temporal;
2. despliegue una de las plantillas ya aprobadas con nombre `libre-reserva-s15-equipoXX`;
3. registre hora de inicio, recursos y consumo;
4. ejecute caso feliz y caso de fallo;
5. elimine la pila antes de terminar.

## Validación

```bash
make check
make test-all
git status --short
aws cloudformation list-stacks --region "$AWS_REGION" \
  --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE
```

**Entrega:** incremento integrado, bitácora de cuatro horas, pruebas, estado del despliegue, ADR, riesgos y confirmación de limpieza. Una lista de actividades sin un incremento ejecutable no satisface la jornada.

**Ruta local:** Podman, PostgreSQL, RabbitMQ y `kind` son suficientes; AWS no es obligatorio si el incremento elegido no lo necesita.
