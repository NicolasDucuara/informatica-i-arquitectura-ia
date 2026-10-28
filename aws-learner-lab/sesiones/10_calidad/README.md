# Sesión 10 — Arquitectura robusta y calidad medible

**Fecha:** 27 de octubre de 2026, encuentro reprogramado de 6:00–10:00 p. m.
**Resultado:** comprobar el comportamiento de LibreReserva detrás de un balanceador y definir qué significa robustez mediante escenarios medibles, una arquitectura objetivo y decisiones versionadas.

## Relación con AWS Academy

El módulo 9 de Cloud Foundations aporta el marco de arquitectura en la nube. Sus principios se aplican como preguntas sobre LibreReserva; no se crean recursos AWS ni se diseña una segunda implementación.

## Secuencia de cuatro horas

| Hora | Tema y acción |
|---|---|
| 6:00–6:30 | comprobar la imagen y la API en una instancia |
| 6:30–7:15 | ejecutar dos instancias detrás de Caddy y observar la distribución |
| 7:15–7:50 | relacionar agendas independientes con durabilidad y consistencia |
| 8:00–8:45 | formular escenarios medibles |
| 8:45–9:30 | arquitectura actual, arquitectura objetivo y ADR |
| 9:30–10:00 | evidencia, pull request y preparación de PostgreSQL |

## Práctica de balanceo local

La práctica usa dos contenedores de LibreReserva y un contenedor Caddy como único punto de entrada. La topología está en [compose-balanceo.yml](compose-balanceo.yml) y la política del proxy en [Caddyfile.balanceo](Caddyfile.balanceo). No incorpora PostgreSQL: su propósito es demostrar que distribuir solicitudes no comparte el estado almacenado en la memoria de cada proceso.

Desde la raíz del repositorio, construya la imagen usada en la sesión 9:

```bash
docker build -f labs/librereserva/Containerfile \
  -t localhost/librereserva:0.1.0 labs/librereserva
```

Revise y levante el ensayo:

```bash
docker compose -p librereserva-s10 \
  -f aws-learner-lab/sesiones/10_calidad/compose-balanceo.yml config
docker compose -p librereserva-s10 \
  -f aws-learner-lab/sesiones/10_calidad/compose-balanceo.yml up -d
docker compose -p librereserva-s10 \
  -f aws-learner-lab/sesiones/10_calidad/compose-balanceo.yml ps
```

El balanceador es el único servicio publicado en el equipo:

```bash
curl -fsS http://127.0.0.1:8080/salud/viva
```

Observe en una terminal qué instancia atiende las solicitudes:

```bash
docker compose -p librereserva-s10 \
  -f aws-learner-lab/sesiones/10_calidad/compose-balanceo.yml \
  logs -f api_a api_b
```

En otra terminal, envíe varias solicitudes al balanceador:

```bash
for intento in 1 2 3 4 5 6; do
  curl -fsS http://127.0.0.1:8080/salud/viva
  echo
done
```

### Estado independiente

Cree una reserva a través del balanceador:

```bash
curl -i -X POST http://127.0.0.1:8080/reservas \
  -H 'content-type: application/json' \
  -d '{"recurso":"A-101","inicio":"2026-10-27T18:00:00-05:00","fin":"2026-10-27T19:00:00-05:00"}'
```

Consulte varias veces el mismo endpoint:

```bash
for intento in 1 2 3 4 5 6; do
  curl -fsS http://127.0.0.1:8080/reservas
  echo
done
```

El resultado puede alternar entre una lista con la reserva y `[]`. Caddy distribuye las solicitudes, pero `api_a` y `api_b` tienen objetos `Agenda` diferentes. La regla de no solapamiento tampoco se protege entre procesos.

Registre como evidencia los logs de ambas instancias, las respuestas observadas y una explicación del resultado. Al finalizar, retire únicamente los contenedores de este ensayo:

```bash
docker compose -p librereserva-s10 \
  -f aws-learner-lab/sesiones/10_calidad/compose-balanceo.yml down
```

## Taller

1. Dibuje la arquitectura actual: cliente, API en contenedor y agenda en memoria.
2. Añada al diagrama actual el balanceador y las dos agendas independientes observadas.
3. Dibuje la arquitectura objetivo: cliente, balanceador, API reemplazable, PostgreSQL, CI, logs y respaldo.
4. Formule exactamente cuatro escenarios:
   - datos conservados después de reiniciar la API;
   - una sola confirmación ante solicitudes concurrentes incompatibles;
   - recuperación después de una caída de PostgreSQL;
   - diagnóstico de una solicitud fallida mediante logs.
5. Cada escenario contiene fuente, estímulo, entorno, artefacto, respuesta, unidad y umbral.
6. Escriba dos ADR: conservar el monolito modular y usar PostgreSQL como almacenamiento durable.
7. Entregue los documentos mediante una rama corta y un pull request.

## Validación

Los diagramas deben distinguir el estado actual del objetivo. El balanceador no cuenta como solución de persistencia ni como prueba de alta disponibilidad. Los ADR deben incluir contexto, alternativas, decisión y consecuencias. Una expresión como “alta disponibilidad” sin condición ni medida no cuenta como escenario.

**Evidencia:** distribución observada en los logs, inconsistencia entre agendas, cuatro escenarios, dos diagramas, dos ADR y pull request revisado.
