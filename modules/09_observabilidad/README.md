# Módulo 9. Operación y recuperación

## Resultado

Diagnosticar solicitudes, distinguir vida de disponibilidad, medir el comportamiento observado y restaurar PostgreSQL mediante un procedimiento reproducible.

## Instalación paso a paso

Use el ambiente acumulativo de LibreReserva: Docker o Podman, Compose, la imagen de la API y PostgreSQL. No se instala una plataforma adicional. Levante el sistema con los comandos documentados por el equipo y compruebe `/salud/viva` y `/salud/lista` antes de inducir fallos.

## Señales mínimas

LibreReserva debe registrar, sin datos sensibles:

- fecha y hora;
- identificador de solicitud;
- método y ruta normalizada;
- estado HTTP;
- duración;
- tipo de error controlado.

`/salud/viva` comprueba el proceso HTTP. `/salud/lista` comprueba realmente PostgreSQL dentro de un tiempo máximo. Ninguna de las dos respuestas debe exponer la cadena de conexión.

## Diagnóstico

Con la API en ejecución, genere una solicitud correcta, un conflicto y una indisponibilidad de PostgreSQL. Relacione cada respuesta con sus logs mediante el identificador de solicitud.

```bash
curl -sS -o /dev/null -w 'HTTP=%{http_code} tiempo=%{time_total}s\n' \
  http://127.0.0.1:8000/salud/viva
docker logs --tail=50 librereserva
```

Use `podman logs` cuando corresponda. Registre las condiciones de cualquier medición: equipo, revisión, número de solicitudes y concurrencia. Reporte al menos p50, p95 y tasa de error; una observación aislada no es un percentil.

## Respaldo y restauración

1. Cree varias reservas identificables.
2. Genere un respaldo de PostgreSQL.
3. Compruebe que el archivo no está vacío.
4. Detenga el ambiente.
5. Identifique y elimine únicamente el volumen del laboratorio.
6. Cree un volumen limpio.
7. Restaure el respaldo.
8. Levante la API y verifique las reservas.

El runbook debe incluir detección, diagnóstico, respaldo disponible, recuperación, validación y reversión segura.

## Validación

- Un conflicto de negocio no se clasifica como error interno.
- Los logs no contienen credenciales, cuerpos completos ni datos personales.
- Vida y disponibilidad cambian de manera coherente durante la caída.
- La medición declara condiciones y muestra datos reproducibles.
- La restauración se comprueba mediante la API.

**Evidencia:** logs correlacionados, medición, respaldo, restauración y runbook.
