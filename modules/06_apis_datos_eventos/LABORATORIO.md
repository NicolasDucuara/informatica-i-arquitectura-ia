# Laboratorio acumulativo: PostgreSQL y API confiable

La API inicial guarda reservas en la memoria del proceso. La sesión 10 mostró que dos instancias mantienen agendas distintas y que compartir un Parquet requiere serializar en la aplicación todo el ciclo leer, validar y escribir. Este laboratorio reemplaza esas soluciones por PostgreSQL en dos incrementos consecutivos. Todo cambio se realiza sobre LibreReserva; no se crea una API paralela.

## Preparación común

Desde la raíz del repositorio, elija un motor:

```bash
./modules/06_apis_datos_eventos/start_services.sh --motor docker
./modules/06_apis_datos_eventos/start_services.sh --motor docker --apply
docker exec librereserva-postgres pg_isready -U curso -d reservas
```

Con Podman, sustituya `docker` por `podman`. Revise antes la imagen, el volumen, el puerto y las credenciales de laboratorio definidos en `compose.yml`.

## Sesión 11: persistencia e integridad

### Incremento 1. Puerto y adaptadores

1. Defina un protocolo `RepositorioReservas` que exprese las operaciones requeridas por el dominio.
2. Extraiga el almacenamiento actual a un adaptador en memoria.
3. Implemente un adaptador PostgreSQL sin importar el cliente de base de datos desde el dominio.
4. Ejecute la misma prueba de contrato contra los dos adaptadores.

### Incremento 2. Migración

La migración debe crear la tabla de reservas, validar que `fin > inicio` y proteger el solapamiento del mismo recurso entre todas las instancias. El archivo `demo_persistencia.sql` muestra una posible restricción PostgreSQL; convierta el diseño elegido en una migración real de la aplicación.

Pruebe la migración sobre una base vacía. Ejecútela una vez como operación separada antes de las réplicas; no use el arranque simultáneo de cada API para competir por cambios de esquema. No edite manualmente una base ya preparada para ocultar un paso faltante.

### Incremento 3. Durabilidad

1. Inicie PostgreSQL, dos instancias de la API y Caddy.
2. Cree una reserva mediante `http://127.0.0.1:8080`.
3. Consulte repetidamente mediante Caddy y compruebe que ambas instancias observan los mismos datos.
4. Reinicie únicamente una API.
5. Consulte nuevamente mediante Caddy.
6. Compruebe que la reserva continúa.

### Incremento 4. Concurrencia

Envíe mediante Caddy dos solicitudes simultáneas para el mismo recurso y un intervalo incompatible. La evidencia debe mostrar exactamente una confirmación `201` y un conflicto `409`. Una comprobación `SELECT` seguida de `INSERT` sin protección en PostgreSQL no es suficiente. La restricción debe seguir funcionando aunque cada solicitud llegue a una instancia diferente.

**Evidencia de sesión 11:** puerto, adaptadores, migración única, prueba de contrato, consultas consistentes mediante Caddy, reinicio con datos y prueba concurrente `201`/`409`.

## Sesión 12: idempotencia y recuperación

### Incremento 5. Clave de idempotencia

1. Reciba una clave de idempotencia al crear una reserva.
2. Almacene clave, huella de la solicitud y respuesta dentro de la transacción.
3. Misma clave y mismo contenido: entregue el resultado anterior sin crear otra reserva.
4. Misma clave y contenido diferente: responda conflicto.
5. Añada pruebas HTTP y de integración.

### Incremento 6. Vida y disponibilidad

- `/salud/viva` indica que el proceso HTTP responde.
- `/salud/lista` comprueba que PostgreSQL acepta una operación liviana dentro de un tiempo máximo.
- Una dependencia caída produce una respuesta controlada; no expone credenciales ni una traza interna al cliente.

### Incremento 7. Fallo y recuperación

1. Cree datos de prueba.
2. Detenga PostgreSQL sin eliminar el volumen.
3. Compruebe vida, disponibilidad y respuesta de una operación que necesita datos.
4. Inicie PostgreSQL.
5. Espere la recuperación y vuelva a consultar los datos.

| Experimento | Resultado esperado |
|---|---|
| repetir solicitud con misma clave y contenido | mismo resultado, sin segunda reserva |
| reutilizar clave con contenido diferente | conflicto |
| PostgreSQL detenido | vida diferenciada de disponibilidad |
| PostgreSQL iniciado nuevamente | disponibilidad recuperada y datos conservados |

**Evidencia de sesión 12:** migración de idempotencia, pruebas, respuestas HTTP y logs de caída/recuperación.

## Cierre del laboratorio

Detenga los contenedores sin borrar el volumen si continuará en la siguiente sesión:

```bash
docker compose -f modules/06_apis_datos_eventos/compose.yml stop
```

Use el comando equivalente de Podman cuando corresponda. La eliminación del volumen se realiza únicamente durante el ejercicio controlado de restauración de la sesión 14 y después de comprobar su nombre.
