# Sesión 12 — Decidir antes de distribuir

**Fecha:** 4 de noviembre de 2026, 6:00–10:00 p. m.
**Resultado:** comparar una notificación dentro del monolito con una cola asíncrona y justificar la distribución mediante evidencia de fallos.

## Alcance y preparación

Esta sesión introduce YAML y Compose con la [lectura breve](../../../docs/YAML_PARA_LABORATORIOS.md) y la [etapa de mensajes del laboratorio](../../../modules/06_apis_datos_eventos/LABORATORIO.md#sesión-12-un-mensaje-y-un-reintento). Prepare Compose antes de clase. Elija RabbitMQ local o SQS como taller principal: no exija ambos. PostgreSQL, transacciones e integración de la API se reservan a sesión 13; Kubernetes a sesión 14. No se implementa un sistema completo de notificaciones en esta sesión.

## Montaje docente en AWS Academy

Publique `S12 — LibreReserva — decidir antes de distribuir` con este archivo, `s12-messaging.yaml`, el módulo 5 y la evidencia. Pruebe previamente envío, recepción repetida, visibilidad y movimiento a DLQ. Aclare que SQS ofrece entrega al menos una vez y que la idempotencia pertenece al consumidor.

## Secuencia de cuatro horas

| Hora | Tema y acción |
|---|---|
| 6:00–6:20 | estado del núcleo modular y pregunta de distribución |
| 6:20–7:10 | tarea síncrona/asíncrona, productor/cola/consumidor y entrega repetida |
| 7:10–7:50 | YAML/Compose y RabbitMQ local, o demo SQS si esa es la ruta elegida |
| 8:00–9:25 | publicar/recibir un mensaje, repetirlo y diseñar cómo evitar un efecto duplicado |
| 9:25–9:50 | matriz monolito/cola/función y ADR |
| 9:50–10:00 | purga y eliminación |

## Taller AWS

```bash
./aws-learner-lab/scripts/stack.sh deploy \
  libre-reserva-s12-equipoXX \
  aws-learner-lab/templates/s12-messaging.yaml --apply

queue_url="$(aws cloudformation describe-stacks \
  --stack-name libre-reserva-s12-equipoXX --region "$AWS_REGION" \
  --query 'Stacks[0].Outputs[?OutputKey==`QueueUrl`].OutputValue' --output text)"
[[ "$queue_url" == https://* ]] || exit 1

aws sqs send-message --queue-url "$queue_url" --region "$AWS_REGION" \
  --message-body '{"type":"ReservaCreada","id":"demo-01","recurso":"A-101"}'
aws sqs receive-message --queue-url "$queue_url" --region "$AWS_REGION" \
  --wait-time-seconds 10 --visibility-timeout 5 --max-number-of-messages 1
```

No elimine el mensaje recibido; repita la recepción después del tiempo de visibilidad y demuestre el reintento. Construya un consumidor local que guarde identificadores procesados y que produzca un solo efecto aunque reciba el mensaje dos veces. Envíe un mensaje inválido y observe su tratamiento hasta la DLQ.

## Validación y limpieza

```bash
aws sqs purge-queue --queue-url "$queue_url" --region "$AWS_REGION"
./aws-learner-lab/scripts/stack.sh delete libre-reserva-s12-equipoXX --apply
```

**Evidencia mínima:** dos entregas del mismo mensaje, explicación del efecto duplicado, decisión síncrona/cola y limpieza. Un consumidor implementado y DLQ son ampliaciones de la ruta elegida, no requisitos simultáneos.

**Ruta local:** siga el [laboratorio RabbitMQ](../../../modules/06_apis_datos_eventos/LABORATORIO.md). La API HTTP de administración permite observar publicación y reencolado; no reproduce todas las garantías de un cliente AMQP ni la semántica de SQS.

Al cerrar, recuerde preparar `kind` y `kubectl` antes de sesión 14, sin utilizarlos en el taller de hoy.
