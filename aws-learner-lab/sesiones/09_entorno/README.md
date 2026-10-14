# Sesión 9 — Entorno reproducible, Git colaborativo y contenedores

**Fecha:** 14 de octubre de 2026, 6:00–10:00 p. m.
**Resultado:** ejecutar LibreReserva en `.venv` y en un contenedor, justificar el motor elegido, comprobar la API y entregar evidencia mediante un PR.

## Alcance de esta clase

Siga la [práctica de un contenedor](../../../modules/01_entorno/PRACTICA_CONTENEDORES.md). Las instalaciones y el acceso a Git se preparan antes del encuentro. En clase se usan la misma API y un solo motor. Compose/YAML pasan a sesión 12; datos y eventos a sesión 13; CI/Kubernetes a sesión 14; operación y ambientes a una ampliación elegida en sesión 15. Consulte la [ruta completa](../../../docs/RUTA_CONTENEDORES.md).

No se exige AWS, PostgreSQL, RabbitMQ, Compose, registro remoto ni Kubernetes para aprobar esta sesión. El taller AWS conservado más abajo es un anexo docente opcional fuera del recorrido mínimo.

## Montaje docente

Publique `S09 — Entorno, Git y contenedores` con enlaces a:

- Este archivo
- `PREPARACION_ANTES_SESION_9.md`
- Guía de Git: https://github.com/eshernan/big-data-postgraduate/blob/main/docs/guia-git/README.md
- `s09-foundation.yaml` (opcional para AWS)
- Plantilla de evidencia

Configure entrega para las 10:10 p. m. La ruta principal es local o una instancia institucional ya disponible. Para la demostración opcional de infraestructura, indique opciones:

1. **AWS Learner Lab** (si está habilitado)
2. **Cloud Privado Universitario** (alternativa institucional)
3. **Entorno local completo** (contingencia)

## Secuencia de cuatro horas - REESTRUCTURADA

### Hora 1 (6:00-7:00 p.m.): Git colaborativo en la práctica

| Tiempo | Tema y acción |
|---|---|
| 6:00–6:30 | **Activación y configuración Git**<br>- Verificar instalación: `git --version`<br>- Configurar identidad: `git config --global user.name "Su Nombre"` y `git config --global user.email "su@email"`<br>- Revisar guía de Git (escenarios E1-E3) |
| 6:30–7:00 | **Ejercicio práctico en parejas**<br>- Fork del repositorio actual<br>- Configuración de remotos: `origin` (fork), `upstream` (original)<br>- Primer commit y PR siguiendo la guía |

### Hora 2 (7:00-8:00 p.m.): Entorno reproducible y contenedores

| Tiempo | Tema y acción |
|---|---|
| 7:00–7:30 | `.venv`, pruebas y API local; comprobar `/docs`, explicar dependencias y liberar el puerto |
| 7:30–8:00 | imagen/contenedor, elección de Docker o Podman y comprobación `hello-world`; lectura del Containerfile real |

### Hora 3 (8:00-9:00 p.m.): LibreReserva en un contenedor

| Tiempo | Tema y acción |
|---|---|
| 8:00–8:10 | pausa |
| 8:10–8:30 | construir la imagen y ejecutar la API en un contenedor |
| 8:30–9:00 | probar salud, reserva `201`, repetición `409` y reinicio; comparar con `.venv` |

### Hora 4 (9:00-10:00 p.m.): Integración y evidencia

| Tiempo | Tema y acción |
|---|---|
| 9:00–9:30 | completar evidencia del mismo caso, motivo del motor y explicación de pérdida de memoria; PR |
| 9:30–10:00 | resolver dificultades, detener solo el contenedor del taller, revisar PR y anticipar la próxima sesión |

## Talleres prácticos

### Taller 1: Git colaborativo (Parejas)

```bash
# Estudiante A y B trabajan juntos
# 1. Clonar repositorio
git clone --branch update_esteban https://github.com/eshernan/informatica-i-arquitectura-ia.git
cd informatica-i-arquitectura-ia

# 2. Configurar remotos
git remote rename origin upstream
git remote add origin URL_DEL_FORK_DEL_EQUIPO
git remote -v

# 3. Crear rama de trabajo
git checkout -b sesion9-equipoXX

# 4. Modificar docs/entorno.md
#    - Estudiante A: Agregar sección "Git"
#    - Estudiante B: Agregar sección "Contenedores"

# 5. Commit y push
git add docs/entorno.md
git commit -m "Agrega secciones Git y Contenedores al entorno"
git push -u origin sesion9-equipoXX

# 6. Crear PR en GitHub desde sesion9-equipoXX hacia update_esteban del repositorio original
```

### Taller 2: Contenedores básicos

Para el ciclo completo de crear, arrancar, detener y eliminar, use la [práctica guiada](../../../modules/01_entorno/PRACTICA_CONTENEDORES.md). Los siguientes comandos son su alternativa corta con `run --rm`.

