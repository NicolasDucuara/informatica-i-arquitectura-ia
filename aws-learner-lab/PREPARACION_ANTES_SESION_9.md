# Preparación antes de la sesión 9

**Sesión:** Docker y despliegue local
**Fecha:** miércoles 14 de octubre de 2026, 6:00–10:00 p. m.

Esta guía conserva la preparación necesaria para la línea base del segundo bloque. La sesión ya realizada utilizó Docker, construyó la imagen de LibreReserva y probó el despliegue local.

## Preparación del estudiante

1. Clone la revisión indicada por el docente:

```bash
git clone --branch update_esteban https://github.com/eshernan/informatica-i-arquitectura-ia.git
cd informatica-i-arquitectura-ia
```

2. Instale Docker siguiendo la [guía de entorno](../modules/01_entorno/README.md).
3. Compruebe el motor:

```bash
docker info
docker run --rm docker.io/library/hello-world
```

4. Compruebe la base del repositorio:

```bash
./scripts/check_environment.sh
make test
```

5. Registre sistema operativo, versión de Docker y resultados.

## Preparación docente

- Verifique que el Containerfile construya desde un clon limpio.
- Ejecute la API en el puerto 8000.
- Pruebe salud, creación, conflicto y consulta.
- Recree el contenedor y compruebe que las reservas desaparecen.
- Use esa pérdida de estado como entrada para la arquitectura objetivo de la semana 10 y PostgreSQL en la semana 11.

## Preparación posterior

Antes de la sesión 11, cada equipo debe comprobar Compose:

```bash
docker compose version
./modules/06_apis_datos_eventos/start_services.sh --motor docker
```

No se requiere preparar Kubernetes, un broker de mensajes, una segunda base de datos ni una cuenta AWS personal.

## Credenciales

- Ninguna credencial se copia a Git, chats o evidencias.
- Las variables del ambiente local se documentan mediante nombres y ejemplos sin valores reales.
- Las credenciales temporales de Learner Lab solo se usan en actividades oficiales que el docente haya habilitado.

## Criterio de habilitación

La ruta continúa cuando el equipo puede construir y ejecutar LibreReserva con Docker. Los problemas de instalación se resuelven antes de la sesión 11 o trabajando temporalmente en pareja; no se cambia la arquitectura por dificultades de preparación.
