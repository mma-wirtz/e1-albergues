CREATE TABLE IF NOT EXISTS albergues (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    concello VARCHAR(100) NOT NULL,
    camino VARCHAR(100) NOT NULL,
    plazas INTEGER NOT NULL CHECK (plazas > 0),
    precio_por_noche NUMERIC(7, 2) NOT NULL CHECK (precio_por_noche >= 0)
);