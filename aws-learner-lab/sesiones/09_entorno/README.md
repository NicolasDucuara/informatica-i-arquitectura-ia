# Sesión 9 — Entorno reproducible, Git colaborativo y contenedores

**Fecha:** 14 de octubre de 2026, 6:00–10:00 p. m.
**Resultado:** Configurar entorno local reproducible, dominar flujo Git colaborativo, introducir contenedores básicos y conectar con infraestructura en la nube (AWS Learner Labs o Cloud Privado).

## Montaje docente

Publique `S09 — Entorno, Git y contenedores` con enlaces a:
- Este archivo
- `PREPARACION_ANTES_SESION_9.md`
- Guía de Git: https://github.com/eshernan/big-data-postgraduate/blob/main/docs/guia-git/README.md
- `s09-foundation.yaml` (opcional para AWS)
- Plantilla de evidencia

Configure entrega para las 10:10 p. m. Indique opciones:
1. **AWS Learner Lab** (si está habilitado)
2. **Cloud Privado Universitario** (alternativa institucional)
3. **Entorno local completo** (contingencia)

## Secuencia de cuatro horas - REESTRUCTURADA

### Hora 1 (6:00-7:00 p.m.): Git colaborativo en la práctica
| Tiempo | Tema y acción |
|---|---|
| 6:00–6:30 | **Activación y configuración Git**<br>- Verificar instalación: `git --version`<br>- Configurar identidad: `git config --global user.name/email`<br>- Revisar guía de Git (escenarios E1-E3) |
| 6:30–7:00 | **Ejercicio práctico en parejas**<br>- Fork del repositorio actual<br>- Configuración de remotos: `origin` (fork), `upstream` (original)<br>- Primer commit y PR siguiendo la guía |

### Hora 2 (7:00-8:00 p.m.): Entorno reproducible y contenedores
| Tiempo | Tema y acción |
|---|---|
| 7:00–7:30 | **Verificación entorno local**<br>- `./scripts/check_environment.sh`<br>- `./scripts/install_base.sh --apply` (si necesario)<br>- `./scripts/setup_python.sh --apply`<br>- Completar `docs/entorno.md` |
| 7:30–8:00 | **Introducción a contenedores**<br>- Docker vs Podman<br>- Ejecutar contenedor simple: `docker run hello-world` o `podman run hello-world`<br>- Construir imagen básica |

### Hora 3 (8:00-9:00 p.m.): Infraestructura en la nube
| Tiempo | Tema y acción |
|---|---|
| 8:00–8:30 | **Opción A: AWS Learner Lab**<br>- Acceder a Learner Lab<br>- Configurar región: `export AWS_REGION=REGION_ACORDADA`<br>- Verificar acceso: `./aws-learner-lab/scripts/check_preparation.sh`<br><br>**Opción B: Cloud Privado Universitario**<br>- Configurar acceso según instrucciones institucionales<br>- Verificar conectividad |
| 8:30–9:00 | **Despliegue de pila básica**<br>- AWS: `./aws-learner-lab/scripts/stack.sh deploy ...`<br>- Cloud Privado: Seguir guía institucional<br>- Local: Simulación con scripts |

### Hora 4 (9:00-10:00 p.m.): Integración y evidencia
| Tiempo | Tema y acción |
|---|---|
| 9:00–9:30 | **Integración de componentes**<br>- Commit con cambios en Git<br>- Contenedor con aplicación simple<br>- Infraestructura desplegada o simulada<br>- PR final con evidencia integrada |
| 9:30–10:00 | **Validación, limpieza y cierre**<br>- Ejecutar pruebas: `make test`<br>- Limpiar recursos (AWS/Cloud)<br>- Registrar evidencia final<br>- Revisar PRs creados |

## Talleres prácticos

### Taller 1: Git colaborativo (Parejas)
```bash
# Estudiante A y B trabajan juntos
# 1. Clonar repositorio
git clone https://github.com/eshernan/informatica-i-arquitectura-ia.git
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

# 6. Crear PR en GitHub desde sesion9-equipoXX hacia dev
```

### Taller 2: Contenedores básicos
```bash
# Verificar Docker/Podman
docker --version || podman --version

# Ejecutar contenedor de prueba
docker run --rm hello-world

# Construir imagen simple
cat > Dockerfile.simple << 'EOF'
FROM alpine:latest
RUN echo "¡Contenedor funcionando!" > /mensaje.txt
CMD cat /mensaje.txt
EOF

docker build -f Dockerfile.simple -t prueba-sesion9 .
docker run --rm prueba-sesion9
```

### Taller 3: Infraestructura (opciones)

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
echo '{"equipo": "XX", "fecha": "'$(date -I)'", "tipo": "simulacion"}' \
  > .infra-simulada/s09-equipoXX/evidencia.json

# Verificar simulación
cat .infra-simulada/s09-equipoXX/evidencia.json
```

## Validación y evidencia

### Evidencia mínima requerida:
1. **Git**: Captura de PR creado, estado del repositorio (`git log --oneline --graph -5`)
2. **Contenedores**: Salida de `docker run hello-world` o equivalente
3. **Entorno**: Archivo `docs/entorno.md` completado
4. **Infraestructura**:
   - AWS: Nombre del bucket y objeto subido
   - Cloud Privado: Evidencia según guía institucional
   - Local: Archivo de simulación `.infra-simulada/...`

### Limpieza:
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
- Usar **Cloud Privado Universitario** siguiendo guía institucional
- O completar **ruta local completa** con simulación

### Si hay problemas con Docker/Podman:
- Usar contenedores preconstruidos: `docker run -it python:3.11-slim bash`
- O saltar a sección de verificación teórica

### Si el tiempo es limitado:
- Priorizar **Git colaborativo** (hora 1)
- Luego **entorno local** (hora 2)
- **Infraestructura** como demostración docente

## Material de apoyo adicional
- [Guía completa de Git](https://github.com/eshernan/big-data-postgraduate/blob/main/docs/guia-git/README.md)
- [Documentación oficial de Docker](https://docs.docker.com/)
- [Documentación de Podman](https://docs.podman.io/)
- [AWS Academy Learner Lab](https://aws.amazon.com/training/awsacademy/)

**Nota:** Esta sesión establece las bases técnicas para las semanas siguientes. La flexibilidad en infraestructura permite adaptarse a las capacidades institucionales disponibles.
