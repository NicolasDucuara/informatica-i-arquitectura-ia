# Preparación obligatoria antes de la sesión 9 - REESTRUCTURADA

**Sesión 9: Entorno reproducible, Git colaborativo y contenedores**
**Fecha:** Miércoles 14 de octubre de 2026, 6:00–10:00 p. m.

Esta actividad debe completarse por docentes y estudiantes antes de las 6:00 p. m. del 14 de octubre.

## Cambios principales para esta sesión

La sesión 9 se ha reestructurado para abordar temas pendientes identificados:
1. **Git colaborativo** - Uso práctico de fork, ramas y PRs
2. **Contenedores básicos** - Docker/Podman para entornos reproducibles
3. **Una aplicación conocida** - LibreReserva local, primero en `.venv` y luego en un contenedor

La [ruta por sesiones](../docs/RUTA_CONTENEDORES.md) reserva Compose/YAML para sesión 12, persistencia para sesión 13 y Kubernetes para sesión 14. AWS es opcional en sesión 9; no prepare bases de datos, colas ni clústeres para la primera práctica. La [guía breve](../modules/01_entorno/PRACTICA_CONTENEDORES.md) contiene el recorrido y la evidencia mínima.

## Preparación institucional y docente

### Opciones de infraestructura (seleccionar una):
1. **AWS Learner Lab** (preferido si disponible):
   - Verificar membresía activa de la institución en AWS Academy
   - Clase de Learner Lab creada para Informática I, segundo semestre 2026
   - Estudiantes invitados con correo institucional
   - Región común configurada

2. **Cloud Privado Universitario** (alternativa institucional):
   - Configurar acceso para todos los estudiantes
   - Proporcionar credenciales o mecanismo de acceso
   - Verificar cuotas y servicios disponibles

3. **Entorno local completo** (contingencia):
   - Preparar la API LibreReserva y su Containerfile
   - Verificar que todos pueden ejecutar contenedores localmente

### Verificaciones técnicas comunes:
- Acceso a Git y GitHub funcionando
- Docker o Podman disponibles
- Python 3.x instalado
- Memoria suficiente (mínimo 8 GB RAM recomendado)

## Prueba docente de configuración completa

```bash
# 1. Verificar entorno general
./scripts/check_sesion9_prep.sh

# 2. Verificar Git específicamente
./scripts/check_git_setup.sh

# 3. Verificar contenedores
./scripts/check_container_tools.sh

# 4. Si usando AWS Learner Lab:
export AWS_REGION=REGION_ACORDADA
./aws-learner-lab/scripts/check_preparation.sh

# 5. Probar despliegue AWS (opcional)
./aws-learner-lab/scripts/stack.sh deploy \
  libre-reserva-s09-docente \
  aws-learner-lab/templates/s09-foundation.yaml --apply

# 6. Limpiar prueba AWS
./aws-learner-lab/scripts/stack.sh delete \
  libre-reserva-s09-docente --apply
```

## Preparación del estudiante

1. Prepare Git y acceso a GitHub; cree el fork del equipo.
2. Clone la rama utilizada en la sesión:

```bash
git clone --branch update_esteban https://github.com/eshernan/informatica-i-arquitectura-ia.git
cd informatica-i-arquitectura-ia
```

3. Elija Docker o Podman en la [guía de entorno](../modules/01_entorno/README.md). Para Ubuntu 26.04 en EC2, siga [Docker en Ubuntu y EC2](../modules/01_entorno/README.md#instalación-con-script-en-ubuntu-y-ec2) y revise el [instalador](../scripts/install_docker_ubuntu.sh).
4. Complete el entorno Python y las pruebas:

```bash
./scripts/setup_python.sh --apply
./scripts/check_environment.sh
make test PYTHON=.venv/bin/python
```

5. Registre sistema operativo, versiones, motor elegido y resultado de pruebas en `docs/entorno.md`.
6. Si participa en la ruta AWS, acepte la invitación institucional, inicie Learner Lab y use CloudShell o AWS CLI con credenciales temporales. Ejecute `./aws-learner-lab/scripts/check_preparation.sh` y registre región y restricciones. Esta comprobación no es requisito para la práctica local de Git y contenedores.

### Preparación escalonada de contenedores

Docker o Podman debe estar instalado y funcionando para la sesión 9 del 14 de octubre. Siga la [guía de instalación del entorno](../modules/01_entorno/README.md), que incluye Linux nativo Debian/Ubuntu, macOS y Windows con WSL2. En Linux nativo, Podman se ejecuta directamente; la máquina de Podman indicada para macOS no es un requisito de esa ruta. Compruebe el motor con `podman info` o `docker info` y ejecute un contenedor de prueba antes de clase.

`kind` y `kubectl` se requieren en la sesión 14. Complete su instalación antes del 18 de noviembre siguiendo las guías oficiales enlazadas en el [módulo de entrega y plataforma](../modules/08_entrega_plataforma/README.md). Para esa sesión, la ruta de Kubernetes del repositorio utiliza Podman. Después ejecute:

```bash
./aws-learner-lab/scripts/check_preparation.sh --full
podman info
kind version
kubectl version --client
```

El docente publica este recordatorio al terminar la sesión 12 y verifica el modo `--full` al inicio de la sesión 14.

Antes de sesión 12, verifique también `podman compose version` o `docker compose version`. Si solo instaló Podman, instale su proveedor Compose siguiendo el [laboratorio](../modules/06_apis_datos_eventos/LABORATORIO.md). No sustituya una comprobación fallida por instalar otro motor durante la clase.

## Reglas de credenciales

- No copie valores de `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` o `AWS_SESSION_TOKEN` en un archivo del repositorio, chat, captura o entrega.
- Prefiera CloudShell para evitar transportar credenciales.
- Si usa CLI local, renueve las credenciales cuando el laboratorio se reinicie y elimine el perfil temporal al terminar.
- Nunca use credenciales personales ni una cuenta AWS propia para completar una práctica del curso.

## Criterio de habilitación

La práctica de Git y contenedores puede comenzar cuando los equipos disponen de Git, acceso al fork y un motor Docker o Podman operativo, localmente o en una instancia Ubuntu institucional. Los casos pendientes trabajan en pareja. Solo el ejercicio AWS requiere identidad temporal y región acordada; si Learner Lab no está habilitado, se utiliza la ruta local sin recurrir a cuentas personales.
