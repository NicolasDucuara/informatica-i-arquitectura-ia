#!/usr/bin/env bash
set -euo pipefail

echo "══════════════════════════════════════════════════════════════════════"
echo "   VERIFICACIÓN DE PREPARACIÓN - SESIÓN 9 - Miércoles 14 oct 2026"
echo "   Entorno reproducible, Git colaborativo y contenedores"
echo "══════════════════════════════════════════════════════════════════════"
echo

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "ℹ️  $1"
}

# Función para pausar y continuar
pause_if_interactive() {
    if [[ -t 0 ]]; then
        echo
        read -p "Presione Enter para continuar..." -r
    fi
}

print_section "1. SISTEMA OPERATIVO Y RECURSOS"
echo "Fecha: $(date)"
echo "Sistema: $(uname -s) $(uname -r)"
echo "Hostname: $(hostname)"

# Verificar recursos
if [[ "$(uname -s)" == "Darwin" ]]; then
    memory_mb=$(sysctl -n hw.memsize 2>/dev/null | awk '{print int($1/1024/1024)}')
    [[ -n "$memory_mb" ]] && echo "Memoria RAM: $memory_mb MB"
elif [[ "$(uname -s)" == "Linux" ]]; then
    memory_mb=$(free -m | awk '/^Mem:/ {print $2}')
    [[ -n "$memory_mb" ]] && echo "Memoria RAM: $memory_mb MB"
fi

echo "Directorio actual: $(pwd)"

pause_if_interactive

print_section "2. HERRAMIENTAS ESENCIALES"
essential_tools=(git make python3)
all_essential_ok=true

for tool in "${essential_tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        print_success "$tool: $(command -v "$tool") ($($tool --version 2>&1 | head -1))"
    else
        print_error "$tool: NO INSTALADO"
        all_essential_ok=false
    fi
done

if ! $all_essential_ok; then
    print_warning "Faltan herramientas esenciales. Ejecute:"
    echo "  ./scripts/install_base.sh --apply"
    echo "  ./scripts/setup_python.sh --apply"
fi

pause_if_interactive

print_section "3. CONFIGURACIÓN GIT"
echo "Usuario Git configurado:"
git_user_name=$(git config --global user.name || echo "NO CONFIGURADO")
git_user_email=$(git config --global user.email || echo "NO CONFIGURADO")

if [[ "$git_user_name" != "NO CONFIGURADO" ]]; then
    print_success "Nombre: $git_user_name"
else
    print_warning "Nombre no configurado"
    echo "  Ejecute: git config --global user.name \"Su Nombre\""
fi

if [[ "$git_user_email" != "NO CONFIGURADO" ]]; then
    print_success "Email: $git_user_email"
else
    print_warning "Email no configurado"
    echo "  Ejecute: git config --global user.email \"su.email@institucion.edu\""
fi

# Verificar si estamos en repositorio correcto
if git rev-parse --git-dir >/dev/null 2>&1; then
    repo_name=$(basename -s .git "$(git config --get remote.origin.url 2>/dev/null || echo "desconocido")")
    print_success "En repositorio Git: $repo_name"
    
    current_branch=$(git branch --show-current)
    echo "  Rama actual: $current_branch"
    
    echo "  Remotos:"
    git remote -v | sed 's/^/    /'
else
    print_warning "No está dentro de un repositorio Git"
    echo "  Para clonar: git clone https://github.com/eshernan/informatica-i-arquitectura-ia.git"
fi

pause_if_interactive

print_section "4. HERRAMIENTAS DE CONTENEDORES"
container_tools_ok=false

# Verificar Docker
if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
        print_success "Docker: $(docker --version)"
        print_success "  Docker daemon funcionando"
        container_tools_ok=true
        CONTAINER_TOOL="docker"
    else
        print_warning "Docker instalado pero daemon no ejecutándose"
    fi
else
    print_info "Docker no instalado"
fi

# Verificar Podman
if command -v podman >/dev/null 2>&1; then
    print_success "Podman: $(podman --version)"
    
    if [[ "$(uname -s)" == "Darwin" ]]; then
        if podman machine list | grep -q running; then
            print_success "  Podman machine ejecutándose"
            container_tools_ok=true
            CONTAINER_TOOL="podman"
        else
            print_warning "  Podman machine no ejecutándose"
            echo "    Ejecute: podman machine start"
        fi
    else
        # En Linux, Podman generalmente funciona sin máquina
        if timeout 5 podman info >/dev/null 2>&1; then
            print_success "  Podman funcionando"
            container_tools_ok=true
            CONTAINER_TOOL="podman"
        fi
    fi
