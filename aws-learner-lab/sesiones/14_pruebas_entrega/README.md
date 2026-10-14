# Sesión 14 — Implementación, pruebas y entrega

**Fecha:** 18 de noviembre de 2026, 6:00–10:00 p. m.
**Resultado:** relacionar commit, pruebas, imagen OCI y despliegue reproducible. El mínimo es CI, acceso a la API en kind y recuperación de un Pod; ECR es una ampliación opcional.

No instale Forgejo, telemetría ni proxy TLS en este taller. Las ampliaciones de operación se reservan a la [sesión 15](../15_proyecto/README.md) y a la [ruta por sesiones](../../../docs/RUTA_CONTENEDORES.md).

## Montaje docente en AWS Academy

Publique `S14 — LibreReserva — pruebas y entrega` con este archivo, `s14-ecr.yaml`, los módulos 7 y 8 y la evidencia. Una semana antes recuerde ejecutar `check_preparation.sh --full`. Verifique previamente que ECR admita crear repositorio, obtener token, subir y eliminar imágenes. Si no está habilitado, quite la sección ECR de la actividad: Podman y `kind` cubren el resultado completo.

## Secuencia de cuatro horas

| Hora | Tema y acción |
|---|---|
| 6:00–6:20 | revisión del corte vertical y estrategia de pruebas |
| 6:20–7:10 | pruebas, commit e imagen; Deployment y Service |
| 7:10–7:50 | demo de suite, construcción y despliegue `kind` |
| 8:00–9:25 | taller: prueba, imagen, dos réplicas, acceso y recuperación |
| 9:25–9:50 | evidencia y decisión de plataforma; ECR solo para equipos que ya completaron el mínimo |
| 9:50–10:00 | eliminar clúster, imágenes remotas y pila |

## Ruta principal con software libre

```bash
./scripts/setup_python.sh --apply
make test-all
podman build -f labs/librereserva/Containerfile -t localhost/librereserva:0.1.0 labs/librereserva
podman image inspect localhost/librereserva:0.1.0 --format '{{.Id}}'
export KIND_EXPERIMENTAL_PROVIDER=podman
kind create cluster --name informatica1
kind load docker-image localhost/librereserva:0.1.0 --name informatica1
kubectl apply -f modules/08_entrega_plataforma/k8s.yml
kubectl rollout status deployment/librereserva --timeout=120s
kubectl get pods,service
kubectl port-forward service/librereserva 8000:80
```

Mientras `port-forward` está activo, abra `http://127.0.0.1:8000/docs`. Siga la [recuperación guiada de un Pod](../../../modules/08_entrega_plataforma/README.md#recuperación-de-una-instancia). Añada una prueba del contrato o del adaptador implementado por su equipo, no de una capacidad que la API base aún no tiene.

La etiqueta construida y cargada coincide con la del manifiesto: `0.1.0`. El [flujo CI](../../../.github/workflows/validate.yml) usa la etiqueta del commit para trazabilidad y conserva un archivo de imagen. Descargar un artefacto de CI no equivale a publicar una imagen en un registro.

## Extensión ECR, solo si fue habilitada

```bash
./aws-learner-lab/scripts/stack.sh deploy \
  libre-reserva-s14-equipoXX \
  aws-learner-lab/templates/s14-ecr.yaml --apply

repository_uri="$(aws cloudformation describe-stacks \
  --stack-name libre-reserva-s14-equipoXX --region "$AWS_REGION" \
  --query 'Stacks[0].Outputs[?OutputKey==`RepositoryUri`].OutputValue' --output text)"
[[ "$repository_uri" == *.amazonaws.com/* ]] || exit 1
registry="${repository_uri%%/*}"
aws ecr get-login-password --region "$AWS_REGION" | \
  podman login --username AWS --password-stdin "$registry"
podman tag localhost/librereserva:0.1.0 "$repository_uri:s14"
podman push "$repository_uri:s14"
aws ecr describe-images --repository-name "${repository_uri#*/}" \
  --region "$AWS_REGION" --output table
```

## Validación y limpieza

```bash
kind delete cluster --name informatica1
./aws-learner-lab/scripts/stack.sh delete libre-reserva-s14-equipoXX --apply
```

La plantilla usa `EmptyOnDelete`, de modo que CloudFormation elimina las imágenes del repositorio de esta práctica. Revise ECR después del borrado.

**Evidencia:** pruebas, digest local/remoto si aplica, manifiesto, recuperación de pod, commit trazable y limpieza.
