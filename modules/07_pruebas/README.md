# Módulo 7. Pruebas y entrega trazable

## Resultado

Construir una estrategia de pruebas por riesgo y relacionar una revisión Git con una imagen OCI reproducible y configurada sin secretos embebidos.

## Instalación paso a paso

```bash
./scripts/setup_python.sh --apply
make check
make test-all
```

Las pruebas de integración requieren PostgreSQL y las migraciones desarrolladas en las sesiones 11–12.

## Pirámide por riesgo

- Unitarias: reglas del dominio rápidas y deterministas.
- Contrato: mismo comportamiento de los adaptadores en memoria y PostgreSQL.
- Integración: migraciones, transacciones, concurrencia e idempotencia.
- HTTP: contrato externo, códigos de error y señales de salud.
- Reproducción: construcción de imagen y arranque desde un clon limpio.

## Ejercicio

1. Mantenga pruebas unitarias para intervalos y conflictos.
2. Ejecute una prueba de contrato contra los dos adaptadores.
3. Pruebe la migración sobre una base vacía.
4. Pruebe dos solicitudes concurrentes incompatibles.
5. Pruebe repetición idempotente y conflicto de clave.
6. Pruebe la diferencia entre vida y disponibilidad.
7. Configure CI para ejecutar la suite antes de construir la imagen.
8. Etiquete la imagen con el commit.
9. Obtenga la conexión a PostgreSQL mediante variable de entorno.
10. Compruebe que la imagen ejecuta un usuario no privilegiado y no contiene secretos.

## Validación

```bash
make check
make test-all
git status --short
```

La cobertura informa qué código se ejecutó, pero no reemplaza aserciones sobre los riesgos. La evidencia debe identificar el commit, el resultado del pipeline y la imagen construida.

**Evidencia:** suite, ejecución CI, identificador de imagen, variables documentadas y revisión de secretos.
