-- 1. Definiciones
CREATE TABLE IF NOT EXISTS kpi_definitions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    user_id INTEGER REFERENCES users(id)
);

-- 2. El registro de hechos
CREATE TABLE IF NOT EXISTS kpi_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    definition_id INTEGER REFERENCES kpi_definitions(id),
    entry_date DATE NOT NULL,
    value TEXT NOT NULL,
    UNIQUE(user_id, entry_date, definition_id)
);