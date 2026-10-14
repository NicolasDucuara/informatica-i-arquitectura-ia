# Módulo 1. Sistemas modernos y entorno reproducible

## Resultado

Preparar una estación verificable, explicar qué es una decisión arquitectónica y registrar la primera evidencia reproducible.

## Requisitos

- 8 GiB de RAM y 20 GiB libres como referencia mínima.
- GNU/Linux Debian/Ubuntu, macOS o Windows con WSL2.
- Permiso institucional para instalar paquetes.

## Instalación paso a paso

Todos los comandos se ejecutan desde la raíz del repositorio. Los materiales de esta sesión están en `update_esteban`:

```bash
git clone --branch update_esteban https://github.com/eshernan/informatica-i-arquitectura-ia.git
cd informatica-i-arquitectura-ia
```

Si ya tiene el repositorio, revise `git status` y guarde sus cambios antes de cambiar de rama. Para actualizar una copia limpia:

```bash
git fetch origin
git switch update_esteban
git pull --ff-only origin update_esteban
```

Elija una ruta de contenedores:

| Sistema y motor | Instrucciones | Instalador |
|---|---|---|
| Ubuntu 22.04, 24.04 o 26.04 con Docker, incluido EC2 | [Docker en Ubuntu y EC2](#instalación-con-script-en-ubuntu-y-ec2) | [install_docker_ubuntu.sh](../../scripts/install_docker_ubuntu.sh) |
| Debian/Ubuntu con Podman | [Linux nativo con Podman](#linux-nativo-con-debian-o-ubuntu) | [install_base.sh](../../scripts/install_base.sh) |
| macOS con Podman | [Máquina de Podman](#macos-y-podman) | [install_base.sh](../../scripts/install_base.sh) |
| Windows con WSL2 | [Terminal Linux en Windows](#windows) | La ruta Ubuntu o Debian elegida dentro de WSL2 |

Para la ruta Podman, revise y aplique el instalador general:

```bash
sed -n '1,240p' scripts/install_base.sh
./scripts/install_base.sh
./scripts/install_base.sh --apply
```

Después de preparar las herramientas del sistema con la ruta elegida, cree el entorno Python y valide:

```bash
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

#### Instalación con script en Ubuntu y EC2

Use el [instalador Docker para Ubuntu](../../scripts/install_docker_ubuntu.sh). Para Ubuntu 22.04, 24.04 y **26.04 LTS (Resolute)**, desde la raíz del repositorio:

```bash
cat /etc/os-release
sed -n '1,240p' scripts/install_docker_ubuntu.sh
./scripts/install_docker_ubuntu.sh          # muestra el plan sin instalar
./scripts/install_docker_ubuntu.sh --apply  # instala y verifica Docker
```

El script detecta la versión y arquitectura, configura el repositorio oficial e instala Docker Engine, Buildx y Compose. Requiere acceso a Internet y permisos sudo; detiene la instalación si encuentra paquetes incompatibles, sin eliminarlos automáticamente. En EC2 use estos pasos dentro de la sesión SSH de la instancia Ubuntu. Amazon Linux y Debian no son compatibles con este script.

Docker no instala las herramientas Python del curso. Si aún no están disponibles:

```bash
sudo apt-get update
sudo apt-get install -y git make python3 python3-venv python3-pip curl
./scripts/setup_python.sh --apply
make test
```

Después construya y ejecute la API desde la raíz del repositorio:

```bash
sudo docker build -f labs/librereserva/Containerfile -t localhost/librereserva:0.1.0 labs/librereserva
sudo docker run --rm -p 127.0.0.1:8000:8000 localhost/librereserva:0.1.0
```

En otra terminal SSH, compruebe `curl -fsS http://127.0.0.1:8000/salud/viva`. Para abrir la API en el navegador de su computador, cree un túnel desde ese computador con `ssh -i /ruta/clave.pem -L 8000:127.0.0.1:8000 ubuntu@HOST_EC2` y visite `http://127.0.0.1:8000/docs`. Sustituya la clave y el host por los de su instancia; el túnel usa el acceso SSH existente.

#### Diagnóstico de paquetes

En una instancia EC2, identifique primero la distribución de la imagen; EC2 no implica que el sistema sea Ubuntu:

```bash
cat /etc/os-release
```

Si `apt` muestra `Package 'docker' has no installation candidate`, no use `sudo apt install docker` para instalar Docker Engine. La ruta oficial para Ubuntu/Debian requiere configurar primero el repositorio de Docker correspondiente a esa distribución y luego instalar estos paquetes:

```bash
# Solo después de configurar el repositorio oficial de su distribución
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Compruebe que `apt-get update` finalice correctamente. Si `docker-ce` tampoco tiene candidato, revise la configuración del repositorio y la versión soportada en la guía oficial. Amazon Linux usa otra ruta de instalación; no aplique los pasos `apt` de Ubuntu/Debian a esa imagen.

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
