-- Tablas exclusivas del laboratorio; la API base no las utiliza.
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

CREATE TABLE IF NOT EXISTS demo_outbox (
    evento_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reserva_id bigint NOT NULL REFERENCES demo_reservas(id),
    evento jsonb NOT NULL,
    creado_en timestamptz NOT NULL DEFAULT now(),
    publicado_en timestamptz
);