else
    print_info "Podman no instalado"
fi

if $container_tools_ok; then
    print_success "Herramienta de contenedores disponible: $CONTAINER_TOOL"
else
    print_warning "Ninguna herramienta de contenedores lista para usar"
    echo "  Instale Docker o Podman según su sistema"
fi

pause_if_interactive

print_section "5. ENTORNO PYTHON Y PRUEBAS"
if command -v python3 >/dev/null 2>&1; then
    print_success "Python: $(python3 --version)"
    
    # Verificar si podemos ejecutar make test
    if command -v make >/dev/null 2>&1; then
        echo "  Probando entorno Python básico..."
        if python3 -c "import sys; print(f'Python {sys.version} OK')" 2>/dev/null; then
            print_success "  Python básico funcionando"
        else
            print_warning "  Problemas con Python"
        fi
    fi
fi

pause_if_interactive

print_section "6. PREPARACIÓN PARA LA CLASE"
echo "Para la sesión 9 del miércoles 14 de octubre, necesitará:"

echo
echo "📋 CHECKLIST PREPARACIÓN:"
echo "  [ ] 1. Git configurado con nombre y email"
echo "  [ ] 2. Fork del repositorio creado en GitHub"
echo "  [ ] 3. Repositorio clonado localmente"
echo "  [ ] 4. Docker o Podman funcionando"
echo "  [ ] 5. Acceso a AWS Learner Lab o Cloud Privado (opcional)"
echo "  [ ] 6. Documento docs/entorno.md listo para completar"

echo
echo "🎯 OBJETIVOS DE LA SESIÓN:"
echo "  1. Git colaborativo: Fork, ramas, PRs"
echo "  2. Contenedores básicos: Imágenes, ejecución"
echo "  3. LibreReserva: .venv, imagen, API y reinicio"
echo "  4. Evidencia en PR; AWS es opcional y Compose/Kubernetes vienen después"

echo
echo "📚 RECURSOS:"
echo "  • Guía Git: https://github.com/eshernan/big-data-postgraduate/blob/main/docs/guia-git/README.md"
echo "  • Sesión 9: aws-learner-lab/sesiones/09_entorno/README.md"
echo "  • Preparación: aws-learner-lab/PREPARACION_ANTES_SESION_9.md"

pause_if_interactive

print_section "7. VERIFICACIÓN FINAL Y RECOMENDACIONES"
echo "Resumen del estado:"

if $all_essential_ok; then
    print_success "✓ Herramientas esenciales: OK"
else
    print_error "✗ Herramientas esenciales: FALTAN"
    echo "  Ejecute: ./scripts/install_base.sh --apply"
fi

if [[ "$git_user_name" != "NO CONFIGURADO" && "$git_user_email" != "NO CONFIGURADO" ]]; then
    print_success "✓ Configuración Git: OK"
else
    print_warning "⚠ Configuración Git: INCOMPLETA"
fi

if $container_tools_ok; then
    print_success "✓ Herramientas contenedores: OK ($CONTAINER_TOOL)"
else
    print_warning "⚠ Herramientas contenedores: NO LISTAS"
fi

# Recomendaciones finales
echo
print_info "RECOMENDACIONES PARA MAÑANA:"
echo "1. Llegar 10 minutos antes para verificar conexión"
echo "2. Tener fork del repositorio listo"
echo "3. Probar contenedor hello-world antes de clase"
echo "4. Completar docs/entorno.md durante la sesión"
echo "5. Trabajar en parejas para ejercicios Git"

echo
echo "══════════════════════════════════════════════════════════════════════"
echo "  ¡Preparación verificada! Revisar áreas marcadas con ⚠️ o ❌"
echo "  Para ayuda específica, ejecute:"
echo "    ./scripts/check_git_setup.sh       # Para Git"
echo "    ./scripts/check_container_tools.sh # Para contenedores"
echo "    ./scripts/check_environment.sh     # Para entorno general"
echo "══════════════════════════════════════════════════════════════════════"

# Retorno de estado
if $all_essential_ok; then
    exit 0
else
    exit 1
fi
