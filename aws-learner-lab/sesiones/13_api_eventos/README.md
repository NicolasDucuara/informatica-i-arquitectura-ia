# Sesión 13 — Entrega segura y trazable

**Fecha:** 11 de noviembre de 2026, 6:00–10:00 p. m.
**Resultado:** relacionar un cambio revisado con pruebas, una imagen OCI identificable y una configuración que no exponga secretos.

## Secuencia de cuatro horas

| Hora | Tema y acción |
|---|---|
| 6:00–6:20 | revisar el incremento persistente e idempotente |
| 6:20–7:10 | estrategia de pruebas por riesgo |
| 7:10–7:50 | pipeline, imagen y configuración por ambiente |
| 8:00–9:25 | completar pruebas y flujo CI |
| 9:25–9:50 | inspeccionar imagen, secretos y ejecución no privilegiada |
| 9:50–10:00 | identificar versión candidata |

## Taller

1. Conserve pruebas unitarias del dominio.
2. Ejecute pruebas de contrato para los dos adaptadores.
3. Ejecute pruebas de integración con PostgreSQL.
4. Añada pruebas HTTP para persistencia, concurrencia, idempotencia y disponibilidad.
5. Configure el flujo CI para ejecutar todas las pruebas antes de construir la imagen.
6. Etiquete la imagen con el commit y registre su identificador.
7. Obtenga la conexión a PostgreSQL mediante variable de entorno.
8. Incluya un `.env.example` sin credenciales reales.
9. Compruebe que la imagen no contiene archivos `.env`, claves ni tokens.
10. Ejecute el proceso del contenedor como usuario no privilegiado.

## Validación

```bash
make check
make test-all
git status --short
```

La ejecución debe partir de una revisión identificable. Una captura de un pipeline anterior o una imagen etiquetada solamente como `latest` no demuestra trazabilidad.

**Evidencia:** pull request, pruebas, ejecución CI, identificador de imagen, variables documentadas y comprobación de secretos.
