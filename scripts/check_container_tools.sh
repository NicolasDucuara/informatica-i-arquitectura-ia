#!/usr/bin/env bash
set -euo pipefail

echo "=== Verificación de herramientas de contenedores ==="
echo

# Verificar Docker
if command -v docker >/dev/null 2>&1; then
    echo "✅ Docker instalado: $(docker --version)"
    
    # Verificar que Docker daemon esté ejecutándose
    if docker info >/dev/null 2>&1; then
        echo "✅ Docker daemon funcionando"
    else
        echo "⚠️  Docker daemon no está ejecutándose"
        echo "  En macOS: Abrir Docker Desktop"
        echo "  En Linux: sudo systemctl start docker"
        echo "  En WSL2: Verificar que Docker Desktop esté instalado y ejecutándose"
    fi
else
    echo "ℹ️  Docker no está instalado"
fi

# Verificar Podman
if command -v podman >/dev/null 2>&1; then
    echo "✅ Podman instalado: $(podman --version)"
    
    # Verificar máquina Podman (macOS)
    if [[ "$(uname -s)" == "Darwin" ]]; then
        if podman machine list | grep -q running; then
            echo "✅ Podman machine ejecutándose"
        else
            echo "⚠️  Podman machine no está ejecutándose"
            echo "  Ejecute: podman machine start"
        fi
    fi
else
    echo "ℹ️  Podman no está instalado"
fi

# Verificar al menos una herramienta disponible
if ! command -v docker >/dev/null 2>&1 && ! command -v podman >/dev/null 2>&1; then
    echo
    echo "❌ Ninguna herramienta de contenedores está instalada"
    echo "  Instale Docker o Podman según su sistema:"
    echo "  - Docker: https://docs.docker.com/get-docker/"
    echo "  - Podman: https://podman.io/getting-started/installation"
    exit 1
fi

# Probar contenedor simple
echo
echo "=== Prueba de contenedor básico ==="

container_tool=""
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    container_tool="docker"
elif command -v podman >/dev/null 2>&1; then
    container_tool="podman"
fi

if [[ -n "$container_tool" ]]; then
    echo "Probando con $container_tool..."
    
    # Intentar ejecutar contenedor hello-world
    if $container_tool run --rm hello-world >/tmp/container_test.log 2>&1; then
        echo "✅ Contenedor hello-world ejecutado exitosamente"
        echo "  Salida:"
        grep -A5 "Hello from Docker!" /tmp/container_test.log 2>/dev/null || \
        grep -A5 "Hello from Podman!" /tmp/container_test.log 2>/dev/null || \
        head -10 /tmp/container_test.log | sed 's/^/    /'
    else
        echo "⚠️  No se pudo ejecutar contenedor hello-world"
        echo "  Posibles soluciones:"
        echo "  1. En macOS: Asegurarse que Docker Desktop/Podman machine esté ejecutándose"
        echo "  2. En Linux: Verificar permisos (sudo o agregar usuario al grupo docker)"
        echo "  3. Red de contenedores: $container_tool pull hello-world"
        
        # Intentar pull primero
        echo "  Intentando descargar imagen primero..."
        if $container_tool pull hello-world; then
            if $container_tool run --rm hello-world; then
                echo "✅ ¡Funciona después de descargar la imagen!"
            fi
        fi
    fi
    rm -f /tmp/container_test.log
fi

# Mostrar comandos básicos
echo
echo "=== Comandos esenciales de contenedores ==="
echo "  $container_tool --version           # Ver versión"
echo "  $container_tool images              # Listar imágenes"
echo "  $container_tool ps -a               # Listar contenedores"
echo "  $container_tool run <imagen>        # Ejecutar contenedor"
echo "  $container_tool build -t <nombre> . # Construir imagen"
echo "  $container_tool stop <contenedor>   # Detener contenedor"
echo "  $container_tool rm <contenedor>     # Eliminar contenedor"

# Mostrar ejemplo para sesión 9
echo
echo "=== Ejemplo para la sesión 9 ==="
cat << 'EOF'
# 1. Crear Dockerfile simple
cat > Dockerfile.sesion9 << 'DOCKERFILE'
FROM alpine:latest
RUN echo "¡Contenedor de la sesión 9 funcionando!" > /mensaje.txt
CMD cat /mensaje.txt
DOCKERFILE

# 2. Construir imagen
docker build -f Dockerfile.sesion9 -t sesion9-test .

# 3. Ejecutar contenedor
docker run --rm sesion9-test

# 4. Limpiar
docker rmi sesion9-test
EOF

echo
echo "Para la sesión 9, necesitará:"
echo "1. Docker o Podman funcionando"
echo "2. Capacidad de ejecutar contenedor hello-world"
echo "3. Permisos para construir imágenes simples"

# Verificar recursos del sistema
echo
echo "=== Recursos del sistema ==="
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Sistema: macOS"
    memory_mb=$(sysctl -n hw.memsize 2>/dev/null | awk '{print int($1/1024/1024)}')
    [[ -n "$memory_mb" ]] && echo "Memoria RAM: $memory_mb MB"
elif [[ "$(uname -s)" == "Linux" ]]; then
    echo "Sistema: Linux"
    memory_mb=$(free -m | awk '/^Mem:/ {print $2}')
    [[ -n "$memory_mb" ]] && echo "Memoria RAM: $memory_mb MB"
fi

echo "Requisito mínimo recomendado: 8 GB RAM, 20 GB disco libre"