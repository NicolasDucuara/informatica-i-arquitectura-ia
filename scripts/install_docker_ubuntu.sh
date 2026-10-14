#!/usr/bin/env bash
set -euo pipefail

mode="${1:-plan}"
if (($# > 1)) || [[ "$mode" != plan && "$mode" != --apply ]]; then
  printf 'Uso: %s [--apply]\n' "$0" >&2
  exit 2
fi

if [[ "$(uname -s)" != Linux || ! -r /etc/os-release ]]; then
  printf 'Este instalador requiere Ubuntu Linux.\n' >&2
  exit 2
fi
. /etc/os-release
if [[ "${ID:-}" != ubuntu ]]; then
  printf 'Distribución no soportada: %s. Este script es exclusivo de Ubuntu.\n' "${ID:-desconocida}" >&2
  exit 2
fi
case "${VERSION_ID:-}:${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}" in
  22.04:jammy|24.04:noble|26.04:resolute) ;;
  *) printf 'Versión Ubuntu no contemplada; revise https://docs.docker.com/engine/install/ubuntu/\n' >&2; exit 2 ;;
esac
codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
architecture="$(dpkg --print-architecture)"

printf 'Plan Ubuntu %s (%s), arquitectura %s:\n' "$VERSION_ID" "$codename" "$architecture"
printf '%s\n' \
  '  Instalar ca-certificates y curl.' \
  '  Configurar la clave y el repositorio oficial de Docker para esta versión.' \
  '  Instalar docker-ce, docker-ce-cli, containerd.io, Buildx y Compose.' \
  '  Iniciar el servicio Docker y ejecutar hello-world con sudo.' \
  '  No cambiar grupos de usuarios ni eliminar paquetes existentes.'
if [[ "$mode" != --apply ]]; then
  printf 'No se hicieron cambios. Revise el script y repita con --apply.\n'
  exit 0
fi

# No quitar automáticamente motores o runtimes que puedan estar en uso.
for package in docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc; do
  if [[ "$(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true)" == 'install ok installed' ]]; then
    printf 'Paquete incompatible instalado: %s. Revise su uso y la guía oficial antes de continuar.\n' "$package" >&2
    exit 1
  fi
done

privilege=()
if ((EUID != 0)); then
  command -v sudo >/dev/null 2>&1 || { printf 'Se requiere sudo o root.\n' >&2; exit 1; }
  privilege=(sudo)
fi
command -v systemctl >/dev/null 2>&1 || { printf 'Este script requiere systemd para iniciar Docker.\n' >&2; exit 1; }

"${privilege[@]}" apt-get update
"${privilege[@]}" apt-get install -y ca-certificates curl
"${privilege[@]}" install -m 0755 -d /etc/apt/keyrings
"${privilege[@]}" curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
"${privilege[@]}" chmod a+r /etc/apt/keyrings/docker.asc
"${privilege[@]}" tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $codename
Components: stable
Architectures: $architecture
Signed-By: /etc/apt/keyrings/docker.asc
EOF
"${privilege[@]}" apt-get update
"${privilege[@]}" apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
"${privilege[@]}" systemctl start docker
"${privilege[@]}" docker info >/dev/null
"${privilege[@]}" docker run --rm docker.io/library/hello-world
"${privilege[@]}" docker compose version
printf 'Docker disponible. Use sudo docker si su usuario no tiene acceso al motor.\n'
