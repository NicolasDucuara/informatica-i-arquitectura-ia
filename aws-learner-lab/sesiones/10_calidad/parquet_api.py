"""API experimental para observar concurrencia sobre un Parquet compartido."""

from contextlib import contextmanager
from datetime import datetime
import fcntl
import os
from pathlib import Path
import time
from typing import Iterator

from fastapi import FastAPI, HTTPException, Response, status
from pydantic import BaseModel
import pyarrow as pa
import pyarrow.parquet as pq


app = FastAPI(title="LibreReserva Parquet", version="0.1.0-lab")

INSTANCE_NAME = os.getenv("INSTANCE_NAME", "desconocida")
PARQUET_FILE = Path(os.getenv("PARQUET_FILE", "/datos/reservas.parquet"))
LOCK_FILE = PARQUET_FILE.with_suffix(".lock")
LOCK_MODE = os.getenv("PARQUET_LOCK_MODE", "none")
WRITE_DELAY_SECONDS = int(os.getenv("WRITE_DELAY_MS", "0")) / 1000

SCHEMA = pa.schema(
    [
        ("id", pa.int64()),
        ("recurso", pa.string()),
        ("inicio", pa.string()),
        ("fin", pa.string()),
    ]
)


class ReservaEntrada(BaseModel):
    recurso: str
    inicio: datetime
    fin: datetime


class ReservaSalida(ReservaEntrada):
    id: int


def _leer_filas() -> list[dict[str, object]]:
    if not PARQUET_FILE.exists():
        return []
    return pq.read_table(PARQUET_FILE).to_pylist()


def _tabla(filas: list[dict[str, object]]) -> pa.Table:
    return pa.Table.from_pylist(filas, schema=SCHEMA)


def _escribir_directamente(filas: list[dict[str, object]]) -> None:
    pq.write_table(_tabla(filas), PARQUET_FILE)


def _escribir_atomicamente(filas: list[dict[str, object]]) -> None:
    temporal = PARQUET_FILE.with_name(
        f".{PARQUET_FILE.name}.{INSTANCE_NAME}.{os.getpid()}.tmp"
    )
    try:
        pq.write_table(_tabla(filas), temporal)
        os.replace(temporal, PARQUET_FILE)
    finally:
        temporal.unlink(missing_ok=True)


@contextmanager
def _seccion_critica() -> Iterator[None]:
    PARQUET_FILE.parent.mkdir(parents=True, exist_ok=True)
    if LOCK_MODE != "flock":
        yield
        return

    with LOCK_FILE.open("a+", encoding="utf-8") as archivo_bloqueo:
        fcntl.flock(archivo_bloqueo.fileno(), fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(archivo_bloqueo.fileno(), fcntl.LOCK_UN)


def _se_solapa(entrada: ReservaEntrada, fila: dict[str, object]) -> bool:
    inicio_existente = datetime.fromisoformat(str(fila["inicio"]))
    fin_existente = datetime.fromisoformat(str(fila["fin"]))
    return (
        fila["recurso"] == entrada.recurso
        and entrada.inicio < fin_existente
        and inicio_existente < entrada.fin
    )


def _respuesta(fila: dict[str, object]) -> ReservaSalida:
    return ReservaSalida(
        id=int(fila["id"]),
        recurso=str(fila["recurso"]),
        inicio=datetime.fromisoformat(str(fila["inicio"])),
        fin=datetime.fromisoformat(str(fila["fin"])),
    )


@app.get("/salud/viva")
def viva() -> dict[str, str]:
    return {"estado": "viva", "instancia": INSTANCE_NAME}


@app.get("/salud/lista")
def lista() -> dict[str, str]:
    try:
        _leer_filas()
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Parquet no disponible") from exc
    return {"estado": "lista", "instancia": INSTANCE_NAME}


@app.get("/reservas", response_model=list[ReservaSalida])
def listar_reservas(response: Response) -> list[ReservaSalida]:
    response.headers["X-Instancia"] = INSTANCE_NAME
    try:
        return [_respuesta(fila) for fila in _leer_filas()]
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Parquet no disponible") from exc


@app.post(
    "/reservas",
    response_model=ReservaSalida,
    status_code=status.HTTP_201_CREATED,
)
def crear_reserva(entrada: ReservaEntrada, response: Response) -> ReservaSalida:
    if entrada.fin <= entrada.inicio:
        raise HTTPException(status_code=422, detail="fin debe ser posterior a inicio")

    response.headers["X-Instancia"] = INSTANCE_NAME
    try:
        with _seccion_critica():
            filas = _leer_filas()
            if any(_se_solapa(entrada, fila) for fila in filas):
                raise HTTPException(
                    status_code=409,
                    detail=f"{entrada.recurso} ya está reservado",
                )

            siguiente_id = max((int(fila["id"]) for fila in filas), default=0) + 1
            nueva_fila: dict[str, object] = {
                "id": siguiente_id,
                "recurso": entrada.recurso,
                "inicio": entrada.inicio.isoformat(),
                "fin": entrada.fin.isoformat(),
            }
            filas.append(nueva_fila)

            if WRITE_DELAY_SECONDS:
                time.sleep(WRITE_DELAY_SECONDS)

            if LOCK_MODE == "flock":
                _escribir_atomicamente(filas)
            else:
                _escribir_directamente(filas)
            return _respuesta(nueva_fila)
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Parquet no disponible") from exc
