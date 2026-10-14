# Módulo 8. Entrega continua, contenedores e infraestructura

## Resultado

Relacionar una confirmación Git con pruebas, imagen OCI, SBOM y despliegue reproducible en Kubernetes local.

## Instalación paso a paso

### 1. Podman e imagen

Prepare Podman siguiendo la [guía de entorno](../01_entorno/README.md). La sesión 9 admite también [Docker en Ubuntu y EC2](../01_entorno/README.md#instalación-con-script-en-ubuntu-y-ec2); los pasos Kubernetes siguientes describen la ruta Podman. Todos los comandos de este módulo se ejecutan desde la raíz del repositorio.

```bash
podman info
podman build -f labs/librereserva/Containerfile -t localhost/librereserva:0.1.0 labs/librereserva
podman run --rm -p 127.0.0.1:8000:8000 localhost/librereserva:0.1.0
```

Detenga la ejecución con Ctrl+C antes de continuar con el clúster.

### 2. kubectl y kind

Siga la [guía oficial de kind](https://kind.sigs.k8s.io/docs/user/quick-start/) y la [instalación oficial de kubectl](https://kubernetes.io/docs/tasks/tools/). No se fija un binario antiguo dentro del repositorio. Verifique:

```bash
kubectl version --client
kind version
```

Con Podman puede ser necesario:

```bash
export KIND_EXPERIMENTAL_PROVIDER=podman
```

### 3. Clúster y despliegue

```bash
kind create cluster --name informatica1
kind load docker-image localhost/librereserva:0.1.0 --name informatica1
kubectl apply -f modules/08_entrega_plataforma/k8s.yml
kubectl rollout status deployment/librereserva --timeout=120s
kubectl get pods,service
```

### 4. Forgejo

Use una instancia institucional o instale Forgejo mediante su [documentación oficial](https://forgejo.org/docs/latest/admin/installation/docker/). Configure un runner aislado y adapte `.github/workflows/validate.yml` a `.forgejo/workflows/validate.yml`. Las acciones externas son código: fíjelas a una versión revisada.

## Ejercicio

Construya la imagen, registre su digest, despliegue dos réplicas, elimine un pod y observe reconciliación. Configure CI para rechazar una prueba fallida. No almacene secretos en el flujo.

## Validación

```bash
podman image inspect localhost/librereserva:0.1.0 --format '{{.Digest}}'
kubectl rollout status deployment/librereserva --timeout=120s
kubectl get pods -l app=librereserva
```

**Evidencia:** ejecución CI, digest, manifiestos, recuperación y ADR de plataforma.
