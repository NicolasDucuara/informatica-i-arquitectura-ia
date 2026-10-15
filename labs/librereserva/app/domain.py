"""Núcleo de dominio sin dependencias de infraestructura."""

from dataclasses import dataclass
from datetime import datetime


class IntervaloInvalido(ValueError):
    """El final no es posterior al inicio."""


class IntervaloOcupado(RuntimeError):
    """La reserva se solapa con otra reserva activa."""


class ReservaNoEncontrada(LookupError):
    """No existe una reserva con el identificador solicitado."""


@dataclass(frozen=True, slots=True)
class Intervalo:
    inicio: datetime
    fin: datetime

    def __post_init__(self) -> None:
        if self.fin <= self.inicio:
            raise IntervaloInvalido("fin debe ser posterior a inicio")

    def se_solapa(self, otro: "Intervalo") -> bool:
        return self.inicio < otro.fin and otro.inicio < self.fin


@dataclass(frozen=True, slots=True)
class Reserva:
    id: int
    recurso: str
    intervalo: Intervalo


class Agenda:
    """Repositorio en memoria útil para el primer incremento vertical."""

    def __init__(self) -> None:
        self._reservas: list[Reserva] = []
        self._siguiente_id = 1

    def crear(self, recurso: str, intervalo: Intervalo) -> Reserva:
        if any(
            reserva.recurso == recurso
            and reserva.intervalo.se_solapa(intervalo)
            for reserva in self._reservas
        ):
            raise IntervaloOcupado(f"{recurso} ya está reservado")
        reserva = Reserva(self._siguiente_id, recurso, intervalo)
        self._reservas.append(reserva)
        self._siguiente_id += 1
        return reserva

    def listar(self) -> tuple[Reserva, ...]:
        return tuple(self._reservas)

    def borrar(self, reserva_id: int) -> None:
        for indice, reserva in enumerate(self._reservas):
            if reserva.id == reserva_id:
                del self._reservas[indice]
                return
        raise ReservaNoEncontrada(f"No existe una reserva con id {reserva_id}")

    def limpiar(self) -> None:
        self._reservas.clear()
        self._siguiente_id = 1
