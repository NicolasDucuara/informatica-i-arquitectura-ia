# Preparación obligatoria antes de la sesión 9 - REESTRUCTURADA

**Sesión 9: Entorno reproducible, Git colaborativo y contenedores**
**Fecha:** Miércoles 14 de octubre de 2026, 6:00–10:00 p. m.

Esta actividad debe completarse por docentes y estudiantes antes de las 6:00 p. m. del 14 de octubre.

## Cambios principales para esta sesión

La sesión 9 se ha reestructurado para abordar temas pendientes identificados:
1. **Git colaborativo** - Uso práctico de fork, ramas y PRs
2. **Contenedores básicos** - Docker/Podman para entornos reproducibles
3. **Infraestructura flexible** - AWS Learner Lab O Cloud Privado O entorno local

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
   - Preparar materiales para simulación local
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

1. Acepte la invitación a la clase con su cuenta institucional.
2. Inicie Learner Lab y ubique el acceso a la consola de AWS.
3. Abra CloudShell si está habilitado. Si no lo está, instale AWS CLI v2 en su equipo y use únicamente las credenciales temporales entregadas por el laboratorio.
4. Clone este repositorio y compruebe el entorno local:

```bash
git clone https://github.com/eshernan/informatica-i-arquitectura-ia.git
cd informatica-i-arquitectura-ia
./scripts/check_environment.sh
./scripts/install_base.sh          # muestra el plan
./scripts/install_base.sh --apply  # solo después de revisarlo
./scripts/setup_python.sh --apply
./aws-learner-lab/scripts/check_preparation.sh
make test
```

5. Registre en la entrega previa: identificador de cuenta parcialmente oculto, región, servicios disponibles, salida de `make test` y cualquier restricción encontrada.
6. Repase los conceptos equivalentes a AWS Academy Cloud Foundations: regiones y zonas, responsabilidad compartida, IAM, cómputo, almacenamiento, redes, bases de datos, monitoreo y costos.

### Preparación escalonada de contenedores

Podman no es necesario en la sesión 9 y `kind` no es necesario hasta la sesión 14. Para evitar dedicar esa clase a instalaciones, complete antes del 18 de noviembre la [instalación de Podman](../modules/08_entrega_plataforma/README.md) y las guías oficiales de `kubectl` y `kind` enlazadas allí. Después ejecute:

```bash
./aws-learner-lab/scripts/check_preparation.sh --full
podman info
kind version
kubectl version --client
```

El docente publica este recordatorio al terminar la sesión 12 y verifica el modo `--full` al inicio de la sesión 14.

## Reglas de credenciales

- No copie valores de `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` o `AWS_SESSION_TOKEN` en un archivo del repositorio, chat, captura o entrega.
- Prefiera CloudShell para evitar transportar credenciales.
- Si usa CLI local, renueve las credenciales cuando el laboratorio se reinicie y elimine el perfil temporal al terminar.
- Nunca use credenciales personales ni una cuenta AWS propia para completar una práctica del curso.

## Criterio de habilitación

La sesión 9 puede empezar su práctica si al menos el 90 % del grupo inicia Learner Lab, obtiene identidad con STS y conoce la región acordada. Los casos pendientes trabajan en pareja durante el encuentro y se resuelven con soporte institucional; no se cambia a cuentas personales.
