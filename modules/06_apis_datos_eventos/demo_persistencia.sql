-- Ejemplo de integridad para diseñar la migración real de LibreReserva.
CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE IF NOT EXISTS demo_reservas (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recurso text NOT NULL,
    inicio timestamptz NOT NULL,
    fin timestamptz NOT NULL,
    CHECK (fin > inicio),
    EXCLUDE USING gist (
        recurso WITH =,
        tstzrange(inicio, fin, '[)') WITH &&
    )
);
