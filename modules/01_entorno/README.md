# Módulo 1. Sistemas modernos y entorno reproducible

## Resultado

Preparar una estación verificable, explicar qué es una decisión arquitectónica y registrar la primera evidencia reproducible.

## Requisitos

- 8 GiB de RAM y 20 GiB libres como referencia mínima.
- GNU/Linux Debian/Ubuntu, macOS o Windows con WSL2.
- Permiso institucional para instalar paquetes.

## Instalación paso a paso

1. Clone el repositorio y entre en él.
2. Revise el instalador; no lo ejecute a ciegas.
3. Muestre el plan sin cambiar el sistema.
4. Aplique el plan solo si coincide con su plataforma.
5. Cree el entorno Python y valide.

```bash
sed -n '1,240p' scripts/install_base.sh
./scripts/install_base.sh
./scripts/install_base.sh --apply
./scripts/setup_python.sh --apply
./scripts/check_environment.sh
make test
```

### Linux nativo con Debian o Ubuntu

Ejecute los comandos en una terminal Bash de su distribución. El instalador anterior reconoce Debian/Ubuntu e instala Podman junto con las herramientas del curso. Linux nativo no necesita WSL2 ni Docker Desktop.

Si solo necesita preparar Git, Python y contenedores, puede instalar este conjunto mínimo en lugar del instalador completo:

```bash
sudo apt-get update
sudo apt-get install -y git make python3 python3-venv python3-pip curl podman
podman --version
podman info
podman run --rm docker.io/library/hello-world
```

Podman se ejecuta directamente sobre Linux. Use su usuario habitual; esta ruta no requiere `podman machine init` ni `podman machine start`. Después, desde la raíz del repositorio, continúe con `./scripts/setup_python.sh --apply` y `make test`.

Para otras distribuciones, siga la [instalación oficial de Podman](https://podman.io/docs/installation). `install_base.sh` automatiza Debian/Ubuntu y macOS; para Fedora, Arch y otras distribuciones, instale también Git, Make, Python, soporte de entornos virtuales y curl con el gestor correspondiente.

### Docker Engine como alternativa en Linux

Elija Docker o Podman para la práctica. `install_base.sh` instala Podman, no Docker. Si elige Docker Engine, siga la instalación oficial de su distribución: [Ubuntu](https://docs.docker.com/engine/install/ubuntu/) o [Debian](https://docs.docker.com/engine/install/debian/).

En sistemas con systemd, compruebe el servicio y ejecute el contenedor de prueba:

```bash
sudo systemctl start docker
sudo docker info
sudo docker run --rm docker.io/library/hello-world
```

Si su usuario ya tiene acceso al motor, puede ejecutar Docker sin `sudo`. La pertenencia al grupo `docker` concede privilegios equivalentes a root; consulte las [opciones oficiales de acceso y ejecución sin root](https://docs.docker.com/engine/install/linux-postinstall/) antes de cambiar permisos. Mantenga el mismo modo de ejecución al construir y ejecutar imágenes.

### macOS y Podman

```bash
podman machine init     # una vez
podman machine start
podman info
```

### Windows

Instale WSL2 con la guía oficial de Microsoft, cree una distribución Debian/Ubuntu y ejecute los pasos GNU/Linux dentro de WSL. Los comandos Bash de esta guía se ejecutan en esa terminal, no en PowerShell. Guarde el repositorio bajo `/home`, no en una unidad montada, para conservar rendimiento y permisos.

## Ejercicio

Complete `docs/entorno.md` con sistema, arquitectura, RAM, versiones y desviaciones. Cree una rama, ejecute las pruebas y confirme solo el documento.

## Validación

```bash
git status --short
python3 --version
make check
```

Compruebe también el motor elegido con `podman info`, `docker info` o `sudo docker info`, según la instalación. Para construir y ejecutar LibreReserva, siga los [ejemplos Docker y Podman de la API](../../labs/librereserva/API.md#ejecución-en-contenedores-y-límites-actuales).

**Evidencia:** archivo de entorno, salida de validación y explicación de una decisión tomada durante la instalación.
