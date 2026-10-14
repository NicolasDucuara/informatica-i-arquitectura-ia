# Módulo 6. API, datos, consistencia y eventos

## Resultado

Diseñar contratos compatibles, persistencia transaccional, idempotencia y publicación confiable de eventos.

Consulte el [laboratorio por etapas](LABORATORIO.md): sesión 12 introduce YAML, Compose y un mensaje; sesión 13 comprueba persistencia y una transacción reserva/outbox. La API base continúa en RAM. El adaptador PostgreSQL y el publicador/consumidor son incrementos del proyecto, no funcionalidades ya implementadas ni una entrega completa de cuatro horas.

## Datos que sobreviven a las réplicas

![Sketch de aplicación sin estado y almacenamiento compartido separado](../../docs/imagenes/despliegue-sin-estado-cloud.jpg)

La API ejecuta reglas y solicitudes, PostgreSQL conserva las reservas y un almacenamiento de objetos puede conservar archivos. Aunque las réplicas de la aplicación puedan cambiar, las reservas y los archivos deben mantenerse fuera de su memoria local. RabbitMQ transporta trabajo pendiente entre programas y no sustituye la base de datos. No basta con iniciar los servicios: el equipo debe implementar y probar los adaptadores y las garantías de consistencia.

## Instalación paso a paso

1. Prepare Podman con el módulo 1.
   También puede elegir Docker. Verifique `podman compose version` o `docker compose version` antes de clase; Podman necesita un proveedor externo como `podman-compose`.
2. Revise las imágenes, puertos, volúmenes y credenciales de laboratorio.
3. Muestre el plan y luego inicie los servicios.
4. Compruebe salud sin instalar PostgreSQL ni RabbitMQ en el sistema anfitrión.

```bash
sed -n '1,240p' modules/06_apis_datos_eventos/compose.yml
./modules/06_apis_datos_eventos/start_services.sh
./modules/06_apis_datos_eventos/start_services.sh --apply
podman ps
# Alternativa Docker: start_services.sh --motor docker --apply
```

Servicios locales:

- PostgreSQL: `localhost:5432`, base `reservas`.
- RabbitMQ AMQP: `localhost:5672`.
- Consola RabbitMQ: `http://localhost:15672`.

Los puertos publicados se restringen a `127.0.0.1`. Las credenciales son únicamente de laboratorio y no se reutilizan en otros entornos. Si usa una máquina remota, acceda por túnel SSH; no publique base de datos ni consola en Internet.

## Temas

- OpenAPI y compatibilidad evolutiva.
- Idempotencia y concurrencia.
- Transacciones, aislamiento y restricciones de base de datos.
- Mensajería asíncrona y entrega al menos una vez.
- Patrón outbox y consumidores idempotentes.

## Ejercicio

Sustituya la agenda en memoria por un puerto de repositorio PostgreSQL. Añada una restricción que impida solapamientos, una migración y una tabla outbox escrita en la misma transacción. El publicador puede fallar y reintentar sin perder la reserva.

## Validación

```bash
podman exec librereserva-postgres pg_isready -U curso -d reservas
curl -fsS http://localhost:15672 >/dev/null
```

Pruebe dos solicitudes concurrentes y demuestre que solo una reserva incompatible se confirma. Reinicie el publicador y compruebe que el evento pendiente se entrega sin duplicar el efecto.

**Evidencia:** contrato, migración, prueba concurrente, evento y explicación de consistencia.
