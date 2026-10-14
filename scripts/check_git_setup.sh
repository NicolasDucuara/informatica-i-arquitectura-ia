#!/usr/bin/env bash
set -euo pipefail

echo "=== Verificación de configuración Git ==="
echo

# Verificar instalación de Git
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git no está instalado"
    echo "  Instale Git según su sistema:"
    echo "  - macOS: brew install git"
    echo "  - Debian/Ubuntu: sudo apt-get install git"
    echo "  - Windows: Descargar desde https://git-scm.com/"
    exit 1
else
    echo "✅ Git instalado: $(git --version)"
fi

# Verificar configuración básica
echo
echo "=== Configuración de usuario Git ==="

git_user_name=$(git config --global user.name || echo "NO CONFIGURADO")
git_user_email=$(git config --global user.email || echo "NO CONFIGURADO")

if [[ "$git_user_name" == "NO CONFIGURADO" ]]; then
    echo "⚠️  Nombre de usuario Git no configurado"
    echo "  Ejecute: git config --global user.name \"Su Nombre\""
else
    echo "✅ Nombre: $git_user_name"
fi

if [[ "$git_user_email" == "NO CONFIGURADO" ]]; then
    echo "⚠️  Email Git no configurado"
    echo "  Ejecute: git config --global user.email \"su.email@institucion.edu\""
else
    echo "✅ Email: $git_user_email"
fi

# Verificar repositorio actual
echo
echo "=== Estado del repositorio actual ==="

if git rev-parse --git-dir >/dev/null 2>&1; then
    echo "✅ Está dentro de un repositorio Git"
    
    current_branch=$(git branch --show-current)
    echo "  Rama actual: $current_branch"
    
    echo "  Remotos configurados:"
    git remote -v | sed 's/^/    /'
    
    echo "  Últimos commits:"
    git log --oneline -3 | sed 's/^/    /'
else
    echo "ℹ️  No está dentro de un repositorio Git"
    echo "  Para clonar: git clone https://github.com/eshernan/informatica-i-arquitectura-ia.git"
fi

# Verificar conocimiento básico de comandos
echo
echo "=== Comandos Git esenciales ==="
echo "  git clone <url>           # Clonar repositorio"
echo "  git status                 # Ver estado actual"
echo "  git add <archivo>         # Preparar cambios"
echo "  git commit -m \"mensaje\"   # Crear commit"
echo "  git push                  # Enviar cambios al remoto"
echo "  git pull                  # Traer cambios del remoto"
echo "  git branch                # Listar ramas"
echo "  git checkout <rama>       # Cambiar de rama"
echo "  git merge <rama>          # Fusionar ramas"

echo
echo "=== Para la sesión 9 ==="
echo "1. Crear fork en GitHub"
echo "2. Clonar repositorio: git clone https://github.com/eshernan/informatica-i-arquitectura-ia.git"
echo "3. Configurar remotos:"
echo "   git remote rename origin upstream"
echo "   git remote add origin URL_DEL_TU_FORK"
echo "4. Crear rama: git checkout -b sesion9-equipoXX"
echo "5. Trabajar, commit y push"
echo "6. Crear Pull Request en GitHub"

echo
echo "Para más detalles, vea la guía completa:"
echo "https://github.com/eshernan/big-data-postgraduate/blob/main/docs/guia-git/README.md"