Prepare el motor con la [guía de entorno](../../../modules/01_entorno/README.md). En Ubuntu 26.04/EC2, revise el [instalador Docker](../../../scripts/install_docker_ubuntu.sh) y aplíquelo antes del taller. Ejecute una sola ruta desde la raíz del repositorio.

**Docker en Ubuntu**, con los permisos de la instalación:

```bash
sudo docker info
sudo docker run --rm docker.io/library/hello-world
sudo docker build -f labs/librereserva/Containerfile -t localhost/librereserva:0.1.0 labs/librereserva
sudo docker run --rm -p 127.0.0.1:8000:8000 localhost/librereserva:0.1.0
```

**Podman**:

```bash
podman info
podman run --rm docker.io/library/hello-world
podman build -f labs/librereserva/Containerfile -t localhost/librereserva:0.1.0 labs/librereserva
podman run --rm -p 127.0.0.1:8000:8000 localhost/librereserva:0.1.0
```

En otra terminal del mismo equipo o instancia, compruebe `curl -fsS http://127.0.0.1:8000/salud/viva`. Consulte la [API y sus endpoints](../../../labs/librereserva/API.md). Para acceder desde su computador a una instancia EC2, use el túnel SSH explicado en la guía de entorno. Detenga el contenedor con Ctrl+C al terminar.

### Anexo docente opcional: infraestructura

Este anexo no ocupa una hora de la ruta mínima ni exige una segunda entrega. Si se realiza una demostración, sustituya parte del cierre sin reducir la validación del contenedor. No prepare nuevas cuentas o instancias durante la clase.

#### Opción A: AWS Learner Lab

```bash
export AWS_REGION=REGION_ACORDADA
./aws-learner-lab/scripts/check_preparation.sh

./aws-learner-lab/scripts/stack.sh deploy \
  libre-reserva-s09-equipoXX \
  aws-learner-lab/templates/s09-foundation.yaml --apply

# Verificar creación
bucket_name="$(aws cloudformation describe-stacks \
  --stack-name libre-reserva-s09-equipoXX \
  --region "$AWS_REGION" \
  --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' \
  --output text)"
echo "Bucket creado: $bucket_name"
```

#### Opción B: Simulación local (contingencia)

```bash
# Simular creación de recursos
mkdir -p .infra-simulada/s09-equipoXX
echo '{"equipo": "XX", "fecha": "'$(date +%F)'", "tipo": "simulacion"}' \
  > .infra-simulada/s09-equipoXX/evidencia.json

# Verificar simulación
cat .infra-simulada/s09-equipoXX/evidencia.json
```

## Validación y evidencia

### Evidencia mínima requerida:

1. **Git**: Captura de PR creado, estado del repositorio (`git log --oneline --graph -5`)
2. **Contenedores**: imagen LibreReserva construida, `/salud/viva`, reserva `201`, repetición `409` y lista vacía tras reiniciar
3. **Entorno**: Archivo `docs/entorno.md` completado
4. **Infraestructura, solo si el docente habilitó la demostración opcional**:
   - AWS: Nombre del bucket y estado de la pila
   - Cloud Privado: Evidencia según guía institucional
   - Local: Archivo de simulación `.infra-simulada/...`

### Limpieza:

En la ruta principal, detenga y retire únicamente el contenedor de la [práctica guiada](../../../modules/01_entorno/PRACTICA_CONTENEDORES.md). Los siguientes comandos corresponden solo a recursos del anexo opcional que efectivamente haya creado.

```bash
# AWS Learner Lab
./aws-learner-lab/scripts/stack.sh delete libre-reserva-s09-equipoXX --apply

# Local
rm -rf .infra-simulada/s09-equipoXX

# Git (opcional - mantener rama para referencia)
# git push origin --delete sesion9-equipoXX
# git branch -d sesion9-equipoXX
```

## Adaptaciones para diferentes contextos

### Si AWS Learner Lab no está disponible:

- Complete la práctica local de LibreReserva; no necesita simular infraestructura ni crear otra cuenta.
- Si la institución ya ofrece una máquina remota, use las instrucciones de acceso aprobadas.

### Si hay problemas con Docker/Podman:

- Revisar el motor y los permisos con la guía de entorno; usar un equipo de pareja si el motor sigue sin funcionar
- O saltar a sección de verificación teórica

### Si el tiempo es limitado:

- Priorizar **Git colaborativo** (hora 1)
- Mantener la prueba de LibreReserva en un contenedor y su reinicio.
- Trabajar en parejas con un motor operativo; no añadir el anexo de infraestructura.

## Material de apoyo adicional

- [Guía completa de Git](https://github.com/eshernan/big-data-postgraduate/blob/main/docs/guia-git/README.md)
- [Documentación oficial de Docker](https://docs.docker.com/)
- [Documentación de Podman](https://docs.podman.io/)
- [AWS Academy Learner Lab](https://aws.amazon.com/training/awsacademy/)

**Nota:** Esta sesión establece las bases técnicas para las semanas siguientes. La flexibilidad en infraestructura permite adaptarse a las capacidades institucionales disponibles.
